# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS user dotfiles repository containing shell configuration, terminal settings, editor configs, and development tool settings. Consistent Gruvbox Dark theme throughout.

## Structure

| Directory | Purpose |
|-----------|---------|
| `zsh/` | ZSH shell config (zshrc, aliases, exports, functions) |
| `git/` | Git config with 1Password SSH signing |
| `alacritty/` | Alacritty terminal (Gruvbox Dark, FiraCode Nerd Font) |
| `starship/` | Starship prompt config |
| `lazygit/` | LazyGit UI config (Gruvbox Dark, vim keys) |
| `doom/` | Doom Emacs (init.el, config.el, packages.el) |
| `claude/` | Claude Code settings, agents, commands |
| `install.sh` | Homebrew-based install + symlink script |

## Key Details

- **OS**: macOS (Homebrew for package management)
- **Shell**: ZSH with Oh My Zsh + Starship prompt
- **Terminal**: Alacritty
- **Editor**: Doom Emacs (DOOMDIR=~/.config/doom)
- **Git signing**: 1Password SSH via op-ssh-sign
- **Version manager**: asdf
- **Theme**: Gruvbox Dark everywhere
- **Font**: FiraCode Nerd Font

## Symlink Layout

The install script creates these symlinks:
- `~/.zshrc` -> repo `zsh/zshrc`
- `~/.zsh_aliases` -> repo `zsh/aliases`
- `~/.zsh_exports` -> repo `zsh/exports`
- `~/.zsh_functions` -> repo `zsh/functions`
- `~/.gitconfig` -> repo `git/config`
- `~/.config/git/ignore` -> repo `git/ignore`
- `~/.config/alacritty/` -> repo `alacritty/`
- `~/.config/starship/` -> repo `starship/`
- `~/.config/lazygit/` -> repo `lazygit/`
- `~/.config/doom/` -> repo `doom/`
- `~/.config/claude/` -> repo `claude/`
