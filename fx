#!/bin/bash


############################
#     Packages Install
############################


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
sed -i '/^\([^#].*main\)*$/s/main/& contrib non-free/' /etc/apt/sources.list ;
echo -e "Acquire::ForceIPv4 "true"/nAcquire::Languages "0"/nAPT::Install-Recommends "0"" >> /etc/apt/apt.conf ;
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
libwebkit2gtk-4.0-dev \
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
echo -e "vm.swappiness = 10/nvm.dirty_ratio = 40/nvm.dirty_background_ratio = 2/nvm.vfs_cache_pressure = 50" >> /etc/sysctl.d/fluxuanctl.conf ;
rm -rf /usr/share/desktop-base ;
cd /etc/skel/ ;
curl -LJO raw.githubusercontent.com/crentz/FX/main/fx.zip ;
unzip fx.zip ;
mv fxslim /usr/share/slim/themes ;
mv CCP /usr/bin/ ;
mv Byef /usr/bin/ ;
mv wallpaper /usr/share/ ;
mv Dark-f /usr/share/themes/ ;
mv fx /usr/share/ ;
rm -rf /boot/grub/splash.png ;
cp /usr/share/fx/splash.png /boot/grub/ ;
mv start.wav /usr/share/sounds/ ;
cp /usr/share/fx/splash.png /usr/lib/refractasnapshot/iso/isolinux ;
sed 's/*.current_theme.*/current_theme fxslim/' /etc/slim.conf ;
rm -rf fx.zip ;
su fluxuan ;
cd /etc/skel/ ;
cp -R .config .fluxbox .wbar .gtkrc-2.0 .screenlayout /home/fluxuan/ ;
cd /home/fluxuan/ ;
curl -LJO raw.githubusercontent.com/crentz/FX/main/badwolf.deb
sudo apt install ./badwolf.deb ;
exit ;
rm -rf fx ;
rm -rf /usr/share/doc/* ; 
rm -rf /usr/share/man/* ;
rm -rf /usr/share/groff/* ; 
rm -rf /usr/share/info/* ;
rm -rf /usr/share/lintian/* ;
rm -rf /usr/share/linda/* ; 
rm -rf /var/cache/man/* ;
rm -rd /var/log/apt ;
rm -rd /var/cache/apt ;
apt clean ;
apt autoclean ;
echo "Packages finished and installed succesfully. Enjoy !"
