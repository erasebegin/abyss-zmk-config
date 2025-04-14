#!/bin/bash
set -e

# Install dependencies for macOS
echo "Installing dependencies for ZMK development on macOS..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed, updating..."
    brew update
fi

# Install required packages
echo "Installing required packages..."
brew install cmake ninja gperf python3 ccache dtc

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install --user -U west

# Add west to PATH if needed
if ! command -v west &> /dev/null; then
    echo "Adding west to PATH..."
    echo 'export PATH="$HOME/Library/Python/3.9/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
fi

# Initialize the ZMK workspace
echo "Initializing ZMK workspace..."
cd "$(dirname "$0")/.."
west init -l config
west update

# Build and install Python dependencies
echo "Installing ZMK Python dependencies..."
pip3 install --user -r zephyr/scripts/requirements.txt

echo "Setup complete! You can now build your firmware with:"
echo "./scripts/build.sh"