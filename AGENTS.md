# local-agents

Repository containing Arch Linux packages that install systemd Quadlet files to run local LLM inference containers via Podman.

The repository is split into two packages:
- [vllm-qwen36](file:///home/michael/code/local-agents/vllm-qwen36) — builds `vllm-qwen36` package for vLLM inference server.
- [hermes](file:///home/michael/code/local-agents/hermes) — builds `hermes-agent` package for the Hermes agent gateway and WebUI dashboard.

## Structure

- `/vllm-qwen36` — Folder for the `vllm-qwen36` package
  - `PKGBUILD` — Arch package definition
  - `vllm-qwen36.container` — Podman Quadlet for vLLM serving Qwen3.6-27B-FP8 on port 8000
  - `vllm-qwen36.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
  - `sysusers.vllm-qwen36` — systemd-sysusers config for the non-root `vllm` user
  - `Makefile` — thin wrapper around `makepkg`
- `/hermes` — Folder for the `hermes-agent` package
  - `PKGBUILD` — Arch package definition
  - `hermes-agent.container` — Podman Quadlet for hermes-agent gateway with API server and dashboard
  - `hermes-webui.container` — Podman Quadlet for hermes-webui dashboard
  - `hermes-agent.env` — secret template file
  - `hermes-agent-setup` — interactive wizard for hermes setup
  - `hermes` — CLI wrapper script to exec into the hermes-agent container
  - `hermes-agent.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
  - `sysusers.hermes-agent` — systemd-sysusers config for the non-root `hermes` user and `agent` group
  - `Makefile` — thin wrapper around `makepkg`

## How it runs

### vLLM Qwen 3.6
Navigate to `vllm-qwen36/` and run `make install`. Then, enable/start the service:
```bash
sudo systemctl enable --now vllm-qwen36.service
```
This creates `vllm-qwen36.service` via Quadlet, pulling the `vllm/vllm-openai:latest` image and mounting `/var/lib/vllm-qwen36` as the HuggingFace cache. The container listens on `localhost:8000` with an OpenAI-compatible API.

### Hermes Agent
Navigate to `hermes/` and run `make install`. Then, run the interactive setup wizard:
```bash
sudo hermes-agent-setup
```
This pulls the required images and initializes configuration files. Afterward, start the services:
```bash
sudo systemctl enable --now hermes-agent.service hermes-webui.service
```

## Key details

- vLLM container runs as the non-root `vllm` user (UID 2000, GID 0)
- Hermes agent runs as the non-root `hermes` user (UID 10000, GID 10000)
- Model cache lives at `/var/lib/vllm-qwen36`
- Hermes agent data lives at `/var/lib/hermes-agent/hermes`
- Uninstalling via `make uninstall` deletes these caches and removes the podman images.
- GPU access requires `nvidia-container-toolkit`

## Commit Message Format

All commit message titles must be prefixed with the subsystem they affect:

- `[vllm]` — changes primarily affecting `vllm-qwen36` folder or its packaging
- `[hermes]` — changes primarily affecting `hermes` folder or its packaging
- `[pkg]` — changes to top level repository setup
- `[...]` — changes spanning multiple subsystems with no clear primary focus
