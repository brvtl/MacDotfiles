# MacDotfiles

macOS dotfiles with Gruvbox Dark theme. XDG Base Directory compliant. Ported from [ArchDotfiles](https://github.com/brvtl/ArchDotfiles).

## Quick Start

```bash
git clone git@github.com:brvtl/MacDotfiles.git ~/code/MacDotfiles
cd ~/code/MacDotfiles
./install.sh
```

## What's Included

- **ZSH** - Oh My Zsh + Starship prompt + aliases/functions
- **Alacritty** - GPU-accelerated terminal
- **Git** - 1Password SSH signing, GitHub CLI credentials, delta pager
- **LazyGit** - Terminal UI for git
- **Doom Emacs** - Go, Python, JS/TS, Terraform, Magit
- **Starship** - Cross-shell prompt
- **Claude Code** - AI dev tool config + agents

## Layout

Everything lives under `~/.config/` via directory symlinks:

```
~/.zshenv                    (real file — bootstraps ZDOTDIR)
~/.config/zsh/               -> repo/zsh/
~/.config/git/               -> repo/git/
~/.config/alacritty/         -> repo/alacritty/
~/.config/starship/          -> repo/starship/
~/.config/lazygit/           -> repo/lazygit/
~/.config/doom/              -> repo/doom/
~/.config/claude/            -> repo/claude/
```

Data stored in XDG locations:

```
~/.local/share/oh-my-zsh/    Oh My Zsh
~/.local/share/asdf/         asdf version manager
~/.local/state/zsh/history   ZSH history
```

The install script handles migration from legacy `~/.*` locations automatically.
