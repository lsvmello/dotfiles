-- include configuration files
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- include package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- use package manager
require("lazy").setup("plugins", {
  install = {
    colorscheme = {
      "rose-pine",
      "catppuccin",
      "tokyonight",
      "habamax",
    },
  },
  change_detection = {
    notify = false,
  },
})
