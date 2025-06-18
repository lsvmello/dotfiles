-- TODO: add pylint with nvim-lint / do I need mason-tool-installer?
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        pyright = {},
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "debugpy" })
        end,
      },
    },
    ft = { "python" },
    keys = {
      -- TODO: test this bindings
      {
        "<Leader>dPm",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Python Method",
        ft = "python",
      },
      {
        "<Leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Python Class",
        ft = "python",
      },
    },
    config = function()
      require("dap-python").setup("python")
    end,
  },
}
