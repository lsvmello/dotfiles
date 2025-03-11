-- UI
vim.o.guifont = 'Iosevka:h12'
vim.g.neovide_theme = 'auto'
vim.g.neovide_padding_top    = 2
vim.g.neovide_padding_bottom = 2
vim.g.neovide_padding_right  = 2
vim.g.neovide_padding_left   = 2

-- https://github.com/neovide/neovide/issues/3049
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-blinkwait100-TermCursor'

vim.g.neovide_title_background_color = 'green'
vim.g.neovide_title_text_color = 'pink'

-- Disable animations
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_antialiasing = false
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00

local group = vim.api.nvim_create_augroup('neovide', { clear = true })
vim.api.nvim_create_autocmd('OptionSet', {
  group = group,
  pattern = 'background',
  callback = function()
    -- Set Title Bar Color
    local normal_hl = vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")})
    vim.g.neovide_title_background_color = string.format("%x", normal_hl.bg)
    vim.g.neovide_title_text_color = string.format('%x', normal_hl.fg)
  end
})
