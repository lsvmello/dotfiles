-- TODO: simplify this mess
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim', -- already configured
    'williamboman/mason-lspconfig.nvim',
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
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = 'E',
          [vim.diagnostic.severity.WARN]  = 'W',
          [vim.diagnostic.severity.INFO]  = 'I',
          [vim.diagnostic.severity.HINT]  = 'H',
        },
      },
      severity_sort = true,
      jump = {
        float = true,
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
  },
  config = function(_, opts)
    -- setup keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        local methods = vim.lsp.protocol.Methods
        local bufnr = event.buf
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- keymaps
        map('n', '<LocalLeader>ca', vim.lsp.buf.code_action, 'Code actions')
        map('n', '<C-K>', vim.lsp.buf.hover, 'Code hover')

        -- TODO: check if will keep this
        if client:supports_method(methods.textDocument_completion) then
          -- Enable auto-completion
          vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        end

        -- TODO: check if will keep this
        if client:supports_method(methods.textDocument_documentHighlight) then
          local under_cursor_highlights_group = vim.api.nvim_create_augroup('cursor_highlights', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Highlight references under the cursor',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Clear highlight references',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- TODO: check if will keep this
        if client:supports_method(methods.textDocument_inlayHint) then
          map('n', '<LocalLeader>ci', function()
            -- Toggle the hints
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })

            -- If toggling them on, turn them back off when entering insert mode.
            if not enabled then
              vim.api.nvim_create_autocmd('InsertEnter', {
                buffer = bufnr,
                once = true,
                callback = function()
                  vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                end,
              })
            end
          end, 'Toggle inlay hints')
        end

        -- TODO: check if will keep this
        if client:supports_method(methods.textDocument_codeLens) then
          map('n', '<LocalLeader>cl', function()
            -- TODO: Add toggle functionality, but
            -- there is no way to check if lens are displaying
            vim.lsp.codelens.refresh({ bufnr = bufnr })

            local codelens_autocmd_id = vim.api.nvim_create_autocmd(
              { 'FocusGained', 'BufEnter', 'CursorHold' }, {
                buffer = bufnr,
                callback = function()
                  vim.lsp.codelens.refresh({ bufnr = bufnr })
                end,
              })

              vim.api.nvim_create_autocmd('InsertEnter', {
                buffer = bufnr,
                once = true,
                callback = function()
                  vim.lsp.codelens.clear(nil, bufnr)
                  vim.api.nvim_del_autocmd(codelens_autocmd_id)
                end,
              })
            end, 'Display code lens')
          end
        end
      })

      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        server_opts.capabilities = capabilities
        require('lspconfig')[server].setup(server_opts)
      end
      -- get all the servers that are available thourgh mason-lspconfig
      local all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      local mlsp = require('mason-lspconfig')
      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end,
  }
