# dotfiles

Personal dotfiles for **macOS and Fedora**, managed with
[GNU Stow](https://www.gnu.org/software/stow/). Everything is kept
system-agnostic — no machine-specific paths.

## Layout

Each top-level directory is a **stow package** whose internal tree mirrors its
location under `$HOME`:

```
dotfiles/
├── bootstrap.sh                  # one-shot setup for a fresh machine
├── nvim/.config/nvim/            -> ~/.config/nvim/
├── fish/.config/fish/            -> ~/.config/fish/
├── alacritty/.config/alacritty/  -> ~/.config/alacritty/
└── omf/.config/omf/              -> ~/.config/omf/   (oh-my-fish bundle/theme)
```

## Fresh machine

```sh
git clone <repo-url> ~/Projects/dotfiles
~/Projects/dotfiles/bootstrap.sh
```

`bootstrap.sh` detects the OS (Homebrew on macOS, dnf on Fedora) and:
1. installs prerequisites — `git`, `curl`, `stow`, `fish`;
2. installs the **JetBrainsMono Nerd Font**;
3. stows every package into `$HOME`;
4. installs **oh-my-fish** if missing, then runs `omf install` to restore the
   plugins/themes listed in `omf/.config/omf/bundle`.

It is idempotent — safe to re-run.

## Manual stow

```sh
cd ~/Projects/dotfiles
stow -t ~ nvim fish alacritty omf   # link everything
stow -t ~ -R nvim                   # restow a package (re-link after changes)
stow -t ~ -D nvim                   # unlink a package
stow -t ~ -n -v nvim                # dry-run, verbose
```

`-t ~` sets the symlink target to `$HOME` (stow otherwise defaults to the parent
of the dotfiles dir, i.e. `~/Projects`).

## Notes

- **oh-my-fish**: the repo tracks only the *bootstrap loader*
  (`fish/.config/fish/conf.d/omf.fish`) and the *declarative bundle*
  (`omf/.config/omf/bundle`). The framework itself lives in
  `~/.local/share/omf` (machine state) and is installed by `bootstrap.sh`.
  Add plugins with `omf install <name>` — they're recorded in `bundle`
  automatically, so commit `bundle` to propagate them to other machines.
- `fish_variables` (machine-specific universal vars) is intentionally **not**
  tracked — see `.gitignore`.
- Paths are kept portable (e.g. alacritty's `shell.program = "fish"` resolves
  via `PATH`, not `/opt/homebrew/bin/fish`).
- A backup of the pre-stow configs lives at `~/dotfiles-backup-20260614/`.
