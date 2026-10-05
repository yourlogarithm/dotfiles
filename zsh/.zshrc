# zsh
# Managed by ~/Projects/dotfiles (stow package: zsh)

# --- PATH --------------------------------------------------------------------
typeset -U path
# Homebrew: GUI-launched terminals on macOS start with launchd's PATH, which
# lacks brew. Existence-guarded, no-op on Linux / Intel vs ARM.
for _b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_b ]] && eval "$($_b shellenv)" && break
done
unset _b
path=(~/.local/bin ~/.cargo/bin $path)

# --- oh-my-zsh ---------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""                        # prompt sourced below instead
zstyle ':omz:update' mode reminder
# Order matters: syntax-highlighting must come after autosuggestions, and
# history-substring-search after syntax-highlighting (both READMEs).
# zsh-autosuggestions / zsh-syntax-highlighting are cloned into $ZSH/custom/plugins
# by bootstrap.sh; the rest ship with oh-my-zsh.
plugins=(git dotenv zsh-autosuggestions zsh-syntax-highlighting history-substring-search)
[[ -r $ZSH/oh-my-zsh.sh ]] && source "$ZSH/oh-my-zsh.sh"
source ~/.config/zsh/beloglazov.zsh-theme

# --- environment -------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim

# podman: point docker-compatible tools at the podman socket
if command -v podman >/dev/null 2>&1; then
  if [[ $OSTYPE == darwin* ]]; then
    _sock=$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)
    [[ -n $_sock ]] && export DOCKER_HOST="unix://$_sock"
    unset _sock
  else
    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  fi
fi

# COSMIC does not export SSH_AUTH_SOCK the way gnome-session did; use the
# socket-activated gcr-ssh-agent (systemctl --user status gcr-ssh-agent.socket).
if [[ -z $SSH_AUTH_SOCK && -S $XDG_RUNTIME_DIR/gcr/ssh ]]; then
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
fi

# herdr has no conditional config: build config.toml from the shared base plus
# the per-OS overlay (config.Linux.toml / config.Darwin.toml, named by uname).
# Edit those, never config.toml. tmp+mv replaces a stale stow symlink instead of
# writing through it. Rebuilt only when missing or older than a source, because
# herdr-radar keeps its own managed blocks in config.toml (machine paths, colours
# that follow light/dark); after a rebuild it is asked to re-apply them.
() {
  local d=~/.config/herdr
  [[ -f $d/config.base.toml ]] || return
  [[ -f $d/config.toml && ! -L $d/config.toml \
    && ! $d/config.base.toml -nt $d/config.toml \
    && ! $d/config.$(uname).toml -nt $d/config.toml ]] && return
  cat $d/config.base.toml $d/config.$(uname).toml >$d/config.toml.tmp 2>/dev/null
  mv -f $d/config.toml.tmp $d/config.toml
  local p
  for p in $d/plugins/github/hhdebb.herdr-radar-*(N/); do
    (cd / && node $p/bin/configure.js --apply --reload &>/dev/null &)
  done
}

# --- aliases / tools ---------------------------------------------------------
# eza (https://github.com/eza-community/eza) as a modern ls
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --git --group-directories-first --icons=auto'
  alias la='eza -la --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'
fi

# zoxide (https://github.com/ajeetdsouza/zoxide) — smarter cd, provides `z`
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Scaleway CLI completion
command -v scw >/dev/null 2>&1 && eval "$(scw autocomplete script shell=zsh)"

# --- machine-local overrides (not tracked) -----------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
