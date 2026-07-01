FROM docker.io/vllm/vllm-openai:latest

# Download the model during the image build process
RUN python3 -c "from huggingface_hub import snapshot_download; snapshot_download('Qwen/Qwen3.6-27B-FP8')"

# Runtime-configurable environment variables
ENV VLLM_USE_DEEP_GEMM=0
ENV VLLM_TENSOR_PARALLEL_SIZE=1
ENV VLLM_MAX_MODEL_LEN=262144
ENV VLLM_ATTENTION_BACKEND=TRITON_ATTN
ENV VLLM_GPU_MEMORY_UTILIZATION=0.85

CMD [ \
  "--model", "Qwen/Qwen3.6-27B-FP8", \
  "--max-model-len", "262144", \
  "--speculative-config", "{\"method\": \"mtp\", \"num_speculative_tokens\": 2}", \
  "--enable-prefix-caching", \
  "--enable-auto-tool-choice", \
  "--tool-call-parser", "qwen3_coder", \
  "--reasoning-parser", "qwen3", \
  "--max-num-seqs", "32" \
  ]
