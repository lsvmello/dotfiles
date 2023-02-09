return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
    dependencies = {
      "tpope/vim-repeat",
    },
  },
  {
    "mbbill/undotree",
    -- stylua: ignore
    cmd = {
      "UndotreeFocus", "UndotreeHide",
      "UndotreeShow", "UndotreeToggle",
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>u", function()
          vim.cmd.UndotreeToggle()
          vim.cmd.UndotreeFocus()
        end, desc = "UndoTree Toggle",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      -- stylua: ignore start
      vim.keymap.set("n", "<leader>m", mark.add_file, { desc = "Harpoon Mark" })
      vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Toggle Menu" })
      vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon Go to 1" })
      vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon Go to 2" })
      vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon Go to 3" })
      vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon Go to 4" })
    end,
  },
}
