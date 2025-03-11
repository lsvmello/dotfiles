vim.opt_local.commentstring = '-- %s'

-- TODO: remove flash_hl and use new timeout on vim.hl.range
local flash_hl_ns = vim.api.nvim_create_namespace('flash_hl_ns')
local flash_hl_timer --- @type uv.uv_timer_t?
local flash_hl_cancel_fn --- @type fun()?

local function flash_hl(start, finish)
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()
  if flash_hl_timer then
    flash_hl_timer:close()
    assert(flash_hl_cancel_fn)
    flash_hl_cancel_fn()
  end

  vim.api.nvim__ns_set(flash_hl_ns, { wins = { winid } })
  vim.hl.range(bufnr, flash_hl_ns, 'IncSearch', start, finish, {
    regtype = 'V',
    inclusive = true,
  })

  flash_hl_cancel_fn = function()
    flash_hl_timer = nil
    flash_hl_cancel_fn = nil
    pcall(vim.api.nvim_buf_clear_namespace, bufnr, flash_hl_ns, 0, -1)
    pcall(vim.api.nvim__ns_set, { wins = {} })
  end

  flash_hl_timer = vim.defer_fn(flash_hl_cancel_fn, 150)
end

vim.keymap.set('n', 'g==', function()
  vim.cmd({ cmd = 'lua', range = { vim.fn.line('.') } })
  flash_hl('.', '.')
end, { buffer = true, desc = 'Execute current line' })

vim.keymap.set('v', 'g=', function()
  local curr_line = vim.fn.line('.')
  local v_line = vim.fn.line('v')

  local line_start = math.min(curr_line, v_line)
  local line_end = math.max(curr_line, v_line)

  vim.cmd({ cmd = 'lua', range = { line_start, line_end } })
  vim.fn.feedkeys('', 'n')
  flash_hl("'<", "'>")
end, { buffer = true, desc = 'Execute current selection' })

vim.keymap.set('n', 'g=g', function()
  vim.cmd.source('%')
  flash_hl({ 1, 1 }, '$')
end, { buffer = true, desc = 'Source current file' })
