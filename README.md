<h1 align="center">ec•s | core</h1>
<div align="center">
  <p>ARCH LINUX • MICRO • ENCRYPTED • DOTBASED</p>

  <p>
  <img src="http://ecos.webhop.me:3000/ecos/core/raw/branch/master/web/ecos.png">
  </p>

  <p><b>The userfriendly & dotbased OS</b></p>
  <p>
    <img src="https://img.shields.io/badge/MAINTAINED-YES-green?style=for-the-badge">
    <img src="https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge">
  </p>
</div>

# Installation

- Create bootable USB Stick
  - `curl -sL http://ecos.webhop.me | bash`
- Boot from USB Stick...
  - `loadkeys de-latin1`
  - `curl -L http://ecos.webhop.me > ecos`
  - `bash ecos`

# Documentation

## Recommendations

- 1000 MB RAM (mind. 512 MB)
- Disable Secure Boot
- Disable Legacy Support
- Set Boot Mode to UEFI (Legacy BIOS supported)
- Connect to Internet via cable

## Package Information

The following packages will be automatically installed during the installation routine.

### Core Installation

This is the first installation step and will install all essential packages and configurations. You have to reboot after this step.

```
base base-devel linux linux-firmware efibootmgr dosfstools gptfdisk networkmanager zsh
```

### Dotfiles Installation

After the first reboot the ECOS TUI will open again automatically. Feel free to execute the ECOS Dotfiles Installation or exit the TUI and install your system manually. The following packages will install before execute your personal `.init` file.

```
git paru
```

**Note:** _The ECOS Dotfiles Installation routine will ask you for your Dotfiles URL and will execute the personal `~/.init` file inside your Dotfiles Repository_

## Configuration

- Show WLAN Interface: `ip link`
- Show Battery Info: `ls -1 /sys/class/power_supply/`
