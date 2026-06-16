# fish
# Managed by ~/Projects/dotfiles (stow package: fish)

# Disable the interactive greeting.
set -g fish_greeting ""

if status is-interactive
    # Use eza (https://github.com/eza-community/eza) as a modern ls.
    if type -q eza
        alias ls='eza --group-directories-first --icons=auto'
        alias ll='eza -l --git --group-directories-first --icons=auto'
        alias la='eza -la --git --group-directories-first --icons=auto'
        alias lt='eza --tree --level=2 --icons=auto'
    end

    # zoxide (https://github.com/ajeetdsouza/zoxide) — smarter cd, provides `z`.
    if type -q zoxide
        zoxide init fish | source
    end

    # Resolve `code` to VSCodium.
    if type -q codium
        alias code='codium'
    end
end
