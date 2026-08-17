# akasha

Pacman packages for running local LLM inference servers and agents on Arch Linux, managed by systemd via Podman Quadlets.

This repository is split into two packages:
1. **[vllm](file:///home/michael/code/akasha/vllm)** — runs `vllm/vllm-openai` containers for `Qwen/Qwen3.8-27B` on port 8000, `Qwen/Qwen3.6-27B` on port 8002 and `Meta/Muse-Glimmer-30B` on port 8001.
2. **[hermes-agent](file:///home/michael/code/akasha/hermes)** — runs `nousresearch/hermes-agent` gateway and `hermes-webui` dashboard.

See [AGENTS.md](file:///home/michael/code/akasha/AGENTS.md) for detailed package configuration, requirements, and design.

## Installation

### vLLM Servers
```bash
cd vllm
make install
sudo systemctl start vllm-qwen38.service vllm-qwen36.service vllm-muse-glimmer.service
```

The servers do not start at boot by default. To make a server start at every boot, enable its target:

```bash
sudo systemctl enable vllm-qwen38.target    # or vllm-qwen36.target / vllm-muse-glimmer.target
```

### Hermes Agent Gateway & WebUI
```bash
cd hermes
make install
sudo hermes install
sudo systemctl enable --now hermes-agent.service hermes-webui.service
```
