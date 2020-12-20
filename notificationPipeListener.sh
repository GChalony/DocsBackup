#!/bin/bash

NOTIF_PIPE=/home/gregnix/Documents/Informatique/bash/DocsBackup/pipe
LOG_FILE=/home/gregnix/Documents/Informatique/bash/DocsBackup/backups.log

echo "Started at $(date)" > $LOG_FILE
while :
do 
	while read p
	do 
		echo Pipe read $p >> $LOG_FILE
		notify-send Backup "$p"
	done < pipe
done
