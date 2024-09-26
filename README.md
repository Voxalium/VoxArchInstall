# VoxArchInstall

## $${\color{red}WARNING \space WORK \space IN \space PROGRESS!}$$

These scripts are specifically design for me.

By default :
- It will make two partitions, no swap partition.

| Partition | File System | Size       |
| --------- | ----------  | -----------|
| /boot     | efi         | 1   - 300  |
| /         | ext4        | 300 - 100% |

- It will install **amd-ucode** and **nvidia** proprietary drivers.
- It will install **systemd-boot** for the boot loader.
- It will install **xorg** and **pipewire**
- It will install **awesome** window manager with **lightdm**

You can modify the scripts to your convenience.

**Please read the scripts! Don't install random scripts from the internet.**

## Getting started

VoxArchInstall is just two scripts :

- **archInstall.sh** setup the device and install the basic Arch Linux distribution.
- **chroot.sh** is executed after arch-chroot to setup user infos and install a boot manager.

### 0. Run your Arch Linux CD/ISO/USB

- Download Arch Linux : https://archlinux.org/download/
- [How to create an Arch Linux Installer USB drive](https://wiki.archlinux.org/title/USB_flash_installation_medium) 
- Sync Pacman
```sh
pacman -Sy
```
- Install git
```sh
pacman -S git
```

### 1. Clone the repo

```sh
git clone https://github.com/Voxalium/VoxArchInstall
```
### 2. Check packages in **chroot.sh** :

```sh
# --- MODULES ---

APPS=("firefox" "thunderbird" "discord" "mpv")
AUDIO=("pavucontrol" "helvum" "pipewire")
DESKTOP=("awesome" "gdm" "picom" "thunar" "xclip" "clipman" "rofi" "flameshot")
DEV=("lua" "python")
NVIDIA=("nvidia" "nvidia-utils" "nvidia-settings")
TOOLS=("git" "neovim" "kitty" "zsh" "fzf" "zip" "unzip" "wget")
WEB=("nodejs" "npm" "typscript")
XORG=("xorg-server" "xorg-apps")

# --- MODULES TO INSTALL ---

PACKAGES=(
  ${APPS[*]}
  ${AUDIO[*]}
  ${DESKTOP[*]}
  ${DEV[*]}
  ${NVIDIA[*]}
  ${TOOLS[*]}
  ${WEB[*]}
  ${XORG[*]}
)

pacman -Syu ${PACKAGES[*]}
```

You can add modules : 
```sh
MY_NEW_MODULE=("list" "of" "packages")
```

Don't forget to add them in **PACKAGES** : 
```sh
PACKAGES=(${MY_NEW_MODULE[*]})
```

### 3. Check services to enable in chroot.sh

```sh
ENABLE_SERVICES(){                                          #All the services to enable
  systemctl enable NetworkManager                           #Enable Network Manager
}
```

### 3. Run the script

```sh
cd VoxArchInstall
./archInstall
```

### 4. Follow instructions


### TODO
- Finish documentation
- Some configs
