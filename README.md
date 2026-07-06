# local-agents

Pacman packages for running local LLM inference servers and agents on Arch Linux, managed by systemd via Podman Quadlets.

This repository is split into two packages:
1. **[vllm-qwen36](file:///home/michael/code/local-agents/vllm)** — runs `vllm/vllm-openai` container for `Qwen3.6-27B-FP8` on port 8000.
2. **[hermes-agent](file:///home/michael/code/local-agents/hermes)** — runs `nousresearch/hermes-agent` gateway and `hermes-webui` dashboard.

See [AGENTS.md](file:///home/michael/code/local-agents/AGENTS.md) for detailed package configuration, requirements, and design.

## Installation

### vLLM Server
```bash
cd vllm
make install
sudo systemctl enable --now vllm-qwen36.service
```

### Hermes Agent Gateway & WebUI
```bash
cd hermes
make install
sudo hermes-agent-setup
sudo systemctl enable --now hermes-agent.service hermes-webui.service
```
