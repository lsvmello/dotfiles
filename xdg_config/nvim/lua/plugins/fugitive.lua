return {
  "tpope/vim-fugitive",
  ft = {
    "git", "gitattributes", "gitcommit",
    "gitconfig", "gitignore", "gitrebase",
  },
  cmd = {
    "G", "GBrowse", "GDelete", "GMove",
    "GRemove", "GRename", "GUnlink", "GcLog",
    "Gcd", "Gclog", "Gdiffsplit", "Gdrop",
    "Ge", "Gedit", "Ggrep", "Ghdiffsplit",
    "Git", "Glcd", "Glgrep", "Gllog",
    "Gllog", "Gpedit", "Gr", "Gread",
    "Gsplit", "Gtabedit", "Gvdiffsplit",
    "Gvsplit", "Gw", "Gwq", "Gwrite",
  },
  keys = {
    { "<Leader>gs", "<Cmd>Git<CR>", desc = "Git" },
    { "<Leader>gg", "<Cmd>Git<CR>", desc = "Git" },
    { "<Leader>g<Space>", ":Git ", desc = "Git command" },
    -- TODO: add more keymaps
  },
}
