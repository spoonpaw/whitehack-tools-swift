#!/bin/bash

# Directory containing the original icon
ASSETS_DIR="Whitehack Tools/Assets.xcassets/AppIcon.appiconset"
ORIGINAL_ICON="$ASSETS_DIR/white_hack_tools.png"

# Create resized versions for each required size
sizes=(16 32 128 256 512)

for size in "${sizes[@]}"; do
    # Generate 1x version
    sips -z $size $size "$ORIGINAL_ICON" --out "$ASSETS_DIR/icon_${size}x${size}.png"
    
    # Generate 2x version (including 512x512@2x)
    double_size=$((size * 2))
    sips -z $double_size $double_size "$ORIGINAL_ICON" --out "$ASSETS_DIR/icon_${size}x${size}@2x.png"
done

# Clean up any 64x64 icons if they exist
rm -f "$ASSETS_DIR/icon_64x64.png" "$ASSETS_DIR/icon_64x64@2x.png"

echo "Icon generation complete!"
