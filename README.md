# akasha

Pacman packages for running local LLM inference servers and agents on Arch Linux, managed by systemd via Podman Quadlets.

This repository is split into three packages:
1. **[vllm](file:///home/michael/code/akasha/vllm)** — runs `vllm/vllm-openai` containers for `Qwen/Qwen3.8-27B` on port 8000, `Qwen/Qwen3.6-27B` on port 8002 and `Meta/Muse-Glimmer-30B` on port 8001.
2. **[hermes-agent](file:///home/michael/code/akasha/hermes)** — runs `nousresearch/hermes-agent` gateway and `hermes-webui` dashboard.
3. **[monitor-power](file:///home/michael/code/akasha/monitor-power)** — sleeps the monitor after 1 minute idle and powers it down after 5 minutes idle in multi-user mode; the system stays running.

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

### Monitor Power Saving
```bash
cd monitor-power
make install
sudo systemctl enable --now monitor-power.target
```

The monitor does not sleep at boot by default. Once the target is enabled, the monitor sleeps after 1 minute without console activity and powers down after 5 minutes idle; the system itself never powers off.
