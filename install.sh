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

        # TODO: 冗長なので関数化する
        echo "Please enable multilib repo to continue installation."
        read -p "Press any key to continue." -n 1
        if type nvim >/dev/null 2>&1; then
            sudo nvim /etc/pacman.conf
        elif type vim >/dev/null 2>&1; then
            sudo vim /etc/pacman.conf
        elif type nano >/dev/null 2>&1; then
            sudo nano /etc/pacman.conf
        else
            echo "No known text editor found. What do you want to install? (1: neovim, 2: vim, 3: nano)"
            read -p "default=1> " -n 1 texteditor
            case "$texteditor" in
            2) sudo pacman -Syyu vim;;
            3) sudo pacman -Syyu nano;;
            *) sudo pacman -Syyu neovim;;
            esac

            # TODO: 冗長なので関数化する
            echo "Please enable multilib repo to continue installation."
            read -p "Press any key to continue." -n 1
            if type nvim >/dev/null 2>&1; then
                sudo nvim /etc/pacman.conf
            elif type vim >/dev/null 2>&1; then
                sudo vim /etc/pacman.conf
            elif type nano >/dev/null 2>&1; then
                sudo nano /etc/pacman.conf
            fi
        fi

        yay -S audacity blender discord dolphin fcitx5-im fcitx5-mozc firefox gimp google-chrome konsole lmms noto-fonts-cjk noto-fonts-emoji obs-studio plasma steam-native-runtime thunderbird tuxclocker unityhub
        sudo bash -c "echo XMODIFIERS=@im=fcitx5 > /etc/environment"

        read -p "Please type your git username> " username
        read -p "Please type your git email> " email
        git config --global user.name $username
        git config --global user.email $email
        
        sudo systemctl enable sddm
    else
        echo "Unknown distribution. Please use Arch Linux"
    fi
}

main
