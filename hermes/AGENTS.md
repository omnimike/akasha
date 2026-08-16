# hermes-agent

Arch package that installs systemd Quadlet files to run the Hermes agent gateway and WebUI dashboard containers via Podman.

## Structure

- `PKGBUILD` — Arch package definition
- `Makefile` — thin wrapper around `makepkg`
- `hermes-agent.container` — Podman Quadlet for hermes-agent gateway with API server and dashboard
- `hermes-agent.build` — Podman Quadlet build unit (generates the oneshot `hermes-agent-build.service`) that builds the custom hermes-agent image before the container starts
- `Containerfile` — Containerfile build context for the custom hermes-agent image (installed to `/usr/share/hermes-agent/build/`)
- `hermes-webui.container` — Podman Quadlet for hermes-webui dashboard
- `hermes-agent.env` — secret template file
- `hermes` — CLI wrapper: `hermes install` installs the agent (secrets, service start, root only), any other invocation execs the hermes CLI inside the hermes-agent container (root, or any member of the `hermes` group without sudo)
- `hermes-agent.sudoers` — NOPASSWD sudoers rule installed to `/etc/sudoers.d/hermes-agent`, letting the `hermes` group run the wrapper's `podman exec`/`container inspect` commands passwordlessly
- `hermes-agent.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
- `sysusers.hermes-agent` — systemd-sysusers config for the non-root `hermes` user and `agent` group

## How it runs

Navigate to `hermes/` and run `make install`. Then:

```bash
sudo hermes install
```

This initializes configuration files and starts the services. Afterward, run the interactive setup wizard:

```bash
hermes setup
```

## Key details

- The container stays a **rootful** Podman container (root store). A regular user can't reach that store directly, so `hermes [args]` runs `sudo podman exec/inspect` under the hood. A scoped `NOPASSWD` sudoers rule (`/etc/sudoers.d/hermes-agent`) makes this passwordless for any member of the `hermes` group; `hermes install` still requires root
- Container runs as the non-root `hermes` user (UID 10000, GID 10000)
- The hermes-agent image `localhost/hermes-agent:latest` is built from `Containerfile` by `hermes-agent-build.service` on every boot, before the container starts (podman layer cache makes no-op rebuilds fast)
- The custom image must keep a UID/GID 10000 user, the `hermes` CLI entrypoint, the `setup` subcommand, and agent source at `/opt/hermes`
- Agent data lives at `/var/lib/hermes-agent/hermes`
- Uninstalling via `make uninstall` deletes the data and removes the podman image
- GPU access requires `nvidia-container-toolkit`