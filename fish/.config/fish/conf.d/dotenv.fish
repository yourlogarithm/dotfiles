# Auto-load environment variables from a `.env` file in the current directory.
# Managed by ~/dotfiles (stow package: fish).
#
# On entering a directory containing `.env`, its `KEY=value` lines are exported.
# On leaving that directory, those same variables are removed again, so the
# effect is scoped to the directory tree where the `.env` lives.
#
# For safety this only parses `KEY=value` assignments — it never executes the
# file as a script, so a `.env` cannot run arbitrary commands.

# Track the directory whose .env is currently loaded, and which keys it set,
# so we can cleanly unload them later.
set -g __dotenv_loaded_dir ""
set -g __dotenv_loaded_keys

function __dotenv_unload --description "Remove vars set by the active .env"
    for key in $__dotenv_loaded_keys
        set -e -g $key
    end
    set -g __dotenv_loaded_keys
    set -g __dotenv_loaded_dir ""
end

function __dotenv_load --description "Export KEY=value lines from a .env file"
    set -l file $argv[1]
    set -l dir (dirname $file)
    set -l keys

    while read -l line
        # Strip a leading `export ` and surrounding whitespace.
        set line (string trim -- $line)
        set line (string replace -r '^export\s+' '' -- $line)

        # Skip blanks and comments.
        string match -qr '^\s*(#|$)' -- $line; and continue

        # Match KEY=VALUE (KEY must be a valid identifier).
        set -l kv (string match -r '^([A-Za-z_][A-Za-z0-9_]*)=(.*)$' -- $line)
        test (count $kv) -eq 3; or continue
        set -l key $kv[2]
        set -l val $kv[3]

        # Strip surrounding quotes, preserving any '#' inside them. An unquoted
        # value instead has trailing inline comments (" # ...") removed.
        if string match -qr '^"' -- $val
            set val (string replace -r '^"(.*)"\s*(#.*)?$' '$1' -- $val)
        else if string match -qr "^'" -- $val
            set val (string replace -r "^'(.*)'\s*(#.*)?\$" '$1' -- $val)
        else
            set val (string replace -r '\s+#.*$' '' -- $val)
            set val (string trim -- $val)
        end

        set -gx $key $val
        set -a keys $key
    end <$file

    set -g __dotenv_loaded_dir $dir
    set -g __dotenv_loaded_keys $keys
    if test (count $keys) -gt 0
        echo "dotenv: loaded "(count $keys)" var(s) from $file"
    end
end

function __dotenv_hook --on-variable PWD --description "Detect and (un)load .env on cd"
    status is-interactive; or return

    # Leaving the directory whose .env we loaded — unload it.
    if test -n "$__dotenv_loaded_dir"; and test "$PWD" != "$__dotenv_loaded_dir"
        __dotenv_unload
    end

    # Entering a directory with a .env we haven't loaded yet — load it.
    if test -f "$PWD/.env"; and test "$PWD" != "$__dotenv_loaded_dir"
        __dotenv_load "$PWD/.env"
    end
end

function dotenv-reload --description "Reload the .env in the current directory"
    if test -n "$__dotenv_loaded_dir"
        __dotenv_unload
    end
    if test -f "$PWD/.env"
        __dotenv_load "$PWD/.env"
    else
        echo "dotenv: no .env in $PWD"
    end
end

# Run once at shell startup so a shell opened inside a .env dir is covered.
status is-interactive; and __dotenv_hook
