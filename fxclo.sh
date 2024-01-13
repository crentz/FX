#!/bin/bash

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  whiptail --msgbox "Please run as root." 8 40
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

# Function to show loading bar
show_loading() {
  (
    echo "XXX"
    echo "10"
    echo "Creating system..."
    sleep 1

    # Use rsync to clone the system
    rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / "$RSYNC_TARGET_DIR"

    echo "XXX"
    echo "50"
    echo "Creating live ISO directory..."
    sleep 1

    # Create a directory for the live ISO
    LIVE_ISO_DIR="/tmp/fluxuan-live-iso"
    mkdir -p "$LIVE_ISO_DIR/live"

    echo "XXX"
    echo "75"
    echo "Copying rsynced content to live ISO directory..."
    sleep 1

    # Copy the rsynced content to the live ISO directory
    cp -a "$RSYNC_TARGET_DIR"/* "$LIVE_ISO_DIR/live"

    echo "XXX"
    echo "90"
    echo "Creating squashfs file..."
    sleep 1

    # Create the squashfs file
    mksquashfs "$LIVE_ISO_DIR" "$ISO_DESTINATION" -comp xz -e boot

    echo "XXX"
    echo "95"
    echo "Configuring syslinux..."
    sleep 1

    # Install syslinux
    apt-get install -y syslinux

    # Configure syslinux
    syslinux -d /syslinux -i "$ISO_DESTINATION"

    echo "XXX"
    echo "100"
    echo "Configuring ISOLINUX..."
    sleep 1

    # Install ISOLINUX
    apt-get install -y isolinux

    # Configure ISOLINUX
    mv "$ISO_DESTINATION" /tmp/iso
    isolinux --install /tmp/iso
    mv /tmp/iso "$ISO_DESTINATION"

    echo "XXX"
  ) | whiptail --title "Live ISO Creation" --gauge "Please wait..." 8 60 0
}

# Execute the loading bar function
show_loading

whiptail --msgbox "Live ISO created successfully: $ISO_DESTINATION" 8 60
