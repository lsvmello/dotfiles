-- Neovim's default color scheme extension

-- Clear hlgroups and set colors_name {{{
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") then
  vim.cmd.syntax("reset")
end
vim.g.colors_name = "default"
-- }}}

-- Colors {{{
local dark_blue     = "NvimDarkBlue"     -- #004c73
local dark_cyan     = "NvimDarkCyan"     -- #007373
local dark_green    = "NvimDarkGreen"    -- #005523
local dark_grey1    = "NvimDarkGrey1"    -- #07080d
local dark_grey2    = "NvimDarkGrey2"    -- #14161b
local dark_grey3    = "NvimDarkGrey3"    -- #2c2e33
local dark_grey4    = "NvimDarkGrey4"    -- #4f5258
local dark_magenta  = "NvimDarkMagenta"  -- #470045
local dark_red      = "NvimDarkRed"      -- #590008
local dark_yellow   = "NvimDarkYellow"   -- #6b5300
local light_blue    = "NvimLightBlue"    -- #a6dbff
local light_cyan    = "NvimLightCyan"    -- #8cf8f7
local light_green   = "NvimLightGreen"   -- #b3f6c0
local light_grey1   = "NvimLightGrey1"   -- #eef1f8
local light_grey2   = "NvimLightGrey2"   -- #e0e2ea
local light_grey3   = "NvimLightGrey3"   -- #c4c6cd
local light_grey4   = "NvimLightGrey4"   -- #9b9ea4
local light_magenta = "NvimLightMagenta" -- #ffcaff
local light_red     = "NvimLightRed"     -- #ffc0b9
local light_yellow  = "NvimLightYellow"  -- #fce094
-- }}}

-- Terminal colors {{{
if vim.o.termguicolors or vim.fn.has("gui_running") == 1 then
  local dark_mode = vim.o.background == "dark"
  vim.g.terminal_color_0  = dark_mode and light_grey4   or dark_grey1
  vim.g.terminal_color_1  = dark_mode and light_red     or dark_red
  vim.g.terminal_color_2  = dark_mode and light_green   or dark_green
  vim.g.terminal_color_3  = dark_mode and light_yellow  or dark_yellow
  vim.g.terminal_color_4  = dark_mode and light_blue    or dark_blue
  vim.g.terminal_color_5  = dark_mode and light_magenta or dark_magenta
  vim.g.terminal_color_6  = dark_mode and light_cyan    or dark_cyan
  vim.g.terminal_color_7  = dark_mode and light_grey2   or dark_grey4
  vim.g.terminal_color_8  = dark_mode and light_grey3   or light_grey4
  vim.g.terminal_color_9  = dark_mode and light_red     or dark_red
  vim.g.terminal_color_10 = dark_mode and light_green   or dark_green
  vim.g.terminal_color_11 = dark_mode and light_yellow  or dark_yellow
  vim.g.terminal_color_12 = dark_mode and light_blue    or dark_blue
  vim.g.terminal_color_13 = dark_mode and light_magenta or dark_magenta
  vim.g.terminal_color_14 = dark_mode and light_cyan    or dark_cyan
  vim.g.terminal_color_15 = dark_mode and light_grey1   or light_grey3
end
--- }}}

-- Highlight groups {{{1
local hlgroups = {

  -- Plugins {{{2
  -- flash.nvim
  FlashBackdrop   = { link = "Comment" },
  FlashMatch      = { link = "Search" },
  FlashCurrent    = { link = "IncSearch" },
  FlashLabel      = { link = "DiffText" },
  FlashPrompt     = { link = "MsgArea" },
  FlashPromptIcon = { link = "Special" },
  FlashCursor     = { link = "Cursor" },
  -- }}}
}
-- }}}1

-- Set highlight groups {{{
for name, attr in pairs(hlgroups) do
  vim.api.nvim_set_hl(0, name, attr)
end
-- }}}
local useless = 1
--- @type fun(a: number, b: number, c: number): string
local function pop(a, b, c)
  return a, posss
end

-- vim:ts=2:sw=2:sts=2:fdm=marker
