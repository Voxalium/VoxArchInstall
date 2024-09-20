#!/usr/bin/env bash                                                           
#                                                           +-------------------------------+
#                                                           |                               |
#                                                           |         packages.sh           |
#                                                           |         by Voxa. 2024         |
#                                                           |                               |
#                                                           +-------------------------------+

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
  #${APPS[*]}
  #${AUDIO[*]}
  #${DESKTOP[*]}
  #${DEV[*]}
  #${NVIDIA[*]}
  #${TOOLS[*]}
  #${WEB[*]}
  #${XORG[*]}
)

pacman -Syu ${PACKAGES[*]}
