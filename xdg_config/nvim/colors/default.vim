" Neovim color file - extension

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "default"

if (has('termguicolors') && &termguicolors) || has('gui_running')
  if &background ==# 'dark'
    let g:terminal_ansi_colors = ['NvimLightGrey4', 'NvimLightRed', 'NvimLightGreen', 'NvimLightYellow', 'NvimLightBlue', 'NvimLightPurple', 'NvimLightCyan', 'NvimLightGrey2', 'NvimLightGrey3', 'NvimLightRed', 'NvimLightGreen', 'NvimLightYellow', 'NvimLightBlue', 'NvimLightPurple', 'NvimLightCyan', 'NvimLightGrey1']
  else
    let g:terminal_ansi_colors = ['NvimDarkGrey1', 'NvimDarkRed', 'NvimDarkGreen', 'NvimDarkYellow', 'NvimDarkBlue', 'NvimDarkPurple', 'NvimDarkCyan', 'NvimDarkGrey4', 'NvimLightGrey4', 'NvimDarkRed', 'NvimDarkGreen', 'NvimDarkYellow', 'NvimDarkBlue', 'NvimDarkPurple', 'NvimDarkCyan', 'NvimLightGrey3']
  endif
  " Nvim uses g:terminal_color_{0-15} instead
  for i in range(g:terminal_ansi_colors->len())
    let g:terminal_color_{i} = g:terminal_ansi_colors[i]
  endfor
endif

" vim: sw=2
