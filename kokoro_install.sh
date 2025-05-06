#!/bin/bash
# deploy_kokoro.sh: Script to set up Kokoro-FastAPI and download models on Choreo

set -e  # Exit on error

echo "Starting Kokoro-FastAPI deployment setup..."

# Install system dependencies
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y espeak-ng git-lfs

# Initialize git-lfs
echo "Initializing git-lfs..."
git lfs install

# Install Poetry
echo "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH
export PATH="$HOME/.local/bin:$PATH"

# Create and activate Python virtual environment with Poetry
echo "Setting up Python virtual environment with Poetry..."
poetry env use 3.10
poetry install --only main  # Install only production dependencies

# Download Kokoro models and voices
echo "Running download-model script to download models and voices..."
poetry run download_model --output api/src/models/v1_0

echo "Deployment setup complete!"
