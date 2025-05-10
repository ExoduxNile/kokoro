#!/bin/bash

# Set environment variables
export USE_GPU=false
export USE_ONNX=false  # Using .pth format instead of ONNX
export PORT=${PORT:-8080}
export MODEL_DIR=api/src/models/v1_0
export VOICES_DIR=api/src/voices/v1_0

# Install dependencies
pip install -r requirements.txt

# Download config file
if [ ! -f "api/src/models/v1_0/config.json" ]; then
    echo "Downloading config file..."
    curl -L -o api/src/models/v1_0/config.json \
        "https://github.com/remsky/Kokoro-FastAPI/releases/download/v0.1.4/kokoro-v1_0.pth"
fi

# Verify you have voices files in the voices directory
if [ ! -f "api/src/voices/v1_0" ]; then
    echo "Error: Missing voice files in voices directory" >&2
    exit 1
fi

# Start the server
#!/bin/bash
exec uvicorn api.src.main:app --host 0.0.0.0 --port $PORT
