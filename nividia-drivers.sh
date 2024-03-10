#!/bin/bash

# Update and upgrade system
sudo apt update
sudo apt upgrade -y

# Add non-free repository
echo "deb http://deb.debian.org/debian/ $(lsb_release -cs) main contrib non-free" | sudo tee -a /etc/apt/sources.list

# Install kernel headers
sudo apt install -y linux-headers-$(uname -r)

# Download NVIDIA driver (replace <version> with the actual version)
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/<version>/NVIDIA-Linux-x86_64-<version>.run

# Make the downloaded file executable
chmod +x NVIDIA-Linux-x86_64-<version>.run

# Run the NVIDIA installer
sudo ./NVIDIA-Linux-x86_64-<version>.run

# Reboot
sudo reboot
