#!/bin/bash

# Prompt for the username
read -p "Enter the new username: " USERNAME

# Prompt for the password and hide input
read -s -p "Enter the password for $USERNAME: " PASSWORD
echo

# Create the new user with /var/www/html as their home directory
useradd -m -d /var/www/html -s /bin/bash "$USERNAME"

# Set the password for the new user
echo "$USERNAME:$PASSWORD" | chpasswd

# Step 3: Set permissions to allow the user access to /var/www/html only
if [ ! -d /var/www/html ]; then
    mkdir -p /var/www/html
    echo "/var/www/html directory created."
else
    echo "/var/www/html directory already exists."
fi

chown $USERNAME:$USERNAME /var/www/html
chmod 700 /var/www/html
echo "Permissions set for /var/www/html."

# Create a restricted shell script
cat << 'EOF' > /usr/local/bin/restricted_shell.sh
#!/bin/bash
if [[ $PWD != /var/www/html* ]]; then
  echo "Access denied. You can only access /var/www/html."
  exit 1
fi
exec /bin/bash
EOF

# Make the script executable
chmod +x /usr/local/bin/restricted_shell.sh

# Set the user's shell to the restricted shell script
chsh -s /usr/local/bin/restricted_shell.sh $USERNAME

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

echo "Password authentication has been enabled in SSH configuration"