return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    { "mason-org/mason-lspconfig.nvim", dependencies = "neovim/nvim-lspconfig" },
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
    servers = {
      ["harper_ls"] = {
        userDictPath = "",
        fileDictPath = "",
        linters = {
          SpellCheck = false,
          BoringWords = true,
        },
        codeActions = {
          ForceStable = false
        },
        markdown = {
          IgnoreLinkTitle = false
        },
        diagnosticSeverity = "hint",
        isolateEnglish = false,
        dialect = "American",
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
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
        map("n", "<LocalLeader>ca", vim.lsp.buf.code_action, "Code actions")

        if client:supports_method(methods.textDocument_documentHighlight) then
          local under_cursor_highlights_group = vim.api.nvim_create_augroup("cursor_highlights", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
            group = under_cursor_highlights_group,
            desc = "Highlight references under the cursor",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
            group = under_cursor_highlights_group,
            desc = "Clear highlight references",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client:supports_method(methods.textDocument_inlayHint) then
          local inlay_hint_group = vim.api.nvim_create_augroup("inlay_hint", { clear = false })
          map("n", "<LocalLeader>ch", function()
            -- Toggle the hints
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })

            -- If toggling them on, turn them back off when entering insert mode.
            if not enabled then
              vim.api.nvim_create_autocmd("InsertEnter", {
                group = inlay_hint_group,
                buffer = bufnr,
                once = true,
                callback = function()
                  vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                end,
              })
            end
          end, "Code hints")
        end

        if client:supports_method(methods.textDocument_codeLens) then
          local code_lens_group = vim.api.nvim_create_augroup("code_lens", { clear = false })
          map("n", "<LocalLeader>cl", function()
            vim.lsp.codelens.refresh({ bufnr = bufnr })

            local codelens_autocmd_id = vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
              group = code_lens_group,
              buffer = bufnr,
              callback = function()
                vim.lsp.codelens.refresh({ bufnr = bufnr })
              end,
            })

            vim.api.nvim_create_autocmd("InsertEnter", {
              group = code_lens_group,
              buffer = bufnr,
              once = true,
              callback = function()
                vim.lsp.codelens.clear(nil, bufnr)
                vim.api.nvim_del_autocmd(codelens_autocmd_id)
              end,
            })
          end, "Code Lens")
        end
      end,
    })
  end,
  config = function(_, opts)

    -- get all the servers that are available through mason-lspconfig
    local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_package)

    local ensure_installed = {} ---@type string[]
    for server, server_opts in pairs(opts.servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    local mlsp = require("mason-lspconfig")
    mlsp.setup({
      ensure_installed = ensure_installed,
      automatic_enable = true,
    })
  end,
}
