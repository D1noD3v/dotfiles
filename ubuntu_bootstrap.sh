#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root!"
    exit 1
fi

grn='\e[0;32m'
blu='\e[0;34m'
wht='\e[0;37m'
red='\e[0;31m'
yel='\e[1;33m'

echo -e "${grn}Welcome to D1noD3v's bootstrap script!${wht}"
echo "${grn}We will start off with updating & upgrading your package list.${wht}"

apt-get update -y
apt-get upgrade -y
echo "Updating done!"

echo "${grn}Packages to install:${wht}"
cat packages.txt
read -rp "Does this look correct?> (Y/n)" pack_choice
if [[ pack_choice == "" || pack_choice == "y" ]]; then
    # Installing packages
    echo "Installing packages from packages.txt..."
    xargs -a packages.txt apt-get install
fi
