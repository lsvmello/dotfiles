return {
  {
    "tpope/vim-fugitive",
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
      { "<leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
        -- Text objects
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
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
          { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview History" } },
        },
      },
    },
  },
}
