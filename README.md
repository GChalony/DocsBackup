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

## Issue with Systemd and DBus

A process started from a systemd unit is by default not connected to dbus, and therefore cannot send notification to gnome (with `notify-send`).  
Despite all my reading, I couldn't find any solution.

I eventually decided to change a bit the design by using a named pipe:
- the process invoke by systemd would simply send notification to a pipe.
- a background (_user space_) process would read from this pipe and create the notification. 

This solution should be very efficient in ressources (no polling), and the background process (`notificationPipeListener.sh`) can be added in startup application to be started in user space at logging.

And guess what, it works like a charm :sunglasses:
