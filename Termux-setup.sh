#!/bin/bash
clear
echo Termux-setup v2024.nov13
echo Basic Termux setup for Android 14 and above
echo => Partially relevant also for Android 12 and 13
echo 👇👇👇
echo Created by Zalexanninev15
echo Copyright (C) 2024-2025 Zalexanninev15
echo Llicense: GPLv3
sleep 5
echo Process of installing the usual person's required minimum packages is underway :)
echo 3
pkg install termux-am nala curl wget git micro openssl libqrencode zbar python3 cmake ranger -y&& echo Press 'Allow' in the window that appears" && echo "or type 'Y' if you already have access" && sleep 5
echo Process is underway to grant rights to the repository
termux-setup-storage
echo Applying the recommended settings for ranger...
sleep 3
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons && echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
export VISUAL=micro && export PAGER=more 
echo "Author's personal recommendation is to customize the appearance of Termux 🤩"
echo "Settings by author: colors - 73, font - 11"
echo 5
git clone https://github.com/adi1090x/termux-style ~/storage/downloads/termux-style
cd termux-style && bash ./install
echo "Removing 'garbage' packages..."
echo 3
apt autoremove -y && apt autoclean
echo "Removing 'Hello-message' in Termux"
echo 3
touch ~/.hushlogin
echo Done!
