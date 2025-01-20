#!/bin/bash

# Install required package (inotify-tools) if not installed
if ! command -v inotifywait &>/dev/null; then
    echo "Installing inotify-tools..."
    sudo apt update && sudo apt install -y inotify-tools
fi

# Define the directory to organize. Default to the current directory.
DIR=${1:-.}

# Define file type extensions and their corresponding folder names.
declare -A file_types
file_types=(
    ["Documents"]="doc docx pdf txt"
    ["Images"]="jpg jpeg png gif"
    ["Videos"]="mp4 avi mov"
    ["Music"]="mp3 wav flac"
    ["Archives"]="zip tar gz bz2"
)

# Function to organize files
organize_files() {
    for folder in "${!file_types[@]}"; do
        mkdir -p "$DIR/$folder"
        extensions=${file_types[$folder]}
        for ext in $extensions; do
            mv -v "$DIR"/*.$ext "$DIR/$folder" 2>/dev/null
        done
    done

    mkdir -p "$DIR/Others"
    for file in "$DIR"/*; do
        if [[ -f "$file" ]]; then
            mv -v "$file" "$DIR/Others" 2>/dev/null
        fi
    done
    echo "File organization completed."
}

# Initial organization
organize_files

# Monitor directory for new files and organize them
echo "Monitoring $DIR for new files..."
inotifywait -m -e create,moved_to "$DIR" --format "%f" | while read FILE; do
    echo "New file detected: $FILE"
    organize_files
done
