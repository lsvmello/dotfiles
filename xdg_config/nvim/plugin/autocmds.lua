-- TODO: user multiple augroups
local augroup = vim.api.nvim_create_augroup('autocmds', { clear = true })

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'reload the file when it changed',
  group = augroup,
  command = 'checktime'
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'enter insert mode when terminal open',
  group = augroup,
  callback = function()
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight on yank',
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  desc = 'resize splits if window got resized',
  group = augroup,
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'go to last cursor position when opening a buffer',
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, "'")
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'close some filetypes with q',
  group = augroup,
  pattern = {
    -- stylua: ignore
    'PlenaryTestPopup', 'checkhealth',
    'fugitive', 'help', 'lspinfo',
    'man', 'notify', 'qf', 'query',
    'startuptime', 'netrw',
  },
  callback = function(event)
    vim.api.nvim_set_option_value('buflisted', false, { buf = event.buf })
    vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = event.buf, silent = true, desc = 'Close buffer' })
  end,
})

-- TODO: do not set relative when on 'sharing' mode
vim.api.nvim_create_autocmd({ 'FocusGained', 'WinEnter', 'CmdlineLeave' }, {
  desc = 'enable focused window options',
  group = augroup,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FocusLost', 'WinLeave', 'CmdlineEnter' }, {
  desc = 'disable focused window options',
  group = augroup,
  callback = function(args)
    if vim.wo.number then
      vim.wo.relativenumber = false
    end

    if args.event == 'CmdlineEnter' and vim.v.event.cmdtype == ':' then
      vim.cmd.redraw()
    end
  end,
})

vim.api.nvim_create_autocmd({ 'TermRequest' }, {
  desc = 'set the directory for the current tab if it has changed on terminal',
  group = augroup,
  callback = function(args)
    local directory = args.data and args.data.sequence:match('\027%]9;9;"(.+)"')
    if directory ~= nil then
      vim.cmd.tcd(directory)
    end
  end,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
  desc = 'Execute command and stay in the command-line window',
  group = augroup,
  callback = function(args)
    vim.keymap.set({ 'n', 'i' }, '<S-CR>', '<CR>q:', { silent = true, buffer = args.buf })
  end,
})
