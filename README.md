# MacDotfiles

macOS dotfiles with Gruvbox Dark theme. XDG Base Directory compliant. Ported from [ArchDotfiles](https://github.com/brvtl/ArchDotfiles).

## Quick Start

```bash
git clone git@github.com:brvtl/MacDotfiles.git ~/code/MacDotfiles
cd ~/code/MacDotfiles
./install.sh            # everything
./install.sh packages   # just `brew bundle` from Brewfile
./install.sh macos      # just macOS settings (macos/defaults.sh)
```

Refresh the Brewfile after installing things: `brew bundle dump --file=Brewfile --force --no-vscode --no-go --no-cargo --no-uv`

## What's Included

- **Brewfile** - every Homebrew formula, cask and tap on the Mac
- **macOS settings** - keyboard repeat, Dock, Finder, screenshots (`macos/defaults.sh`)
- **ZSH** - Oh My Zsh + Starship prompt + aliases/functions
- **Ghostty** - main terminal (Gruvbox, Option-as-Alt for tmux)
- **Ghostty** - main terminal (Gruvbox, Option acts as Alt for tmux)
- **Alacritty** - backup terminal
- **Git** - 1Password SSH signing, GitHub CLI credentials, delta pager
- **LazyGit** - Terminal UI for git
- **tmux** - oh-my-tmux + Gruvbox pill status bar, resurrect/continuum, fzf session picker, searchable cheatsheet (`prefix ?`), every terminal starts in tmux
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
~/.config/ghostty/           -> repo/ghostty/
~/.config/starship/          -> repo/starship/
~/.config/lazygit/           -> repo/lazygit/
~/.config/tmux/              -> repo/tmux/
~/.config/doom/              -> repo/doom/
~/.claude                    -> ~/.config/claude/ (real dir; settings.json, commands/, statusline -> repo/claude/)
```

Data stored in XDG locations:

```
~/.local/share/oh-my-zsh/    Oh My Zsh
~/.local/share/mise/         mise version manager
~/.local/state/zsh/history   ZSH history
```

The install script handles migration from legacy `~/.*` locations automatically.
