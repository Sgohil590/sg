#!/bin/bash

# Define the username and password
USERNAME="newuser"
PASSWORD="password"

# Create the new user
useradd -m -s /bin/bash "$USERNAME"

# Set the password for the new user
echo "$USERNAME:$PASSWORD" | chpasswd

# Add the new user to the sudo group
usermod -aG sudo "$USERNAME"

# Print a message indicating the user has been created
echo "User $USERNAME created and added to the sudo group with root privileges."
# This task is done.
# 