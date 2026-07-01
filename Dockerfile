FROM docker.io/vllm/vllm-openai:latest

# Download the model during the image build process
RUN python3 -c "from huggingface_hub import snapshot_download; snapshot_download('Qwen/Qwen3.6-27B-FP8')"

# Do not talk to the internet on startup
ENV HF_HUB_OFFLINE=1
ENV TORCH_DISTRIBUTED_DEBUG=OFF
ENV TORCH_HUB_OFFLINE=1
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
