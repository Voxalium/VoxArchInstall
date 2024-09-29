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
  "awesome" "picom" "thunar" "xclip"
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
  "unzip" "wget" "ufw"
)
WEB=(                                                       #Web tools
  "nodejs" "npm" "typscript"
)
XORG=(                                                      #Xorg
  "xorg-server" "xorg-apps" "xorg-xinit"
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
  clear
  echo "------------- Set root password -------------"
  passwd
}

# --- USER ---

CREATE_USER(){                                              #Create new user
  useradd -m -G "wheel" $USERNAME
  sed -i "$WHEEL" /etc/sudoers                              #Add wheel for sudo
  clear
  echo "------------- Set user password -------------"
  passwd $USERNAME
}
# --- CONFIG ---

GET_CONFIG(){
  cd /home/$USERNAME 
  /config.sh
  chown -R $USERNAME /home/$USERNAME/.config
}
EXTRA_CONFIG(){
  ln -s /home/$USERNAME/.config/zsh/.zshrc /home/$USERNAME
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ln -s /home/$USERNAME/.config/xinit/.xinitrc /home/$USERNAME
}

# --- SERVICES ---

ENABLE_SERVICES(){                                          #All the services to enable
  systemctl enable NetworkManager                           #Enable Network Manager
  systemctl enable ufw                                      #Enable firewall
}

# --- CLEAN ---

CLEAN(){                                                    #Remove scripts
  rm /chroot.sh /config.sh 
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
EXTRA_CONFIG
ENABLE_SERVICES
CLEAN
