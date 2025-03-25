return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "cpp" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "clang-format" })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy=false",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-args-placeholders",
            "--fallback-style=llvm",
            "--compile-commands-dir=build-dbg",
          },
          on_init = function()
            require("clangd_extensions.inlay_hints").setup_autocmd()
          end,
          on_attach = function(_, buf)
            local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })

            vim.keymap.set("n", "<Leader>th", function()
              if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
                vim.api.nvim_create_autocmd("InsertEnter", {
                  group = group,
                  buffer = buf,
                  callback = require("clangd_extensions.inlay_hints").disable_inlay_hints,
                })
                vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                  group = group,
                  buffer = buf,
                  callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
                })
              else
                vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
              end
            end, { buffer = buf, desc = "Toggle Hints" })
          end,
        },
      },
    },
  },
}
