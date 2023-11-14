return {
  {
    "tpope/vim-fugitive",
    ft = { "git", "gitcommit", "gitrebase" },
    -- stylua: ignore
    cmd = {
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

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- stylua: ignore start
        -- Actions
        map("n", "<LocalLeader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<LocalLeader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<LocalLeader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
        map("v", "<LocalLeader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
        map("n", "<LocalLeader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<LocalLeader>hU", gs.undo_stage_hunk, "Undo stage buffer")
        map("n", "<LocalLeader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<LocalLeader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<LocalLeader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<LocalLeader>tb", gs.toggle_current_line_blame, "Current line blame")
        map("n", "<LocalLeader>hd", gs.diffthis, "Diff this")
        map("n", "<LocalLeader>hD", function() gs.diffthis("~") end, "Diff this ~")
        map("n", "<LocalLeader>td", gs.toggle_deleted, "Toggle deleted")
        -- Text objects
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        -- stylua: ignore end
      end,
    },
  },
}
