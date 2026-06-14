# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package** whose internal tree mirrors its
location under `$HOME`:

```
dotfiles/
├── nvim/.config/nvim/         -> ~/.config/nvim/
├── fish/.config/fish/         -> ~/.config/fish/
└── alacritty/.config/alacritty/ -> ~/.config/alacritty/
```

## Install

```fish
cd ~/Projects/dotfiles
stow -t ~ nvim fish alacritty
```

`-t ~` sets the symlink target to `$HOME` (stow defaults to the parent of the
dotfiles dir, which would be `~/Projects`).

## Common commands

```fish
cd ~/Projects/dotfiles
stow -t ~ nvim            # link a single package
stow -t ~ -D nvim         # unlink (delete) a package
stow -t ~ -R nvim         # restow (re-link after changes)
stow -t ~ -n -v nvim      # dry-run, verbose
```

## Notes

- `fish_variables` (machine-specific universal vars) is intentionally **not**
  managed — see `.gitignore`.
- A backup of the pre-stow configs lives at `~/dotfiles-backup-20260614/`.
