#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )  # go to the parent path of the script
cd "$parent_path"

if [ -f "config.sh" ]; then
    source config.sh  # config file should be in the same folder
else
    echo "Unable to find config.sh file"
    exit 1
fi

timestamp=$(date '+%Y-%m-%d.%H-%M-%S')  # current timestamp
last_timestamp=$(<lastBackup)  # read last timestamp

ssh_line="ssh -i $backup_destination_key"
ssh_host="$backup_destination_user@$backup_destination_host"

echo "Starting sync for timestamp $timestamp..."
rsync -aPh --delete -e "ssh -i $backup_destination_key" --link-dest=$backup_destination_mount/$backup_destination_folder/$last_timestamp $vm_sync_dir/* $backup_destination_user@$backup_destination_host:$backup_destination_mount/$backup_destination_folder/$timestamp
echo "...Done backing up"

backup_size_query=$($ssh_line $ssh_host "du -h --max-depth=0 $backup_destination_mount/$backup_destination_folder")
backup_size=$(echo $backup_size_query | cut -d ' ' -f1)

echo "Your backup is using $backup_size of space"

echo $timestamp > lastBackup
