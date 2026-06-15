# Graph Report - .  (2026-06-15)

## Corpus Check
- Corpus is ~4,857 words - fits in a single context window. You may not need a graph.

## Summary
- 165 nodes · 145 edges · 60 communities (57 shown, 3 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 7 edges (avg confidence: 0.81)
- Token cost: 0 input · 21,724 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Dotfiles Provisioning|Dotfiles Provisioning]]
- [[_COMMUNITY_Plugin Lockfile|Plugin Lockfile]]
- [[_COMMUNITY_Bootstrap Shell Functions|Bootstrap Shell Functions]]
- [[_COMMUNITY_Neovim IDE Navigation|Neovim IDE Navigation]]
- [[_COMMUNITY_blink.cmp (lock entry)|blink.cmp (lock entry)]]
- [[_COMMUNITY_bufferline (lock entry)|bufferline (lock entry)]]
- [[_COMMUNITY_claudecode (lock entry)|claudecode (lock entry)]]
- [[_COMMUNITY_conform (lock entry)|conform (lock entry)]]
- [[_COMMUNITY_flatten (lock entry)|flatten (lock entry)]]
- [[_COMMUNITY_friendly-snippets (lock entry)|friendly-snippets (lock entry)]]
- [[_COMMUNITY_gitsigns (lock entry)|gitsigns (lock entry)]]
- [[_COMMUNITY_hop (lock entry)|hop (lock entry)]]
- [[_COMMUNITY_lazy (lock entry)|lazy (lock entry)]]
- [[_COMMUNITY_lualine (lock entry)|lualine (lock entry)]]
- [[_COMMUNITY_markdown-preview (lock entry)|markdown-preview (lock entry)]]
- [[_COMMUNITY_mason-lspconfig (lock entry)|mason-lspconfig (lock entry)]]
- [[_COMMUNITY_mason (lock entry)|mason (lock entry)]]
- [[_COMMUNITY_mason-tool-installer (lock entry)|mason-tool-installer (lock entry)]]
- [[_COMMUNITY_mini (lock entry)|mini (lock entry)]]
- [[_COMMUNITY_neo-tree (lock entry)|neo-tree (lock entry)]]
- [[_COMMUNITY_neovim-project (lock entry)|neovim-project (lock entry)]]
- [[_COMMUNITY_neovim-session-manager (lock entry)|neovim-session-manager (lock entry)]]
- [[_COMMUNITY_nui (lock entry)|nui (lock entry)]]
- [[_COMMUNITY_nvim-lint (lock entry)|nvim-lint (lock entry)]]
- [[_COMMUNITY_nvim-lspconfig (lock entry)|nvim-lspconfig (lock entry)]]
- [[_COMMUNITY_nvim-scrollbar (lock entry)|nvim-scrollbar (lock entry)]]
- [[_COMMUNITY_nvim-treesitter (lock entry)|nvim-treesitter (lock entry)]]
- [[_COMMUNITY_nvim-web-devicons (lock entry)|nvim-web-devicons (lock entry)]]
- [[_COMMUNITY_oil (lock entry)|oil (lock entry)]]
- [[_COMMUNITY_plenary (lock entry)|plenary (lock entry)]]
- [[_COMMUNITY_snacks (lock entry)|snacks (lock entry)]]
- [[_COMMUNITY_telescope-fzf-native (lock entry)|telescope-fzf-native (lock entry)]]
- [[_COMMUNITY_Completion menu|Completion menu]]
- [[_COMMUNITY_hop motion plugin|hop motion plugin]]
- [[_COMMUNITY_surround adddeletereplace|surround add/delete/replace]]

## God Nodes (most connected - your core abstractions)
1. `bootstrap.sh` - 7 edges
2. `bootstrap.sh script` - 6 edges
3. `Stow Package` - 5 edges
4. `auto-save.nvim` - 3 edges
5. `blink.cmp` - 3 edges
6. `bufferline.nvim` - 3 edges
7. `claudecode.nvim` - 3 edges
8. `conform.nvim` - 3 edges
9. `flatten.nvim` - 3 edges
10. `friendly-snippets` - 3 edges

## Surprising Connections (you probably didn't know these)
- `Neovim editor` --conceptually_related_to--> `nvim package`  [INFERRED]
  nvim-cheatsheet.txt → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Stow-managed config packages** — readme_nvim_package, readme_fish_package, readme_alacritty_package, readme_omf_package [EXTRACTED 1.00]
- **Fresh-machine bootstrap provisioning flow** — readme_bootstrap_sh, readme_gnu_stow, readme_oh_my_fish, readme_jetbrainsmono_nerd_font, readme_omf_bundle [EXTRACTED 0.85]
- **oh-my-fish declarative propagation** — readme_oh_my_fish, readme_omf_loader, readme_omf_bundle [EXTRACTED 0.85]

## Communities (60 total, 3 thin omitted)

### Community 0 - "Dotfiles Provisioning"
Cohesion: 0.13
Nodes (19): Claude integration, gitsigns, Neovim editor, alacritty package, bootstrap.sh, dnf (Fedora), dotfiles repository, fish package (+11 more)

