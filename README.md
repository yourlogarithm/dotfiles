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
├── zsh/.zshrc                    -> ~/.zshrc           (oh-my-zsh plugins + config)
├── zsh/.config/zsh/              -> ~/.config/zsh/     (beloglazov prompt theme)
├── kitty/.config/kitty/          -> ~/.config/kitty/
├── herdr/.config/herdr/          -> ~/.config/herdr/   (--no-folding)
└── herdr-projects/.config/...    -> ~/.config/herdr-projects/ (--no-folding)
```

## Fresh machine

```sh
git clone <repo-url> ~/Projects/dotfiles
~/Projects/dotfiles/bootstrap.sh
```

`bootstrap.sh` detects the OS (Homebrew on macOS, dnf on Fedora) and:
1. installs prerequisites — `git`, `curl`, `stow`, `zsh` (Fedora), `kitty`;
2. installs the **JetBrainsMono Nerd Font**;
3. makes zsh the login shell, stows every package into `$HOME`;
4. installs **oh-my-zsh** if missing, then clones the external plugins
   (`zsh-autosuggestions`, `zsh-syntax-highlighting`) into its `custom/plugins`.

It is idempotent — safe to re-run.

## Manual stow

```sh
cd ~/Projects/dotfiles
stow -t ~ nvim zsh kitty                  # link everything
stow -t ~ --no-folding herdr herdr-projects
stow -t ~ -R nvim                   # restow a package (re-link after changes)
stow -t ~ -D nvim                   # unlink a package
stow -t ~ -n -v nvim                # dry-run, verbose
```

`-t ~` sets the symlink target to `$HOME` (stow otherwise defaults to the parent
of the dotfiles dir, i.e. `~/Projects`).

## Notes

- **oh-my-zsh**: the repo tracks only `zsh/.zshrc` (the `plugins=(...)` list
  is the declarative state) and the prompt theme. The framework lives in
  `~/.oh-my-zsh` (machine state, installed by `bootstrap.sh`). Built-in plugins:
  add the name to `plugins=(...)`. External ones: also add a clone line to the
  loop in `bootstrap.sh`.
- `~/.zshrc.local` (machine-specific, not tracked) is sourced last if present.
- Paths are kept portable — kitty launches the login shell, no hardcoded
  `/opt/homebrew/...`.
- A backup of the pre-stow configs lives at `~/dotfiles-backup-20260614/`.
