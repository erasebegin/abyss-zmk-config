#!/usr/bin/env fish

# Helper script to build ZMK firmware for The Abyss keyboard (Fish Shell version)

# Function to display help message
function show_help
    echo "Usage: $argv[0] [options]"
    echo ""
    echo "Options:"
    echo "  -l, --left      Build left half firmware"
    echo "  -r, --right     Build right half firmware"
    echo "  -a, --all       Build both halves (default)"
    echo "  -c, --clean     Clean build directories before building"
    echo "  -h, --help      Show this help message"
end

# Default values
set build_left false
set build_right false
set clean_build false

# Parse arguments
if test (count $argv) -eq 0
    set build_left true
    set build_right true
else
    set i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -l --left
                set build_left true
            case -r --right
                set build_right true
            case -a --all
                set build_left true
                set build_right true
            case -c --clean
                set clean_build true
            case -h --help
                show_help
                exit 0
            case '*'
                show_help
                exit 1
        end
        set i (math $i + 1)
    end
end

# Set directory paths
set script_dir (dirname (status filename))
set repo_dir (dirname $script_dir)
set left_build_dir "$repo_dir/build/left"
set right_build_dir "$repo_dir/build/right"
set build_output_dir "$repo_dir/build-output"

# Create build-output directory if it doesn't exist
mkdir -p "$build_output_dir"

# Clean build directories if requested
if test "$clean_build" = true
    echo "Cleaning build directories..."
    if test -d "$left_build_dir"
        rm -rf "$left_build_dir"
    end
    if test -d "$right_build_dir"
        rm -rf "$right_build_dir"
    end
end

# Make sure we're in the repo directory
cd "$repo_dir"

# Build left half
if test "$build_left" = true
    echo "Building firmware for left half..."
    west build -d "$left_build_dir" -b nice_nano_v2 -s zmk/app -- -DSHIELD="the_abyss_left nice_view" -DZMK_CONFIG="$repo_dir/config"
    echo "Left half firmware built at: $left_build_dir/zephyr/zmk.uf2"
    
    # Copy firmware to build-output directory
    cp "$left_build_dir/zephyr/zmk.uf2" "$build_output_dir/the_abyss_left.uf2"
    echo "Left half firmware copied to: $build_output_dir/the_abyss_left.uf2"
end

# Build right half
if test "$build_right" = true
    echo "Building firmware for right half..."
    west build -d "$right_build_dir" -b nice_nano_v2 -s zmk/app -- -DSHIELD="the_abyss_right nice_view" -DZMK_CONFIG="$repo_dir/config"
    echo "Right half firmware built at: $right_build_dir/zephyr/zmk.uf2"
    
    # Copy firmware to build-output directory
    cp "$right_build_dir/zephyr/zmk.uf2" "$build_output_dir/the_abyss_right.uf2"
    echo "Right half firmware copied to: $build_output_dir/the_abyss_right.uf2"
end

echo "Build process complete!"