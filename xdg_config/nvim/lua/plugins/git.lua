return {
  {
    "tpope/vim-fugitive",
    ft = { "git", "gitcommit", "gitrebase" },
    -- stylua: ignore
    cmd = {
      -- fill other commands
      "G", "GBrowse", "GDelete", "GMove",
      "GRemove", "GRename", "GUnlink",
      "GcLog", "Gcd", "Gclog",
      "Gdiffsplit", "Gdrop", "Ge",
      "Gedit", "Ggrep", "Ghdiffsplit",
      "Git", "GlLog", "Glcd", "Glgrep",
      "Gllog", "Gpedit", "Gr", "Gread",
      "Gsplit", "Gtabedit", "Gvdiffsplit",
      "Gvsplit", "Gw", "Gwq", "Gwrite",
    },
    keys = {
      { "<Leader>gs", "<Cmd>Git<CR>", desc = "[G]it [S]tatus" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
    keys = function()
      local gs = require("gitsigns")

      -- stylua: ignore start
      return {
        { "]h", gs.next_hunk, "Next Hunk" },
        { "[h", gs.prev_hunk, "Previous Hunk" },
        { "<Leader>gb", function() gs.blame_line({ full = true }) end, desc = "[G]it [B]lame Line" },
        { "<Leader>gd", gs.diffthis, desc = "[G]it [D]iff This" },
        { "<Leader>gD", function() gs.diffthis("~") end, desc = "[G]it [D]iff This ~" },
        -- Text Objects
        { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "GitSigns Select Hunk" },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    -- stylua: ignore
    cmd = {
      "DiffviewClose", "DiffviewFileHistory",
      "DiffviewFocusFiles", "DiffviewLog",
      "DiffviewOpen", "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    opts = {
      keymaps = {
        file_panel = {
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview History" } },
        },
      },
    },
  },
}
