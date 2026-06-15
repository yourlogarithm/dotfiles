# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal dotfiles for **macOS and Fedora**, managed with [GNU Stow](https://www.gnu.org/software/stow/). There is no build, test, or lint suite — this repo is configuration, applied to `$HOME` via symlinks.

## The stow model (read this first)

Each top-level directory is a **stow package** whose internal tree mirrors its destination under `$HOME`. So `nvim/.config/nvim/init.lua` is symlinked to `~/.config/nvim/init.lua`. To edit a config, edit the file *inside the package* — the symlink means changes take effect live; no re-stow needed for edits to already-linked files.

Re-stow is only required after **adding or removing** files in a package:

```sh
stow -t ~ nvim fish alacritty omf   # link everything (first time)
stow -t ~ -R nvim                   # restow (re-link after adding/removing files)
stow -t ~ -D nvim                   # unlink a package
stow -t ~ -n -v nvim                # dry-run, verbose — preview without changing anything
```

`-t ~` is mandatory: stow otherwise targets the *parent* of the dotfiles dir, not `$HOME`.

## Cross-platform is a hard constraint

Every change must work on **both macOS (Homebrew) and Fedora (dnf)**. Keep paths portable — resolve binaries via `PATH`, never hardcode `/opt/homebrew/...` or distro-specific locations. `bootstrap.sh` branches on `$OS`; when adding setup logic that differs per platform, guard it with the existing `[[ "$OS" == macos ]]` pattern rather than assuming one OS (e.g. `dscl` is macOS-only, `getent` is Linux-only).

## bootstrap.sh

One-shot, **idempotent** provisioning for a fresh machine: detects OS → installs prerequisites → JetBrainsMono Nerd Font → stows all packages → installs oh-my-fish and restores its bundle. Run it to apply, re-run safely anytime.

- Runs under `set -euo pipefail` with an `ERR` trap that reports the failing line/command/exit code. Run `DEBUG=1 ./bootstrap.sh` to trace every command.
- **Neovim install differs by OS**: macOS uses brew (current stable); Fedora installs the official prebuilt tarball into `/opt/nvim` symlinked to `/usr/local/bin/nvim`, because dnf lags (ships 0.10.4). The version is pinned via `NVIM_RELEASE` and gated by `NVIM_MIN_MINOR` near the top of the neovim section — bump `NVIM_RELEASE` to upgrade.

## Neovim config (`nvim/` package)

- **Requires Neovim ≥ 0.11.** `lua/plugins/lsp.lua` uses the 0.11+ API (`vim.lsp.config`, `vim.lsp.enable`); older nvim crashes at startup. This is why bootstrap force-installs a recent nvim on Fedora.
- Plugin manager is **lazy.nvim**, bootstrapped in `lua/config/lazy.lua`, which auto-imports every spec file under `lua/plugins/`. To add a plugin, drop a new `lua/plugins/<name>.lua` returning a lazy spec — no central registry to edit.
- `init.lua` loads `config.options`, `config.keymaps`, `config.autocmds`, then `config.lazy`.
- **`lazy-lock.json` is tracked on purpose** (see `.gitignore`) — it pins exact plugin commits for reproducible installs across machines. Update plugins with `:Lazy update` inside nvim (or headless `nvim --headless "+Lazy! update" +qa`), which rewrites the lock; commit it to propagate versions. LSP servers are managed via Mason + mason-lspconfig 2.x (`ensure_installed` in `lsp.lua`).

## oh-my-fish (`omf/` + fish loader)

Only the **declarative state** is tracked: the loader `fish/.config/fish/conf.d/omf.fish` and the `omf/.config/omf/{bundle,theme,channel}` files. The framework itself lives in `~/.local/share/omf` (machine state, installed by bootstrap, not in the repo). Add plugins/themes with `omf install <name>` — it records them in `bundle` automatically; commit `bundle` (and `theme`) to propagate to other machines. Don't hand-edit the framework.

## Not tracked / generated

- `fish/.config/fish/fish_variables` — machine-specific universal vars, intentionally gitignored.
- `graphify-out/` — generated knowledge-graph artifacts (from the `/graphify` skill). A post-commit hook auto-rebuilds and stages this directory, so it gets swept into commits; it is not hand-maintained source.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
