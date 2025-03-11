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
echo -e "${grn}We will start off with updating & upgrading your package list.${wht}"

#apt-get update -y
#apt-get upgrade -y
echo "Updating done!"

echo -e "${grn}Packages to install:${wht}"
cat packages.txt
read -rp "Does this look correct?(Y/n)> " pack_choice 
if [[ $pack_choice == "y" || pack_choice == "" ]]; then
    # Installing packages
    echo "Installing packages from packages.txt..."
    xargs -a packages.txt apt-get install
else
    echo -e "${grn}Skipping packages install..."
fi

read -rp "Would you like to install node.js? (y/N)> " node_choice

if [[ $node_choice == "y" ]]; then
    # Download and install nvm, taken from node.js installation website
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    # in lieu of restarting the shell
    \. "dinodev/.nvm/nvm.sh" # replace with your own home directory

    # Download and install Node.js:
    nvm install 23

    # Verify the Node.js version:
    echo -e "${grn}Current Node.js version: ${wht}" && node -v # Should print "v23.9.0".
    echo -e "${grn}Current node version manager: ${wht}" && nvm current # Should print "v23.9.0".

    # Verify npm version:
    echo -e "${grn}Current NPM version: ${wht}" && npm -v # Should print "10.9.2".

fi