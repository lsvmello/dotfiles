vim.api.nvim_create_user_command("Del", function(args)
  local bufnr = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if vim.bo[bufnr].buftype == "" then
    local ok, err = os.remove(fname)
    assert(args.bang or ok, err)
  end
  vim.api.nvim_buf_delete(bufnr, { force = args.bang })
end, { bang = true })
