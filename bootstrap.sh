#!/usr/bin/env bash
# bootstrap.sh — bring a fresh macOS or Fedora machine to a working state.
#
# Installs prerequisites (stow, zsh, kitty, the Nerd Font), symlinks every stow
# package into $HOME, installs oh-my-zsh and its external plugins.
# Idempotent: safe to re-run.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(nvim zsh kitty herdr)

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n'  "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n'  "$*" >&2; exit 1; }

# On any unexpected failure, report where and why instead of exiting silently.
# Run with DEBUG=1 ./bootstrap.sh to trace every command as it executes.
trap 'rc=$?; printf "\033[1;31mxx\033[0m line %s: \x60%s\x60 exited %s\n" "$LINENO" "$BASH_COMMAND" "$rc" >&2' ERR
[[ "${DEBUG:-0}" == 1 ]] && set -x

# --- detect OS / package manager ---------------------------------------------
if [[ "$(uname -s)" == "Darwin" ]]; then
  OS=macos
  command -v brew >/dev/null 2>&1 || die "Homebrew not found — install from https://brew.sh first."
  PM=brew
elif command -v dnf >/dev/null 2>&1; then
  OS=fedora
  PM=dnf
else
  die "Unsupported system: need macOS (Homebrew) or Fedora (dnf)."
fi
log "Detected $OS"

# install a package only if missing
pkg_install() {
  case "$PM" in
    brew) brew list "$1" >/dev/null 2>&1 || brew install "$1" ;;
    dnf)  rpm -q "$1"    >/dev/null 2>&1 || sudo dnf install -y "$1" ;;
  esac
}

# --- prerequisites -----------------------------------------------------------
log "Installing prerequisites (git, curl, stow, eza, zoxide, ripgrep)"
for p in git curl stow eza zoxide ripgrep; do pkg_install "$p"; done

# zsh — macOS ships 5.9 at /bin/zsh; Fedora needs the package.
[[ "$OS" == fedora ]] && pkg_install zsh

# kitty — a cask on Homebrew, a plain package on Fedora.
if [[ "$OS" == macos ]]; then
  brew list --cask kitty >/dev/null 2>&1 || brew install --cask kitty
else
  pkg_install kitty
  # Custom icon: kitty itself applies ~/.config/kitty/kitty.app.{icns,png} on
  # macOS and as the X11/Wayland window icon, but GNOME takes the dock/overview
  # icon from the .desktop file — so shadow it with a user copy pointing there.
  apps="$HOME/.local/share/applications"
  mkdir -p "$apps"
  sed "s|^Icon=.*|Icon=$HOME/.config/kitty/kitty.app.png|" \
    /usr/share/applications/kitty.desktop > "$apps/kitty.desktop"
fi

# fd (used by telescope) — named 'fd' on Homebrew, 'fd-find' on Fedora.
if [[ "$OS" == macos ]]; then pkg_install fd; else pkg_install fd-find; fi

# C compiler — Treesitter compiles parsers from source. macOS gets `cc` from the
# Xcode Command Line Tools (a Homebrew prerequisite), so only Fedora needs gcc.
[[ "$OS" == fedora ]] && pkg_install gcc

# tree-sitter CLI — nvim-treesitter's `main` branch builds parsers with it (the
# old `master` branch needed only a C compiler). Named 'tree-sitter' on Homebrew,
# 'tree-sitter-cli' on Fedora.
if [[ "$OS" == macos ]]; then pkg_install tree-sitter; else pkg_install tree-sitter-cli; fi

# --- neovim ------------------------------------------------------------------
# The nvim config uses the 0.11+ LSP API (vim.lsp.config / vim.lsp.enable), so
# we require Neovim >= 0.11. Homebrew ships current stable; Fedora's dnf lags
# (0.10.4 on F41), so on Fedora we install the official prebuilt tarball into
# /opt/nvim and symlink it onto PATH ahead of any dnf copy.
NVIM_MIN_MINOR=11           # minimum acceptable 0.MINOR
NVIM_RELEASE="v0.12.3"      # tarball version installed on Fedora

nvim_minor() { nvim --version 2>/dev/null | sed -n 's/^NVIM v0\.\([0-9]*\)\..*/\1/p'; }

if [[ "$OS" == macos ]]; then
  pkg_install neovim
else
  minor="$(nvim_minor)"
  if [[ -n "$minor" && "$minor" -ge "$NVIM_MIN_MINOR" ]]; then
    log "Neovim already >= 0.$NVIM_MIN_MINOR ($(nvim --version | head -1))"
  else
    log "Installing Neovim $NVIM_RELEASE to /opt/nvim (dnf's is too old)"
    rpm -q neovim >/dev/null 2>&1 && sudo dnf remove -y neovim
    arch="$(uname -m)"; [[ "$arch" == aarch64 ]] && arch=arm64
    tarball="nvim-linux-${arch}.tar.gz"
    curl -fsSL -o /tmp/$tarball \
      "https://github.com/neovim/neovim/releases/download/${NVIM_RELEASE}/${tarball}"
    sudo rm -rf /opt/nvim && sudo mkdir -p /opt/nvim
    sudo tar -xzf /tmp/$tarball -C /opt/nvim --strip-components=1
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  fi
fi

