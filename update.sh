sudo cp backup.service /etc/systemd/system 
sudo systemctl start backup.service
sudo systemctl enable backup.service
echo "done"
