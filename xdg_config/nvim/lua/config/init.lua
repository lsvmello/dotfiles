-- include configuration files
require("config.options")
require("config.keymaps")
require("config.autocmds")

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
})
