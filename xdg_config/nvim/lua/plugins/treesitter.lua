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
            ["a/"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["am"] = { query = "@function.outer", desc = "Select outer part of a method" },
            ["ar"] = { query = "@return.outer", desc = "Select outer part of a return" },
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select outer part of a scope" },
            ["az"] = { query = "@fold.outer", query_group = "folds", desc = "Select outer part of a fold" },
            ["i/"] = { query = "@comment.inner", desc = "Select inner part of a comment" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
            ["im"] = { query = "@function.inner", desc = "Select inner part of a method" },
            ["ir"] = { query = "@return.inner", desc = "Select inner part of a return" },
            ["is"] = { query = "@scope", query_group = "locals", desc = "Select inner part of a scope" },
            ["iz"] = { query = "@fold.inner", query_group = "folds", desc = "Select inner part of a fold" },
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<LocalLeader>a"] = "@parameter.inner" },
          swap_previous = { ["<LocalLeader>A"] = "@parameter.inner" },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]/"] = { query = "@comment.outer", desc = "Next Comment" },
            ["]C"] = { query = "@class.outer", desc = "Next Class" },
            ["]L"] = { query = "@loop.outer", desc = "Next Loop" },
            ["]f"] = { query = "@function.outer", desc = "Next Function" },
            ["]i"] = { query = "@conditional.inner", desc = "Next Conditional" },
            ["]m"] = { query = "@function.outer", desc = "Next Method" },
            ["]r"] = { query = "@return.inner", desc = "Next Return" },
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next Scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next Fold" },
          },
          goto_previous_start = {
            ["[/"] = { query = "@comment.outer", desc = "Next Comment" },
            ["[C"] = { query = "@class.outer", desc = "Previous Class" },
            ["[L"] = { query = "@loop.outer", desc = "Previous Loop" },
            ["[f"] = { query = "@function.outer", desc = "Previous Function" },
            ["[i"] = { query = "@conditional.inner", desc = "Previous Conditional" },
            ["[m"] = { query = "@function.outer", desc = "Previous Method" },
            ["[r"] = { query = "@return.inner", desc = "Previous Return" },
            ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous Scope" },
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous Fold" },
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
      local map = function(lhs, rhs, opts)
        opts = opts or {}
        vim.keymap.set({ "n", "x", "o" }, lhs, rhs, opts)
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
      map(";", repeatable.repeat_last_move, { desc = "Repeat lastest f, t, F, T or custom movement" })
      map(",", repeatable.repeat_last_move_opposite,
        { desc = "Repeat lastest f, t, F, T or custom movement in opposite direction" })
      map("f", repeatable.builtin_f, { desc = "To [count]'th occurence of {char} to the right" })
      map("F", repeatable.builtin_F, { desc = "To [count]'th occurence of {char} to the left" })
      map("t", repeatable.builtin_t, { desc = "Till before [count]'th occurence of {char} to the right" })
      map("T", repeatable.builtin_T, { desc = "Till after [count]'th occurence of {char} to the left" })

      local next_buffer, prev_buffer = repeatable.make_repeatable_move_pair(safe_cmd("bnext"), safe_cmd("bprevious"))
      map("]b", next_buffer, { desc = "Next Buffer" })
      map("[b", prev_buffer, { desc = "Previous Buffer" })

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
      map("]c", next_hunk, { desc = "Jump forward to the next start of a change" })
      map("[c", prev_hunk, { desc = "Jump backwards to the previous start of a change" })

      local next_diagnostic, prev_diagnostic = repeatable.make_repeatable_move_pair(
        vim.diagnostic.goto_next,
        vim.diagnostic.goto_prev)
      map("]d", next_diagnostic, { desc = "Next Diagnostic" })
      map("[d", prev_diagnostic, { desc = "Previous Diagnostic" })

      local next_error, prev_error = repeatable.make_repeatable_move_pair(
        function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
        function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
      map("]e", next_error, { desc = "Next Error" })
      map("[e", prev_error, { desc = "Previous Error" })

      local harpoon = require("harpoon.ui")
      local next_harpoon, prev_harpoon = repeatable.make_repeatable_move_pair(harpoon.nav_next, harpoon.nav_prev)
      map("]h", next_harpoon, { desc = "Next Harpoon Mark" })
      map("[h", prev_harpoon, { desc = "Previous Harpoon Mark" })

      local next_locationlist, prev_locationlist = repeatable.make_repeatable_move_pair(safe_cmd("lnext"),
        safe_cmd("lprevious"))
      map("]l", next_locationlist, { desc = "Next Location List item" })
      map("[l", prev_locationlist, { desc = "Previous Location List item" })

      local next_quickfix, prev_quickfix = repeatable.make_repeatable_move_pair(safe_cmd("cnext"), safe_cmd("cprevious"))
      map("]q", next_quickfix, { desc = "Next Quickfix item" })
      map("[q", prev_quickfix, { desc = "Previous Quickfix item" })

      local next_tab, prev_tab = repeatable.make_repeatable_move_pair(safe_cmd("tabnext"), safe_cmd("tabprevious"))
      map("]t", next_tab, { desc = "Next Tab" })
      map("[t", prev_tab, { desc = "Previous Tab" })

      local next_window, prev_window = repeatable.make_repeatable_move_pair(safe_cmd("wnext"), safe_cmd("wprevious"))
      map("]w", next_window, { desc = "Next Window" })
      map("[w", prev_window, { desc = "Previous Window" })
    end,
  },
}
