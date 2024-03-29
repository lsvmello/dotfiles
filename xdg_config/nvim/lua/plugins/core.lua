return {
  { "nvim-lua/plenary.nvim", lazy = false, priority = 9999 },
  { "folke/lazy.nvim", version = false },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
