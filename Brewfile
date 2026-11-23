require "socket"

# ghastly is an SSH-only Mac: no VPN client, and no Command Line Tools update,
# so nothing that has to build from source (Stripe CLI, emacs-plus).
ghastly = Socket.gethostname.split(".").first == "ghastly"

tap "bitwise-media-group/tap"
tap "d12frosted/emacs-plus"
tap "stripe/stripe-cli"
# Official Amazon AWS command-line interface
brew "awscli"
# Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript
brew "clang-format"
# GNU File, Shell, and Text utilities
brew "coreutils"
# YAML Parser
brew "libyaml"
# Easiest way to build and release mobile apps
brew "fastlane"
# Simple, fast and user-friendly alternative to find
brew "fd"
# Play, record, convert, and stream select audio and video codecs
brew "ffmpeg"
# Command-line fuzzy finder written in Go
brew "fzf"
# GitHub command-line tool
brew "gh"
# Kubernetes package manager
brew "helm"
# Simple terminal UI for git commands
brew "lazygit"
# Polyglot runtime manager (asdf rust clone)
brew "mise"
# Lightweight PDF and XPS viewer
brew "mupdf"
# Development kit for the Java programming language
brew "openjdk"
# Your Gateway to Embedded Software Development Excellence
brew "platformio"
# PDF rendering library (based on the xpdf-3.0 code base)
brew "poppler"
# Object-relational database system
brew "postgresql@16", link: true
# GNU Emacs for Doom (doom/), native compilation
brew "d12frosted/emacs-plus/emacs-plus@30" unless ghastly
# Cross-shell prompt for astronauts
brew "starship"
# Command-line tool for Stripe
brew "stripe/stripe-cli/stripe" unless ghastly
# Multi-modal AI tool to extract and summarize content
brew "summarize"
# Terminal multiplexer
brew "tmux"
# Generate your Xcode project from a spec file and your folder structure
brew "xcodegen"
# Password manager that keeps all passwords secure behind one password
cask "1password"
# Chromium based browser
cask "arc"
# 3D model slicing software for 3D printers, maintained by Bambu Lab
cask "bambu-studio"
# OpenAI's official ChatGPT desktop app
cask "chatgpt"
# Anthropic's official Claude AI desktop app
cask "claude"
# Terminal-based AI coding assistant
cask "claude-code"
# OpenAI's coding agent that runs in your terminal
cask "codex"
# Voice and text chat software
cask "discord"
# App to build and share containerised applications and microservices
cask "docker-desktop"
# VPN client for secure and private internet access
cask "expressvpn" unless ghastly
cask "font-fira-code-nerd-font"
# Fast, native terminal emulator (ghostty/ config)
cask "ghostty"
# Set of tools to manage resources and applications hosted on Google Cloud
cask "gcloud-cli"
# Web browser
cask "google-chrome"
# AI-first web browser from The Browser Company
cask "thebrowsercompany-dia"
# AI teammates that work across your apps and tools
cask "grok-bot"
# Extensible coding agent for the terminal
cask "grok-build"
# Terminal emulator as alternative to Apple's Terminal app
cask "iterm2"
# Reverse proxy, secure introspectable tunnels to localhost
cask "ngrok"
cask "patchy"
# Control your tools with a few keystrokes
cask "raycast"
# Instant messaging application focusing on security
cask "signal"
# Team communication and collaboration software
cask "slack"
# Music streaming service
cask "spotify"
# Text editor for code, markup and prose
cask "sublime-text"
# Mesh VPN based on WireGuard
cask "tailscale-app"
# Messaging app with a focus on speed and security
cask "telegram"
# Open-source BitTorrent client
cask "transmission"
# Native desktop client for WhatsApp
cask "whatsapp"
npm "@colbymchenry/codegraph"
npm "corepack"
npm "firebase-tools"
npm "pnpm"
npm "vercel"
