#!/bin/bash

# Function to check if a user exists
user_exists() {
  id "$1" &>/dev/null
}

# Function to check if Docker is installed
docker_installed() {
  docker --version &>/dev/null
}

# Function to check if Docker Compose is installed
docker_compose_installed() {
  docker-compose --version &>/dev/null
}

# Variables
USER_NAME="docker-main"
DOCKER_COMPOSE_VERSION="1.29.2"

# Create docker-main user if it doesn't exist
if user_exists "$USER_NAME"; then
  echo "User $USER_NAME already exists. Skipping user creation."
else
  echo "Creating user $USER_NAME..."
  sudo adduser --gecos "" --disabled-password "$USER_NAME"
  echo "$USER_NAME:password" | sudo chpasswd
  sudo usermod -aG docker "$USER_NAME"
fi

# Install Docker if it is not installed
if docker_installed; then
  echo "Docker is already installed. Skipping Docker installation."
else
  echo "Installing Docker..."
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker "$USER_NAME"
fi

# Install Docker Compose if it is not installed
if docker_compose_installed; then
  echo "Docker Compose is already installed. Skipping Docker Compose installation."
else
  echo "Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# Print completion message
echo "Setup completed successfully."
echo "Powered by Chito Systems"
