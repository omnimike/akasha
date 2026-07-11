# vllm-qwen36

Arch package that installs a systemd Quadlet file to run a vLLM inference container via Podman.

## Structure

- `PKGBUILD` — Arch package definition
- `Makefile` — thin wrapper around `makepkg`
- `vllm-qwen36.container` — Podman Quadlet for vLLM serving Qwen3.6-27B-FP8 on port 8000
- `vllm-qwen36.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
- `sysusers.vllm-qwen36` — systemd-sysusers config for the non-root `vllm` user
- `src/` — source files installed into the package (`sysusers.vllm-qwen36`, `vllm-qwen36.container`)
- `pkg/` — built package output

## How it runs

Navigate to `vllm-qwen36/` and run `make install`. Then, enable/start the service:

```bash
sudo systemctl enable --now vllm-qwen36.service
```

This creates `vllm-qwen36.service` via Quadlet, pulling the `vllm/vllm-openai:latest` image and mounting `/var/lib/vllm-qwen36` as the HuggingFace cache. The container listens on `localhost:8000` with an OpenAI-compatible API.

## Key details

- Container runs as the non-root `vllm` user (UID 2000, GID 0)
- Model cache lives at `/var/lib/vllm-qwen36`
- Uninstalling via `make uninstall` deletes the cache and removes the podman image
- GPU access requires `nvidia-container-toolkit`