# --- JetBrainsMono Nerd Font -------------------------------------------------
font_installed() {
  fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font" && return 0
  ls "$HOME/Library/Fonts" 2>/dev/null | grep -qi "JetBrainsMonoNerdFont" && return 0
  return 1
}
if font_installed; then
  log "JetBrainsMono Nerd Font already installed"
else
  log "Installing JetBrainsMono Nerd Font"
  if [[ "$OS" == macos ]]; then
    brew install --cask font-jetbrains-mono-nerd-font
  else
    pkg_install unzip
    dest="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
    mkdir -p "$dest"
    curl -fsSL -o /tmp/JetBrainsMono.zip \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -oq /tmp/JetBrainsMono.zip -d "$dest"
    fc-cache -f "$dest"
  fi
fi

# --- make zsh the default login shell ----------------------------------------
# kitty has no shell override; it launches the login shell by absolute path,
# which sidesteps the macOS GUI-launch PATH problem and keeps the config portable.
zsh_path="$(command -v zsh)"
if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
  log "Registering $zsh_path in /etc/shells (sudo)"
  echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$OS" == macos ]]; then
  current_shell="$(dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}')"
else
  current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
fi
if [[ "$current_shell" != "$zsh_path" ]]; then
  log "Setting login shell to zsh (chsh — may prompt for your password)"
  chsh -s "$zsh_path" || warn "chsh failed; run manually: chsh -s $zsh_path"
else
  log "Login shell already zsh"
fi

# --- symlink dotfiles --------------------------------------------------------
# A pre-existing hand-written ~/.zshrc would block the stow link; keep its
# contents as ~/.zshrc.local, which the tracked .zshrc sources at the end.
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  if [[ -e "$HOME/.zshrc.local" ]]; then
    warn "~/.zshrc exists and ~/.zshrc.local too — merge by hand, skipping"
  else
    log "Moving existing ~/.zshrc to ~/.zshrc.local"
    mv "$HOME/.zshrc" "$HOME/.zshrc.local"
  fi
fi

log "Stowing: ${PACKAGES[*]}"
# herdr is stowed file-by-file (--no-folding): it and its plugins write
# runtime state (sockets, logs, plugins.json with absolute paths, installed
# plugins) into the same dirs as the
# tracked config, which must stay out of the repo.
for pkg in "${PACKAGES[@]}"; do
  if [[ "$pkg" == herdr ]]; then
    stow -d "$DOTFILES_DIR" -t "$HOME" --no-folding -R "$pkg"
  else
    stow -d "$DOTFILES_DIR" -t "$HOME" -R "$pkg"
  fi
done

# rust-analyzer: if a rustup toolchain is present, ensure its rust-analyzer
# component is installed. Otherwise the ~/.cargo/bin/rust-analyzer proxy — which
# sits first on PATH — is a dead stub that exits with "Unknown binary", so nvim
# launches it instead of a working LSP. No-op when rustup isn't installed (then
# Mason's rust-analyzer is used and no proxy exists to shadow it).
if command -v rustup >/dev/null 2>&1; then
  log "Ensuring rustup rust-analyzer component"
  rustup component add rust-analyzer >/dev/null 2>&1 \
    || warn "rustup component add rust-analyzer failed (continuing)"
fi

# --- neovim plugins + treesitter parsers -------------------------------------
# Install/sync lazy.nvim plugins headlessly so the first interactive launch is
# ready, then compile the Treesitter parsers. Without the parsers a buffer's
# FileType handler errors, which on Neovim 0.12 aborts other FileType autocmds
# (the LSP-attach one included, so rust-analyzer never attaches).
log "Syncing Neovim plugins (lazy.nvim)"
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 \
  || warn "Lazy sync reported an issue (continuing)"
# nvim-treesitter's `main` branch installs parsers asynchronously; the plugin
# config stashes the install handle in `_G.__ts_install`, so block on it here
# (main has no synchronous :TSUpdateSync command). Idempotent: returns at once
# when every parser is already present.
log "Compiling Treesitter parsers"
nvim --headless -c "lua if _G.__ts_install then _G.__ts_install:wait(600000) end" +qa >/dev/null 2>&1 \
  || warn "Treesitter parser install reported an issue (continuing)"

# --- oh-my-zsh ---------------------------------------------------------------
OMZ_DIR="$HOME/.oh-my-zsh"
if [[ -d "$OMZ_DIR" ]]; then
  log "oh-my-zsh already installed"
else
  log "Installing oh-my-zsh"
  # KEEP_ZSHRC: the stowed ~/.zshrc is the config; don't let the installer
  # replace it with its template. CHSH/RUNZSH: handled above / not wanted.
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/omz-install
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh /tmp/omz-install --unattended
fi

# External plugins listed in .zshrc's plugins=(...) that oh-my-zsh doesn't ship.
# custom/ is gitignored by oh-my-zsh, so `omz update` leaves them alone.
for p in zsh-autosuggestions zsh-syntax-highlighting; do
  dest="$OMZ_DIR/custom/plugins/$p"
  if [[ -d "$dest" ]]; then
    log "$p already installed"
  else
    log "Installing $p"
    git clone --depth 1 "https://github.com/zsh-users/$p" "$dest"
  fi
done

log "Done. Open a new kitty window — zsh + gruvbox + Nerd Font."
