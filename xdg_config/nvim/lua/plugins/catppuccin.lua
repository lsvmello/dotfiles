return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end,
  opts = {
    show_end_of_buffer = true,
    term_colors = true,
    no_italic = true,
  },
}
