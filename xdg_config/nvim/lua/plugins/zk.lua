return {
  "mickael-menu/zk-nvim",
  opts = {
    picker = "telescope",
  },
  -- stylua: ignore
  cmd = {
    "ZkBacklinks", "ZkCd", "ZkIndex", "ZkInsertLink",
    "ZkInsertLinkAtSelection", "ZkLinks", "ZkMatch",
    "ZkNew", "ZkNewFromContentSelection",
    "ZkNewFromTitleSelection", "ZkNotes", "ZkTags",
    -- custom commands
    "ZkFleeting", "ZkPermanent", "ZkReference",
  },
  keys = {
    -- Normal Mode
    {
      "<Leader>zo",
      "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
      desc = "[Z]ettelkasten [O]pen Notes",
    },
    {
      "<Leader>zt",
      "<Cmd>ZkTags<CR>",
      desc = "[Z]ettelkasten [T]ags",
    },
    {
      "<Leader>zf",
      "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
      desc = "[Z]ettelkasten [F]ind",
    },
    {
      "<Leader>zn",
      "<Cmd>ZkFleeting<CR>",
      desc = "[Z]ettelkasten [N]ew Fleeting Note",
    },
    {
      "<Leader>zr",
      "<Cmd>ZkReference { title = vim.fn.input('Title: ') }<CR>",
      desc = "[Z]ettelkasten New [R]eference Note",
    },
    {
      "<Leader>zp",
      "<Cmd>ZkPermanent { title = vim.fn.input('Title: ') }<CR>",
      desc = "[Z]ettelkasten New [P]ermanent Note",
    },
    { "<Leader>zb", "<Cmd>ZkBacklinks<CR>", desc = "[Z]ettelkasten [B]acklinks" },
    { "<Leader>zl", "<Cmd>ZkLinks<CR>", desc = "[Z]ettelkasten [L]inks" },
    -- Visual Mode
    {
      "<Leader>zf",
      ":'<,'>ZkMatch<CR>",
      mode = "v",
      desc = "[Z]ettelkasten [F]ind",
    },
    {
      "<Leader>zn",
      ":'<,'>ZkNewFromContentSelection { dir = 'fleeting', group = 'fleeting' } }<CR>",
      mode = "v",
      desc = "[Z]ettelkasten [N]ew Fleeting Note",
    },
    {
      "<Leader>zr",
      ":'<,'>ZkNewFromContentSelection { dir = 'reference', group = 'reference' }, title = vim.fn.input('Title: ') }<CR>",
      mode = "v",
      desc = "[Z]ettelkasten New [R]eference Note",
    },
    {
      "<Leader>zp",
      ":'<,'>ZkNewFromContentSelection { dir = 'permanent', group = 'permanent' }, title = vim.fn.input('Title: ') }<CR>",
      mode = "v",
      desc = "[Z]ettelkasten New [P]ermanent Note",
    },
  },
  ft = function(_, fts)
    -- loads the plugin if it is on a notebook folder
    if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
      table.insert(fts, "markdown")
    end
    return fts
  end,
  config = function(_, opts)
    local zk = require("zk")
    local commands = require("zk.commands")

    local function make_new_fn(group_name)
      return function(options)
        options = vim.tbl_extend("force", { dir = group_name, group = group_name }, options or {})
        zk.new(options)
      end
    end

    zk.setup(opts)
    commands.add("ZkFleeting", make_new_fn("fleeting"))
    commands.add("ZkPermanent", make_new_fn("permanent"))
    commands.add("ZkReference", make_new_fn("reference"))
  end,
}
