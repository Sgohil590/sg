#!/bin/bash

# Prompt for the username
read -p "Enter the new username: " USERNAME

# Prompt for the password and hide input
read -s -p "Enter the password for $USERNAME: " PASSWORD
echo

# Create the new user
useradd -m -s /bin/bash "$USERNAME"

# Set the password for the new user
echo "$USERNAME:$PASSWORD" | chpasswd

# Add the new user to the sudo group
usermod -aG sudo "$USERNAME"

# Print a message indicating the user has been created
echo "User $USERNAME created and added to the sudo group with root privileges."

# Edit the sshd_config file to set PasswordAuthentication to yes
SSHD_CONFIG="/etc/ssh/sshd_config"
SSHD_CONFIG_D="/etc/ssh/sshd_config.d"

# Backup the original sshd_config file
cp $SSHD_CONFIG "${SSHD_CONFIG}.bak"

# Check if PasswordAuthentication is already set, if not set it to yes
if grep -q "^PasswordAuthentication" $SSHD_CONFIG; then
    sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' $SSHD_CONFIG
else
    echo "PasswordAuthentication yes" >> $SSHD_CONFIG
fi

# Check if sshd_config.d directory exists and edit the files
if [ -d "$SSHD_CONFIG_D" ]; then
    for file in $SSHD_CONFIG_D/*; do
        # Backup the original files
        cp $file "${file}.bak"

        # Check if PasswordAuthentication is already set, if not set it to yes
        if grep -q "^PasswordAuthentication" $file; then
            sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' $file
        else
            echo "PasswordAuthentication yes" >> $file
        fi
    done
fi

# Restart the SSH service to apply changes
systemctl restart ssh

echo "Password authentication has been enabled in SSH configuration."