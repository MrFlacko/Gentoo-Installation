#!/bin/bash

## Command to run the script, this is a gentoo installation script in case you didn't read the title??
## This is mainly meant for my own use, if you wanna use it go ahead.
## bash <(curl -s https://raw.githubusercontent.com/MrFlacko/Gentoo-Installation/main/installation.sh) 

formatDisk() {
    ## Main Formatting of the drive, this will create 512MB partition at the start of the drive for EFI
    ## and create a 4GB partition for the Swap, finally the rest of the drive placed as the linux filesystem
    
    # List the drives first so the user can choose them
    lsblk
    read -p "Enter the drive you want to format (e.g., /dev/sda): " drive
    read -p "You have chosen to format $drive. This will erase all data. Are you sure? (yes/no): " confirmation
    [[ $confirmation != "yes" ]] && echo "Byyee!" && exit 1

    # Unmount the drive if it's mounted
    umount ${drive}* 2> /dev/null

    # Creating of the partitions
    clear
    echo "Creating partitions..."
    parted -s $drive mklabel gpt \
        mkpart primary 1MiB 513MiB \
        mkpart primary linux-swap 513MiB 4617MiB \
        mkpart primary 4617MiB 100%

    # Set to EFI
    parted -s $drive set 1 esp on
    mkfs.fat -F 32 ${drive}1

    # Create and turn on swap
    mkswap ${drive}2
    swapon ${drive}2

    # Format last drive as ext3
    mkfs.ext4 ${drive}3

    echo "Drive $drive has been formatted. Lets Go!"
}

formatDisk
