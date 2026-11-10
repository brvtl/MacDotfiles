#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Toggle Hidden Files
# @raycast.mode silent
# @raycast.packageName System
# @raycast.icon 👻
# @raycast.description Show or hide dotfiles in Finder

if [[ "$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)" =~ ^(1|YES|true)$ ]]; then
  defaults write com.apple.finder AppleShowAllFiles -bool false; msg="Hidden files hidden"
else
  defaults write com.apple.finder AppleShowAllFiles -bool true; msg="Hidden files shown"
fi
killall Finder
echo "$msg"
