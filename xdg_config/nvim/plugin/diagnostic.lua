vim.diagnostic.config({
  update_in_insert = false,
  virtual_text = {
    prefix = "▓",
    spacing = 0,
  },
  signs = false,
  float = {
    source = "if_many",
  },
  severity_sort = true,
  jump = {
    float = true,
  },
})

vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })
