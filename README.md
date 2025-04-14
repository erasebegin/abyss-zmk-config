# ZMK Config for The Abyss Keyboard

This repository contains the ZMK configuration for The Abyss keyboard.

## Setup

To set up the ZMK development environment locally:

```bash
chmod +x scripts/setup.sh scripts/build.sh
./scripts/setup.sh
```

This script will:
1. Install necessary dependencies using Homebrew
2. Install and configure West (the Zephyr meta-tool)
3. Initialize and update the ZMK workspace
4. Install required Python dependencies

## Building Firmware

To build the firmware locally, use the build script:

```bash
# Build both halves
./scripts/build.sh

# Build only left half
./scripts/build.sh --left

# Build only right half
./scripts/build.sh --right

# Clean build and rebuild both halves
./scripts/build.sh --clean --all
```

The generated firmware files will be located at:
- Left half: `build/left/zephyr/zmk.uf2`
- Right half: `build/right/zephyr/zmk.uf2`

## Flashing Firmware

To flash the firmware to your keyboard:
1. Connect your Nice!Nano to your computer while holding the RESET button to enter bootloader mode
2. It will appear as a USB drive named NICENANO
3. Copy the appropriate `zmk.uf2` file to the drive
4. The keyboard will automatically reboot with the new firmware

## Keyboard Layout

The Abyss is a split 34-key keyboard with the following features:
- Multiple layers (base, navigation, symbol, number, function)
- Combos for common modifier keys
- Home row mods
- Tap-dance behaviors for Bluetooth profiles
- Sticky keys for improved ergonomics

## Customizing

To customize the keymap, edit the `config/the_abyss.keymap` file. Rebuild the firmware after making changes.