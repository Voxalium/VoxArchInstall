#!/usr/bin/env bash                                                           
#                                                           +-------------------------------+
#                                                           |                               |
#                                                           |         config.sh             |
#                                                           |         by Voxa. 2024         |
#                                                           |                               |
#                                                           +-------------------------------+

# --- VARIABLES ---

DOT_CONFIG_REPO="https://github.com/Voxalium/.config.git"   #Edit the url if you want to match your .config repo
DIRECTORIES=("awesome" "nvim")                              #Directories from the repo to add in the config 

# ---------------------------------------------------------

GET_CONFIG(){
  mkdir ~/.config
  cd ~/.config
  git init 
  git remote add origin $DOT_CONFIG_REPO
  git sparse-checkout init --cone
  git sparse-checkout set ${DIRECTORIES[*]}
  git pull origin main
}

GET_CONFIG








