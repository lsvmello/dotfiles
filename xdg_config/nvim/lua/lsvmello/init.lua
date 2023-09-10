vim.g.mapleader = "\\"     -- editor mappings
vim.g.maplocalleader = " " -- editing mappings

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h9"
  vim.g.neovide_transparency = 0.85
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_hide_mouse_when_typing = true
end

-- include configuration files
require("lsvmello.options")
require("lsvmello.keymaps")
require("lsvmello.autocmds")

-- helper functions
function I(...)
  print(unpack(vim.tbl_map(vim.inspect, { ... })))
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
