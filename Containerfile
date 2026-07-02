FROM docker.io/vllm/vllm-openai:latest

# We are going to download the model file on the first startup
# ENV HF_HUB_OFFLINE=1
# ENV TORCH_HUB_OFFLINE=1

# Do not talk to the internet
ENV TORCH_DISTRIBUTED_DEBUG=OFF
ENV VLLM_NO_USAGE_STATS=1
ENV DO_NOT_TRACK=1

# Runtime-configurable environment variables (no CLI equivalent)
ENV VLLM_USE_DEEP_GEMM=0

CMD [ \
  "--model", "Qwen/Qwen3.6-27B-FP8", \
  "--max-model-len", "262144", \
  "--gpu-memory-utilization", "0.8", \
  "--speculative-config", "{\"method\": \"mtp\", \"num_speculative_tokens\": 2}", \
  "--enable-prefix-caching", \
  "--enable-auto-tool-choice", \
  "--tool-call-parser", "qwen3_coder", \
  "--reasoning-parser", "qwen3", \
  "--max-num-seqs", "32" \
  ]
