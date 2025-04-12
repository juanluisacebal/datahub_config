#!/bin/bash

echo "👤 HOME is: $HOME"
echo "📂 RUTA_BACKUP_DATAHUB is: $RUTA_BACKUP_DATAHUB"

# Try to load environment variables if they exist in the user's .bashrc
if [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi

# Use a default path if not already defined
RUTA_BACKUP_DATAHUB="${RUTA_BACKUP_DATAHUB:-$HOME/.datahub}"

# Execute the backup script
"$RUTA_BACKUP_DATAHUB/backup.sh"