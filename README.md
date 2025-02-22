# Introduction

This repo is a general collection of all my dotfiles i use in my dev enviroment. 
I have also included a bootstrap script in order to make installing all the required software easier for
both you and me!

# Usage

To start the installation, begin by cloning the repository and running the bootstrap script.

Linux
```bash
git clone https://github.com/D1noD3v/dotfiles.git
cd dotfiles
sudo ./ubuntu_bootstrap.sh
```
## Addtional packages
You may change the  ```packages.txt```  to include whatever packages you would like to install.
In order for it to work you need to structure the package names like this:

```
python3
curl
wget
```
