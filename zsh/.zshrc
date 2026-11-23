# =============================================================================
# .ZSHRC - Modular ZSH Configuration (macOS)
# =============================================================================
# XDG variables and ZSH/ZDOTDIR are set in .zshenv

# =============================================================================
# OH MY ZSH SETTINGS
# =============================================================================

# Auto-update frequency (in days)
zstyle ':omz:update' frequency 7

# Disable magic functions (fixes paste issues)
DISABLE_MAGIC_FUNCTIONS="true"

# Enable command auto-correction (disabled to prevent prompts during automation)
ENABLE_CORRECTION="false"

# Display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files as dirty (faster git status)
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History timestamp format
HIST_STAMPS="yyyy-mm-dd"

# =============================================================================
# PLUGINS
# =============================================================================

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    brew
    docker
    docker-compose
    kubectl
    helm
    aws
    terraform
    golang
    node
    npm
    yarn
    python
    pip
    virtualenv
    vscode
    macos
    history
    dirhistory
    copypath
    copyfile
    extract
    web-search
    jsontools
    urltools
    colored-man-pages
    sudo
    fzf
    z
)

# =============================================================================
# SOURCE OH MY ZSH
# =============================================================================

source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# HOMEBREW
# =============================================================================

eval "$(/opt/homebrew/bin/brew shellenv)"

# =============================================================================
# STARSHIP PROMPT
# =============================================================================

eval "$(starship init zsh)"

# =============================================================================
# MISE VERSION MANAGER
# =============================================================================

# Reads .tool-versions and .mise.toml
eval "$(/opt/homebrew/bin/mise activate zsh)"

# =============================================================================
# MODULAR CONFIGURATION
# =============================================================================

# Source exports
[ -f "$ZDOTDIR/exports" ] && source "$ZDOTDIR/exports"

# Source aliases
[ -f "$ZDOTDIR/aliases" ] && source "$ZDOTDIR/aliases"

# Source functions
[ -f "$ZDOTDIR/functions" ] && source "$ZDOTDIR/functions"

# =============================================================================
# HISTORY CONFIGURATION
# =============================================================================

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_STATE_HOME/zsh/history"

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# =============================================================================
# COMPLETION CONFIGURATION
# =============================================================================

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' menu select

# =============================================================================
# KEY BINDINGS
# =============================================================================

bindkey -e
bindkey '^ ' autosuggest-accept
autoload edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^k' kill-line
bindkey '^u' backward-kill-line
bindkey '^w' backward-kill-word
bindkey '^y' yank
bindkey '^f' fzf-file-widget
bindkey '^r' fzf-history-widget

# =============================================================================
# LOCAL CUSTOMIZATIONS
# =============================================================================

[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

# =============================================================================
# TMUX — every terminal and SSH login runs in tmux
# =============================================================================
# SSH: land in the shared, persistent "main" session.
# Alacritty/Ghostty/iTerm (matched on what the terminal itself sets, which
# editors launched from a terminal don't inherit): reattach a detached session
# (e.g. one whose window was closed) or start a new one. Editor terminals (VS Code, Cursor, GoLand,
# Emacs) stay plain. Detach (prefix d) drops back to a plain shell.
# Skip with NO_TMUX=1 (e.g. `NO_TMUX=1 alacritty`, `ssh host -t NO_TMUX=1 zsh`)
_tmux_autostart() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    tmux new-session -A -s main
    return
  fi
  local detached
  detached=$(tmux list-sessions -f '#{==:#{session_attached},0}' -F '#{session_name}' 2>/dev/null | head -n 1)
  if [[ -n "$detached" ]]; then
    tmux attach-session -t "=$detached"
  else
    tmux new-session
  fi
}
if [[ -z "$TMUX" && -z "$NO_TMUX" && -o interactive ]] && command -v tmux >/dev/null \
   && [[ -n "$SSH_CONNECTION" || "$TERM" == alacritty || "$TERM" == xterm-ghostty || "$TERM_PROGRAM" == iTerm.app ]]; then
  _tmux_autostart
fi
