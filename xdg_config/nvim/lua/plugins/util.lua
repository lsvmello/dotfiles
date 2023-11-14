return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    "mbbill/undotree",
    -- stylua: ignore
    cmd = {
      "UndotreeFocus", "UndotreeHide",
      "UndotreeShow", "UndotreeToggle",
    },
    keys = {
      {
        "<Leader>u",
        function()
          vim.cmd.UndotreeToggle()
          vim.cmd.UndotreeFocus()
        end,
        desc = "UndoTree toggle",
      },
    },
  },
}
