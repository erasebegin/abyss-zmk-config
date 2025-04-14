#!/usr/bin/env fish

# Helper functions for flashing The Abyss keyboard firmware

function flash_abyss_left
    echo "Flashing left half of The Abyss keyboard..."
    cp build/left/zephyr/zmk.uf2 /Volumes/NICENANO/
    echo "Done! Left half flashed successfully."
end

function flash_abyss_right
    echo "Flashing right half of The Abyss keyboard..."
    cp build/right/zephyr/zmk.uf2 /Volumes/NICENANO/
    echo "Done! Right half flashed successfully."
end