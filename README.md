# My Custom Backup strategy

Docs are backed up on my external hard drive, so I can't cron the task.

Desired flow is:
- Whenever external drive is plugged, check if backup should be done
	- If more than x days past, or y Mo changed, or z files were changed
- If so, inform the user (via Gnome Notification?)
- When backing up, copy all folders to EHDD, with rotating backup folders (two?)

## Current implementation

- `on_plugged.sh` script is triggered by systemd, whenever the external hard drive is mounted.
- it checks the date of the last modified folder in the folder backup, and if it's been more than 30 days, it shows a Gnome Notification to the user (with the number of files that were modified)
- `backup.sh`: script to backup all folders listed in `folders_to_backup.txt` to the backup folder using `rsync`. Keeps only 2 backups.
