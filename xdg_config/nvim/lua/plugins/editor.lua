return {
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  {
    "tpope/vim-commentary",
    dependencies = { "nvim-treesitter" },
    keys = { { "gc", mode = { "n", "v", "o" } } },
    cmd = { "Commentary" },
  },
  {
    "ThePrimeagen/harpoon",
    -- stylua: ignore
    keys = {
      { "<Leader>h",  function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon" },
      { "<Leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Toggle Menu" },
      { "<Leader>hm", function() require("harpoon.mark").add_file() end,        desc = "Harpoon Mark" },
      { "<Leader>h1", function() require("harpoon.ui").nav_file(1) end,         desc = "Harpoon Go to 1" },
      { "<Leader>h2", function() require("harpoon.ui").nav_file(2) end,         desc = "Harpoon Go to 2" },
      { "<Leader>h3", function() require("harpoon.ui").nav_file(3) end,         desc = "Harpoon Go to 3" },
      { "<Leader>h4", function() require("harpoon.ui").nav_file(4) end,         desc = "Harpoon Go to 4" },
      { "<Leader>h5", function() require("harpoon.ui").nav_file(5) end,         desc = "Harpoon Go to 5" },
    },
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-A>",  "<Plug>(dial-increment)", mode = { "n", "v" } },
      { "<C-X>",  "<Plug>(dial-decrement)", mode = { "n", "v" } },
      { "g<C-A>", "g<Plug>(dial-increment)", mode = { "n", "v" }, remap = true },
      { "g<C-X>", "g<Plug>(dial-decrement)", mode = { "n", "v" }, remap = true },
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
