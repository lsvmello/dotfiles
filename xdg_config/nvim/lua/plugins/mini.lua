return {
  "echasnovski/mini.nvim",
  event = "VeryLazy",
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  keys = {
    { "<Leader>-", function() MiniFiles.open() end, desc = "Open current working directory" },
    { "<LocalLeader>-", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, desc = "Open current buffer directory" },
  },
  config = function()
    require("mini.icons").setup()
    require("mini.move").setup()
    require("mini.surround").setup()
    require("mini.splitjoin").setup()
    require("mini.files").setup()
    local ai = require("mini.ai")
    local gen_ai_spec = require("mini.extra").gen_ai_spec
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        ["="] = ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.rhs", }),
        ["/"] = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
        a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner", }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        f = ai.gen_spec.treesitter({ a = "@call.outer", i = "@call.inner", }),
        G = gen_ai_spec.buffer(),
        i = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner", }),
        l = ai.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner", }),
        m = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner", }),
        n = gen_ai_spec.number(),
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        r = ai.gen_spec.treesitter({ a = "@return.outer", i = "@return.inner", }),
        s = ai.gen_spec.treesitter({ a = "@scope", i = "@scope", }),
        z = ai.gen_spec.treesitter({ a = "@fold.outer", i = "@fold.inner", }),
      },
      silent = true,
    })
    local clue = require("mini.clue")
    clue.setup({
      window = {
        delay = 500,
        config = {
          width = "auto",
          border = "double",
        },
      },
      triggers = {
        -- Leader and LocalLeader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "<LocalLeader>" },
        { mode = "x", keys = "<LocalLeader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },

      clues = {
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
      },
    })
    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
      highlighters = {
        fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        todo      = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo"  },
        todo2     = { pattern = "%f[%a]()TODO%f[%A]%(%w+%)()", group = "MiniHipatternsTodo" },
        note      = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote"  },
        hex_color = hipatterns.gen_highlighter.hex_color(),
        hsl_color = {
          pattern = "hsl%(%d+,?%s?%d+,?%s?%d+%)",
          group = function(_, match)
            --- @type string, string, string
            local h, s, l = match:match("hsl%((%d+),?%s?(%d+),?%s?(%d+)%)")
            local hex_color = require("custom.color").hsl_to_hex(tonumber(h), tonumber(s), tonumber(l))
            return hipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
        rgb_color = {
          pattern = "rgb%(%d+,?%s?%d+,?%s?%d+%)",
          group = function(_, match)
            --- @type string, string, string
            local r, g, b = match:match("rgb%((%d+),?%s?(%d+),?%s?(%d+)%)")
            local hex_color = require("custom.color").rgb_to_hex(tonumber(r), tonumber(g), tonumber(b))
            return hipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    })
  end,
}