### Community 1 - "Plugin Lockfile"
Cohesion: 0.12
Nodes (15): auto-save.nvim, branch, commit, gruvbox.nvim, branch, commit, indent-blankline.nvim, branch (+7 more)

### Community 2 - "Bootstrap Shell Functions"
Cohesion: 0.43
Nodes (6): die(), font_installed(), log(), pkg_install(), warn(), bootstrap.sh script

### Community 3 - "Neovim IDE Navigation"
Cohesion: 0.33
Nodes (6): Leader key (Space), LSP code navigation, neo-tree file explorer, oil directory editor, Telescope (find/picker), which-key keymap menu

### Community 5 - "blink.cmp (lock entry)"
Cohesion: 0.67
Nodes (3): blink.cmp, branch, commit

### Community 6 - "bufferline (lock entry)"
Cohesion: 0.67
Nodes (3): bufferline.nvim, branch, commit

### Community 7 - "claudecode (lock entry)"
Cohesion: 0.67
Nodes (3): claudecode.nvim, branch, commit

### Community 8 - "conform (lock entry)"
Cohesion: 0.67
Nodes (3): conform.nvim, branch, commit

### Community 9 - "flatten (lock entry)"
Cohesion: 0.67
Nodes (3): flatten.nvim, branch, commit

### Community 10 - "friendly-snippets (lock entry)"
Cohesion: 0.67
Nodes (3): friendly-snippets, branch, commit

### Community 11 - "gitsigns (lock entry)"
Cohesion: 0.67
Nodes (3): gitsigns.nvim, branch, commit

### Community 12 - "hop (lock entry)"
Cohesion: 0.67
Nodes (3): hop.nvim, branch, commit

### Community 13 - "lazy (lock entry)"
Cohesion: 0.67
Nodes (3): lazy.nvim, branch, commit

### Community 14 - "lualine (lock entry)"
Cohesion: 0.67
Nodes (3): lualine.nvim, branch, commit

### Community 15 - "markdown-preview (lock entry)"
Cohesion: 0.67
Nodes (3): markdown-preview.nvim, branch, commit

### Community 16 - "mason-lspconfig (lock entry)"
Cohesion: 0.67
Nodes (3): mason-lspconfig.nvim, branch, commit

### Community 17 - "mason (lock entry)"
Cohesion: 0.67
Nodes (3): mason.nvim, branch, commit

### Community 18 - "mason-tool-installer (lock entry)"
Cohesion: 0.67
Nodes (3): mason-tool-installer.nvim, branch, commit

### Community 19 - "mini (lock entry)"
Cohesion: 0.67
Nodes (3): mini.nvim, branch, commit

### Community 20 - "neo-tree (lock entry)"
Cohesion: 0.67
Nodes (3): neo-tree.nvim, branch, commit

### Community 21 - "neovim-project (lock entry)"
Cohesion: 0.67
Nodes (3): neovim-project, branch, commit

### Community 22 - "neovim-session-manager (lock entry)"
Cohesion: 0.67
Nodes (3): neovim-session-manager, branch, commit

### Community 23 - "nui (lock entry)"
Cohesion: 0.67
Nodes (3): nui.nvim, branch, commit

### Community 24 - "nvim-lint (lock entry)"
Cohesion: 0.67
Nodes (3): nvim-lint, branch, commit

### Community 25 - "nvim-lspconfig (lock entry)"
Cohesion: 0.67
Nodes (3): nvim-lspconfig, branch, commit

### Community 26 - "nvim-scrollbar (lock entry)"
Cohesion: 0.67
Nodes (3): nvim-scrollbar, branch, commit

### Community 27 - "nvim-treesitter (lock entry)"
Cohesion: 0.67
Nodes (3): nvim-treesitter, branch, commit

### Community 28 - "nvim-web-devicons (lock entry)"
Cohesion: 0.67
Nodes (3): nvim-web-devicons, branch, commit

### Community 29 - "oil (lock entry)"
Cohesion: 0.67
Nodes (3): oil.nvim, branch, commit

### Community 30 - "plenary (lock entry)"
Cohesion: 0.67
Nodes (3): plenary.nvim, branch, commit

### Community 31 - "snacks (lock entry)"
Cohesion: 0.67
Nodes (3): snacks.nvim, branch, commit

### Community 32 - "telescope-fzf-native (lock entry)"
Cohesion: 0.67
Nodes (3): telescope-fzf-native.nvim, branch, commit

## Knowledge Gaps
- **77 isolated node(s):** `branch`, `commit`, `branch`, `commit`, `branch` (+72 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `blink.cmp` connect `blink.cmp (lock entry)` to `Plugin Lockfile`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Why does `bufferline.nvim` connect `bufferline (lock entry)` to `Plugin Lockfile`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `branch`, `commit`, `branch` to the rest of the system?**
  _78 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Dotfiles Provisioning` be split into smaller, more focused modules?**
  _Cohesion score 0.13450292397660818 - nodes in this community are weakly interconnected._
- **Should `Plugin Lockfile` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._