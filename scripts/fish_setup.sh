#!/usr/bin/env fish

# Install dependencies for macOS
echo "Installing dependencies for ZMK development on macOS..."

# Check if Homebrew is installed
if not command -v brew > /dev/null
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed, updating..."
    brew update
end

# Install required packages
echo "Installing required packages..."
brew install cmake ninja gperf python3 ccache dtc

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install --user -U west

# Add west to PATH if needed
if not command -v west > /dev/null
    echo "Adding west to PATH..."
    echo 'set -x PATH $HOME/Library/Python/3.9/bin $PATH' >> ~/.config/fish/config.fish
    source ~/.config/fish/config.fish
end

# Initialize the ZMK workspace
echo "Initializing ZMK workspace..."
cd (dirname (status filename))/..
west init -l config
west update

# Build and install Python dependencies
echo "Installing ZMK Python dependencies..."
pip3 install --user -r zephyr/scripts/requirements.txt

echo "Setup complete! You can now build your firmware with:"
echo "./scripts/fish_build.sh"