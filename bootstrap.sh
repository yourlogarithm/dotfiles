#!/usr/bin/env bash
# bootstrap.sh — bring a fresh macOS or Fedora machine to a working state.
#
# Installs prerequisites (stow, fish, the Nerd Font), symlinks every stow
# package into $HOME, installs oh-my-fish, and restores its bundle.
# Idempotent: safe to re-run.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(nvim fish alacritty omf)

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
log "Installing prerequisites (git, curl, stow, fish, eza, zoxide, ripgrep)"
for p in git curl stow fish eza zoxide ripgrep; do pkg_install "$p"; done

# fd (used by telescope) — named 'fd' on Homebrew, 'fd-find' on Fedora.
if [[ "$OS" == macos ]]; then pkg_install fd; else pkg_install fd-find; fi

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

# --- make fish the default login shell ---------------------------------------
# alacritty has no shell override; it launches the login shell by absolute path,
# which sidesteps the macOS GUI-launch PATH problem and keeps the config portable.
fish_path="$(command -v fish)"
if ! grep -qxF "$fish_path" /etc/shells 2>/dev/null; then
  log "Registering $fish_path in /etc/shells (sudo)"
  echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$OS" == macos ]]; then
  current_shell="$(dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}')"
else
  current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
fi
if [[ "$current_shell" != "$fish_path" ]]; then
  log "Setting login shell to fish (chsh — may prompt for your password)"
  chsh -s "$fish_path" || warn "chsh failed; run manually: chsh -s $fish_path"
else
  log "Login shell already fish"
fi

# --- symlink dotfiles --------------------------------------------------------
log "Stowing: ${PACKAGES[*]}"
stow -d "$DOTFILES_DIR" -t "$HOME" -R "${PACKAGES[@]}"

# Add the Rust toolchain to PATH once, as a fish universal var (persists across
# sessions with no per-startup cost). Idempotent.
if [[ -d "$HOME/.cargo/bin" ]]; then
  fish -c 'fish_add_path ~/.cargo/bin' || true
fi

# --- oh-my-fish --------------------------------------------------------------
OMF_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/omf"
if [[ -d "$OMF_PATH" ]]; then
  log "oh-my-fish already installed"
else
  log "Installing oh-my-fish"
  # The fish process that runs the installer sources the (already-stowed)
  # conf.d/omf.fish, which tries to load OMF before it exists — one benign
  # "no such file" message may appear; the install then proceeds normally.
  curl -fsSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o /tmp/omf-install
  fish /tmp/omf-install --noninteractive --yes
fi

# --- restore plugins/themes from bundle --------------------------------------
log "Restoring oh-my-fish bundle"
fish -c "omf install" || warn "omf install reported an issue (continuing)"

log "Done. Open a new alacritty window — fish + gruvbox + Nerd Font."
