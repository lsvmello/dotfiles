return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim", },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        servers = {
          jsonls = {
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                format = {
                  enable = true,
                },
                validate = { enable = true },
              },
            },
          },
        },
      })
    end,
  },
}
