return {
  {
    "gap.nvim",
    cond = vim.fn.has("win32") == 1,
    lazy = false,
    dev = true,
    config = true,
  },
  {
    "gf-curl.nvim",
    cond = false, -- TODO: disable netrw and move to this
    dev = true,
    config = true,
  },
}
