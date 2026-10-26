#!/usr/bin/env bash
# Snapshot sessions when one is killed (session-closed hook), so continuum's
# restore doesn't bring it back. Without this the snapshot is only refreshed
# by continuum's autosave, up to 15 minutes later.

# Last session gone (server shutting down): keep the previous snapshot rather
# than overwriting it with an empty one.
[ -n "$(tmux ls 2>/dev/null)" ] || exit 0

# resurrect names snapshots by the second, and a second save within the same
# second deletes the file "last" points at. Serialize saves and space them out.
# mkdir is the lock (atomic, and works on macOS, which has no flock); a lock
# older than a minute is left over from a killed save and is taken over.
lock="${TMPDIR:-/tmp}/tmux-resurrect-save.lock"
until mkdir "$lock" 2>/dev/null; do
  if [ -n "$(find "$lock" -maxdepth 0 -mmin +1 2>/dev/null)" ]; then
    rmdir "$lock" 2>/dev/null
  fi
  sleep 0.2
done
trap 'rmdir "$lock"' EXIT
sleep 1
~/.config/tmux/plugins/tmux-resurrect/scripts/save.sh quiet 2>/dev/null
