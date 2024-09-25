#!/usr/bin/env bash                                                           
#                                                           +-------------------------------+
#                                                           |                               |
#                                                           |         archInstall.sh        |
#                                                           |         by Voxa. 2024         |
#                                                           |                               |
#                                                           +-------------------------------+
#
# --- VARIABLES ---

DEVICE=""
TIMEZONE="Europe/Paris"
PACKAGES=(
  "base" "base-devel" 
  "linux" "linux-headers" "linux-firmware" 
  "mtools" "dosfstools"
  "os-prober"
 # "amd-ucode"
  "efibootmgr"
  "networkmanager"
)

# --- TOOLS ---

PAUSE(){                                                    #Pause the script
  read -p "Press a key to continue"
}

LIST_DISKS(){                                               #List all disks
  echo -e "\nList of disks :\n"
  fdisk -l | grep --color=always "/dev"
  echo ""
}

# --- PARTITIONNING ---

PARTITIONNING(){
  echo -e "--- I. PARTITIONNING ---\n"
  LIST_DISKS
  read -p "Select a device to work with : " DEVICE
  parted $DEVICE mklabel gpt                                #New gpt table
  parted $DEVICE mkpart esp fat32 1 350                     #New esp partition
  parted $DEVICE set 1 esp on
  parted $DEVICE mkpart ext4 350 100%                       #New ext4 partition
  echo -e "\nDisk $DEVICE partition OK\n"
}

# --- FORMATING ---

FORMATING(){
  mkfs.fat -F32 "$DEVICE"1                                  #Format esp
  mkfs.ext4 "$DEVICE"2                                      #Format ext4
}

# --- MOUNTING ---

MOUNTING(){
  mount "$DEVICE"2 /mnt                                     #Mount root to /mnt
  mount --mkdir "$DEVICE"1 /mnt/boot                        #Mount esp  to /mnt/boot  
}

# --- BASE INSTALL ---
#
BASE_INSTALL(){
  timedatectl set-timezone $TIMEZONE                        #Set the time zone
  reflector > /etc/pacman.d/mirrorlist                      #Update the mirrors and replace /etc/pacman.d/mirrorlist
  echo "Mirrors updated"
  pacstrap -K /mnt ${PACKAGES[*]}                           #Install base packages in /mnt
  genfstab -U /mnt > /mnt/etc/fstab                         #Generate fstab
  FSTAB_FILE="/mnt/etc/fstab"
  sed -i 's/fmask=[0-9]\{4\}/fmask=0077/' $FSTAB_FILE
  sed -i 's/dmask=[0-9]\{4\}/dmask=0077/' $FSTAB_FILE
  echo "FSTAB MODIFIED"
}

# --- CHROOT ---
CHROOT(){
  cp chroot.sh /mnt                                         #Copy script to run in /mnt
  arch-chroot /mnt /bin/bash /chroot.sh                     #Chroot
}

# --- EXECUTION ---

echo "
+---------------------+
|                     |
|     ArchInstall     |
|     by Voxa         |
|                     |
+---------------------+"

PARTITIONNING
FORMATING
MOUNTING
BASE_INSTALL
CHROOT

echo "Installation complete, you can now reboot"
