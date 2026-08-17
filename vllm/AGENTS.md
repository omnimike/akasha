# vllm

Arch package that installs three systemd Quadlet files to run vLLM inference containers via Podman.

## Structure

- `PKGBUILD` — Arch package definition
- `Makefile` — thin wrapper around `makepkg`
- `vllm-qwen38.container` — Podman Quadlet for vLLM serving `Qwen/Qwen3.8-27B-FP8` on port 8000
- `vllm-qwen36.container` — Podman Quadlet for vLLM serving `Qwen/Qwen3.6-27B-FP8` on port 8002
- `vllm-muse-glimmer.container` — Podman Quadlet for vLLM serving `RedHatAI/Muse-Glimmer-30B-FP8-block` on port 8001
- `vllm-qwen38.target`, `vllm-qwen36.target`, `vllm-muse-glimmer.target` — systemd targets that toggle boot-start for the matching container (`Wants=`/`After=` on the service); the container `PartOf=` its target, so starting/stopping the target starts/stops the container. Disabled by default, so nothing starts at boot until one is enabled
- `nvidia-cdi.service` — oneshot systemd service that regenerates `/etc/cdi/nvidia.yaml` via `nvidia-ctk cdi generate`; all containers `Requires=` it, so it runs once per boot before any of them start
- `vllm.install` — pacman hooks: `daemon-reload` on install/upgrade, cleanup on remove
- `sysusers.vllm` — systemd-sysusers config for the non-root `vllm` user
- `pkg/` — built package output

## How it runs

Navigate to `vllm/` and run `make install`. The containers do not start at boot by default — start/stop them manually:

```bash
sudo systemctl start vllm-qwen38.service vllm-qwen36.service vllm-muse-glimmer.service
sudo systemctl stop vllm-qwen38.service
```

To make a server start at every boot, enable its matching target (disabled by default):

```bash
sudo systemctl enable vllm-qwen38.target    # add --now to also start it now
sudo systemctl disable vllm-qwen38.target   # add --now to also stop it now
```

Starting/stopping a target starts/stops its container. This creates `vllm-qwen38.service`, `vllm-qwen36.service` and `vllm-muse-glimmer.service` via Quadlet, pulling the `vllm/vllm-openai:latest` and `vllm/vllm-openai:muse-glimmer` images and mounting `/var/lib/vllm/qwen38`, `/var/lib/vllm/qwen36` and `/var/lib/vllm/muse-glimmer` as the HuggingFace caches. The containers listen on `localhost:8000`, `localhost:8002` and `localhost:8001` respectively, each with an OpenAI-compatible API.

## Key details

- All containers run as the non-root `vllm` user (UID 2000, GID 0)
- Model caches live at `/var/lib/vllm/qwen38`, `/var/lib/vllm/qwen36` and `/var/lib/vllm/muse-glimmer`
- Uninstalling via `make uninstall` deletes all caches and removes the podman images
- GPU access requires `nvidia-container-toolkit`
- All containers depend on `nvidia-cdi.service` (pulled in automatically as a `Requires=` dependency, no need to enable it directly); regenerate the CDI spec manually with `sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml` if the spec goes stale (e.g. after a driver reload)

## Qwen3.8 notes

- FP8 weights with FP8 KV cache, 256K context, MTP speculative decoding (x3), FlashInfer GDN prefill, async scheduling
- `qwen3_coder` tool-call parser, `qwen3` reasoning parser

## Qwen3.6 notes

- Served with the same flags as Qwen3.8 (FP8 KV cache, MTP x3, FlashInfer GDN prefill, async scheduling)
- `qwen3_coder` tool-call parser, `qwen3` reasoning parser

## Glimmer 30B notes (from https://recipes.vllm.ai/meta-models/Muse-Glimmer-30B)

- Dense 29.6B vision-language model (ViT-G/14 encoder), 128K context, BF16 reference. Served here as FP8 block-scaled weights
- Requires the dedicated `muse_glimmer` tool-call and reasoning parsers, which key off ATEM/XML channel framing rather than JSON or `think` tags; the image tag `muse-glimmer` (vLLM 0.27.0+) is required — do not switch to `:latest`
- `--reasoning-parser muse_glimmer` forces `skip_special_tokens=False`
- Do not run greedy: use `temperature 1.0`, `top_p 0.95`, `top_k 64` in requests
- Set reasoning effort per-request with a `Reasoning strength: low|medium|high|xhigh` line in the system prompt; use `high`/`xhigh` for coding and agentic tasks
- Speculative decoding uses the DFlash draft head `meta-models/Muse-Glimmer-30B-assistant` with a fixed `num_speculative_tokens 15`
- The first start downloads the ~33 GB FP8 model plus the ~5 GB DFlash draft head
