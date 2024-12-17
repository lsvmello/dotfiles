local augroup = vim.api.nvim_create_augroup("custom.autocmds", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "reload the file when it changed",
  group = augroup,
  command = "checktime"
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  desc = "set terminal options and start terminal mode",
  group = augroup,
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    -- Lualine doesn't allow filter by buftype
    vim.bo.ft = "terminal"
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight on yank",
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  desc = "resize splits if window got resized",
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "go to last cursor position when opening a buffer",
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "close some filetypes with q",
  group = augroup,
  pattern = {
    -- stylua: ignore
    "PlenaryTestPopup", "checkhealth",
    "fugitive", "help", "lspinfo",
    "man", "notify", "qf", "query",
    "startuptime", "netrw",
  },
  callback = function(event)
    vim.api.nvim_set_option_value("buflisted", false, { buf = event.buf })
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close buffer" })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "creates not existing directory when saving a file",
  group = augroup,
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
