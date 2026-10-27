#!/bin/sh
# tmux copy-command: put a copied selection (on stdin) in the OS clipboard.
# On Linux it also fills PRIMARY, so middle-click pastes it like any X app.
# Output goes to /dev/null: xclip stays running to serve the selection, and an
# open stdout would keep tmux waiting on it.
if command -v pbcopy >/dev/null 2>&1; then
  exec pbcopy
fi
data=$(cat)
if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy >/dev/null 2>&1; then
  printf %s "$data" | wl-copy --primary >/dev/null 2>&1
  printf %s "$data" | wl-copy >/dev/null 2>&1
elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
  printf %s "$data" | xclip -selection primary -i >/dev/null 2>&1
  printf %s "$data" | xclip -selection clipboard -i >/dev/null 2>&1
fi
exit 0
