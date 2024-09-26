#!/usr/bin/env bash                                                           
#                                                           +-------------------------------+
#                                                           |                               |
#                                                           |         chroot.sh             |
#                                                           |         by Voxa. 2024         |
#                                                           |                               |
#                                                           +-------------------------------+

# --- VARIABLES ---

DEVICE=""
HOSTNAME="Voxa"
KEYMAP="fr"
TIMEZONE="Europe/Paris"
USERNAME="Voxa"
WHEEL='/^# %wheel ALL=(ALL:ALL) ALL/s/^# //'                #Remove '#' in sudoers file for wheel

DOT_CONFIG_REPO="https://github.com/Voxalium/.config.git"   #Edit the url if you want to match your .config repo
DIRECTORIES=("awesome" "nvim" "kitty" "picom")              #Directories from the repo to add in the config 

# --- TOOLS ---

PAUSE(){                                                    #Pause the script
  read -p "Press a key to continue"
}

LIST_DISKS(){                                               #List all disks
  echo -e "\nList of disks :\n"
  fdisk -l | grep --color=always "/dev"
  echo ""
}

# --- MODULES ---

APPS=(                                                      #Desktop apps
  "firefox" "thunderbird" "discord" "mpv"
)
AUDIO=(                                                     #Audio
  "pavucontrol" "helvum" "pipewire"
)
DESKTOP=(                                                   #Desktop and window manager
  "awesome" "lightdm" "picom" "thunar" "xclip"
  "nwg-clipman" "rofi" "flameshot"
)
DEV=(                                                       #Dev tools
  "lua" "python"
)
NVIDIA=(                                                    #Nvidia drivers
  "nvidia" "nvidia-utils" "nvidia-settings"
)
TOOLS=(                                                     #Command line tools 
  "git" "neovim" "kitty" "zsh" "fzf" "zip"
  "unzip" "wget"
)
WEB=(                                                       #Web tools
  "nodejs" "npm" "typscript"
)
XORG=(                                                      #Xorg
  "xorg-server" "xorg-apps"
)

# --- MODULES TO INSTALL ---

PACKAGES=(                                                  #This list of packages will be install with pacman
#  ${APPS[*]}
  ${AUDIO[*]}
  ${DESKTOP[*]}
#  ${DEV[*]}
#  ${NVIDIA[*]}
  ${TOOLS[*]}
#  ${WEB[*]}
  ${XORG[*]}
)

# --- Disk ---

GET_INFO(){
  echo "DEVICE :"
  LIST_DISKS                                                #List Disks
  read -p "Root partition (for boot manager ) : " DEVICE    #Get Root partition
}

# --- TIME ---

SET_TIME(){
  ln -sf /urs/share/zoneinfo/$TIMEZONE /etc/localtime       #Set Timezone
  hwclock --systohc                                         #Set Clock
}

# --- LOCALES ---

SET_LOCALES(){
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen                #Set Locales.gen to English
  locale-gen                                                #Local Generation
  echo "LANG=en_US.UTF-8"  > /etc/locales.conf              #Set Locales to English
  echo "KEYMAP=$KEYMAP"    > /etc/vconsole.conf             #Set Keymap
}

# --- NETWORK ---

SET_NETWORK(){
  echo $HOSTNAME > /etc/hostname                            #Set Hostname
  echo "                                                    
  127.0.0.1   localhost
  ::1         localhost
  127.0.1.1   $HOSTNAME.localdomain   $HOSTNAME
  " > /etc/hosts                                            #Config Hosts
}

# --- BOOT ---

SET_BOOT_MANAGER(){                                         #Install systemd-boot manager
  bootctl --path=/boot install                              
  echo "
  default arch.conf
  timeout 3  
  " > /boot/loader/loader.conf                              #Config loader.conf
  echo "  
  title Arch Linux
  linux /vmlinuz-linux
  initrd /initramfs-linux.img
  options root=$DEVICE rw
  " > /boot/loader/entries/arch.conf                        #Config Entries
}

# --- ROOT ---

SET_ROOT_PASSWORD(){                                        #Set Root password
  echo "------------- Set root password -------------"
  passwd
}

# --- USER ---

CREATE_USER(){                                              #Create new user
  useradd -m -G "wheel" $USERNAME
  sed -i "$WHEEL" /etc/sudoers                              #Add wheel for sudo
  echo "------------- Set user password -------------"
  passwd $USERNAME
}


# --- USER CONFIG  ---

GET_CONFIG(){                                               #Setup .config folder with the .config repo of your choice
  mkdir ~/.config
  cd ~/.config
  git init 
  git remote add origin $DOT_CONFIG_REPO
  git sparse-checkout init --cone
  git sparse-checkout set ${DIRECTORIES[*]}
  git pull origin main

}

INSTALL_AUR_HELPER(){
  cd ~/
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
}


# --- SERVICES ---

ENABLE_SERVICES(){                                          #All the services to enable
  systemctl enable NetworkManager                           #Enable Network Manager
  systemctl enable lightdm                                  #Enable Desktop Manager
}

# --- CLEAN ---

CLEAN(){                                                    #Remove scripts
  rm /chroot.sh 
}

# --- EXECUTION ---

GET_INFO
SET_TIME
SET_LOCALES
SET_NETWORK
SET_BOOT_MANAGER
SET_ROOT_PASSWORD
CREATE_USER
sudo pacman -Syu ${PACKAGES[*]}
GET_CONFIG
INSTALL_AUR_HELPER
ENABLE_SERVICES
CLEAN
