#!/bin/bash

# Function to install Node.js
install_node() {
  local version=$1
  echo "Installing Node.js version $version.x..."
  
  # Remove previous Node.js versions
  sudo apt-get remove -y nodejs

  # Update package index
  sudo apt-get update

  # Add NodeSource PPA for the specific version
  curl -fsSL https://deb.nodesource.com/setup_$version.x | sudo -E bash -

  # Install Node.js
  sudo apt-get install -y nodejs

  echo "Node.js version $version.x installed successfully."
}

# Display menu for version selection
echo "Select the Node.js version to install:"
echo "1) Node.js 14.x"
echo "2) Node.js 16.x"
echo "3) Node.js 18.x"
read -p "Enter your choice (1, 2, or 3): " choice

# Install the selected version
case $choice in
  1)
    install_node 14
    ;;
  2)
    install_node 16
    ;;
  3)
    install_node 18
    ;;
  *)
    echo "Invalid choice. Please run the script again and select a valid option."
    exit 1
    ;;
esac

# Verify installation
echo "Verifying Node.js installation..."
node -v
npm -v

echo "Script execution completed."