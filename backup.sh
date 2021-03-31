#!/bin/bash

if [ -f "config.sh" ]; then
    source config.sh  # config file should be in the same folder
else
    echo "Unable to find config.sh file"
    exit 1
fi

timestamp=$(date '+%Y-%m-%d.%H-%M-%S')  # current timestamp
last_timestamp=$(<lastBackup)  # read last timestamp

ssh_line="ssh -i $vm_script_dir/$backup_destination_key"
ssh_host="$backup_destination_user@$backup_destination_host"

echo "Setting up remote environment..."
total_backup_size=$($ssh_line $ssh_host "mkdir -p $backup_destination_mount/$backup_destination_folder")
echo "...Done"

echo "Starting sync for timestamp $timestamp..."
rsync -aPh --delete -e "ssh -i $vm_script_dir/$backup_destination_key" --link-dest=$backup_destination_folder/$backup_destination_folder/$last_timestamp $vm_sync_dir/* $backup_destination_user@$backup_destination_host:$backup_destination_mount/$backup_destination_folder/$timestamp
echo "...Done backing up"


total_backup_size=$($ssh_line $ssh_host "df -h --max-tree-depth=1 $backup_destination_folder/$backup_destination_folder")
echo "Your backup is using $total_backup_size of space"

echo $timestamp > lastBackup
