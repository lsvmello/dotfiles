return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    opts = {
      options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_x = { "encoding", "filetype" },
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
