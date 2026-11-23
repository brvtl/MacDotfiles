#!/usr/bin/env bash
# Searchable cheatsheet: the shared tmux sheet plus the machine's own sheet
# (~/.config/cheatsheet/sheet.txt) when there is one.
#   cheatsheet.sh         fzf in the terminal (tmux C-a ?, `cheat` in zsh)
#   cheatsheet.sh --rofi  rofi on the desktop (Super+/ on Arch)

sheets=()
for f in ~/.config/tmux/cheatsheet.txt ~/.config/cheatsheet/sheet.txt; do
  [[ -f $f ]] && sheets+=("$f")
done

# "## section" headers + "keys  description" lines -> aligned rows
rows() {
  awk '
    /^## / { section = substr($0, 4); next }
    /^#/ || /^[[:space:]]*$/ { next }
    {
      match($0, /  +/)
      printf "%-9s %-26s %s\n", section, substr($0, 1, RSTART - 1), substr($0, RSTART + RLENGTH)
    }
  ' "${sheets[@]}"
}

if [[ $1 == --rofi ]]; then
  rows | rofi -dmenu -i -no-custom -p "Cheatsheet" \
    -theme-str 'window { width: 60em; } listview { lines: 36; spacing: 0; } element { padding: 0.15em 0.8em; }' >/dev/null
else
  # fill the popup: override the shell's FZF_DEFAULT_OPTS (--height 40% --border)
  rows | fzf --height=100% --border=none --no-sort --layout=reverse --prompt="cheat> " \
    --header="type to filter, Esc to close" \
    --color="bg:#282828,bg+:#3c3836,fg+:#fabd2f,hl:#fe8019,hl+:#fe8019,prompt:#fabd2f,pointer:#fabd2f,header:#a89984,border:#504945" \
    >/dev/null
fi
exit 0
