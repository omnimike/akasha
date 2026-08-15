# vllm-qwen3

Arch package that installs a systemd Quadlet file to run a vLLM inference container via Podman.

## Structure

- `PKGBUILD` — Arch package definition
- `Makefile` — thin wrapper around `makepkg`
- `vllm-qwen3.container` — Podman Quadlet for vLLM serving Qwen/Qwen3.8-27B on port 8000
- `vllm-qwen3.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
- `sysusers.vllm-qwen3` — systemd-sysusers config for the non-root `vllm` user
- `src/` — source files installed into the package (`sysusers.vllm-qwen3`, `vllm-qwen3.container`)
- `pkg/` — built package output

## How it runs

Navigate to `vllm-qwen3/` and run `make install`. Then, enable/start the service:

```bash
sudo systemctl enable --now vllm-qwen3.service
```

This creates `vllm-qwen3.service` via Quadlet, pulling the `vllm/vllm-openai:latest` image and mounting `/var/lib/vllm-qwen3` as the HuggingFace cache. The container listens on `localhost:8000` with an OpenAI-compatible API.

## Key details

- Container runs as the non-root `vllm` user (UID 2000, GID 0)
- Model cache lives at `/var/lib/vllm-qwen3`
- Uninstalling via `make uninstall` deletes the cache and removes the podman image
- GPU access requires `nvidia-container-toolkit`