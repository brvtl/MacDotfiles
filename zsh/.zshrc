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
    1password
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
# ASDF VERSION MANAGER
# =============================================================================

if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
    fpath=("$ASDF_DATA_DIR/completions" $fpath)
    autoload -Uz compinit
    compinit
fi

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

# FZF keybindings (Homebrew paths)
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# =============================================================================
# LOCAL CUSTOMIZATIONS
# =============================================================================

[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"
[ -f ~/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh

# 1Password SSH Agent (macOS)
[ -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ] && \
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
