return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",   -- already configured
      "cmp-nvim-lsp", -- already configured in completion.lua
      "williamboman/mason-lspconfig.nvim",
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
          text = { spinner = "moon" },
          window = {
            relative = "editor",
            blend = 0,
          },
        },
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require('lsvmello.icons').diagnostics.Error,
            [vim.diagnostic.severity.WARN] = require('lsvmello.icons').diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = require('lsvmello.icons').diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = require('lsvmello.icons').diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = true,
      },
      format = {
        formatting_options = nil,
        timeout = nil,
      },
      servers = {},
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
      -- setup auto-format
      require("lsvmello.format").setup(opts.format)

      -- setup keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = event.buf, desc = desc })
          end

          -- keymaps
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map({ "n", "i" }, "<C-K>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<LocalLeader>k", vim.diagnostic.open_float, "View diagnostic")
          map("n", "<LocalLeader>ca", vim.lsp.buf.code_action, "Code actions")
          map("n", "<LocalLeader>r", vim.lsp.buf.rename, "Rename")
        end,
      })

      -- setup diagnostics
      for name, icon in pairs(require("lsvmello.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "", icon = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if (opts.setup[server] and opts.setup[server](server, server_opts))
            or (opts.setup["*"] and opts.setup["*"](server, server_opts)) then
          return
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
