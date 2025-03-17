# Environment Variables
set -x XDG_CONFIG_HOME ~/.config
set -x EDITOR nvim
set -x DOTFILES ~/personal/dotfiles/xdg_config
set -x FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git'"
set -x FZF_DEFAULT_OPTS_FILE ~/.config/.fzf
set -x BAT_THEME ansi

# Add cargo, go and pip installation folder to PATH
set -x PATH ~/.cargo/bin /usr/local/go/bin ~/go/bin ~/.local/bin $PATH

# Disable greeting
set -g fish_greeting

# Key bindings
bind \cw backward-kill-bigword # ctrl+w delete word backward
bind \e\[3\;5~ kill-word # ctrl+del delete work forward

function storePathForWindowsTerminal --on-variable PWD
    if test -n "$WT_SESSION"
      printf "\e]9;9;%s\e\\" (wslpath -w "$PWD")
    end
end

# Terminal and prompt
# if status --is-interactive
#   if ! set -q TMUX
#     exec tmux -f ~/.config/tmux/tmux.conf
#   end
# end

starship init fish | source
