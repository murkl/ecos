<h1 align="center">ECOS - The Indie Arch Distro</h1>

<div align="center">
  <p>ARCH LINUX • MICRO • ENCRYPTED • DOTBASED</p>

  <p>
    <img width="70%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-title.png" />
  </p>

  <p><b>The userfriendly & dotbased OS</b></p>
  <p>
    <img src="https://img.shields.io/badge/MAINTAINED-YES-green?style=for-the-badge">
    <img src="https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge">
  </p>
</div>

# Features

- TUI Installer
- Tweak Scripts
- Driver Scripts
- Supports Virtualbox & GNOME Boxes (qemu)
- Sandbox ECOS Home Dir (~/.ecos)
- Easy expandable (have a look in ECOS home dir)
- Based on official Arch Linux
- Minimal Package Dependencies
- Full HDD Encryption & Auto Login (enter password only once)
- Choose between GNOME and BSPWM
- Optimized for Desktop & Notebook
- Touchpad Support
- Languages: English, German
- Custom Dotfiles Support

# Prerequisites

- Disable Secure Boot
- Disable Legacy Support
- Set Boot Mode to UEFI (Legacy BIOS supported)
- Connect to Internet via cable (recommended)

## Optional: Connect to WLAN

Execute `iwctl` and you will enter the WLAN config console. Enter the commands in **iwctl console** and connect to your WLAN:

```
device list
station wlan0 get-networks
station wlan0 connect "WLAN Name"
exit
```

# Installation

- Create bootable USB Stick
  - `curl -sL http://ecos.webhop.me | bash`
- Boot [Arch ISO](https://www.archlinux.de/download) from USB Stick...
  - `loadkeys de-latin1` _(use your prefered language layout)_
  - `curl -L http://ecos.webhop.me > installer`
  - `bash installer`

# Documentation

ECOS is a full automatic TUI based installation script for Arch Linux. This script will install a minimal installation of Arch Linux including encryption (LUKS) and your prefered Dotfiles from Git repository (optional). It is seperated in two installation steps.

## 1. Step: Core Installation (installer script)

The `installer` script is the first installation step and will install all essential packages and configurations for Arch Linux. Boot for this step from the [official Arch ISO](https://www.archlinux.de/download) and execute the `installer` script:

- `curl -L http://ecos.webhop.me > installer`
- `bash installer`

You have to reboot after this step. The following packages and configurations will be installed during the core installation step.

```
base base-devel linux linux-firmware efibootmgr dosfstools gptfdisk lvm2 grub os-prober networkmanager zsh git nano
```

Also the choosen ECOS git repository cloned into the following direcory in the new Arch system

```
git clone https://github.com/murkl/ecos.git ~/.ecos/.system/repo
```

This file will be created and automatically loaded on first system boot

```
~/.zlogin
```

**Source:** _For more information have a look at the [ installer ](https://github.com/murkl/ecos/blob/main/installer) script in method: [ exec_install_chroot() ](https://github.com/murkl/ecos/blob/main/installer#L446)_

## 2. Step (optional): ECOS Installation (ecos script)

After the first reboot the ECOS TUI will open again automatically. Feel free to execute the ECOS Dotfiles Installation (with all preconfigured packages) or exit the TUI and install your fresh Arch Linux system manually.
The following packages will be installed during this routine before the `~/.ecos/init.sh` script within the given Dotfiles Repository will be executed.

```
paru zenity
```

**Note:** _The ECOS Dotfiles Installation routine will ask you for your prefered Dotfiles URL and will execute the `~/.ecos/init.sh` script inside this Dotfiles Repository. You can use a preconfigured Dotfiles Repository (see below) or your own one_

**Source:** _For more information have a look at the [ ecos ](https://github.com/murkl/ecos/blob/main/ecos) script in method: [ exec_install_ecos() ](https://github.com/murkl/ecos/blob/main/ecos#L653)_

## Use Custom Dotfiles Repo

You have to create the init bash script file which will executed during the ECOS installation routine: `./ecos/init.sh`

For Example: Have a look into the official GNOME Dotfiles repo: https://github.com/murkl/dotfiles-gnome/blob/main/.ecos/init.sh

## GNOME Variant

<b>Repository:</b> https://github.com/murkl/dotfiles-gnome.git

### Screenshots

<span align="center">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/gnome-01.png">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/gnome-02.png">
</span>

## BSPWM Variant

<b>Repository:</b> https://github.com/murkl/dotfiles-bspwm.git

### Screenshots

<span align="center">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/bspwm-01.png">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/bspwm-02.png">
</span>

## ECOS Installation

### Screenshots

<span align="center">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-01.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-02.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-03.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-04.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-05.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-06.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-07.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-08.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-09.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-core-10.png">
</span>

## ECOS Manager

### Screenshots

<span align="center">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-manager-01.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-manager-02.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-manager-03.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-manager-04.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/assets/screenshots/ecos-manager-05.png">
</span>
