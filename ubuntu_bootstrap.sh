#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root!"
    exit 1
fi

echo "Welcome to D1noD3v's bootstrap script!"
echo "We will start off with updating & upgrading your package list."

apt-get update -y
apt-get upgrade -y

apt-get install 