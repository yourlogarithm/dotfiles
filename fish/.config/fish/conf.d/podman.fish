if command -q podman
    if test (uname) = Darwin
        set -l sock (podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)
        test -n "$sock"; and set -gx DOCKER_HOST "unix://$sock"
    else
        set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    end
end
