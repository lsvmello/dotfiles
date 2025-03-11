return {
  'b0o/incline.nvim',
  cond = false,
  dependencies = {
    'echasnovski/mini.nvim',
  },
  event = 'WinLeave',
  config = function()
    local function get_diagnostics(props)
      local labels = {}

      for _, severity in ipairs({ 'Hint', 'Info', 'Warn', 'Error' }) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
          table.insert(labels, { ' ' .. severity:sub(1, 1) .. n, group = 'DiagnosticSign' .. severity })
        end
      end
      if #labels > 0 then
        table.insert(labels, 1, { ' ', group = 'MiniIconsCyan' })
        table.insert(labels, { ' ┊' })
      end
      return labels
    end

    local function get_diff(props)
      local labels = {}

      local signs = vim.b[props.buf].gitsigns_status_dict
      if signs == nil then
        return labels
      end

      local signs_map = {
        added = { icon = '+', group = 'GitSignsAdd' },
        changed = { icon = '~', group = 'GitSignsChange' },
        removed = { icon = '-', group = 'GitSignsDelete' },
      }
      for _, key in ipairs({ 'added', 'changed', 'removed' }) do
        if signs[key] and signs[key] ~= 0 then
          table.insert(labels, { ' ' .. signs_map[key].icon .. signs[key], group = signs_map[key].group })
        end
      end

      if #labels > 0 then
        table.insert(labels, 1, { ' ', group = 'MiniIconsOrange' })
        table.insert(labels, { ' ┊' })
      end
      return labels
    end

    require('incline').setup({
      window = {
        margin = { horizontal = 0, vertical = 0, },
        padding = 0,
      },
      render = function(props)
        if props.focused then
          return nil
        end

        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        local icon, hl = require('mini.icons').get('file', vim.api.nvim_buf_get_name(props.buf))
        local modified = vim.bo[props.buf].modified
        if filename == '' then
          filename = '[No Name]'
        end

        return {
          { '', group = 'InclineBorder' },
          {
            get_diff(props),
            get_diagnostics(props),
            { ' ' .. icon, group = hl, },
            ' ' .. filename,
            modified and ' ●' or '',
            ' ',
            group = 'InclineBackground',
          },
          { '', group = 'InclineBorder' },
        }
      end
    })
  end,
}
