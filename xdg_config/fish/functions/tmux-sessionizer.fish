# this is based on https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

function tmux-sessionizer
  if test (count $argv) -gt 0
    set selected $argv[1]
  else
    set selected (find ~/git -mindepth 1 -maxdepth 1 -type d | fzf --height=100% --margin=15% --layout=reverse --border --border-label="Choose your session")
  end

  if test -z $selected
    exit 0
  end

  set selected_name (basename "$selected" | tr . _)
  set tmux_running (pgrep tmux)

  if test -z $TMUX; and test -z $tmux_running
    tmux new-session -s $selected_name -c $selected
    exit 0
  end

  if not tmux has-session -t=$selected_name 2> /dev/null
    tmux new-session -ds $selected_name -c $selected
  end

  tmux switch-client -t $selected_name
end
