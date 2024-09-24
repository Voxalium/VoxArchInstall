#!/usr/bin/env bash                                                           
#                                                           +-------------------------------+
#                                                           |                               |
#                                                           |         userSetup.sh          |
#                                                           |         by Voxa. 2024         |
#                                                           |                               |
#                                                           +-------------------------------+

# --- GIT ---

DOT_CONFIG_REPO="https://github.com/Voxalium/.config.git"   #Edit the url if you want to match your .config repo
DIRECTORIES=("awesome" "nvim")                              #Directories from the repo to add in the config 

# --- MODULES ---

APPS=(                                                      #Desktop apps
  "firefox" "thunderbird" "discord" "mpv"
)
AUDIO=(                                                     #Audio
  "pavucontrol" "helvum" "pipewire"
)
DESKTOP=(                                                   #Desktop and window manager
  "awesome" "gdm" "picom" "thunar" "xclip"
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

# --- SERVICES ---

ENABLE_SERVICES(){                                          #All the services to enable
  sudo systemctl enable NetworkManager                           #Enable Network Manager
  sudo systemctl enable gdm                                      #Enable Desktop Manager
}

GET_CONFIG(){                                               #Setup .config folder with the .config repo of your choice
  mkdir ~/.config
  cd ~/.config
  git init 
  git remote add origin $DOT_CONFIG_REPO
  git sparse-checkout init --cone
  git sparse-checkout set ${DIRECTORIES[*]}
  git pull origin main
}

# --- EXECUTION ---

sudo pacman -Syu ${PACKAGES[*]}
ENABLE_SERVICES

