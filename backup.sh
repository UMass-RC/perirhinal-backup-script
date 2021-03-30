#!/bin/bash

if [-f "config.sh"]; then
    source config.sh  # config file should be in the same folder
else
    echo "Unable to find config.sh file"
    exit 1
fi

timestamp=$(date '+%Y-%m-%d.%H-%M-%S')  # current timestamp
last_timestamp=$(<lastBackup)  # read last timestamp

echo "Starting sync..."
rsync -aPh --delete -e "ssh -i $vm_script_dir/$backup_destination_key" --link-dest=$backup_destination_user@$backup_destination_host:$backup_destination_folder/$last_timestamp $vm_sync_dir $backup_destination_user@$backup_destination_host:$backup_destination_folder/$timestamp
echo "...Done backing up"

echo $timestamp > lastBackup