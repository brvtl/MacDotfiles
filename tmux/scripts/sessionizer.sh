#!/usr/bin/env bash
# Fuzzy-pick an existing tmux session and switch to it. With --projects the
# list also has the project directories, and picking one creates a session
# named after it when there isn't one.
# Bound to Alt+o (sessions) and <prefix> o (--projects), in a popup.
set -euo pipefail

# Project roots: ~/code, plus any extra colon-separated dirs in
# SESSIONIZER_ROOTS (set it in an untracked file, e.g. zsh/.zshrc.local).
roots=("$HOME/code")
IFS=: read -ra extra <<< "${SESSIONIZER_ROOTS:-}"
for r in ${extra[@]+"${extra[@]}"}; do
  if [[ -n $r ]]; then roots+=("$r"); fi
done

list() {
  tmux list-sessions -F '#S' 2>/dev/null
  [[ ${1:-} == --projects ]] || return 0
  find "${roots[@]}" -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null | sed "s|^$HOME|~|" | sort
}

prompt='session> '
[[ ${1:-} == --projects ]] && prompt='session or project> '
pick=$(list "${1:-}" | fzf --reverse --prompt="$prompt") || exit 0

if tmux has-session -t "=$pick" 2>/dev/null; then
  tmux switch-client -t "=$pick"
  exit 0
fi

dir="${pick/#\~/$HOME}"
name=$(basename "$dir" | tr '.:' '__')
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -ds "$name" -c "$dir"
tmux switch-client -t "=$name"
