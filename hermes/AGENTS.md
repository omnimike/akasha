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
- `hermes-agent-setup` — interactive wizard for hermes setup
- `hermes` — CLI wrapper script to exec into the hermes-agent container
- `hermes-agent.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
- `sysusers.hermes-agent` — systemd-sysusers config for the non-root `hermes` user and `agent` group

## How it runs

Navigate to `hermes/` and run `make install`. Then, run the interactive setup wizard:

```bash
sudo hermes-agent-setup
```

This builds the custom hermes-agent image and initializes configuration files. Afterward, start the services:

```bash
sudo systemctl enable --now hermes-agent.service hermes-webui.service
```

## Key details

- Container runs as the non-root `hermes` user (UID 10000, GID 10000)
- The hermes-agent image `localhost/hermes-agent:latest` is built from `Containerfile` by `hermes-agent-build.service` on every boot, before the container starts (podman layer cache makes no-op rebuilds fast)
- The custom image must keep a UID/GID 10000 user, the `hermes` CLI entrypoint, the `setup` subcommand, and agent source at `/opt/hermes`
- Agent data lives at `/var/lib/hermes-agent/hermes`
- Uninstalling via `make uninstall` deletes the data and removes the podman image
- GPU access requires `nvidia-container-toolkit`