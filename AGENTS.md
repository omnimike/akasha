# akasha

Repository containing Arch Linux packages that install systemd Quadlet files to run local LLM inference containers via Podman.

The repository is split into three packages:

- `vllm` — builds the `vllm` package for the vLLM inference servers (Qwen3.8, Qwen3.6 and Muse-Glimmer-30B).
- `hermes` — builds the `hermes-agent` package for the Hermes agent gateway and WebUI dashboard.
- `monitor-power` — builds the `monitor-power` package that sleeps the monitor after 1 minute idle and powers it down after 5 minutes idle in multi-user mode, without ever powering off the system.
