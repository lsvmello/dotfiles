return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewClose", "DiffviewFileHistory",
    "DiffviewFocusFiles", "DiffviewOpen",
    "DiffviewRefresh", "DiffviewToggleFiles",
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
          { "n", ">", actions.diffget("ours"), { desc = "Obtain the diff hunk from the LEFT version of the file" } },
          { "n", "<", actions.diffget("theirs"), { desc = "Obtain the diff hunk from the RIGHT version of the file" } },
        },
      },
    })
  end,
}
