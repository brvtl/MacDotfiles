#!/bin/bash
# =============================================================================
# macOS Dotfiles Installation Script
# =============================================================================
# XDG-compliant dotfiles installer. Sets up symlinks, migrates data from
# legacy locations, and installs dependencies via Homebrew.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# XDG defaults (match zsh/.zshenv)
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# =============================================================================
# XDG DIRECTORY SETUP
# =============================================================================

setup_xdg_dirs() {
    log_info "Creating XDG directories..."

    mkdir -p "$XDG_CONFIG_HOME"
    mkdir -p "$XDG_DATA_HOME"
    mkdir -p "$XDG_STATE_HOME/zsh"
    mkdir -p "$XDG_CACHE_HOME/zsh"

    log_success "XDG directories created"
}

# =============================================================================
# ZSHENV BOOTSTRAP
# =============================================================================

setup_zshenv_bootstrap() {
    log_info "Setting up ~/.zshenv bootstrap..."

    cat > "$HOME/.zshenv" <<'EOF'
# Bootstrap ZDOTDIR — all other env vars live in $ZDOTDIR/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
[ -f "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
EOF

    log_success "Created ~/.zshenv (bootstraps ZDOTDIR)"
}

# =============================================================================
# CLEANUP OLD SYMLINKS
# =============================================================================

cleanup_old_symlinks() {
    log_info "Cleaning up legacy symlinks..."

    local old_links=(
        "$HOME/.zshrc"
        "$HOME/.zsh_aliases"
        "$HOME/.zsh_exports"
        "$HOME/.zsh_functions"
        "$HOME/.gitconfig"
        "$XDG_CONFIG_HOME/git/ignore"
    )

    for link in "${old_links[@]}"; do
        if [ -L "$link" ]; then
            rm "$link"
            log_success "Removed old symlink: $link"
        fi
    done

    # Remove empty ~/.config/git if it exists
    [ -d "$XDG_CONFIG_HOME/git" ] && rmdir "$XDG_CONFIG_HOME/git" 2>/dev/null || true
}

# =============================================================================
# DATA MIGRATION
# =============================================================================

migrate_data() {
    log_info "Migrating data to XDG locations..."

    # Migrate Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ] && [ ! -d "$XDG_DATA_HOME/oh-my-zsh" ]; then
        log_info "Moving ~/.oh-my-zsh -> $XDG_DATA_HOME/oh-my-zsh"
        mv "$HOME/.oh-my-zsh" "$XDG_DATA_HOME/oh-my-zsh"
        log_success "Migrated Oh My Zsh"
    fi

    # Migrate asdf
    if [ -d "$HOME/.asdf" ] && [ ! -d "$XDG_DATA_HOME/asdf" ]; then
        log_info "Moving ~/.asdf -> $XDG_DATA_HOME/asdf"
        mv "$HOME/.asdf" "$XDG_DATA_HOME/asdf"
        log_success "Migrated asdf"
    fi

    # Migrate zsh history
    if [ -f "$HOME/.zsh_history" ] && [ ! -f "$XDG_STATE_HOME/zsh/history" ]; then
        log_info "Moving ~/.zsh_history -> $XDG_STATE_HOME/zsh/history"
        mv "$HOME/.zsh_history" "$XDG_STATE_HOME/zsh/history"
        log_success "Migrated zsh history"
    fi

    # Remove legacy starship.toml if it exists alongside the symlinked directory
    if [ -f "$XDG_CONFIG_HOME/starship.toml" ] && [ -d "$XDG_CONFIG_HOME/starship" ]; then
        rm "$XDG_CONFIG_HOME/starship.toml"
        log_success "Removed legacy starship.toml"
    fi
}

# =============================================================================
# HOMEBREW PACKAGES
# =============================================================================

install_packages() {
    log_info "Installing Homebrew packages..."

    local formulas=(
        starship
        fzf
        fd
        ripgrep
        lazygit
        tmux
        git
        neovim
        git-delta
        gh
    )

    local casks=(
        alacritty
        font-fira-code-nerd-font
    )

    for formula in "${formulas[@]}"; do
        if brew list --formula "$formula" &>/dev/null; then
            log_success "$formula already installed"
        else
            log_info "Installing $formula..."
            brew install "$formula"
        fi
    done

    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null; then
            log_success "$cask already installed"
        else
            log_info "Installing $cask..."
            brew install --cask "$cask"
        fi
    done

    log_success "Homebrew packages installed"
}

# =============================================================================
# SYMLINK CREATION
# =============================================================================

create_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        log_warn "Symlink already exists: $target (removing and recreating)"
        rm "$target"
    fi

    if [ -e "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warn "Backing up existing file: $target -> $backup"
        mv "$target" "$backup"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"

    ln -s "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

setup_symlinks() {
    log_info "Setting up symlinks..."

    # Shell config (directory symlink — contains .zshrc, .zshenv, exports, aliases, functions)
    create_symlink "$SCRIPT_DIR/zsh" "$XDG_CONFIG_HOME/zsh"

    # Git config (directory symlink — contains config and ignore)
    create_symlink "$SCRIPT_DIR/git" "$XDG_CONFIG_HOME/git"

    # Application configs
    create_symlink "$SCRIPT_DIR/alacritty" "$XDG_CONFIG_HOME/alacritty"
    create_symlink "$SCRIPT_DIR/starship" "$XDG_CONFIG_HOME/starship"
    create_symlink "$SCRIPT_DIR/lazygit" "$XDG_CONFIG_HOME/lazygit"
    create_symlink "$SCRIPT_DIR/tmux" "$XDG_CONFIG_HOME/tmux"
    create_symlink "$SCRIPT_DIR/doom" "$XDG_CONFIG_HOME/doom"
    create_symlink "$SCRIPT_DIR/claude" "$XDG_CONFIG_HOME/claude"

    log_success "Symlinks configured"
}

# =============================================================================
# OH MY ZSH SETUP
# =============================================================================

setup_oh_my_zsh() {
    log_info "Checking Oh My Zsh..."

    local omz_dir="$XDG_DATA_HOME/oh-my-zsh"

    if [ ! -d "$omz_dir" ]; then
        log_info "Installing Oh My Zsh..."
        ZSH="$omz_dir" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    fi

    # Install zsh-autosuggestions
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$omz_dir/custom}"

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # Install zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    log_success "Oh My Zsh configured"
}

# =============================================================================
# TMUX SETUP
# =============================================================================

setup_tmux() {
    log_info "Setting up oh-my-tmux..."

    local omt_dir="$XDG_DATA_HOME/tmux/oh-my-tmux"

    if [ ! -d "$omt_dir" ]; then
        log_info "Cloning oh-my-tmux..."
        git clone https://github.com/gpakosz/.tmux "$omt_dir"
    fi

    # tmux.conf is oh-my-tmux's own file (gitignored); customizations live in
    # the tracked tmux.conf.local. Plugins are fetched by TPM on first launch.
    ln -sfn "$omt_dir/.tmux.conf" "$SCRIPT_DIR/tmux/tmux.conf"

    log_success "oh-my-tmux configured"
}

# =============================================================================
# ASDF SETUP
# =============================================================================

setup_asdf() {
    log_info "Checking asdf..."

    if ! brew list --formula asdf &>/dev/null; then
        log_info "Installing asdf via Homebrew..."
        brew install asdf
    fi

    log_success "asdf configured (Homebrew)"
}

# =============================================================================
# DOOM EMACS SETUP
# =============================================================================

setup_doom_emacs() {
    log_info "Checking Doom Emacs..."

    # Install emacs if not present
    if ! command -v emacs &>/dev/null; then
        log_info "Installing Emacs via Homebrew..."
        brew install emacs-plus --with-native-comp
    fi

    if [ ! -d "$HOME/.emacs.d" ]; then
        log_info "Installing Doom Emacs..."
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
        ~/.emacs.d/bin/doom install --no-env --no-fonts
    else
        log_info "Syncing Doom Emacs..."
        ~/.emacs.d/bin/doom sync -e
    fi

    log_success "Doom Emacs configured"
}

# =============================================================================
# SSH SETUP
# =============================================================================

setup_ssh() {
    log_info "Setting up SSH configuration..."

    mkdir -p "$HOME/.ssh"

    # Create SSH config for 1Password agent
    local ssh_config="$HOME/.ssh/config"
    if [ ! -f "$ssh_config" ] || ! grep -q "IdentityAgent" "$ssh_config"; then
        cat >> "$ssh_config" <<'EOF'
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
EOF
        log_success "SSH config updated with 1Password agent"
    else
        log_success "SSH config already has 1Password agent"
    fi

    # Create allowed_signers file for git commit verification
    local allowed_signers="$HOME/.ssh/allowed_signers"
    if [ ! -f "$allowed_signers" ]; then
        echo "peter@devthe.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILzxdtUdffO94cxWHTHSAddrS7mSX/IQajso4lYEFkWO" > "$allowed_signers"
        log_success "Created allowed_signers file"
    else
        log_success "allowed_signers already exists"
    fi

    log_success "SSH configured"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    echo ""
    echo "=========================================="
    echo "   macOS Dotfiles Installation Script"
    echo "=========================================="
    echo ""

    case "${1:-all}" in
        packages)
            install_packages
            ;;
        symlinks)
            setup_xdg_dirs
            cleanup_old_symlinks
            setup_symlinks
            setup_zshenv_bootstrap
            ;;
        zsh)
            setup_oh_my_zsh
            ;;
        asdf)
            setup_asdf
            ;;
        tmux)
            setup_tmux
            ;;
        doom)
            setup_doom_emacs
            ;;
        ssh)
            setup_ssh
            ;;
        migrate)
            setup_xdg_dirs
            migrate_data
            ;;
        all)
            install_packages
            setup_xdg_dirs
            migrate_data
            setup_oh_my_zsh
            setup_asdf
            setup_tmux
            setup_ssh
            cleanup_old_symlinks
            setup_symlinks
            setup_zshenv_bootstrap
            setup_doom_emacs

            echo ""
            log_success "Installation complete!"
            echo ""
            echo "Next steps:"
            echo "  1. Restart your shell: exec zsh"
            echo "  2. Install missing dependencies if any"
            echo ""
            ;;
        *)
            echo "Usage: $0 [packages|symlinks|zsh|asdf|tmux|doom|ssh|migrate|all]"
            exit 1
            ;;
    esac
}

main "$@"
