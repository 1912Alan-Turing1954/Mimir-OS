#!/bin/bash

# Function to get the latest NVIDIA driver version
get_latest_nvidia_version() {
    curl -s https://www.nvidia.com/Download/Find.aspx?lang=en&type=Quadro | grep -oP 'data-v="([^"]+)"' | head -n 1 | sed 's/data-v=//'
}

# Function to get the latest Proton version
get_latest_proton_version() {
    curl -s https://github.com/ValveSoftware/Proton/releases/latest | grep -oP 'tag/([^\"]+)' | cut -d '/' -f 2
}

# Function to get the latest stable Wine version
get_latest_wine_version() {
    curl -s https://api.github.com/repos/wine/wine/releases/latest | jq -r '.tag_name'
}

# Update and upgrade system
sudo apt update
sudo apt upgrade -y

# Add non-free repository
echo "deb http://deb.debian.org/debian/ $(lsb_release -cs) main contrib non-free" | sudo tee -a /etc/apt/sources.list

# Install kernel headers
sudo apt install -y linux-headers-$(uname -r)

# Get the latest NVIDIA driver version
NVIDIA_VERSION=$(get_latest_nvidia_version)

# Download NVIDIA driver
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run

# Make the downloaded file executable
chmod +x NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run

# Run the NVIDIA installer
sudo ./NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run

# Reboot
sudo reboot

# Install Steam
sudo apt install -y steam

# Get the latest Proton version
PROTON_VERSION=$(get_latest_proton_version)

# Install Proton
mkdir -p ~/.steam/root/compatibilitytools.d
wget https://github.com/ValveSoftware/Proton/releases/download/proton-${PROTON_VERSION}/proton-${PROTON_VERSION}.tar.gz -P ~/.steam/root/compatibilitytools.d
tar xf ~/.steam/root/compatibilitytools.d/proton-${PROTON_VERSION}.tar.gz -C ~/.steam/root/compatibilitytools.d/

echo "Proton ${PROTON_VERSION} installed. You can select it in Steam settings for specific games."

# Get the latest stable Wine version
WINE_VERSION=$(get_latest_wine_version)

# Install Wine
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine64 wine32 winetricks=${WINE_VERSION}-*

# Install additional Wine dependencies or tools based on Nobara requirements
# Example: Install Mono and Gecko
winetricks --force dotnet40
winetricks --force gecko

# Download and install other software used by Nobara (replace URLs)
wget http://example.com/software/nobara_tool1.tar.gz
tar xf nobara_tool1.tar.gz -C /opt/nobara_tool1

# ... Repeat for other necessary tools ...

echo "Nobara tools installed. Make sure to configure Wine and other components as required."
