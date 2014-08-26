#!/bin/bash

installFileName="VPNDemon.desktop"
installPath="/usr/share/applications/"
installFilePath="$installPath$installFileName"
iconPath="/usr/share/icons/gnome/32x32/devices/ac-adapter.png"
header="VPNDemon\nhttps://github.com/primaryobjects/vpndemon\n\n"
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# First, make sure the installer is running as root.
if [[ $UID -ne 0 ]]
then
    # Prompt for admin password to install.
    password=$(zenity --password --title="VPNDemon Installer")
    result=$?
    echo $result
    if [ $result = 0 ]
    then
        # Restart installer as root.
        echo -e $password | sudo -S bash "$scriptPath/install.sh"
    fi

    # Not root, so exit.
    exit
fi

# Prompt for install path.
installPath=$(zenity --entry --title="VPNDemon Installer" --text="$header Enter an install path" --entry-text="$installPath")
result=$?
if [ $result = 0 ]
then
    # Prompt for icon path.
    iconPath=$(zenity --entry --title="VPNDemon Installer" --text="$header Enter an icon path" --entry-text="$iconPath")
    result=$?
    if [ $result = 0 ]
    then
        # Create application entry.
        echo "[Desktop Entry]" > "$installFilePath"
        echo "Version=1.0" >> "$installFilePath"
        echo "Type=Application" >> "$installFilePath"
        echo "Exec=\"$scriptPath/vpndemon.sh\"" >> "$installFilePath"
        echo "Name=VPNDemon" >> "$installFilePath"
        echo "Icon=$iconPath" >> "$installFilePath"

        zenity --info --title="VPNDemon Install" --text="VPNDemon has been successfully installed to $installFilePath!\n\nTo add an icon to your desktop or panel: open the start menu and search for VPNDemon. Right-click the result and select 'Add to Panel' or 'Add to Desktop'"
    fi
fi