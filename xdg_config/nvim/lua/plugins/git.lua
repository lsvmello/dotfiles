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
      { "<Leader>g", ":Git ", desc = "[G]it" },
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
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- stylua: ignore start
        -- Actions
        map("n", "<LocalLeader>hs", gs.stage_hunk)
        map("n", "<LocalLeader>hr", gs.reset_hunk)
        map("v", "<LocalLeader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        map("v", "<LocalLeader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        map("n", "<LocalLeader>hS", gs.stage_buffer)
        map("n", "<LocalLeader>hu", gs.undo_stage_hunk)
        map("n", "<LocalLeader>hR", gs.reset_buffer)
        map("n", "<LocalLeader>hp", gs.preview_hunk)
        map("n", "<LocalLeader>hb", function() gs.blame_line({ full = true }) end)
        map("n", "<LocalLeader>tb", gs.toggle_current_line_blame)
        map("n", "<LocalLeader>hd", gs.diffthis)
        map("n", "<LocalLeader>hD", function() gs.diffthis("~") end)
        map("n", "<LocalLeader>td", gs.toggle_deleted)
        -- Text objects
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
        -- stylua: ignore end
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
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview History" } },
        },
      },
    },
  },
}
