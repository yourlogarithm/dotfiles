# beloglazov — zsh port of the oh-my-fish theme of the same name.
# Prompt:  [✘ ]HH:MM cwd (branch) [+N] [✗]
#   ✘   last command failed (bold red)
#   ➜   shown when root
#   time is 24-hour (the one change vs. upstream, carried over from the fish copy)
# Sourced from .zshrc after oh-my-zsh.sh with ZSH_THEME="" — no OMZ custom dir needed.

setopt PROMPT_SUBST

_beloglazov_git() {
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) || return
  # a literal % in a branch name would be expanded by the prompt
  local out=" %B%F{blue}(%F{red}${branch//\%/%%}%F{blue})%f%b"

  local ahead
  ahead=$(command git rev-list --count "origin/${branch}..HEAD" 2>/dev/null)
  [[ -n $ahead && $ahead != 0 ]] && out+=" %F{green}+${ahead}%f"

  [[ -n $(command git status -s --ignore-submodules=dirty 2>/dev/null) ]] && out+=" %B%F{yellow}✗%f%b"

  print -n -- "$out"
}

PROMPT='%(?..%B%F{red}✘%f%b )%(!.%B%F{red}➜%f%b  .)%F{red}%D{%H:%M}%f %B%F{cyan}%1~%f%b$(_beloglazov_git) '
