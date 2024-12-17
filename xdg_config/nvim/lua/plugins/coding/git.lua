local git_fts = {
  "git", "gitattributes",
  "gitcommit", "gitconfig",
  "gitignore", "gitrebase"
}
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "git_config", "gitcommit",
        "git_rebase", "gitignore",
        "gitattributes"
      }
    },
  },
  {
    "tpope/vim-fugitive",
    ft = git_fts,
    -- stylua: ignore
    cmd = {
      "G", "GBrowse", "GDelete", "GMove", "GRemove",
      "GRename", "GUnlink", "GcLog", "Gcd", "Gclog",
      "Gdiffsplit", "Gdrop", "Ge", "Gedit", "Ggrep",
      "Ghdiffsplit", "Git", "Glcd", "Glgrep", "Gllog",
      "Gllog", "Gpedit", "Gr", "Gread", "Gsplit",
      "Gtabedit", "Gvdiffsplit", "Gvsplit", "Gw",
      "Gwq", "Gwrite",
    },
    keys = {
      { "<Leader>gs",       "<Cmd>Git<CR>", desc = "Git" },
      { "<Leader>gg",       "<Cmd>Git<CR>", desc = "Git" },
      { "<Leader>g<Space>", ":Git ",        desc = "Git command" },
      -- TODO: add more keymaps to USEFUL commands
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "GitSigns",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Jump to next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Jump to previous hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Jump to last hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "Jump to first hunk")
        -- buffer
        map("n", "<LocalLeader>gb", "<Cmd>Gitsigns blame_line full=true<CR>", "Blame line")
        map("n", "<LocalLeader>gd", "<Cmd>Gitsigns diffthis<CR>", "Diff this")
        -- hunk
        map({ "n", "v" }, "<LocalLeader>hs", "<Cmd>Gitsigns stage_hunk<CR>", "Stage hunk")
        map("n", "<LocalLeader>hS", "<Cmd>Gitsigns stage_buffer<CR>", "Stage buffer")
        map({ "n", "v" }, "<LocalLeader>hr", "<Cmd>Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<LocalLeader>hR", "<Cmd>Gitsigns reset_buffer<CR>", "Reset buffer")
        map("n", "<LocalLeader>hp", "<Cmd>Gitsigns preview_hunk<CR>", "Preview hunk")
        map("n", "<LocalLeader>hu", "<Cmd>Gitsigns undo_stage_hunk<CR>", "Undo stage hunk")
        -- toggles
        map("n", "<LocalLeader>tb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle blame line")
        map("n", "<LocalLeader>td", "<Cmd>Gitsigns toggle_deleted<CR>", "Toggle deleted hunk")
        -- Text objects
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "around a hunk")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "inside a hunk")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles",
      "DiffviewOpen", "DiffviewRefresh", "DiffviewToggleFiles",
    },
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        keymaps = {
          -- TODO: confirm these
          diff3 = {
            { "n", ">", actions.diffget("ours"), { desc = "Get ours leo" } },
            { "n", "<", actions.diffget("theirs"), { desc = "Get theirs leo" } },
            { "n", "]]", "]c", { desc = "Next leo" } },
            { "n", "[[", "[c", { desc = "Previous leo" } },
          },
        },
      })
  end,
  },
}
