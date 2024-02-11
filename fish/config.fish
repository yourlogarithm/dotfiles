if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.android-tools/bin:$PATH"

set nvim "/usr/bin/nvim"
export EDITOR=$nvim
export VIEWER=$nvim
alias vim=$nvim
alias v="$nvim ."

export SHELL="/bin/fish"

alias python=python3.12
function jadx-gui
    /home/vcretu/.jadx/bin/jadx-gui $argv > /dev/null 2>&1 & disown
end
