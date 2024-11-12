#!/bin/bash
clear
echo "Termux-setup 2024.nov13-fix"
echo "Basic Termux setup for Android 14 and above"
echo "=> Partially relevant also for Android 12 and 13"
echo "👇👇👇"
echo "Created by Zalexanninev15"
echo "Copyright (C) 2024-2025 Zalexanninev15"
echo "License: GPLv3"
sleep 4
echo "Process of installing the usual person's required minimum packages is underway :)"
pkg install termux-am nala curl wget git micro openssl libqrencode zbar python3 ranger -y && echo "Press 'Allow' in the window that appears" && echo "or type 'Y' if you already have access" && echo "Process is underway to grant rights to the storage (Android)" && sleep 2
termux-setup-storage
sleep 5
echo "Applying the recommended settings for ranger..."
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons && echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
export VISUAL=micro && export PAGER=more 
echo "Author's personal recommendation is to customize the appearance of Termux 🤩"
echo "Settings by author: colors - 73, font - 11"
echo 4
git clone https://github.com/Zalexanninev15/termux-style-clone.git ~/storage/downloads/termux-style
cd termux-style && bash ./install
echo "Removing 'garbage' packages..."
apt autoremove -y && apt autoclean
echo "Removing 'Hello-message' in Termux"
touch ~/.hushlogin
echo "Done!"
