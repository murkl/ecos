<h1 align="center">ECOS Core Installer</h1>

<div align="center">
  <p>ARCH LINUX • MICRO • ENCRYPTED • DOTBASED</p>

  <p>
  <img src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/ecos.png" />
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

ECOS is a minimal installation script for Arch Linux. This script will install a minimal installation of arch linux including encryption (LUKS). It is seperated in two installation steps.

## Core Installation

This is the first installation step and will install all essential packages and configurations. You have to reboot after this step. The following packages will be installed during this installation step.

```
base base-devel linux linux-firmware efibootmgr dosfstools gptfdisk networkmanager zsh
```

## Dotfiles Installation

After the first reboot the ECOS TUI will open again automatically. Feel free to execute the ECOS Dotfiles Installation or exit the TUI and install your system manually. The following packages will install before execute your personal `.init` file.

```
git paru
```

**Note:** _The ECOS Dotfiles Installation routine will ask you for your Dotfiles URL and will execute the personal `~/.init` file inside your Dotfiles Repository_

### GNOME Variant

<b>Repository:</b> https://github.com/murkl/dotfiles-gnome.git

  <p align="center">

  <img width="75%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/gnome-01.png">
    <img width="75%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/gnome-02.png">
  </p>

## BSPWM Variant

<b>Repository:</b> https://github.com/murkl/dotfiles-bspwm.git

  <p align="center">
  <img width="75%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/bspwm-01.png">
    <img width="75%" src="https://raw.githubusercontent.com/murkl/ecos/master/screenshots/bspwm-02.png">
  </p>
