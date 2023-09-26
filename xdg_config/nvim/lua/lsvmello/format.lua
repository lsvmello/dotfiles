local M = {}

local client_supports_format = function(client)
  if client.config and client.config.capabilities
      and client.config.capabilities.documentFormattingProvider == false then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

local format_on_save = false

function M.enabled()
  return format_on_save
end

function M.toggle()
  format_on_save = not format_on_save
  if format_on_save then
    vim.notify("Enabled format on save")
  else
    vim.notify("Disabled format on save")
  end
end

function M.status()
  if format_on_save then
    return "⌨"
  end

  return ""
end

function M.setup(format_opts)
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(event)
      if not format_on_save then
        return
      end

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
      }, format_opts or {}))
    end,
  })
end

return M
