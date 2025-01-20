#!/bin/bash
# Source directory to back up
SOURCE_DIR="/mnt/data"
# Destination directory for backups
BACKUP_DIR="/mnt/backup"
# File to store the hash of the directory contents
HASH_FILE="/mnt/backup/hashfile"

# Function to calculate the hash of the directory contents
calculate_hash() {
    find "$SOURCE_DIR" -type f -exec md5sum {} \; | md5sum | awk '{print $1}'
}

# Calculate the current hash of the directory
current_hash=$(calculate_hash)

# Check if the hash file exists
if [ -f "$HASH_FILE" ]; then
    # Read the previous hash from the file
    previous_hash=$(cat "$HASH_FILE")
else
    # If the hash file doesn't exist, initialize the previous hash to an empty string
    previous_hash=""
fi

# Compare the current hash with the previous hash
if [ "$current_hash" != "$previous_hash" ]; then
    # If the hashes are different, create a backup
    timestamp=$(date +"%Y%m%d%H%M%S")
    backup_name="backup-$timestamp.tar.gz"
    tar -czf "$BACKUP_DIR/$backup_name" -C "$SOURCE_DIR" .

    # Store the current hash in the hash file
    echo "$current_hash" > "$HASH_FILE"

    echo "Backup created: $backup_name"
else
    echo "No changes detected. No backup created."
fi