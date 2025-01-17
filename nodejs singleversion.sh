#!/bin/bashS

# Function to install nvm
install_nvm() {
  echo "Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Check if nvm is installed
if ! command -v nvm &> /dev/null
then
  install_nvm
else
  echo "NVM is already installed."
fi

# Load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Function to install Node.js
install_node() {
  local version=$1
  echo "Installing Node.js version $version..."
  nvm install $version
  nvm alias default $version
  echo "Node.js version $version installed successfully."
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

# Verify installations
echo "Verifying Node.js installations..."
nvm list

echo "Script execution completed."