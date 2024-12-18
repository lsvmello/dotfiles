return {
  {
    "saghen/blink.cmp",
    event = "insertenter",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      appearance = {
        kind_icons = require("custom.icons").kinds,
      },
      completion = {
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        -- documentation = {
        --   auto_show = true,
        -- },
      },
      signature = { enabled = true, },
    },
  },
}
