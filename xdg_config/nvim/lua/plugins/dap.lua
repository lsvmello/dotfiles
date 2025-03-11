return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      {
        'rcarriga/nvim-dap-ui',
        opts = {},
        config = function(_, opts)
          local dap = require('dap')
          local dapui = require('dapui')
          dapui.setup(opts)
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close({})
          end
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    -- stylua: ignore
    cmd = {
      'DapEval', 'DapNew', 'DapContinue', 'DapDisconnect',
      'DapLoadLaunchJSON', 'DapRestartFrame', 'DapSetLogLevel',
      'DapShowLog', 'DapStepInto', 'DapStepOut', 'DapStepOver',
      'DapTerminate', 'DapToggleBreakpoint', 'DapToggleRepl',
    },
    keys = {
      -- TODO: review these mappings
      { '<Leader>db', function() require('dap').toggle_breakpoint() end,                                    desc = 'Debug Toggle Breakpoint' },
      { '<Leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug Breakpoint Condition' },
      { '<Leader>dc', function() require('dap').continue() end,                                             desc = 'Debug Continue' },
      { '<Leader>dC', function() require('dap').run_to_cursor() end,                                        desc = 'Debug Run to Cursor' },
      { '<Leader>de', function() require('dapui').eval() end,                                               desc = 'Debug Eval',                   mode = { 'n', 'v' } },
      { '<Leader>dg', function() require('dap').goto_() end,                                                desc = 'Debug Go to Line (No Execute)' },
      { '<Leader>di', function() require('dap').step_into() end,                                            desc = 'Debug Step Into' },
      { '<Leader>dj', function() require('dap').down() end,                                                 desc = 'Debug Down' },
      { '<Leader>dk', function() require('dap').up() end,                                                   desc = 'Debug Up' },
      { '<Leader>dl', function() require('dap').run_last() end,                                             desc = 'Debug Run Last' },
      { '<Leader>do', function() require('dap').step_out() end,                                             desc = 'Debug Step Out' },
      { '<Leader>dO', function() require('dap').step_over() end,                                            desc = 'Debug Step Over' },
      { '<Leader>dp', function() require('dap').pause() end,                                                desc = 'Debug Pause' },
      { '<Leader>dr', function() require('dap').repl.toggle() end,                                          desc = 'Debug Toggle REPL' },
      { '<Leader>ds', function() require('dap').session() end,                                              desc = 'Debug Session' },
      { '<Leader>dt', function() require('dap').terminate() end,                                            desc = 'Debug Terminate' },
      { '<Leader>du', function() require('dapui').toggle({}) end,                                           desc = 'Debug UI' },
      { '<Leader>dw', function() require('dap.ui.widgets').hover() end,                                     desc = 'Debug Widgets' },
    },

    config = function()
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      for name, sign in pairs(require('icons').dap) do
        vim.fn.sign_define(
          'Dap' .. name,
          { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },
}
