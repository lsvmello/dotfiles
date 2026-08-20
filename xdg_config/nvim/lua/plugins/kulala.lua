return {
  {
    "mistweaverco/kulala.nvim",
    event = { "SessionLoadPost", "VimLeavePre" },
    ft = { "http", "rest", "javascript", "lua" },
    opts = {},
    keys = {
      { "[[", '<Cmd>lua require("kulala").jump_prev()<CR>', desc = "Jump to the next request", ft = "http" },
      { "]]", '<Cmd>lua require("kulala").jump_next()<CR>', desc = "Jump to the previous request", ft = "http" },
      { "<CR>", '<Cmd>lua require("kulala").run()<CR>', desc = "Execute the request", ft = "http" },
      { "<LocalLeader>c", '<Cmd>lua require("kulala").from_curl()<CR>', desc = "Paste curl from clipboard as request", ft = "http" },
      { "<LocalLeader>C", '<Cmd>lua require("kulala").copy()<CR>', desc = "Copy the current request as a curl command", ft = "http" },
      { "<LocalLeader>e", '<Cmd>lua require("kulala").set_selected_env()<CR>', desc = "Set environment", ft = "http" },
      { "<LocalLeader>i", '<Cmd>lua require("kulala").inspect()<CR>', desc = "Inspect the current request", ft = "http" },
      { "<LocalLeader>o", '<Cmd>lua require("kulala").open()<CR>', desc = "Open Kulala", ft = "http" },
      { "<LocalLeader>q", '<Cmd>lua require("kulala").close()<CR>', desc = "Close Kulala", ft = "http" },
    },
  },
}
