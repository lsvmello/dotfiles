vim.api.nvim_create_user_command("Del", function(args)
  local bufnr = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if vim.bo[bufnr].buftype == "" then
    local ok, err = os.remove(fname)
    assert(args.bang or ok, err)
  end
  vim.api.nvim_buf_delete(bufnr, { force = args.bang })
end, { bang = true })

vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("botright 15new")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].filetype = "scratch"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true

  local win = vim.api.nvim_get_current_win()
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false

  vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = buf, silent = true, desc = "Close scratch buffer" })
  vim.cmd("startinsert")
end, { desc = "Open a scratch buffer", nargs = 0 })
