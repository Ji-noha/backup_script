#!/bin/bash

read -p "Enter the path of folder to backup:" src_dir

if [ ! -d "$src_dir" ]; then
    echo "Error:Folder '$src_dir' does not exist!"
    exit 1
fi
backup_dir="./backup"
mkdir -p "$backup_dir" || {
    echo "Error: Cannot create backup directoty"
}

if ! cp -R "$src_dir"/* "$backup_dir"/; then
    echo "Error: Failed to copy files from '$src_dir' to '$backup_dir'"
    exit 1
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
Archive="backup_$DATE.tar.gz"

if ! tar -czvf "$Archive" -C "$backup_dir" . ; then
    echo "Failed to create compressed archive"
    exit 1
fi
echo "Archive '$Archive' is created successefully"

#Clean old backups that are older than 7 days:
find . -name "backup_*.tar.gz" -type f -mtime +7 -exec rm -f {} \;