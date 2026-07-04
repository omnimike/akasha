# local-agents

Arch Linux package that installs systemd Quadlet files to run local LLM inference containers via Podman.

## Structure

- `PKGBUILD` — Arch package definition; installs Quadlet `.container` and systemd `.target` files
- `vllm-qwen36.container` — Podman Quadlet for vLLM serving Qwen3.6-27B-FP8 on port 8000
- `hermes-agent.container` — Podman Quadlet for hermes-agent gateway with API server and dashboard
- `local-agents.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
- `Makefile` — thin wrapper around `makepkg`

## Commands

- `make build` — build the `.pkg.tar.zst` package
- `make install` — build + install via `pacman` (requires root)
- `make uninstall` — remove package via `pacman` (triggers model/cache cleanup in hook)
- `make clean` — remove `pkg/`, `src/`, `*.pkg.tar*`

## How it runs

After `make install`, enable/start the target:
```
sudo systemctl enable --now vllm-qwen36.service
```
This creates `vllm-qwen36.service` via Quadlet, pulling the `vllm/vllm-openai:latest` image and mounting `/var/lib/local-agents/vllm` as the HuggingFace cache. The container listens on `localhost:8000` with an OpenAI-compatible API.

## Key details

- vLLM container runs as the non-root `vllm` user (UID 2000, GID 0) via `User=` in the Quadlet
- A host `vllm` system user is created by `systemd-sysusers` and deleted on uninstall
- Model cache lives at `/var/lib/local-agents/vllm` (mounted as `/home/vllm/.cache/huggingface` in the container)
- Hermes agent data lives at `/var/lib/local-agents/hermes`
- `post_remove` hook deletes these caches and removes the podman images — `make uninstall` is destructive
- GPU access requires `nvidia-container-toolkit`
- Adding a new model/container: create a `<name>.container` Quadlet file and list it in `source=` in the PKGBUILD

## Commit Message Format

All commit message titles must be prefixed with the subsystem they affect:

- `[vllm]` — changes to `vllm-qwen36.container` or vLLM-specific configuration
- `[hermes]` — changes to `hermes-agent.container` or hermes-specific configuration
- `[pkg]` — changes to `PKGBUILD`, `local-agents.install`, `Makefile`, or other packaging files
- `[]` — changes affecting multiple subsystems or shared infrastructure
