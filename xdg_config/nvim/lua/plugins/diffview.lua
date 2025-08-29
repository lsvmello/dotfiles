return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewClose", "DiffviewFileHistory",
    "DiffviewFocusFiles", "DiffviewOpen",
    "DiffviewRefresh", "DiffviewToggleFiles",
  },
  keys = {
    { "<Leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
    { "<Leader>gh", "<Cmd>DiffviewFileHistory<CR>", desc = "Open Diffview branch history" },
    { "<LocalLeader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Open Diffview file history" },
  },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
      keymaps = {
        diff3 = {
          { "n", ">c", actions.diffget("ours"), { desc = "Obtain the diff hunk from the LEFT version of the file" } },
          { "n", "<c", actions.diffget("theirs"), { desc = "Obtain the diff hunk from the RIGHT version of the file" } },
          { "n", ">x", actions.conflict_choose("ours"), { desc = "Choose the LEFT version of a conflict" } },
          { "n", "<x", actions.conflict_choose("theirs"), { desc = "Choose the RIGHT version of a conflict" } },
          { "n", ">X", actions.conflict_choose_all("ours"), { desc = "Choose the LEFT version of a conflict for the whole file" } },
          { "n", "<X", actions.conflict_choose_all("theirs"), { desc = "Choose the RIGHT version of a conflict for the whole file" } },
        },
      },
    })
  end,
}
