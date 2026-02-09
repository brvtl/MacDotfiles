#!/bin/bash
# =============================================================================
# macOS Dotfiles Installation Script
# =============================================================================
# This script installs dependencies and sets up symlinks for the dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

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

    # Shell configs
    create_symlink "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$SCRIPT_DIR/zsh/aliases" "$HOME/.zsh_aliases"
    create_symlink "$SCRIPT_DIR/zsh/exports" "$HOME/.zsh_exports"
    create_symlink "$SCRIPT_DIR/zsh/functions" "$HOME/.zsh_functions"

    # Git config
    create_symlink "$SCRIPT_DIR/git/config" "$HOME/.gitconfig"
    create_symlink "$SCRIPT_DIR/git/ignore" "$CONFIG_DIR/git/ignore"

    # Application configs (symlink directories)
    create_symlink "$SCRIPT_DIR/alacritty" "$CONFIG_DIR/alacritty"
    create_symlink "$SCRIPT_DIR/starship" "$CONFIG_DIR/starship"
    create_symlink "$SCRIPT_DIR/lazygit" "$CONFIG_DIR/lazygit"
    create_symlink "$SCRIPT_DIR/doom" "$CONFIG_DIR/doom"
    create_symlink "$SCRIPT_DIR/claude" "$CONFIG_DIR/claude"

    log_success "Symlinks configured"
}

# =============================================================================
# OH MY ZSH SETUP
# =============================================================================

setup_oh_my_zsh() {
    log_info "Checking Oh My Zsh..."

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install zsh-autosuggestions
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

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
# ASDF SETUP
# =============================================================================

setup_asdf() {
    log_info "Checking asdf..."

    if [ ! -d "$HOME/.asdf" ]; then
        log_info "Installing asdf..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    fi

    log_success "asdf configured"
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
            setup_symlinks
            ;;
        zsh)
            setup_oh_my_zsh
            ;;
        asdf)
            setup_asdf
            ;;
        doom)
            setup_doom_emacs
            ;;
        ssh)
            setup_ssh
            ;;
        all)
            install_packages
            setup_oh_my_zsh
            setup_asdf
            setup_ssh
            setup_symlinks
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
            echo "Usage: $0 [packages|symlinks|zsh|asdf|doom|ssh|all]"
            exit 1
            ;;
    esac
}

main "$@"
