# COSMIC does not export SSH_AUTH_SOCK the way gnome-session did.
# Point at the socket-activated gcr-ssh-agent (systemctl --user status gcr-ssh-agent.socket).
if not set -q SSH_AUTH_SOCK; and test -S $XDG_RUNTIME_DIR/gcr/ssh
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh
end
