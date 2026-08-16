# akasha

Pacman packages for running local LLM inference servers and agents on Arch Linux, managed by systemd via Podman Quadlets.

This repository is split into two packages:
1. **[vllm-qwen3](file:///home/michael/code/akasha/vllm-qwen3)** — runs `vllm/vllm-openai` container for `Qwen/Qwen3.8-27B` on port 8000.
2. **[hermes-agent](file:///home/michael/code/akasha/hermes)** — runs `nousresearch/hermes-agent` gateway and `hermes-webui` dashboard.

See [AGENTS.md](file:///home/michael/code/akasha/AGENTS.md) for detailed package configuration, requirements, and design.

## Installation

### vLLM Server
```bash
cd vllm-qwen3
make install
sudo systemctl enable --now vllm-qwen3.service
```

### Hermes Agent Gateway & WebUI
```bash
cd hermes
make install
sudo hermes install
sudo systemctl enable --now hermes-agent.service hermes-webui.service
```
