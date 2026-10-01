# herdr has no conditional config: build config.toml from the shared base plus
# the per-OS overlay (config.Linux.toml / config.Darwin.toml, named by uname).
# Edit those, never config.toml. tmp+mv replaces a stale stow symlink instead of
# writing through it.
set -l d ~/.config/herdr
if test -f $d/config.base.toml
    cat $d/config.base.toml $d/config.(uname).toml >$d/config.toml.tmp 2>/dev/null
    mv -f $d/config.toml.tmp $d/config.toml
end
