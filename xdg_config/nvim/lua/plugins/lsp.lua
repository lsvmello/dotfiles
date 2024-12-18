return {
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason", "MasonInstall", "MasonLog",
      "MasonUninstall", "MasonUninstallAll",
      "MasonUpdate",
    },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "shellcheck", "shfmt", },
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
      "williamboman/mason.nvim", -- already configured
      "saghen/blink.cmp", -- already configured
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {}, },
    },
    opts = {
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
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
            [vim.diagnostic.severity.ERROR] = require("custom.icons").diagnostics.Error,
            [vim.diagnostic.severity.WARN] = require("custom.icons").diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = require("custom.icons").diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = require("custom.icons").diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = true,
      },
      document_highlight = {
        enabled = true,
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
          -- TODO: check if lsp defaults are available. See |grr|, |grn|, |gra|, |i_CTRL-S|.
          map("n", "<LocalLeader>k", vim.diagnostic.open_float, "View diagnostic")
          map("n", "<LocalLeader>ca", vim.lsp.buf.code_action, "Code actions")
          map({ "n", "v" }, "<LocalLeader>cl", vim.lsp.codelens.run, "Run Code lens")
          map("n", "<LocalLeader>cL", vim.lsp.codelens.refresh, "Refresh Code Lens")
          map("n", "<LocalLeader>r", vim.lsp.buf.rename, "Rename")

        end,
      })

      -- setup diagnostics
      for name, icon in pairs(require("custom.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "", icon = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

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
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

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

      local mlsp = require("mason-lspconfig")
      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers({ setup })
    end,
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf ---@type number
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, buffer)
          end
        end,
      })
    end,
    opts = function()
      return {
        highlight = true,
        depth_limit = 5,
        icons = require("custom.icons").kinds,
        lazy_update_context = true,
        separator = "  ",
      }
    end,
  },
}
