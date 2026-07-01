#!/bin/bash
# Build the container image (downloads the model during build if not already cached in build context/layers)
echo "Building the container image vllm-qwen36..."
podman build -t vllm-qwen36:latest .
