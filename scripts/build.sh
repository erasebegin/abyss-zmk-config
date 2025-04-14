#!/bin/bash
set -e

# Helper script to build ZMK firmware for The Abyss keyboard

# Function to display help message
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -l, --left      Build left half firmware"
    echo "  -r, --right     Build right half firmware"
    echo "  -a, --all       Build both halves (default)"
    echo "  -c, --clean     Clean build directories before building"
    echo "  -h, --help      Show this help message"
}

# Default values
build_left=false
build_right=false
clean_build=false

# Parse arguments
if [ $# -eq 0 ]; then
    build_left=true
    build_right=true
else
    while [ "$1" != "" ]; do
        case $1 in
            -l | --left )   build_left=true
                            ;;
            -r | --right )  build_right=true
                            ;;
            -a | --all )    build_left=true
                            build_right=true
                            ;;
            -c | --clean )  clean_build=true
                            ;;
            -h | --help )   show_help
                            exit
                            ;;
            * )             show_help
                            exit 1
        esac
        shift
    done
fi

# Set directory paths
script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_dir="$(dirname "$script_dir")"
left_build_dir="$repo_dir/build/left"
right_build_dir="$repo_dir/build/right"
build_output_dir="$repo_dir/build-output"

# Create build-output directory if it doesn't exist
mkdir -p "$build_output_dir"

# Clean build directories if requested
if [ "$clean_build" = true ]; then
    echo "Cleaning build directories..."
    [ -d "$left_build_dir" ] && rm -rf "$left_build_dir"
    [ -d "$right_build_dir" ] && rm -rf "$right_build_dir"
fi

# Make sure we're in the repo directory
cd "$repo_dir"

# Build left half
if [ "$build_left" = true ]; then
    echo "Building firmware for left half..."
    west build -d "$left_build_dir" -b nice_nano_v2 -s zmk/app -- -DSHIELD="the_abyss_left nice_view" -DZMK_CONFIG="${repo_dir}/config"
    echo "Left half firmware built at: ${left_build_dir}/zephyr/zmk.uf2"
    
    # Copy firmware to build-output directory
    cp "${left_build_dir}/zephyr/zmk.uf2" "${build_output_dir}/the_abyss_left.uf2"
    echo "Left half firmware copied to: ${build_output_dir}/the_abyss_left.uf2"
fi

# Build right half
if [ "$build_right" = true ]; then
    echo "Building firmware for right half..."
    west build -d "$right_build_dir" -b nice_nano_v2 -s zmk/app -- -DSHIELD="the_abyss_right nice_view" -DZMK_CONFIG="${repo_dir}/config"
    echo "Right half firmware built at: ${right_build_dir}/zephyr/zmk.uf2"
    
    # Copy firmware to build-output directory
    cp "${right_build_dir}/zephyr/zmk.uf2" "${build_output_dir}/the_abyss_right.uf2"
    echo "Right half firmware copied to: ${build_output_dir}/the_abyss_right.uf2"
fi

echo "Build process complete!"