# local-agents

A Pacman package for running local LLM inference servers on Arch Linux, managed by systemd via Podman Quadlets.

## What's Inside

- **vllm-qwen36** — vLLM server running `Qwen3.6-27B-FP8` with MTP speculative decoding and prefix caching, exposed on port `8000` (OpenAI-compatible API).

## Requirements

- Arch Linux
- `podman`
- `nvidia-container-toolkit` (for GPU access)

## Installation

```bash
make install
```

## Usage

The vLLM server starts as a systemd service and is available at `http://localhost:8000`. It speaks the OpenAI API, so you can use any OpenAI-compatible client:

```bash
curl http://localhost:8000/v1/models
```

## Adding a New Model/Container

1. Create a `<name>.container` Quadlet file.
2. List the file in `source=` in the `PKGBUILD`.

## Model Cache

Models are cached at `/var/lib/local-agents`, which is mounted as `/root/.cache/huggingface` inside the container.

## Uninstall

```bash
make uninstall
```

**Warning:** This is destructive — it removes the podman image and deletes all cached models in `/var/lib/local-agents`.

## License

MIT
