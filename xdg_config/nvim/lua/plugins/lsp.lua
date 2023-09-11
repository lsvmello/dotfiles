local client_supports_format = function(client)
  if client.config and client.config.capabilities
      and client.config.capabilities.documentFormattingProvider == false then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "clang-format",
        "clangd",
        "gopls",
        "jq",
        "json-lsp",
        "lua-language-server",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        "yaml-language-server",
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
      "b0o/SchemaStore.nvim",
      { "folke/neodev.nvim", config = true },
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
      },
      format = {
        formatting_options = nil,
        timeout = nil,
      },
      servers = {
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            }
          }
        },
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
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        jsonls = function(_, server_opts)
          server_opts.settings.json.schemas = server_opts.settings.json.schemas or {}
          vim.list_extend(server_opts.settings.json.schemas, require("schemastore").json.schemas())
        end,
        yamlls = function(_, server_opts)
          server_opts.settings.yaml.schemas = server_opts.settings.yaml.schemas or {}
          vim.list_extend(server_opts.settings.yaml.schemas, require("schemastore").yaml.schemas())
        end,
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
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(event)
          local bufnr = event.buf
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if #clients == 0 then return end

          local client_ids = vim.tbl_map(function(client)
            return client.id
          end, vim.tbl_filter(client_supports_format, clients))

          if #client_ids == 0 then return end

          vim.lsp.buf.format(vim.tbl_deep_extend("force", {
            bufnr = bufnr,
            filter = function(client)
              return vim.tbl_contains(client_ids, client.id)
            end,
          }, opts.format or {}))
        end,
      })

      -- setup keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = event.buf, desc = desc })
          end

          -- keymaps
          map("n", "gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
          map("n", "gi", vim.lsp.buf.implementation, "[G]o to [I]mplementation")
          map("n", "K", vim.lsp.buf.hover, "Peek definition")
          map({ "n", "i" }, "<C-K>", vim.lsp.buf.signature_help, "Signature help")
          map("n", "<LocalLeader>k", vim.diagnostic.open_float, "View diagnostic")
          map("n", "<LocalLeader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions")
          map("n", "<LocalLeader>r", vim.lsp.buf.rename, "[R]ename")
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
