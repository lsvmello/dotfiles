vim.g.mapleader = '\\'     -- editor related mappings
vim.g.maplocalleader = ' ' -- buffer related mappings

if vim.g.neovide then
  require('neovide')
else
  vim.o.background = 'light' -- https://github.com/neovim/neovim/issues/32238
end
vim.cmd [[colorscheme default]]

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- use lazy.nvim
require('lazy').setup({
  spec = {
    { 'folke/lazy.nvim', version = '*' },
    { import = 'plugins' },
    { import = 'plugins.coding' },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      -- stylua: ignore
      disabled_plugins = {
        'gzip', 'matchit',
        'matchparen', 'tarPlugin',
        'zipPlugin',
      },
    },
  },
})
