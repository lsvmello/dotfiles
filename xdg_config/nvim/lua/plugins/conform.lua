return {
  'stevearc/conform.nvim',
  cmd = { 'Autoformat', 'ConformInfo' },
  keys = {
    { 'gq', mode = '' },
    { 'gw', mode = '' },
  },
  opts = {
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
  init = function()
    vim.o.formatexpr = [[v:lua.require'conform'.formatexpr()]]

    vim.api.nvim_create_user_command('Autoformat', function(opts)
      local scope = opts.bang and vim.g or vim.b
      if opts.args == '' then
        scope.disable_autoformat = not scope.disable_autoformat
      elseif opts.args == 'true' or opts.args == 'enable' then
        scope.disable_autoformat = false
      elseif opts.args == 'false' or opts.args == 'disable' then
        scope.disable_autoformat = true
      else
        vim.api.nvim_echo({ { 'Autoformat: Invalid option' } }, false, { err = true })
        return
      end
      local state = scope.disable_autoformat and 'disabled' or 'enabled'
      local context = opts.bang and ' globally' or ' on current buffer'
      vim.api.nvim_echo({ { 'Autoformat ' .. state .. context } }, true, {})
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true,
      nargs = '?',
      complete = function(arg_lead, cmd_line)
        return vim.tbl_filter(function(val)
          return vim.startswith(val, arg_lead)
        end, { 'disable', 'enabled', 'false', 'true' })
      end
    })
  end
}
