vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    source = "if_many",
    prefix = "░",
    spacing = 2,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
  float = {
    source = "if_many",
  },
  severity_sort = true,
  jump = {
    float = true,
  },
})
