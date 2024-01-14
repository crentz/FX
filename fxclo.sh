#!/bin/bash

# Set strict mode
set -euo pipefail

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Set the default ISO and system names
DEFAULT_ISO_NAME="fluxuan-daedalus.iso"
DEFAULT_SYSTEM_NAME="fluxuan"

# Prompt user for ISO name
ISO_NAME=$(whiptail --inputbox "Enter the name for the ISO file:" 8 60 "$DEFAULT_ISO_NAME" --title "ISO Name" 3>&1 1>&2 2>&3)

# Prompt user for system name
SYSTEM_NAME=$(whiptail --inputbox "Enter system name:" 8 60 "$DEFAULT_SYSTEM_NAME" --title "System Name" 3>&1 1>&2 2>&3)

# Set the ISO destination
ISO_DESTINATION="/home/$ISO_NAME"

# Set the target directory for rsync
RSYNC_TARGET_DIR="/tmp/fluxuan-rsync-target"

# Create a temporary directory for whiptail messages
TMP_MSG_DIR=$(mktemp -d)

# Create system
echo "Creating system..."
# Use rsync to clone the system
rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / "$RSYNC_TARGET_DIR"

# Create live ISO directory
echo "Creating live ISO directory..."
# Create a directory for the live ISO
LIVE_ISO_DIR="/tmp/fluxuan-live-iso"
mkdir -p "$LIVE_ISO_DIR/live"

# Copy rsynced content to live ISO directory
echo "Copying rsynced content to live ISO directory..."
# Copy the rsynced content to the live ISO directory
cp -a "$RSYNC_TARGET_DIR"/* "$LIVE_ISO_DIR/live"

# Create squashfs file
echo "Creating squashfs file..."
# Create the squashfs file
mksquashfs "$LIVE_ISO_DIR" "$ISO_DESTINATION" -comp xz -e boot -noappend

# Configure syslinux
echo "Configuring syslinux..."
# Install syslinux
apt-get install -y syslinux
syslinux -d /syslinux -i "$ISO_DESTINATION"

# Configure GRUB and ISOLINUX
echo "Configuring GRUB and ISOLINUX..."
# Install GRUB for BIOS boot
apt-get install -y grub-pc
grub-install --target=i386-pc --recheck --force --boot-directory="$ISO_DESTINATION/boot" /dev/sdX  # Replace /dev/sdX with your target device

# Install GRUB for UEFI boot
apt-get install -y grub-efi
grub-install --target=x86_64-efi --efi-directory="$ISO_DESTINATION/boot/efi" --boot-directory="$ISO_DESTINATION/boot" --removable

# Update ISOLINUX configuration
sed -i 's|/boot|/live|' "$ISO_DESTINATION/boot/syslinux/isolinux.cfg"

echo "Live ISO created successfully: $ISO_DESTINATION"
