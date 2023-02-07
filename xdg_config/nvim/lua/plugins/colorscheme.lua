return {
  -- default colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme rose-pine]])
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
    lazy = true,
  },
}
