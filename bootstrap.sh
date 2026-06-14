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
log "Installing prerequisites (git, curl, stow, fish, eza, zoxide)"
for p in git curl stow fish eza zoxide; do pkg_install "$p"; done

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

# --- symlink dotfiles --------------------------------------------------------
log "Stowing: ${PACKAGES[*]}"
stow -d "$DOTFILES_DIR" -t "$HOME" -R "${PACKAGES[@]}"

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
