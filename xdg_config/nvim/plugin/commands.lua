vim.api.nvim_create_user_command('Del', function(args)
  local bufnr = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if vim.bo[bufnr].buftype == '' then
    local ok, err = os.remove(fname)
    assert(args.bang or ok, err)
  end
  vim.api.nvim_buf_delete(bufnr, { force = args.bang })
end, { bang = true })

-- TODO: notes command? a buffer that is auto-saved?
vim.api.nvim_create_user_command('Scratch', function()
  vim.cmd('below 10new')
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_option_value('filetype', 'scratch', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_set_option_value('number', false, { win = win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = win })
  vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf, silent = true, desc = 'Close buffer' })
end, { desc = 'Open a scratch buffer', nargs = 0 })
