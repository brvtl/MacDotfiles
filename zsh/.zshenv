# =============================================================================
# .ZSHENV - XDG Base Directory Setup
# =============================================================================
# Sourced on all invocations of the shell. Sets XDG paths and app overrides
# so every tool respects the same directory structure.

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# ZSH
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH="$XDG_DATA_HOME/oh-my-zsh"

# App overrides
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/config.toml"
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
