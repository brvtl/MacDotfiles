#!/usr/bin/env bash
# Fuzzy-pick an existing tmux session or a project directory and switch to
# it, creating a session named after the directory when there isn't one.
# Bound to <prefix> o (in a popup).
set -euo pipefail

roots=("$HOME/code" "$HOME/code/overdub")

pick=$(
  {
    tmux list-sessions -F '#S' 2>/dev/null
    find "${roots[@]}" -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null | sed "s|^$HOME|~|" | sort
  } | fzf --reverse --prompt='session> '
) || exit 0

if tmux has-session -t "=$pick" 2>/dev/null; then
  tmux switch-client -t "=$pick"
  exit 0
fi

dir="${pick/#\~/$HOME}"
name=$(basename "$dir" | tr '.:' '__')
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -ds "$name" -c "$dir"
tmux switch-client -t "=$name"
