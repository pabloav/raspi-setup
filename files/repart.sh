#!/bin/sh

###################
# Summary: Automatic online Raspberry Pi filesystem resizer
# Description: The default Raspberry Pi Linux images are designed for 2GB SD cards.
#	This script will calculate new partition size/locations to maximize use of your SD card. 
#	It assumes you're running it on a live Raspberry Pi linux system.
#	It will ask for confirmation before it does anything.
#	
#	Special thanks to the author of this document with instructions:
#		http://elinux.org/RPi_Resize_Flash_Partitions
#
# Copyright: Pablo Averbuj <pablo@vanitude.com>  
#
# Licesing: (CC) BY-SA
# Automatic online Raspberry Pi filesystem resizer by Pablo Averbuj is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License. (http://creativecommons.org/licenses/by-sa/3.0/)
# Based on a work at elinux.org.
# Permissions beyond the scope of this license may be available at mailto:pablo@vanitude.com.

BLOCK=/dev/mmcblk0

if [ ! -b $BLOCK ]; then
	echo "You should ONLY run this on a live Raspberry Pi system."
	exit 3;
fi

partitions=$(fdisk -lcu $BLOCK)
before=$(echo "$partitions" | tail -3 | tr -s " ")

echo
echo "$before"
echo

total_sectors=$( echo "$partitions" | grep total | grep sectors | tr -s " " | cut -f8 -d" ")
echo "Total Sectors: $total_sectors"

old_linux_start=$( echo "$before" | grep p2 | cut -f2 -d" ")
old_linux_end=$( echo "$before" | grep p2 | cut -f3 -d" ")
old_swap_start=$( echo "$before" | grep p3 | cut -f2 -d" ")
old_swap_end=$( echo "$before" | grep p3 | cut -f3 -d" ")

old_linux_size=$(( $old_linux_end - $old_linux_start ))
old_swap_size=$(( $old_swap_end - $old_swap_start ))

echo "These are the old start/end sectors for your partitions"
echo "Linux: $old_linux_start - $old_linux_end ($old_linux_size)"
echo "Swap: $old_swap_start - $old_swap_end ($old_swap_size)"

echo

new_swap_end=$(( $total_sectors - 1 ))  # Sectors are 0 indexed so we have to subtract 1 from the total sectors to get the final sector
new_swap_start=$(( $new_swap_end - $old_swap_size ))
new_linux_end=$((new_swap_start - 1 ))
new_linux_start=$old_linux_start

new_linux_size=$(( $new_linux_end - $new_linux_start ))
new_swap_size=$(( $new_swap_end - $new_swap_start ))

echo "These are the new start/end sectors for your partitions"
echo "Linux: $new_linux_start - $new_linux_end ($new_linux_size)"
echo "Swap: $new_swap_start - $new_swap_end ($new_swap_size)"

echo
read -p "Proceed [y/N]?: " proceed

response=$(echo "$proceed" | cut -c1 | tr "Y" "y" )

echo "Proceed: $response"

if [ "$response" = "y" ]; then
   echo "Proceeding ... "
   # These sequence of commands will be newline delimited. This is for clarity of reading
   input="d 2 d 3 n p 2 $new_linux_start $new_linux_end t 2 83 n p 3 $new_swap_start $new_swap_end t 3 82 w"

   echo "$input" | tr " " "\n" | fdisk -cu $BLOCK

   echo "Now you MUST reboot. Issue: 'sudo reboot' or 'sudo shutdown -r now'"
   echo "When the system comes back up, run the following command: 'sudo resize2fs $BLOCK'"
   echo "When the resize completes you can verify your new disk size by issuing 'df -h /'"
else
   echo "Aborting ... "
fi


