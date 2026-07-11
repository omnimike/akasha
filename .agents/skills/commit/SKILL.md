---
name: commit
description: Use when creating git commits to ensure proper commit message prefixes
---

## Commit Message Format

All commit message titles must be prefixed with the subsystem they affect:

- `[vllm]` — changes primarily affecting `vllm-qwen36` folder or its packaging
- `[hermes]` — changes primarily affecting `hermes` folder or its packaging
- `[agents]` — changes primarily affecting `AGENTS.md` files or the `.agents` folder
- `[...]` — changes spanning multiple subsystems with no clear primary focus
