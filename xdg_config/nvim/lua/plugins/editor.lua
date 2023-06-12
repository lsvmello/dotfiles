return {
  { "numToStr/Comment.nvim", event = "VeryLazy", config = true },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "Wansmer/treesj", config = true, dependencies = { "nvim-treesitter" } },
  {
    "ThePrimeagen/harpoon",
    -- stylua: ignore
    keys = {
      { "<Leader>m", function() require("harpoon.mark").add_file() end, desc = "Harpoon Mark" },
      { "<Leader>h", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Toggle Menu" },
      { "<Leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon Go to 1" },
      { "<Leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon Go to 2" },
      { "<Leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon Go to 3" },
      { "<Leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon Go to 4" },
    },
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-A>", "<Plug>(dial-increment)", mode = { "n", "v" } },
      { "<C-X>", "<Plug>(dial-decrement)", mode = { "n", "v" } },
      { "g<C-A>", "<Plug>(dial-increment-additional)", mode = "v" },
      { "g<C-X>", "<Plug>(dial-decrement-additional)", mode = "v" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
          augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
          augend.constant.new({ elements = { "no", "yes" }, word = true, cyclic = true }),
          augend.constant.new({ elements = { "on", "off" }, word = true, cyclic = true }),
          augend.date.alias["%m/%d"],
          augend.date.alias["%-m/%-d"],
          augend.date.alias["%H:%M"],
          augend.date.alias["%H:%M:%S"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y/%m/%d"],
          augend.decimal_fraction.new({ signed = true }),
          augend.integer.alias.binary,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.semver.alias.semver,
        },
      })
    end,
  },
}
