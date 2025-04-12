#!/bin/bash

#####################################################################
# Author: Juan Luis Acebal
# Description: This script creates a DataHub backup using the
#              'datahub docker quickstart --backup' command.
#              The backup file is saved in the directory specified by
#              the environment variable RUTA_BACKUP_DATAHUB.
#              The filename format is: backup_datahub_<timestamp>.sql_part_aa, ab, etc.
#              To reconstruct the original file, run:
#              cat backup_datahub_<timestamp>.sql_part_* > backup_datahub_<timestamp>.sql
#              Or use: ./precommit.sh --reconstruct <backup_folder>
#####################################################################
source .bashrc


# Check if the environment variable is set
if [ -z "$RUTA_BACKUP_DATAHUB" ]; then
  echo "❌ Error: Environment variable RUTA_BACKUP_DATAHUB is not set."
  exit 1
fi

# Interactive restore menu
if [ "$1" == "--menu" ]; then
  base_dir="$RUTA_BACKUP_DATAHUB/datahub_backup"

  if [ ! -d "$base_dir" ]; then
    echo "❌ Backup base directory does not exist: $base_dir"
    exit 1
  fi

  echo "📂 Available backup months:"
  select folder in $(find "$base_dir" -maxdepth 1 -type d -printf "%f\n" | grep -E '^[0-9]{4}_[0-9]{2}$' | sort) "Exit"; do
    if [ "$folder" == "Exit" ]; then
      echo "👋 Exiting..."
      exit 0
    elif [ -n "$folder" ]; then
      folder_path="$base_dir/$folder"
      break
    else
      echo "❗ Invalid option. Try again."
    fi
  done

  echo "🗃 Available backups in $folder:"
  select file in $(ls "$folder_path" | grep '\.sql_part_aa$' | sed 's/_part_aa$//'); do
    if [ -n "$file" ]; then
      selected_file="$file"
      break
    fi
  done

  echo "🔄 Reconstructing $selected_file from parts..."
  cat "$folder_path/${selected_file}_part_"* > "$folder_path/${selected_file}_reconstructed.sql"
  echo "✅ Reconstructed file: $folder_path/${selected_file}_reconstructed.sql"

  echo "📁 Changing directory to parent of backup folder..."
  cd "$RUTA_BACKUP_DATAHUB"
  exec $SHELL
  exit 0
fi

# Create folder name and timestamp
folder=$(date +"%Y_%m")
timestamp=$(date +"%Y%m%d")

# Create the full backup file path
backup_dir="$RUTA_BACKUP_DATAHUB/datahub_backup/$folder"
mkdir -p "$backup_dir"
backup_file="$backup_dir/backup_datahub_${timestamp}.sql"

# Create the backup
echo "📦 Creating backup at: $backup_file"
datahub docker quickstart --backup --backup-file "$backup_file"

# Split the backup file into parts of 100MB each
echo "🪓 Splitting backup file into 100MB chunks..."
split -b 100M "$backup_file" "${backup_file}_part_"

# Remove the original full backup to save space
rm "$backup_file"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "✅ Backup created and split successfully."
else
  echo "❌ Error occurred during backup creation."
  exit 1
fi