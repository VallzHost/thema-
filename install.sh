#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf PanelThemaBackup.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r ThemaVallzoffc
    git clone https://github.com/Angelillo15/MinecraftPurpleTheme.git
    cd ThemaVallzoffc
    rm /var/www/pterodactyl/resources/scripts/VallzoffcThema.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv VallzOffcThema.css /var/www/pterodactyl/resources/scripts/VallzOffcThema.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Apkah Anda Yakin Ingin Mengginstal Thema panel? [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please Ketik Y/N.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/Angelillo15/MinecraftPurpleTheme/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf PanelThemaBackup.tar.gz
    rm PanelThemaBackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2024 Vallz | VallzOfficial"
echo "Sc Thema Ini Di buat oleh VallzOffc :v"
echo ""
echo ""
echo "[1] Install Tema Panel"
echo "[2] Restore backup"
echo "[3] Uninstall Panel"
echo "[4] Exit"

read -p "Pilih angka di atas :v: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi
