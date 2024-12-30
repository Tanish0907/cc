#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Define the ISO URL and the output file name
ISO_URL="https://releases.ubuntu.com/jammy/ubuntu-22.04.5-desktop-amd64.iso"
ISO_NAME="ubuntu-22.04.5-desktop-amd64.iso"

# Download the Ubuntu 22.04 ISO
if [ ! -f "$ISO_NAME" ]; then
    echo "Downloading Ubuntu 22.04 ISO..."
    wget -O "$ISO_NAME" "$ISO_URL"
else
    echo "ISO file already exists. Skipping download."
fi

# Install required packages for KVM
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y

# Add the current user to the KVM group
sudo usermod -aG kvm $USER

# Create a virtual hard drive
VM_DISK="ubuntu.qcow2"
DISK_SIZE="30G"
if [ ! -f "$VM_DISK" ]; then
    echo "Creating a virtual hard disk..."
    qemu-img create -f qcow2 "$VM_DISK" "$DISK_SIZE"
else
    echo "Virtual disk already exists. Skipping creation."
fi

# Run the virtual machine
echo "Starting the virtual machine..."
qemu-system-x86_64 -accel kvm -vga virtio -m 8G -smp 4 -drive file="$VM_DISK",format=qcow2 -cdrom "$ISO_NAME" -boot d