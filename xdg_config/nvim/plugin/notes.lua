--- @type string
local notes_dir = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath("data"), "notes"))
--- @type integer?
local notes_tabid = nil

--- @return boolean
local function notes_tab_is_valid()
  return notes_tabid ~= nil and vim.api.nvim_tabpage_is_valid(notes_tabid)
end

--- @param path string
--- @return boolean
local function is_notes_path(path)
  if path == "" then return false end
  local norm_notes_dir = notes_dir:lower()
  local norm_path = vim.fs.normalize(path):lower()
  return norm_path == norm_notes_dir or vim.startswith(norm_path, norm_notes_dir .. "/")
end

local function ensure_notes_dir()
  if not vim.uv.fs_stat(notes_dir) then
    local ok, err = vim.uv.fs_mkdir(notes_dir, 493)
    if not ok then
      vim.notify("Notes: failed to create notes directory: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

--- @param name string
--- @return string
local function resolve_name(name)
  return name:match("%.[^.]+$") and name or (name .. ".md")
end

--- @param prefix? string
--- @return string[]
local function note_names(prefix)
  local out = {}
  for name, ftype in vim.fs.dir(notes_dir) do
    if ftype == "file" and vim.startswith(name, prefix or "") then
      table.insert(out, name)
    end
  end
  table.sort(out)
  return out
end

--- @return string?
local function get_latest_note()
  local best_path, best_mtime = nil, -1
  for name, ftype in vim.fs.dir(notes_dir) do
    if ftype == "file" then
      local path = vim.fs.joinpath(notes_dir, name)
      local stat = vim.uv.fs_stat(path)
      if stat and stat.mtime.sec > best_mtime then
        best_mtime = stat.mtime.sec
        best_path  = path
      end
    end
  end
  return best_path
end

local function open_notes_tab()
  ensure_notes_dir()
  if notes_tab_is_valid() then
    vim.api.nvim_set_current_tabpage(notes_tabid --[[@as integer]])
    return
  end
  vim.cmd("tabnew")
  notes_tabid = vim.api.nvim_get_current_tabpage()
  vim.cmd.tcd(notes_dir)
end

--- @param name? string
local function cmd_new(name)
  open_notes_tab()
  local target = (name and name ~= "")
    and vim.fs.joinpath(notes_dir, resolve_name(name))
    or  vim.fs.joinpath(notes_dir, os.date("%Y-%m-%d") .. ".md")
  vim.cmd.edit(target)
end

--- @param name? string
local function cmd_open(name)
  local target
  if not name or name == "" then
    target = get_latest_note()
    if not target then
      vim.notify("Notes: no notes found", vim.log.levels.WARN)
      return
    end
  else
    target = vim.fs.joinpath(notes_dir, resolve_name(name))
    if not vim.uv.fs_stat(target) then
      vim.notify("Note not found: " .. vim.fs.basename(target), vim.log.levels.ERROR)
      return
    end
  end
  open_notes_tab()
  vim.cmd.edit(target)
end

--- @param arg1? string
--- @param arg2? string
local function cmd_rename(arg1, arg2)
  if not arg1 or arg1 == "" then
    vim.notify("Notes rename: a new name is required", vim.log.levels.ERROR)
    return
  end
  local old_path, new_path
  if not arg2 or arg2 == "" then
    local current = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
    if not is_notes_path(current) then
      vim.notify("Current buffer is not a note", vim.log.levels.ERROR)
      return
    end
    old_path = current
    new_path = vim.fs.joinpath(notes_dir, resolve_name(arg1))
  else
    old_path = vim.fs.joinpath(notes_dir, resolve_name(arg1))
    new_path = vim.fs.joinpath(notes_dir, resolve_name(arg2))
  end

  if not vim.uv.fs_stat(old_path) then
    vim.notify("Note not found: " .. vim.fs.basename(old_path), vim.log.levels.ERROR)
    return
  end

  local ok, err = vim.uv.fs_rename(old_path, new_path)
  if not ok then
    vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fs.normalize(vim.api.nvim_buf_get_name(buf)):lower() == old_path:lower() then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_win_call(win, function() vim.cmd.edit(new_path) end)
        end
      end
      vim.api.nvim_buf_delete(buf, { force = true })
      break
    end
  end
end

local subcommands = { "new", "open", "rename" }

vim.api.nvim_create_user_command("Notes", function(opts)
  local args = opts.fargs
  if #args == 0 then
    open_notes_tab()
    local target = get_latest_note()
      or vim.fs.joinpath(notes_dir, os.date("%Y-%m-%d") .. ".md")
    vim.cmd.edit(target)
    return
  end
  local sub = args[1]
  if     sub == "new"    then cmd_new(args[2])
  elseif sub == "open"   then cmd_open(args[2])
  elseif sub == "rename" then cmd_rename(args[2], args[3])
  else vim.notify("Notes: unknown subcommand '" .. sub .. "'", vim.log.levels.ERROR)
  end
end, {
  nargs    = "*",
  desc     = "Notes manager (new / open / rename)",
  complete = function(arg_lead, cmd_line)
    local parts = vim.split(cmd_line, "%s+", { trimempty = false })
    if #parts <= 2 then
      return vim.tbl_filter(function(v) return vim.startswith(v, arg_lead) end, subcommands)
    end
    local sub = parts[2]
    local arg_pos = #parts - 2
    if (sub == "new" or sub == "open") and arg_pos <= 1 then
      return note_names(arg_lead)
    end
    if sub == "rename" and arg_pos == 1 then
      return note_names(arg_lead)
    end
    return {}
  end,
})

local group = vim.api.nvim_create_augroup("notes", { clear = true })

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufLeave", "FocusLost" }, {
  group    = group,
  desc     = "Auto-save notes",
  callback = function(args)
    local b = args.buf
    if vim.bo[b].buftype ~= "" then return end
    if not vim.bo[b].modified then return end
    if not is_notes_path(vim.api.nvim_buf_get_name(b)) then return end
    pcall(vim.api.nvim_buf_call, b, function() vim.cmd("silent! write") end)
  end,
})

vim.api.nvim_create_autocmd("TabClosed", {
  group    = group,
  desc     = "Reset notes tab handle when the notes tab itself is closed",
  callback = function()
    if notes_tabid ~= nil and not vim.api.nvim_tabpage_is_valid(notes_tabid) then
      notes_tabid = nil
    end
  end,
})
