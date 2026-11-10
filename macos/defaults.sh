#!/bin/bash
# macOS settings. Safe to re-run. Some changes need a logout to take effect.
# Values marked "current" are what this Mac already had; the rest are additions.
set -e

# --- Keyboard ---------------------------------------------------------------
defaults write NSGlobalDomain KeyRepeat -int 2                 # current
defaults write NSGlobalDomain InitialKeyRepeat -int 15         # current
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false   # hold key = repeat, not accent popup
# Smart quotes/dashes mangle code and shell commands pasted from notes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# --- Trackpad ---------------------------------------------------------------
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true   # current: tap to click

# --- Dock -------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true              # current
defaults write com.apple.dock tilesize -int 30                 # current
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false           # don't reorder Spaces by recent use

# --- Finder -----------------------------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --- Screenshots ------------------------------------------------------------
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

killall Dock Finder SystemUIServer 2>/dev/null || true
echo "macOS defaults applied (log out/in for keyboard changes)."
