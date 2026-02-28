# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS user dotfiles repository containing shell configuration, terminal settings, editor configs, and development tool settings. Consistent Gruvbox Dark theme throughout. Fully XDG Base Directory compliant.

## Structure

| Directory | Purpose |
|-----------|---------|
| `zsh/` | ZSH shell config (.zshrc, .zshenv, aliases, exports, functions) |
| `git/` | Git config with 1Password SSH signing + global ignore |
| `alacritty/` | Alacritty terminal (Gruvbox Dark, FiraCode Nerd Font) |
| `starship/` | Starship prompt config |
| `lazygit/` | LazyGit UI config (Gruvbox Dark, vim keys) |
| `doom/` | Doom Emacs (init.el, config.el, packages.el) |
| `claude/` | Claude Code settings, agents, commands |
| `install.sh` | Homebrew-based install + XDG symlink script |

## Key Details

- **OS**: macOS (Homebrew for package management)
- **Shell**: ZSH with Oh My Zsh + Starship prompt
- **Terminal**: Alacritty
- **Editor**: nvim (Doom Emacs also configured, DOOMDIR=~/.config/doom)
- **Git signing**: 1Password SSH via op-ssh-sign
- **Version manager**: asdf (Homebrew install, data in ~/.local/share/asdf)
- **Theme**: Gruvbox Dark everywhere
- **Font**: FiraCode Nerd Font
- **XDG**: All config under ~/.config, data under ~/.local/share, state under ~/.local/state

## Symlink Layout

The install script writes a minimal `~/.zshenv` bootstrap and creates these symlinks:
- `~/.zshenv` (real file — bootstraps ZDOTDIR)
- `~/.config/zsh/` -> repo `zsh/`
- `~/.config/git/` -> repo `git/`
- `~/.config/alacritty/` -> repo `alacritty/`
- `~/.config/starship/` -> repo `starship/`
- `~/.config/lazygit/` -> repo `lazygit/`
- `~/.config/doom/` -> repo `doom/`
- `~/.config/claude/` -> repo `claude/`

## Data Locations (XDG)

- Oh My Zsh: `~/.local/share/oh-my-zsh/`
- asdf: `~/.local/share/asdf/`
- ZSH history: `~/.local/state/zsh/history`
- ZSH completion cache: `~/.cache/zsh/`
