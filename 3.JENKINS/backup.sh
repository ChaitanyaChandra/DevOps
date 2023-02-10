#!/bin/bash

# Define the backup directory
BACKUP_DIR=~/jenkins-backups

# Create the backup directory if it does not exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir $BACKUP_DIR
fi

# Get the current date and time for the backup file name
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the backup file name
BACKUP_FILE=$BACKUP_DIR/jenkins-config-$DATE.tar.gz

# Backup only the Jenkins configuration directory
tar -czf $BACKUP_FILE /var/lib/jenkins/config.xml /var/lib/jenkins/hudson.model.* /var/lib/jenkins/users

# Print a message indicating that the backup is complete
echo "Jenkins configuration backup complete: $BACKUP_FILE"