#!/bin/bash

# Set variables
BBOX=${1:-""} # No default bounding box
THEME=${2:-"all"} # Default to extract all themes if no theme is provided
OUTPUT_PATH=${3:-"."}

# Function to download, validate, and convert data
download_and_convert() {
    local theme=$1
    local output_file="$OUTPUT_PATH/$theme.parquet"

    # Download data
    if [ -n "$BBOX" ]; then
        echo "Downloading $theme data within the specified bounding box..."
        overturemaps download -f geoparquet --type="$theme" --bbox "$BBOX" -o "$output_file"
    else
        echo "Downloading $theme data for the entire dataset..."
        overturemaps download -f geoparquet --type="$theme" -o "$output_file"
    fi

    # Validate GeoParquet file
    echo "Validating $theme GeoParquet file..."
    gpq validate "$output_file"
    if [ $? -ne 0 ]; then
        echo "Error: GeoParquet validation failed for $theme. Skipping PMTiles conversion."
        return
    fi

    # Convert to PMTiles
    echo "Converting $theme data to MBtiles format..."
    ogr2ogr -f 'mbtiles' "$OUTPUT_PATH/$theme.mbtiles" "$output_file" -progress
    echo "Converting $theme data to PMtiles format ..."
    pmtiles convert "$OUTPUT_PATH/$theme.mbtiles" "$OUTPUT_PATH/$theme.pmtiles"
    echo "Done processing $theme data."
}

# Call the download_and_convert function for specified theme or all themes
echo "Starting data download and conversion..."

if [ "$THEME" == "all" ]; then
    for theme in $(overturemaps download --help | grep -o 'type=[a-z]*' | cut -d'=' -f2); do
        download_and_convert "$theme"
    done
else
    download_and_convert "$THEME"
fi

echo "Data download and conversion completed."