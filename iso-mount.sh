#!/bin/bash
# 1.
# Get the current stable version of Debian
DEBIAN_VERSION=$(curl -sL https://www.debian.org/ | grep -oP 'Stable[^<]+' | awk '{print $2}')

# Download the netinst ISO for the current stable version to /mnt
curl -o "/mnt/debian-$DEBIAN_VERSION-amd64-netinst.iso" "https://cdimage.debian.org/debian-cd/$DEBIAN_VERSION/amd64/iso-cd/debian-$DEBIAN_VERSION-amd64-netinst.iso"

# 2.
cd /mnt

sudo apt-get install debootstrap squashfs-tools genisoimage

# 3.
mkdir iso_mount
sudo mount -o loop debian-$DEBIAN_VERSION-amd64-netinst.iso iso_mount 

# 4.
sudo mkdir -p iso-mount/proc
sudo mkdir -p iso-mount/sys
sudo mkdir -p iso-mount/dev
sudo mkdir -p iso-mount/dev/pts

# 5.
sudo mount --bind / iso-mount

# 6.
sudo mount -t proc none iso-mount/proc
sudo mount -o bind /sys iso-mount/sys
sudo mount -o bind /dev iso-mount/dev
sudo mount -o bind /dev/pts iso-mount/dev/pts

# 7.
mkdir custom_debian
cp -r iso_mount/* custom_debian

# 8.
sudo chroot ~/custom_debian
sudo apt update -y
