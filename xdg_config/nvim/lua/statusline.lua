local groupid = vim.api.nvim_create_augroup("StatusLine", {})

_G._statusline = {}

--- Get string representation of a string with highlight
--- @param str? string sign symbol
--- @param hl? string name of the highlight group
--- @param restore? boolean restore highlight after the string, default true
--- @param force? boolean apply highlight even if 'termguicolors' is off
--- @return string sign string representation of the sign with highlight
local function stl_hl(str, hl, restore, force)
  restore = restore == nil or restore
  -- Don't add highlight in tty to get a cleaner UI
  hl = (vim.go.termguicolors or force) and hl or ""
  return restore and table.concat({ "%#", hl, "#", str or "", "%*" }) or table.concat({ "%#", hl, "#", str or "" })
end

--- Escape '%' with '%' in a string to avoid it being treated as a statusline
--- field, see `:h 'statusline'`
--- @param str string
--- @return string
local function stl_escape(str)
  return str ~= nil and str:gsub("%%", "%%%%") or ""
end
--- Get string represantation of current git branch and status
--- @return string
function _G._statusline.git_info()
  if vim.b.gitsigns_status_dict == nil then
    return ""
  end

  local git_info = vim.b.gitsigns_status_dict
  local result = { "@ " .. stl_escape(git_info.head) }
  local added = git_info.added or 0
  local changed = git_info.changed or 0
  local removed = git_info.removed or 0
  if added > 0 or removed > 0 or changed > 0 then
    table.insert(result, " (")
    table.insert(result, "+" .. added)
    table.insert(result, "~" .. changed)
    table.insert(result, "-" .. removed)
    table.insert(result, ")")
  end
  return table.concat(result)
end

--- Get formatted buffer number, buffer type, current directory and file path
--- @return string
function _G._statusline.fname(focused)

  local path = vim.fn.expand("%:p:~")

  -- Normal buffer
  if vim.bo.bt == "" then
    if path == "" then
      return "[Buffer %n]"
    end

    if focused then
      local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")

      if path:find(cwd, 1, true) == 1 then
        path = path:sub(#cwd + 1)
      elseif path ~= "" then
        cwd = cwd .. "   "
      end

      return stl_hl(cwd, "NonText") .. path .. "%( %m%w%r%)"
    end
  end

  -- Terminal buffer, show terminal command and id
  if vim.bo.bt == "terminal" then
    local id, cmd = path:match("^term://.*/(%d+):(.*)")
    return id and cmd and string.format("[terminal] %s (%s)", vim.fn.fnamemodify(cmd, ":t"):lower(), id)
      or "[terminal] %F"
  end

  -- default format
  return "%h %F %m%w%r"
end

local unused = 2

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = groupid,
  desc = "Update diagnostics cache for the status line.",
  callback = function(args)
    -- local signs_config = vim.diagnostic.config().signs
    -- local signs = type(signs_config) == "table" and type(signs_config.text) == "table" and signs_config.text or {}
    local signs = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    }

    if vim.tbl_isempty(signs) then
      return
    end

    local buf_cnt = vim.diagnostic.count(args.buf)
    if vim.tbl_isempty(buf_cnt) then
      return
    end

    local diag_str = {}
    for serverity, count in pairs(buf_cnt) do
      if count > 0 then
        table.insert(diag_str, signs[serverity] .. count)
      end
    end

    vim.b[args.buf].diag_str_cache = table.concat(diag_str, " ")
    vim.cmd.redrawstatus({
      mods = { emsg_silent = true },
    })
  end,
})

--- Get string representation of diagnostics for current buffer
--- @return string
function _G._statusline.diag()
  return vim.b.diag_str_cache ~= vim.NIL and vim.b.diag_str_cache or ""
end

local spinner_end_keep = 2000 -- ms
local spinner_status_keep = 600 -- ms
local spinner_progress_keep = 80 -- ms
local spinner_timer = vim.uv.new_timer()

