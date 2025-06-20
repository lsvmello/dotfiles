vim.opt_local.commentstring = "-- %s"

local blink_ns = vim.api.nvim_create_namespace("blink_ns")

local function blink(start, finish)
  local bufnr = vim.api.nvim_get_current_buf()

  vim.hl.range(bufnr, blink_ns, "IncSearch", start, finish, {
    regtype = "V",
    inclusive = true,
    timeout = 150,
  })
end

vim.keymap.set("n", "g==", function()
  blink(".", ".")
  vim.cmd({ cmd = "lua", range = { vim.fn.line(".") } })
end, { buffer = true, desc = "Execute current line" })

vim.keymap.set("v", "g=", function()
  local curr_line = vim.fn.line(".")
  local v_line = vim.fn.line("v")

  local line_start = math.min(curr_line, v_line)
  local line_end = math.max(curr_line, v_line)

  blink({ line_start - 1, -1 }, { line_end - 1, -1 })
  vim.cmd({ cmd = "lua", range = { line_start, line_end } })
  vim.fn.feedkeys("", "n")
end, { buffer = true, desc = "Execute current selection" })

vim.keymap.set("n", "g=g=", function()
  blink({ 0, -1 }, "$")
  vim.cmd({ cmd = "lua", range = { 1, vim.fn.line("$") } })
end, { buffer = true, desc = "Execute current file" })
