#! /bin/bash

# Use this script to automatically make copies.
# This script makes copies of your website(s) located at /var/www/html
# It also makes copies of your HOME-Directory where this script is located.
# Backup-Drive must be manually written into the variable.
# If you have no idea where the drive is located use this command: lsblk

# Create directoy at /mnt/
MOUNT_DIR=/mnt/backup_drive/
if [ -d $MOUNT_DIR ]
then
	echo "Mounting Drive already existing"
else
	echo "Creating mounting directory.."
	mkdir $MOUNT_DIR
	echo "Directory created!\n"
fi

# This needs to be changed for localisating your drive rightly
DRIVE=/dev/sda1

#Then mount the drive
echo "Mounting drive to " $MOUNT_DIR
mount -t auto $DRIVE $MOUNT_DIR
if [ $(mount | grep /mnt/backup_drive > /dev/null) ]
then
	echo "Drive is already mounted!"
else
	echo "Drive is not mounted"
	echo "Starting mounting..."
	mount $DRIVE $MOUNT_DIR
fi

# This is the directory for the backup on the drive
BACKUP_FOLDER=$MOUNT_DIR/backup/

# Create backup folder on the backup-drive if not exist
echo "Creating directory backup on mounted drive"
if [ -d $BACKUP_FOLDER ]
then
	echo "Directory is already existing."
	echo "Continuing with process..."
else
	mkdir $BACKUP_FOLDER 
fi

echo "Switching current directory to HOME directory ..."
cd /home/
echo "Directory changed"

echo "Copying files from directory /var/www/ to " $BACKUP_FOLDER " ..."
yes | cp -rf /var/www/* $BACKUP_FOLDER 
echo "Copying from /var/www/ done!"

echo "Copying files from HOME to " $BACKUP_FOLDER " ..."
yes | cp -rf ./* $BACKUP_FOLDER
echo "Copying from HOME done!"

# Then unmount the drive for safety
echo "Unmounting drive..."
umount $DRIVE
echo "Drive unmounted"

echo "All backups are done!"
