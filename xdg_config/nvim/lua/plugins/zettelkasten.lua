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
      "<leader>zo",
      "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
      desc = "[Z]ettelkasten [O]pen Notes",
    },
    {
      "<leader>zt",
      "<Cmd>ZkTags<CR>",
      desc = "[Z]ettelkasten [T]ags",
    },
    {
      "<leader>zf",
      "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
      desc = "[Z]ettelkasten [F]ind",
    },
    {
      "<leader>zn",
      "<Cmd>ZkFleeting<CR>",
      desc = "[Z]ettelkasten [N]ew Fleeting Note",
    },
    {
      "<leader>zr",
      "<Cmd>ZkReference { title = vim.fn.input('Title: ') }<CR>",
      desc = "[Z]ettelkasten New [R]eference Note",
    },
    {
      "<leader>zp",
      "<Cmd>ZkPermanent { title = vim.fn.input('Title: ') }<CR>",
      desc = "[Z]ettelkasten New [P]ermanent Note",
    },
    { "<leader>zb", "<Cmd>ZkBacklinks<CR>", desc = "[Z]ettelkasten [B]acklinks" },
    { "<leader>zl", "<Cmd>ZkLinks<CR>", desc = "[Z]ettelkasten [L]inks" },
    -- Visual Mode
    {
      "<leader>zf",
      ":'<,'>ZkMatch<CR>",
      mode = "v",
      desc = "[Z]ettelkasten [F]ind",
    },
    {
      "<leader>zn",
      ":'<,'>ZkNewFromContentSelection { dir = 'fleeting', group = 'fleeting' } }<CR>",
      mode = "v",
      desc = "[Z]ettelkasten [N]ew Fleeting Note",
    },
    {
      "<leader>zr",
      ":'<,'>ZkNewFromContentSelection { dir = 'reference', group = 'reference' }, title = vim.fn.input('Title: ') }<CR>",
      mode = "v",
      desc = "[Z]ettelkasten New [R]eference Note",
    },
    {
      "<leader>zp",
      ":'<,'>ZkNewFromContentSelection { dir = 'permanent', group = 'permanent' }, title = vim.fn.input('Title: ') }<CR>",
      mode = "v",
      desc = "[Z]ettelkasten New [P]ermanent Note",
    },
  },
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
