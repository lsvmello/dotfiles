return {
  'mbbill/undotree',
  cmd = {
    'UndotreeFocus', 'UndotreeHide',
    'UndotreePersistUndo',
    'UndotreeShow', 'UndotreeToggle',
  },
  keys = {
    { '<LocalLeader>u', '<Cmd>UndotreeToggle<CR>', desc = 'Undotree Toggle' },
  },
  init = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_DiffAutoOpen = 0
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_SplitWidth = 40
    vim.g.undotree_DiffpanelHeight = 20
    vim.g.undotree_DiffCommand = 'git diff --no-index'
  end,
}
