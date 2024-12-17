vim.g.mapleader = "\\"     -- editor-wise mappings
vim.g.maplocalleader = " " -- editing-wise mappings

if vim.fn.has("win32") == 1 then
  vim.g.python3_host_prog = "C:\\Python312\\python.exe"
end

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- use lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.coding" },
  },
  dev = {
    path = "~/git",
  },
  install = {
    colorscheme = {
      "catppuccin",
      "habamax",
    },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      -- stylua: ignore
      disabled_plugins = {
        "gzip", "matchit", "matchparen",
        "tarPlugin", "tohtml",
        "zipPlugin",
      },
    },
  },
})