local spinner_icon_done = "[done]"
local spinner_icons = { "[    ]", "[=   ]", "[==  ]", "[=== ]", "[ ===]", "[  ==]", "[   =]" }

--- Id and additional info of language servers in progress
--- @type table<integer, { name: string, timestamp: integer, type: string|nil }>
local server_info = {}

vim.api.nvim_create_autocmd("LspProgress", {
  desc = "Update LSP progress info for the status line.",
  group = groupid,
  pattern = { "begin", "end" },
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(spinner_progress_keep, spinner_progress_keep, vim.schedule_wrap(vim.cmd.redrawstatus))
    end

    local id = info.data.client_id
    local now = vim.uv.now()
    server_info[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      timestamp = now,
      type = info.data and info.data.params and info.data.params.value and info.data.params.value.kind,
    } -- Update LSP progress data
    -- Clear client message after a short time if no new message is received
    vim.defer_fn(function()
      -- No new report since the timer was set
      local last_timestamp = (server_info[id] or {}).timestamp
      if not last_timestamp or last_timestamp == now then
        server_info[id] = nil
        if vim.tbl_isempty(server_info) and spinner_timer then
          spinner_timer:stop()
        end
        vim.cmd.redrawstatus()
      end
    end, spinner_end_keep)

    vim.cmd.redrawstatus({
      mods = { emsg_silent = true },
    })
  end,
})

--- @return string
function _G._statusline.lsp_progress()
  if vim.tbl_isempty(server_info) then
    return ""
  end

  local buf = vim.api.nvim_get_current_buf()
  local server_ids = {}
  for id, _ in pairs(server_info) do
    if vim.tbl_contains(vim.lsp.get_buffers_by_client_id(id), buf) then
      table.insert(server_ids, id)
    end
  end
  if vim.tbl_isempty(server_ids) then
    return ""
  end

  local now = vim.uv.now()
  --- @return boolean
  local function allow_changing_state()
    return not vim.b.spinner_state_changed or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  if #server_ids == 1 and server_info[server_ids[1]].type == "end" then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done
    end
  else
    local spinner_icon_progress = spinner_icons[math.ceil(now / spinner_progress_keep) % #spinner_icons + 1]
    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return stl_hl(
    string.format(
      "%s %s",
      table.concat(
        vim.tbl_map(function(id)
          return stl_escape(server_info[id].name)
        end, server_ids),
        ", "
      ),
      vim.b.spinner_icon
    ),
    "NonText"
  )
end

--- Statusline components
--- @type table<string, string>
local components = {
  align        = [[%=]],
  diag         = [[%{%v:lua._statusline.diag()%}]],
  git_info     = [[%{%v:lua._statusline.git_info()%}]],
  fname        = [[%{%v:lua._statusline.fname(v:true)%}]],
  fname_nc     = [[%{%v:lua._statusline.fname(v:false)%}]],
  lsp_progress = [[%{%v:lua._statusline.lsp_progress()%}]],
  mode         = [[%{%v:lua._statusline.mode()%}]],
  padding      = [[ ]],
  filetype     = [[%y]],
  pos          = [[%3l:%-3c %P]],
  truncate     = [[%<]],
}

local stl = table.concat({
  components.padding,
  components.fname,
  components.padding,
  components.git_info,
  components.truncate,
  components.align,
  components.lsp_progress,
  components.padding,
  components.diag,
  components.padding,
  components.filetype,
  components.padding,
  components.pos,
  components.padding,
})

local stl_nc = table.concat({
  components.padding,
  components.fname_nc,
  components.truncate,
  components.align,
  components.filetype,
  components.padding,
  components.pos,
  components.padding,
})

setmetatable(_G._statusline, {
  --- Get statusline string
  --- @return string
  __call = function()
    return vim.g.statusline_winid == vim.api.nvim_get_current_win() and stl or stl_nc
  end,
})

return _G._statusline
