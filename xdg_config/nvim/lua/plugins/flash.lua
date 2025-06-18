return {
  "folke/flash.nvim",
  opts = {
    search = {
      multi_window = false,
    },
    modes = {
      char = {
        highlight = { backdrop = false },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash search" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash search with Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Remote Flash with Treesitter" },
    { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
