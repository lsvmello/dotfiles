return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerBuild', 'OverseerClearCache', 'OverseerClose',
    'OverseerDeleteBundle', 'OverseerInfo', 'OverseerLoadBundle',
    'OverseerOpen', 'OverseerQuickAction', 'OverseerRun',
    'OverseerRunCmd', 'OverseerSaveBundle', 'OverseerTaskAction',
    'OverseerToggle',
  },
  keys = {
    { '<Leader>or', '<Cmd>OverseerRun<CR> | <Cmd>OverseerOpen<CR>', desc = 'Overseer run task' },
    { '<Leader>ot', '<Cmd>OverseerToggle<CR>', desc = 'Overseer toggle task runner' },
    { '<Leader>oo', '<Cmd>OverseerOpen<CR>', desc = 'Overseer open task runner' },
  },
  opts = {},
}
