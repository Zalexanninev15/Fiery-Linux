#!/bin/bash

# Remove snap
sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gnome-3-38-2004
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge bare
sudo snap remove --purge core20
sudo snap remove --purge snapd
sudo apt remove --autoremove snapd -y
echo -e "Package: snapd\nPin: release a=*\nPin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref

# fastfetch
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch

# kdiskmark
sudo add-apt-repository ppa:jonmagon/kdiskmark

# Install apps
sudo apt update
sudo apt install fastfetch mc micro gedit synaptic gparted partitionmanager git python3 python-is-python3 python3-pip distrobox kdiskmark gnome-disk-utility obs-studio bleachbit gamemode inxi -y

# For PortProton
sudo dpkg --add-architecture i386
sudo add-apt-repository multiverse
sudo apt update
sudo apt install inxi bubblewrap gamemode icoutils tar vulkan-tools libvulkan1 libvulkan1:i386 zenity zstd steam cabextract -y

# Install eget
curl https://zyedidia.github.io/eget.sh | sh

# Install Rust with Cargo (just Enter)
curl https://sh.rustup.rs -sSf | sh
