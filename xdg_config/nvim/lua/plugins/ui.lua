return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      show_end_of_buffer = true,
      term_colors = true,
      integrations = {
        fidget = true,
        harpoon = true,
        mason = true,
        treesitter_context = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        component_separators = { left = "∙", right = "∙" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding" },
        lualine_y = { "filetype" },
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        height = 0.9,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          list = false,
          cursorline = false,
          cursorcolumn = false,
        },
      },
    },
    dependencies = {
      { "folke/twilight.nvim", config = true },
    },
  },
}
