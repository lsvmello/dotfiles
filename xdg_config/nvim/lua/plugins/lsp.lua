--@param on_attach fun(client, buffer)
local on_lsp_attach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "clang-format",
        "clangd",
        "gopls",
        "lua-language-server",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim", -- already configured
      "gitsigns.nvim", -- already configured
      "ThePrimeagen/refactoring.nvim",
    },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.code_actions.gitsigns,
          nls.builtins.code_actions.refactoring,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim", -- already configured
      "null-ls.nvim", -- already configured
      "cmp-nvim-lsp", -- already configured in completion.lua
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = {
          experimental = { pathStrict = true },
        },
      },
      {
        "j-hui/fidget.nvim",
        opts = {
          text = { spinner = "moon" },
          window = {
            relative = "editor",
            blend = 10,
          },
        },
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      format = {
        formatting_options = nil,
        timeout = nil,
      },
      servers = {
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        -- Fallback for any server
        ["*"] = function()
          local lsp = vim.lsp
          local win_opts = { border = "single" }

          lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, win_opts)
          lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, win_opts)
        end,
      },
    },
    config = function(_, opts)
      on_lsp_attach(function(client, buffer)
        -- formatting
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. buffer, {}),
            buffer = buffer,
            callback = function()
              local buf = vim.api.nvim_get_current_buf()
              local ft = vim.bo[buf].filetype
              local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

              vim.lsp.buf.format(vim.tbl_deep_extend("force", {
                bufnr = buf,
                filter = function(c)
                  if have_nls then
                    return c.name == "null-ls"
                  end
                  return c.name ~= "null-ls"
                end,
              }, {}))
            end,
          })
        end

        -- keymaps
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "K", vim.lsp.buf.hover, "Peek definition")
        map("n", "<leader>fws", vim.lsp.buf.workspace_symbol, "Find Workspace Symbol")
        map("n", "<leader>vd", vim.diagnostic.open_float, "View Diagnostics")
        map("n", "[d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("n", "]d", vim.diagnostic.goto_prev, "Preview Diagnostic")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
        map("n", "<leader>rr", vim.lsp.buf.references, "View References")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
      end)

      for name, icon in pairs(require("lsvmello.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available thourgh mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers({ setup })
    end,
  },
}
