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
    "ThePrimeagen/harpoon",
    -- stylua: ignore
    keys = {
      { "<leader>m", function() require("harpoon.mark").add_file() end, desc = "Harpoon Mark" },
      { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Toggle Menu" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon Go to 1" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon Go to 2" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon Go to 3" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon Go to 4" },
    },
  },
}
