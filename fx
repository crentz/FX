#!/bin/bash


############################
#     Packages Install
############################


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
sed -i '/^\([^#].*main\)*$/s/main/& contrib non-free/' /etc/apt/sources.list ;
apt update && apt upgrade -y ;
apt install sudo \
wget \
unzip \
curl \
xserver-xorg \
arandr \
fluxbox \
slim \
featherpad \
lxappearance \
lxpolkit \
sakura \
viewnior \
xpaint \
xpdf \
xarchiver \
pcmanfm \
udevil \
gparted \
synaptic \
gufw \
xfburn \
alsa-utils \
volumeicon-alsa \
apulse \
wbar \
wbar-config \
nitrogen \
smplayer \
yad \
bleachbit \
refractasnapshot-base \
refractainstaller-gui \
firmware-linux-nonfree \
firmware-misc-nonfree \
firmware-b43-installer \
firmware-b43legacy-installer \
firmware-realtek \
firmware-atheros \
firmware-iwlwifi \
firmware-brcm80211 \
network-manager-gnome -y ;
dpkg-reconfigure localepurge ;
usermod -aG sudo fluxuan ;
sed -i 's/false/true/' /etc/NetworkManager/NetworkManager.conf ;
rm -rf /usr/share/fluxbox/styles ;
sed -i 's/Devuan/Fluxuan/' /etc/motd ;
sed -i 's/Devuan/Fluxuan/' /etc/issue ;
sed -i 's/Devuan/Fluxuan/' /etc/issue.net ;
sed -i 's/Devuan/Fluxuan/' /etc/os-release ;
sed -i 's/Devuan/Fluxuan/' /etc/default/grub ;
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=3/' /etc/default/grub ;
sed -i 's/GRUB_THEME/#GRUB_THEME/' /etc/default/grub ;
rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* ;
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/* ;
rm -rd /var/log/apt ;
rm -rd /var/cache/apt ;
cat << EOF > /etc/sysctl.d/fluxuanctl.conf
vm.swappiness = 10
vm.dirty_ratio = 40
vm.dirty_background_ratio = 2
vm.vfs_cache_pressure = 50
EOF
cat << EOF > /etc/apt/apt.conf
Acquire::ForceIPv4 "true";
Acquire::Languages "0";
APT::Install-Recommends "0";
EOF
rm -rf /usr/share/desktop-base





cp /boot/grub/splash.png /usr/lib/refractasnapshot/iso/isolinux

echo "Packages finished and installed succesfully. Enjoy !"
