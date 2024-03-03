#!/bin/bash
     
     # Define variables
     SOURCE_DIR="/path/to/source"
     BACKUP_DIR="/path/to/backup"
     DATE=$(date +"%Y%m%d_%H%M%S")
     BACKUP_FILE="backup_$DATE.tar.gz"
     
     # Create backup
     tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"
     
     # Optional: Clean up old backups
     # find $BACKUP_DIR -type f -name "backup_*" -mtime +7 -exec rm {} \;