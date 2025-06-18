return {
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
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Jump to next hunk")
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Jump to previous hunk")
      -- buffer
      map("n", "<LocalLeader>gb", "<Cmd>Gitsigns blame_line full=true<CR>", "Blame line")
      map("n", "<LocalLeader>gB", "<Cmd>Gitsigns blame<CR>", "Git blame buffer")
      map("n", "<LocalLeader>gd", "<Cmd>Gitsigns diffthis<CR>", "Diff this buffer with staged")
      map("n", "<LocalLeader>gD", "<Cmd>Gitsigns diffthis<CR>", "Diff this buffer with HEAD")
    end,
  },
}
