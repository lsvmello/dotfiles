--- @type string
local notes_dir = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath("data"), "notes"))
--- @type integer?
local notes_tabid = nil

local function ensure_notes_dir()
  if not vim.uv.fs_stat(notes_dir) then
    local ok, err = vim.uv.fs_mkdir(notes_dir, 493)
    if not ok then
      vim.notify("Notes: failed to create notes directory: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
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
        best_path = path
      end
    end
  end
  return best_path
end

--- @param note string?
local function open_note(note)
  if not note then
    vim.notify("Notes: no notes found", vim.log.levels.WARN)
    return
  end
  if notes_tabid ~= nil and vim.api.nvim_tabpage_is_valid(notes_tabid) then
    vim.api.nvim_set_current_tabpage(notes_tabid --[[@as integer]])
  else
    vim.cmd("tabnew")
    notes_tabid = vim.api.nvim_get_current_tabpage()
    vim.cmd.tcd(notes_dir)
  end
  vim.cmd.edit(note)
end

vim.api.nvim_create_user_command("Notes", function(opts)
  ensure_notes_dir()
  local name = opts.fargs[1]
  local path = name and vim.fs.joinpath(notes_dir, name:match("%.[^.]+$") and name or name .. ".md")
    or get_latest_note()
  open_note(path)
end, {
  nargs = "?",
  desc = "Notes: open last note or create/open note by name",
  complete = function(arg_lead)
    local out = {}
    for name, ftype in vim.fs.dir(notes_dir) do
      if ftype == "file" and vim.startswith(name, arg_lead or "") then
        table.insert(out, name)
      end
    end
    table.sort(out)
    return out
  end,
})

local group = vim.api.nvim_create_augroup("notes", { clear = true })

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufLeave", "FocusLost" }, {
  group = group,
  desc = "Auto-save notes",
  pattern = vim.fs.joinpath(notes_dir, "*"),
  command = "silent! update",
})

vim.api.nvim_create_autocmd("TabClosed", {
  group = group,
  desc = "Reset notes tab handle when the notes tab itself is closed",
  callback = function()
    if notes_tabid ~= nil and not vim.api.nvim_tabpage_is_valid(notes_tabid) then
      notes_tabid = nil
    end
  end,
})
