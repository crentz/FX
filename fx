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
xorg \
arandr \
fluxbox \
xdm \
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
localepurge \
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
su fluxuan ;
curl -LJO raw.githubusercontent.com/crentz/FX/main/fx.deb ;
curl -LJO raw.githubusercontent.com/crentz/FX/main/badwolf.deb ;

echo "Packages finished and installed succesfully. Enjoy !"
