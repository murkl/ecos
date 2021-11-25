<h1 align="center">ECOS - The Indie Arch Distro</h1>

<div align="center">
  <p>ARCH LINUX • MICRO • ENCRYPTED • DOTBASED</p>

  <p>
    <img width="70%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-title.png" />
  </p>

  <p><b>The userfriendly & dotbased OS</b></p>
  <p>
    <img src="https://img.shields.io/badge/MAINTAINED-YES-green?style=for-the-badge">
    <img src="https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge">
  </p>
</div>

# Prerequisites

- Disable Secure Boot
- Disable Legacy Support
- Set Boot Mode to UEFI (Legacy BIOS supported)
- Connect to Internet via cable (recommended)

# Installation

- Create bootable USB Stick
  - `curl -sL http://ecos.webhop.me | bash`
- Boot from USB Stick...
  - `loadkeys de-latin1`
  - `curl -L http://ecos.webhop.me > ecos`
  - `bash ecos`

# Documentation

ECOS is a full automatic TUI based installation script for Arch Linux. This script will install a minimal installation of Arch Linux including encryption (LUKS) and your prefered Dotfiles. It is seperated in two installation steps.

## Core Installation

This is the first installation step and will install all essential packages and configurations for Arch Linux. You have to reboot after this step. The following packages will be installed during this installation step.

```
base base-devel linux linux-firmware efibootmgr dosfstools gptfdisk networkmanager zsh
```

## Dotfiles Installation

After the first reboot the ECOS TUI will open again automatically. Feel free to execute the ECOS Dotfiles Installation (with all preconfigured packages) or exit the TUI and install your fresh Arch Linux system manually.
The following packages will be installed during this routine before the `~/.ecos/init` script within the given Dotfiles Repository will be executed.

```
git paru
```

**Note:** _The ECOS Dotfiles Installation routine will ask you for your prefered Dotfiles URL and will execute the `~/.ecos/init` script inside this Dotfiles Repository. You can use a preconfigured Dotfiles Repository (see below) or your own one_

### GNOME Variant

<b>Repository:</b> https://github.com/murkl/dotfiles-gnome.git

<span align="center">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/gnome-01.png">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/gnome-02.png">
</span>

## BSPWM Variant

<b>Repository:</b> https://github.com/murkl/dotfiles-bspwm.git

<span align="center">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/bspwm-01.png">
  <img width="45%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/bspwm-02.png">
</span>

## ECOS Installation Screenshots

<span align="center">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-01.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-02.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-03.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-04.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-05.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-06.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-07.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-08.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-09.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-core-10.png">
</span>

## ECOS Manager Screenshots

<span align="center">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-manager-01.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-manager-02.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-manager-03.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-manager-04.png">
  <img width="22%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos-manager-05.png">
</span>
