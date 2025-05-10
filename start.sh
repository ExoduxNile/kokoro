#!/bin/bash

# Set environment variables
export USE_GPU=false
export USE_ONNX=false  # Using .pth format instead of ONNX
export PORT=${PORT:-8080}
export MODEL_DIR=models
export VOICES_DIR=api/src/voices/v1_0

# Install dependencies
pip install -r requirements.txt

# Download .pth model from GitHub release
if [ ! -f "models/kokoro-v1_0.pth" ]; then
    mkdir -p models
    echo "Downloading model file..."
    curl -L -o models/kokoro-v1_0.pth \
        "https://objects.githubusercontent.com/github-production-release-asset-2e65be/910061041/182e4328-153b-4ff4-944d-4a6fda3d2d5a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250509%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250509T220525Z&X-Amz-Expires=300&X-Amz-Signature=11c848a00e4e8de20973310d1711a2276963b860ea1cde9503f7bb9db4e6e9a7&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dkokoro-v1_0.pth&response-content-type=application%2Foctet-stream"
fi

# Download config file
if [ ! -f "models/config.json" ]; then
    echo "Downloading config file..."
    curl -L -o models/config.json \
        "https://github.com/remsky/Kokoro-FastAPI/releases/download/v1.4/config.json"
fi

# Verify you have voices files in the voices directory
if [ ! -f "api/src/voices/v1_0" ]; then
    echo "Error: Missing voice files in voices directory" >&2
    exit 1
fi

# Start the server
#!/bin/bash
uvicorn api.src.main:app --host 0.0.0.0 --port ${PORT:-8080}
