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
        "https://github.com/remsky/Kokoro-FastAPI/releases/download/v0.1.4/config.json"
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
exec uv run --extra $DEVICE --no-sync python -m uvicorn api.src.main:app --host 0.0.0.0 --port 8880 --log-level debug
