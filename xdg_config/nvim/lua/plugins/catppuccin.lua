return {
  'catppuccin/nvim',
  cond = false,
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  opts = {
    show_end_of_buffer = true,
    term_colors = true,
    default_integrations = false,
    integrations = {
      blink_cmp = true,
      copilot_vim = true,
      dap = true,
      dap_ui = true,
      diffview = true,
      dropbar = {
        enabled = true,
        color_mode = false,
      },
      fidget = true,
      fzf = true,
      gitsigns = true,
      mason = true,
      mini = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
          ok = { 'italic' },
        },
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
          ok = { 'undercurl' },
        },
        inlay_hints = {
          background = true,
        },
      },
      neogit = true,
      overseer = true,
      render_markdown = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
    },
    custom_highlights = function(C)
      return {
--[[
    color_name |  mocha  |  latte  |
    rosewater  | #f5e0dc | #dc8a78 |
    flamingo   | #f2cdcd | #dd7878 |
    pink       | #f5c2e7 | #ea76cb |
    mauve      | #cba6f7 | #8839ef |
    red        | #f38ba8 | #d20f39 |
    maroon     | #eba0ac | #e64553 |
    peach      | #fab387 | #fe640b |
    yellow     | #f9e2af | #df8e1d |
    green      | #a6e3a1 | #40a02b |
    teal       | #94e2d5 | #179299 |
    sky        | #89dceb | #04a5e5 |
    sapphire   | #74c7ec | #209fb5 |
    blue       | #89b4fa | #1e66f5 |
    lavender   | #b4befe | #7287fd |
    text       | #cdd6f4 | #4c4f69 |
    subtext1   | #bac2de | #5c5f77 |
    subtext0   | #a6adc8 | #6c6f85 |
    overlay2   | #9399b2 | #7c7f93 |
    overlay1   | #7f849c | #8c8fa1 |
    overlay0   | #6c7086 | #9ca0b0 |
    surface2   | #585b70 | #acb0be |
    surface1   | #45475a | #bcc0cc |
    surface0   | #313244 | #ccd0da |
    base       | #1e1e2e | #eff1f5 |
    mantle     | #181825 | #e6e9ef |
    crust      | #11111b | #dce0e8 |
--]]

        NormalMode        = { fg = C.blue },
        InsertMode        = { fg = C.green },
        VisualMode        = { fg = C.mauve },
        CommandMode       = { fg = C.peach },
        ReplaceMode       = { fg = C.red },
        SelectMode        = { fg = C.mauve },
        TerminalMode      = { fg = C.green },

        InclineBorder     = { fg = C.mantle },
        InclineBackground = { bg = C.mantle },
      }
    end,
  },
  init = function()
    vim.cmd.colorscheme('catppuccin')
  end,
}
