return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter-textobjects", -- configured below
      { "nvim-treesitter/nvim-treesitter-context", config = true },
    },
    -- stylua: ignore
    cmd = {
      "TSInstall", "TSInstallSync", "TSInstallInfo",
      "TSUpdate", "TSUpdateSync", "TSUninstall",
      "TSBufEnable", "TSBufDisable", "TSBufToggle",
      "TSEnable", "TSDisable", "TSToggle",
      "TSModuleInfo", "TSEditQuery", "TSEditQueryUserAfter",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- stylua: ignore
      ensure_installed = {
        "diff", "git_rebase", "gitcommit", "gitignore",
        "markdown", "markdown_inline", "query",
        "regex", "vim", "vimdoc",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

            ["a/"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
            ["i/"] = { query = "@comment.inner", desc = "Select inner part of a comment" },

            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a argument/parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a argument/parameter" },

            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

            ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            ["am"] = { query = "@function.outer", desc = "Select outer part of a function/method definition" },
            ["im"] = { query = "@function.inner", desc = "Select inner part of a function/method definition" },

            ["ar"] = { query = "@return.outer", desc = "Select outer part of a return" },
            ["ir"] = { query = "@return.inner", desc = "Select inner part of a return" },

            ["as"] = { query = "@scope", query_group = "locals", desc = "Select outer part of a scope" },
            ["is"] = { query = "@scope", query_group = "locals", desc = "Select inner part of a scope" },

            ["az"] = { query = "@fold.outer", query_group = "folds", desc = "Select outer part of a fold" },
            ["iz"] = { query = "@fold.inner", query_group = "folds", desc = "Select inner part of a fold" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<LocalLeader>sa"] = "@parameter.inner",
            ["<LocalLeader>sm"] = "@function.outer",
          },
          swap_previous = {
            ["<LocalLeader>sA"] = "@parameter.inner",
            ["<LocalLeader>sM"] = "@function.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]/"] = { query = "@comment.outer", desc = "Next comment" },
            ["]C"] = { query = "@class.outer", desc = "Next class" },
            ["]L"] = { query = "@loop.outer", desc = "Next loop" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
            ["]f"] = { query = "@call.outer", desc = "Next function call" },
            ["]i"] = { query = "@conditional.inner", desc = "Next conditional" },
            ["]m"] = { query = "@function.outer", desc = "Next method" },
            ["]r"] = { query = "@return.inner", desc = "Next return" },
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_previous_start = {
            ["[/"] = { query = "@comment.outer", desc = "Next comment" },
            ["[C"] = { query = "@class.outer", desc = "Previous class" },
            ["[L"] = { query = "@loop.outer", desc = "Previous loop" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter" },
            ["[f"] = { query = "@call.outer", desc = "Previous function call" },
            ["[i"] = { query = "@conditional.inner", desc = "Previous conditional" },
            ["[m"] = { query = "@function.outer", desc = "Previous method" },
            ["[r"] = { query = "@return.inner", desc = "Previous return" },
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
          },
        },
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ["<LocalLeader>K"] = "@function.outer",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "gitsigns.nvim", -- already configured in git.lua
      "harpoon",       -- already configured in editor.lua
    },
    -- stylua: ignore
    keys = {
      ";", ",", "f", "F", "t", "T",
      "[b", "]b", "[c", "]c",
      "[d", "]d", "[e", "]e",
      "[h", "]h", "[l", "]l",
      "[q", "]q", "]t", "[t",
      "[w", "]w",
    },
    config = function()
      local map = function(lhs, rhs, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, rhs, { desc = desc })
      end
      local safe_cmd = function(cmd)
        return function()
          local ok, error_msg = pcall(vim.cmd --[[@as fun()]], cmd)
          if not ok then
            local split_msg = vim.split(error_msg, ":")
            vim.notify(split_msg[#split_msg], vim.log.levels.WARN)
          end
        end
      end

      local repeatable = require("nvim-treesitter.textobjects.repeatable_move")

      -- stylua: ignore start
      map(";", repeatable.repeat_last_move, "Repeat lastest f, t, F, T or custom movement")
      map(",", repeatable.repeat_last_move_opposite, "Repeat lastest f, t, F, T or custom movement in opposite direction")
      map("f", repeatable.builtin_f, "To [count]'th occurence of {char} to the right")
      map("F", repeatable.builtin_F, "To [count]'th occurence of {char} to the left")
      map("t", repeatable.builtin_t, "Till before [count]'th occurence of {char} to the right")
      map("T", repeatable.builtin_T, "Till after [count]'th occurence of {char} to the left")

      local next_buffer, prev_buffer = repeatable.make_repeatable_move_pair(safe_cmd("bnext"), safe_cmd("bprevious"))
      map("]b", next_buffer, "Next Buffer")
      map("[b", prev_buffer, "Previous Buffer")

      local next_hunk, prev_hunk = repeatable.make_repeatable_move_pair(function()
        if vim.wo.diff then
          vim.api.nvim_feedkeys("]c", "n", true)
        else
          require("gitsigns").next_hunk()
        end
      end, function()
        if vim.wo.diff then
          vim.api.nvim_feedkeys("[c", "n", true)
        else
          require("gitsigns").prev_hunk()
        end
      end)
      map("]c", next_hunk, "Jump forward to the next start of a change")
      map("[c", prev_hunk, "Jump backwards to the previous start of a change")

      local next_diagnostic, prev_diagnostic = repeatable.make_repeatable_move_pair(
        vim.diagnostic.goto_next,
        vim.diagnostic.goto_prev)
      map("]d", next_diagnostic, "Next diagnostic")
      map("[d", prev_diagnostic, "Previous diagnostic")

      local next_error, prev_error = repeatable.make_repeatable_move_pair(
        function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
        function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
      map("]e", next_error, "Next error")
      map("[e", prev_error, "Previous error")

      local harpoon = require("harpoon.ui")
      local next_harpoon, prev_harpoon = repeatable.make_repeatable_move_pair(harpoon.nav_next, harpoon.nav_prev)
      map("]h", next_harpoon, "Next harpoon mark")
      map("[h", prev_harpoon, "Previous harpoon mark")

      local next_locationlist, prev_locationlist = repeatable.make_repeatable_move_pair(safe_cmd("lnext"),
        safe_cmd("lprevious"))
      map("]l", next_locationlist, "Next location list item")
      map("[l", prev_locationlist, "Previous location list item")

      local next_quickfix, prev_quickfix = repeatable.make_repeatable_move_pair(safe_cmd("cnext"), safe_cmd("cprevious"))
      map("]q", next_quickfix, "Next quickfix item")
      map("[q", prev_quickfix, "Previous quickfix item")

      local next_tab, prev_tab = repeatable.make_repeatable_move_pair(safe_cmd("tabnext"), safe_cmd("tabprevious"))
      map("]t", next_tab, "Next tab")
      map("[t", prev_tab, "Previous tab")

      local next_window, prev_window = repeatable.make_repeatable_move_pair(safe_cmd("wnext"), safe_cmd("wprevious"))
      map("]w", next_window, "Next window")
      map("[w", prev_window, "Previous window")
    end,
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    cmds = { "TSJJoin", "TSJSplit", "TSJToggle" },
    keys = {
      { "<LocalLeader>j", function() require('treesj').toggle() end, desc = "Join/Split node under cursor" },
    },
    opts = {
      use_default_keymaps = false
    }
  },
}
