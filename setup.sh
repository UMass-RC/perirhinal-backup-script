#!/bin/bash

if [-f "config.sh"]; then
    source config.sh  # config file should be in the same folder
else
    echo "Unable to find config.sh file"
    exit 1
fi

echo "Creating sync directories on the client..."
mkdir -p "${vm_sync_dirs[@]}"  # create sync directories if they don't exist
echo -e "...Done\n"

echo "Adding cron entry for backup"
(crontab -l 2>/dev/null; echo "$vm_sync_frequency $vm_script_dir/backup.sh") | crontab -  # add to crontab
echo -e "...Done\n"

echo "Adding binary backup-sync"
echo -e "#!/bin/bash\n$DIR/backup.sh" > /usr/local/bin/backup-sync  # add backup-sync binary
echo -e "...Done\n"