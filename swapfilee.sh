#!/bin/sh

LOGFILE="swapmanager_$(date +'%Y%m%d_%H%M%S').txt"

# Function to log output
log() {
    echo "$1" | tee -a "$LOGFILE"
}

# Function to display current memory and swap usage
display_memory_usage() {
    log "Current memory and swap usage:"
    free -h | tee -a "$LOGFILE"
}

# Function to create a swap file
create_swapfile() {
    local swapsize=$1
    log "Creating a swapfile of size ${swapsize}M."
    fallocate -l ${swapsize}M /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap defaults 0 0' >> /etc/fstab
    log "Swapfile created and activated."
}

# Function to modify the existing swap file
modify_swapfile() {
    local newsize=$1
    log "Modifying swapfile to size ${newsize}M."
    swapoff /swapfile
    fallocate -l ${newsize}M /swapfile
    mkswap /swapfile
    swapon /swapfile
    log "Swapfile modified and reactivated."
}

# Start logging
log "======== Swap Manager Script Started: $(date) ========"

# Display current memory and swap usage
display_memory_usage

# Check if a swap file already exists
grep -q "swapfile" /etc/fstab
if [ $? -eq 0 ]; then
    log "Swapfile found."
    # Prompt user to modify the swap file
    read -p "Do you want to modify the existing swapfile? (y/n): " modify
    if [ "$modify" = "y" ]; then
        read -p "Enter the new size of the swapfile in megabytes: " newsize
        if ! [ "$newsize" -eq "$newsize" ] 2>/dev/null; then
            log "Invalid size. Please enter a valid number."
            exit 1
        fi
        modify_swapfile $newsize
    else
        log "No changes made to the swapfile."
    fi
else
    log "Swapfile not found."
    read -p "Enter the size of the swapfile in megabytes: " swapsize
    if ! [ "$swapsize" -eq "$swapsize" ] 2>/dev/null; then
        log "Invalid size. Please enter a valid number."
        exit 1
    fi
    create_swapfile $swapsize
fi

# Output updated swap details
log "Updated Swap Details:"
cat /proc/swaps | tee -a "$LOGFILE"
cat /proc/meminfo | grep Swap | tee -a "$LOGFILE"

log "======== Swap Manager Script Completed: $(date) ========