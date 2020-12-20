#!/bin/bash

LOG_FILE=/home/gregnix/Documents/Informatique/bash/DocsBackup/backups.log
DAYS_THRESHOLD=1
BACKUP_FOLDER=/media/gregnix/GregWD/Backups

NOTIFICATION_PIPE=/home/gregnix/Documents/Informatique/bash/DocsBackup/pipe

log() {
	echo $(date +'%Y-%m-%d %H:%M:%S') $1 >> $LOG_FILE
}

sendNotif(){
	echo $1 > $NOTIFICATION_PIPE
}

datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d2 - d1) / 86400 ))
}

computeDateDelta(){
	d1=$(date -I --date=${f#*_})				# Parsed date from folder name
	d2=$(date -I)								# Current date

	delta=$(datediff "$d1" "$d2")				# Number of days separating the two
	echo $delta
}

computeNbDifferentFiles(){
	# Compute number of different files
	n=0;
	while read p;
		do 
			folder=$(basename $p);
			d=$(diff $p $f/$folder | wc -l);
			n=$(( n + d ));
	done < folders_to_backup.txt
	echo $n
}

log "Starting backup scan"
f=$(echo $BACKUP_FOLDER/Back* | tail -n 1)	# Last backup folder

delta=$(computeDateDelta)
log "$delta jours depuis la dernière backup"

n=$(computeNbDifferentFiles)
log "$n fichiers differents"

if [ $delta -ge $DAYS_THRESHOLD ]
then
	log "Should do backup, sending notification"
	msg="$delta jours depuis la dernière backup ($n fichiers differents)"
	log "Notification: $msg"
	sendNotif "$msg"
else
	log "No need for backup"
fi
log "Scan done"
