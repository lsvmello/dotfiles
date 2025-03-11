return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  keys = {
    { '<LocalLeader>-', '<Cmd>Oil<CR>', desc = 'Open parent directory' },
    { '<Leader>-', function()
      require('oil').open(vim.fn.getcwd())
    end, desc = 'Open current working directory' },
  },
  opts = {
    columns = {
      { 'mtime', highlight = 'Number', format = '%Y/%m/%d %I:%M %p' },
      { 'size', highlight = 'Special' },
      'icon',
    },
    win_options = {
      spell = false,
      number = false,
      relativenumber = false,
    },
    keymaps = {
      ['q'] = { 'actions.close', mode = 'n' },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
