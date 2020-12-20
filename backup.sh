#!/bin/bash
BACKUP_FOLDER=/media/gregnix/GregWD/Backups
N_ROTATION=2
LOG_FILE=/home/gregnix/Documents/Informatique/bash/DocsBackup/backups.log

log() {
	echo $(date +'%Y-%m-%d %H:%M:%S') $1 >> $LOG_FILE
}


f=$(cat folders_to_backup.txt)

log "Backing up: $f"

rsync -aL --info=progress2 --delete --progress $f $BACKUP_FOLDER/Backup_$(date +%Y-%m-%d)

n=$(echo $BACKUP_FOLDER/Backup* | wc -w)
if [ $n -gt $N_ROTATION ]
then
	oldest=$(echo $BACKUP_FOLDER/Backup* | head -n 1)
	log "Removing backup $oldest"
	rm -r "$oldest"
fi
