#!/bin/bash

# Install required package (inotify-tools) if not installed
if ! command -v inotifywait &>/dev/null; then
    echo "Installing inotify-tools..."
    sudo apt update && sudo apt install -y inotify-tools
fi

# Define the directory to organize. Default to the current directory.
DIR=${1:-.}

# Enable nullglob to avoid errors when no files match
shopt -s nullglob nocaseglob

# Define file type extensions and their corresponding folder names.
declare -A file_types
file_types=(
    ["Documents"]="doc docx pdf txt"
    ["Images"]="jpg jpeg png gif"
    ["Videos"]="mp4 avi mov"
    ["Music"]="mp3 wav flac"
    ["Archives"]="zip tar gz bz2"
)

# Function to organize a single file
organize_file() {
    local file="$1"
    local ext="${file##*.}"  # Extract the file extension
    ext="${ext,,}"  # Convert to lowercase

    for folder in "${!file_types[@]}"; do
        for valid_ext in ${file_types[$folder]}; do
            if [[ "$ext" == "$valid_ext" ]]; then
                mkdir -p "$DIR/$folder"
                mv -v "$file" "$DIR/$folder/" 2>/dev/null
                return
            fi
        done
    done

    # If no match, move to "Others"
    mkdir -p "$DIR/Others"
    mv -v "$file" "$DIR/Others/" 2>/dev/null
}

# Initial organization
for file in "$DIR"/*; do
    [[ -f "$file" ]] && organize_file "$file"
done
echo "Initial file organization completed."

# Monitor directory for new files and organize them
echo "Monitoring $DIR for new files..."
inotifywait -m -e create,moved_to --format "%w%f" "$DIR" | while read file; do
    [[ -f "$file" ]] && organize_file "$file"
done
