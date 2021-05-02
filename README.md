<h1 align="center">ec•s | core</h1>
<div align="center">
  <p>ARCH LINUX • MICRO • ENCRYPTED • DOTBASED</p>

  <p>
  <img src="http://ecos.webhop.me:3000/ecos/core/raw/branch/master/web/ecos.png">
  </p>

  <p><b>The userfriendly & dotbased OS for Digital Pirates</b></p>
  <p>
    <img src="https://img.shields.io/badge/MAINTAINED-YES-green?style=for-the-badge">
    <img src="https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge">
  </p>
</div>

# Installation

- Create bootable USB Stick
  - `curl -s http://ecos.webhop.me/ecos | bash`
- Boot from USB Stick...
  - `loadkeys de-latin1`
  - `curl http://ecos.webhop.me/ecos > ecos`
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

### Base Installation - [Go to Base Repository...](http://murkl.ddns.net:3000/ecos/base)

After the first reboot the ECOS TUI will open again automatically. Feel free to execute the Base Installation or exit the TUI and install your system manually.

```
git paru
```

**Note:** _The base installation routine will execute the personal `~/.init` file inside your dotfiles repository_

## Configuration

- Show WLAN Interface: `ip link`
- Show Battery Info: `ls -1 /sys/class/power_supply/`

## Manual Installation Guide

### Downlod Arch ISO file

- https://www.archlinux.de/download

### Create USB Stick

- _Show device info with `lsblk`_
- `dd bs=4M if=archlinux.iso of=/dev/sdX status=progress oflag=sync`

### Boot from Arch ISO...

- Set prefered keyboard layout
  - `loadkeys de-latin1`

### Prepare Disk

| **Partition** | **Mount Point** | **Partition Type**                     | **Size** |
| ------------- | --------------- | -------------------------------------- | -------- |
| /dev/sda1     | /mnt/boot       | EFI Boot partition (fat32)             | 512 MB   |
| /dev/sda2     | /mnt            | Encrypted Linux Root Filesystem (ext4) | Rest     |

- **Check your drive with:** `lsblk -f`
- **Partition drive:** `gdisk /dev/sda`
  - **Create new GPT partition table:** `o`
  - **Create EFI/Boot partition:** `n`
    - Number `1`, First Sector: `ENTER`, Last Sector: `+512M`, Hex Code: `ef00`
  - **Create Root partition:** `n`
    - Number `2`, First Sector: `ENTER`, Last Sector: `ENTER`, Hex Code: `8300`
  - **Write partitions:** `w`
- **Encrypt root drive**
  - `cryptsetup -y -v luksFormat /dev/sda2` - Confirm (YES) and enter your own password (passphrase)
  - `cryptsetup open /dev/sda2 cryptroot` - Open the new crypted partition as _cryptroot_
- **Format drive**
  - `mkfs.fat -F 32 -n BOOT /dev/sda1` - Formatting EFI/Boot partition
  - `mkfs.ext4 -L ROOT /dev/mapper/cryptroot` - Formatting encrypted Root partition
- **Mount drive**
  - `mount -L ROOT /mnt`
  - `mkdir /mnt/boot`
  - `mount -L BOOT /mnt/boot`
  - Check with `lsblks`
    ```
    NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
    sda             8:0    0 931,5G  0 disk
    ├─sda1          8:1    0   512M  0 part  /mnt/boot
    ├─sda2          8:2    0   931G  0 part
      └─root      253:0    0   931G  0 crypt /mnt
    ```

### Pacstrap

- **Install essential packages**
  - `nano /etc/pacman.d/mirrorlist` _- (optional) edit mirrors for faster download_
  - `pacstrap /mnt base base-devel linux linux-firmware`

### System Configuration

- **Fstab**
  - `genfstab -Lp /mnt > /mnt/etc/fstab`
- **Chroot** into the new system
  - `arch-chroot /mnt`
- **Install Editor**
  - `pacman -S nano`
- **Swapfile (Optional)** - _16 GB_

  - `dd if=/dev/zero of=/swapfile bs=1G count=16`
  - `chmod 600 /swapfile`
  - `mkswap /swapfile`
  - `swapon /swapfile`
  - `nano /etc/fstab` _- add to the end of file:_
    ```
    /swapfile none swap defaults 0 0
    ```

- **Set Timezone**
  - `ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
- **Localization**

  - `echo LANG=de_DE.UTF-8 > /etc/locale.conf`
  - `nano /etc/locale.gen` _- uncomment prefered language:_

    ```
    de_DE.UTF-8 UTF-8
    de_DE ISO-8859-1
    de_DE@euro ISO-8859-15
    ```

  - `locale-gen`

- **Keyboard Mapping**
  - `echo KEYMAP=de-latin1-nodeadkeys > /etc/vconsole.conf`

### Root Password

- Set your root passwort: `passwd`

### Network Configuration

- `pacman -S networkmanager`
- `systemctl enable NetworkManager`
- `echo murkl-desktop > /etc/hostname`
- `nano /etc/hosts`
  ```
  127.0.0.1    localhost
  ::1          localhost
  ```

### Initramfs

- `nano /etc/mkinitcpio.conf` _- modify hooks_

  ```
  HOOKS=(base udev autodetect modconf block keyboard keymap encrypt filesystems fsck)
  ```

- Create initramfs: `mkinitcpio -p linux`

### Boot Loader (systemdboot)

- `pacman -S efibootmgr dosfstools gptfdisk intel-ucode`
- `bootctl install`
- `nano /boot/loader/entries/arch.conf`

  ```
  title     Arch Linux
  linux     /vmlinuz-linux
  initrd    /intel-ucode.img
  initrd    /initramfs-linux.img
  options   cryptdevice=/dev/sda2:cryptroot root=LABEL=ROOT rw lang=de init=/usr/lib/systemd/systemd locale=de_DE.UTF-8
  ```

- `nano /boot/loader/entries/arch-fallback.conf`

  ```
  title     Arch Linux Fallback
  linux     /vmlinuz-linux
  initrd    /intel-ucode.img
  initrd    /initramfs-linux-fallback.img
  options   cryptdevice=/dev/sda2:cryptroot root=LABEL=ROOT rw lang=de init=/usr/lib/systemd/systemd locale=de_DE.UTF-8
  ```

- `nano /boot/loader/loader.conf`

  ```
  timeout 1
  default arch
  ```

### Reboot

- `exit`
- `swapoff -a`
- `umount -R /mnt`
- `reboot`
- **Login as `root`**

### Create User

- **Add user**
  - `pacman -S zsh`
  - `useradd -m -G users,wheel,video,audio,storage,disk -s /bin/zsh murkl`
  - `passwd murkl`
- **Add sudoers**

  - `EDITOR=nano visudo`
  - _Uncomment wheel group..._

  ```
  %wheel ALL=(ALL) ALL
  ```

- **Logout from root**
  - `exit`
- **Login new user**
  - Login as `murkl`
  - Quit the zsh configuration promt with `q`
