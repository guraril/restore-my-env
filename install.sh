#!/bin/bash

get_os_distribution() {
    if [ -e /etc/arch-release ]; then
        distri_name="arch"
    fi
}

main() {
    get_os_distribution
    if [ "$distri_name"="arch" ]; then
        sudo pacman -Syyu git go
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si

        echo "Please enable multilib repo to continue installation."
        read -p "Press any key to continue." -n 1
        if type nvim >/dev/null 2>&1; then
            sudo nvim /etc/pacman.conf
        elif type vim >/dev/null 2>&1; then
            sudo vim /etc/pacman.conf
        elif type nano >/dev/null 2>&1; then
            sudo nano /etc/pacman.conf
        fi

        yay -S audacity blender dolphin fcitx5-im fcitx5-mozc firefox gimp google-chrome konsole lmms noto-fonts-cjk noto-fonts-emoji obs-studio plasma steam-native-runtime thunderbird tuxclocker ufw unityhub
        sudo bash -c "echo XMODIFIERS=@im=fcitx5 > /etc/environment"

        sudo ufw default deny
        sudo ufw enable

        read -p "Please type your git username> " username
        read -p "Please type your git email> " email
        git config --global user.name $username
        git config --global user.email $email
    else
        echo "Unknown distribution. Please use Arch Linux"
    fi
}

main
