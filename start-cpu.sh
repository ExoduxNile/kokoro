#!/bin/bash
set -euo pipefail  # Enable strict mode

# Set environment variables
export USE_GPU=false
export USE_ONNX=false
export PORT=${PORT}  # Cloud Run provides $PORT automatically
export PYTHONPATH=$(pwd):$(pwd)/api
export MODEL_DIR=api/src/models/v1_0
export VOICES_DIR=api/src/voices/v1_0
export ESPEAK_DATA_PATH=${ESPEAK_DATA_PATH:-/usr/lib/x86_64-linux-gnu/espeak-ng-data}

# Install dependencies
pip install --no-cache-dir -e ".[cpu]"

# Download model (ensure directory exists)
mkdir -p "$MODEL_DIR"
python -m docker.scripts.download_model --output "$MODEL_DIR"

# Start server
exec uvicorn api.src.main:app --host 0.0.0.0 --port "$PORT"
