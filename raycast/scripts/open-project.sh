#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Project
# @raycast.mode silent
# @raycast.packageName Dev
# @raycast.icon 📂
# @raycast.argument1 { "type": "text", "placeholder": "project (e.g. myapp or org/repo)", "optional": true }
# @raycast.description Open ~/code/<project> as a tmux session in Ghostty (empty = tmux picker)

export PATH="/opt/homebrew/bin:$PATH"
q="$1"

if [[ -z "$q" ]]; then
  dir=""
else
  # exact path under ~/code first, then first fuzzy match one or two levels down
  dir="$HOME/code/$q"
  [[ -d "$dir" ]] || dir=$(find "$HOME/code" -mindepth 1 -maxdepth 2 -type d ! -path '*/.*' -iname "*$q*" 2>/dev/null | head -1)
  [[ -n "$dir" && -d "$dir" ]] || { echo "No project matching '$q'"; exit 1; }
  name=$(basename "$dir" | tr '.:' '__')
  tmux has-session -t "=$name" 2>/dev/null || tmux new-session -ds "$name" -c "$dir"
fi

client=$(tmux list-clients -F '#{client_name}' 2>/dev/null | head -1)
if [[ -n "$client" ]]; then
  [[ -n "$q" ]] && tmux switch-client -c "$client" -t "=$name"
  open -a Ghostty
elif [[ -n "$q" ]]; then
  open -na Ghostty --args -e tmux attach -t "=$name"
else
  open -a Ghostty   # zsh auto-start attaches/creates a session
fi
[[ -n "$q" ]] && echo "→ $name"
