#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )  # go to the parent path of the script
cd "$parent_path"

if [ -f "config.sh" ]; then
    source config.sh  # config file should be in the same folder
else
    echo "Unable to find config.sh file"
    exit 1
fi

ssh_line="ssh -i $parent_path/$backup_destination_key"
ssh_host="$backup_destination_user@$backup_destination_host"

echo "Checking for SSH key..."
if [ -f "$backup_destination_key" ]; then
    chmod 400 $backup_destination_key
else
    echo "Unable to find $backup_destination_key in the current folder"
    exit 1
fi
echo -e "...Done\n"

echo "Creating sync directories on the client..."
mkdir -p $vm_sync_dir  # create sync directories if they don't exist
echo -e "...Done\n"

echo "Setting up remote environment..."
total_backup_size=$($ssh_line $ssh_host "mkdir -p $backup_destination_mount/$backup_destination_folder")
echo -e "...Done\n"

echo "Adding cron entry for backup..."

current_cron=$(crontab -l 2> /dev/null)
crontab -r 2> /dev/null
echo "$current_cron" | while read line; do
    if [[ ${line} != *"$parent_path"* ]]; then
        (crontab -l 2>/dev/null; echo "$line") | crontab -
    fi
done

(crontab -l 2>/dev/null; echo "$vm_sync_frequency $parent_path/backup.sh > log") | crontab -

echo -e "...Done\n"

echo "Adding binary backup-sync"
echo -e "#!/bin/bash\n\n$parent_path/backup.sh" > ~/.local/bin/backup-sync  # add backup-sync binary
chmod +x ~/.local/bin/backup-sync
echo -e "...Done\n"
