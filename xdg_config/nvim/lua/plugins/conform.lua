local format_toggle = 'Auto-format'
return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  keys = {
    {
      '<LocalLeader>f',
      function()
        require('conform').format()
      end,
      desc = 'Format buffer',
    },
    {
      '<LocalLeader>f',
      function()
        require('conform').format()
        vim.api.nvim_input('<Esc>') -- escape from visual mode
      end,
      mode = 'v',
      desc = 'Format selection',
    },
    {
      '<LocalLeader>tf',
      function() require('toggler').toggle(format_toggle, vim.api.nvim_get_current_buf()) end,
      desc = 'Toggle format on current buffer',
    },
    {
      '<Leader>tf',
      function() require('toggler').toggle(format_toggle) end,
      desc = 'Toggle format on all buffers',
    },
  },
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },
    -- TODO: use format_after_save instead of creating an autocmd?
  },
  config = function(_, opts)
    require('conform').setup(opts)

    require('toggler').set(format_toggle, { buffer = '⌨', global = '⌨+', off = '' })

    local autoformat_group = vim.api.nvim_create_augroup('auto-format', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = autoformat_group,
      callback = function(event)
        if require('toggler').enabled(format_toggle, event.buffer) then
          require('conform').format()
        end
      end,
    })
  end
}
