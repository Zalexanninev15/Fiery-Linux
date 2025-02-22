#!/bin/bash
clear
echo "Termux-setup v2025"
echo "Basic Termux setup for Android 14 and above"
echo "=> Partially relevant also for Android 12 and 13"
echo "👇👇👇"
echo "Created by Zalexanninev15"
echo "Copyright (C) 2024-2025 Zalexanninev15"
echo "License: GPLv3"
sleep 3
echo "Process of installing the usual person's required minimum packages is underway :)"
pkg install termux-am curl wget git micro openssl libqrencode zbar python3 ranger bat eza -y && apt install libssh2 && echo "Press 'Allow' in the window that appears" && echo "or type 'Y' if you already have access" && echo "Process is underway to grant rights to the storage (Android)" && sleep 2
echo "Wait..."
termux-setup-storage
sleep 12
git config --global http.postBuffer 524288000
echo "cd ./storage/shared" >> /data/data/com.termux/files/usr/etc/termux-login.sh
echo "Applying the recommended settings for ranger..."
rm -rf ~/.config/ranger/plugins/ranger_devicons
git clone "https://github.com/alexanderjeurissen/ranger_devicons.git" ~/.config/ranger/plugins/ranger_devicons && echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
export VISUAL=micro && export PAGER=more 
echo "Author's personal recommendation is to customize the appearance of Termux 🤩"
rm -rf ~/storage/downloads/termux-style
git clone "https://github.com/Zalexanninev15/termux-style-clone.git" ~/storage/downloads/termux-style && cd ~/storage/downloads/termux-style && bash ./install
echo "Removing 'garbage' packages..."
apt autoremove -y && apt autoclean
echo "Removing 'Hello-message' in Termux"
touch ~/.hushlogin
echo "Settings for bash by KNIGHTFALL"
wget https://raw.githubusercontent.com/knightfall-cs/termux-bashrc/refs/heads/main/bash.bashrc -O /data/data/com.termux/files/usr/etc/bash.bashrc
echo "Done! Please restart Termux!"
echo "Run 'termix-style'. Settings by author: colors - 73, font - 6"
