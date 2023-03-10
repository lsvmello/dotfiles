# Abbreviations
abbr -a e nvim
abbr -a g git
abbr -a l 'ls'
abbr -a ll 'ls -l'
abbr -a lll 'ls -la'

# Environment Variables
set -x XDG_CONFIG_HOME ~/.config
set -x FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git'"
set -x FZF_DEFAULT_OPTS '--height 20%'
# Add pip and cargo installation folder to PATH
set -x PATH ~/.local/bin ~/.cargo/bin $PATH

# Disable greeting
set -g fish_greeting

# Key bindings
bind \cw backward-kill-bigword # ctrl+w delete word backward
bind \e\[3\;5~ kill-word # ctrl+del delete work forward

# Terminal and prompt
if status --is-interactive
  if ! set -q TMUX
    exec tmux -f ~/.config/tmux/tmux.conf
  end
end

starship init fish | source
