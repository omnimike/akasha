#!/bin/bash
# Build the container image (downloads the model during build if not already cached in build context/layers)
echo "Building the container image vllm-qwen36..."
podman build -t vllm-qwen36:latest .

echo "Starting the container..."
podman run --rm -it --name vllm-qwen36 \
 --device nvidia.com/gpu=all \
 --ipc=host \
 -p 8000:8000 \
 vllm-qwen36:latest
