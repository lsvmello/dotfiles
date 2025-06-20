return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "<LocalLeader>-", "<Cmd>Oil<CR>", desc = "Open buffer directory" },
    {
      "<Leader>-",
      function()
        require("oil").open(vim.fn.getcwd())
      end,
      desc = "Open current working directory",
    },
  },
  opts = {
    columns = {
      { "mtime", highlight = "Number", format = "%Y/%m/%d %I:%M %p" },
      { "size", highlight = "Special" },
      "icon",
    },
    win_options = {
      spell = false,
      number = false,
      relativenumber = false,
    },
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-v>"] = { "actions.select", opts = { vertical = true, close = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true, close = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true, close = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["q"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["gy"] = "actions.yank_entry",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
