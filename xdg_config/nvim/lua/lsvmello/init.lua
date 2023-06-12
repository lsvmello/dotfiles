vim.g.mapleader = "\\" -- editor mappings
vim.g.maplocalleader = " " -- editing mappings

-- include configuration files
require("lsvmello.options")
require("lsvmello.keymaps")
require("lsvmello.autocmds")

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
require("lazy").setup("plugins", {
  dev = {
    path = "~/work",
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
})
