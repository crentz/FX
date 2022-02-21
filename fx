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
qutebrowser \
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
sed -i 's/false/true/' /etc/NetworkManager/NetworkManager.conf ;
rm -rf /usr/share/fluxbox/styles ;
cd /etc/skel ;
curl -LJO https://raw.githubusercontent.com/crentz/FX/main/FX.zip ;
unzip FX.zip ;
mkdir /usr/share/wallpaper ;
mv backgrounds /usr/share/wallpaper/ ;
mv fxs /usr/share/slim/themes/ ;
sed -i 's/desktop-slim-theme/fxs/' /etc/slim.conf ;
mv CCP /usr/bin/ ;
mv Byef /usr/bin/ ;
mv start.wav /usr/share/sounds/ ;
mv fx /usr/share/ ;
chmod +x /usr/bin/Byef ;
chmod +x /usr/bin/CCP ;
cp -r Dark-f ambiance Trollwut /usr/share/themes/ ;
rm -rf Dark-f ambiance Trollwut ;
rm -rf FX.zip ;
mkdir .screenlayout ;
rm -rf FX ;
usermod -aG sudo fluxuan ;
su fluxuan ;
cd /etc/skel/ ;
cp -r * ~/ ; 
echo "Packages finished and installed succesfully. Enjoy !"
