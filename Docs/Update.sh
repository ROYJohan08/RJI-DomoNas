#!/bin/bash

mkdir /etc/RJIDomoNas/ # Create launcher folder
mkdir /etc/RJIDomoNas/Old # Create launcher folder

service smbd stop # Restart samba
rm -rf /etc/samba/smb.conf.old # Remove oldest config
mv /etc/samba/smb.conf /etc/samba/smb.conf.old # Save old config
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/smb.conf # Get samba config.
mv smb.conf /etc/samba/smb.conf
service smbd start # Restart samba


rm -rf /etc/RJIDomoNas/Old/Docker.sh # Remove oldest launcher
mv /etc/RJIDomoNas/Docker.sh /etc/RJIDomoNas/Old/Docker.sh # Save old config.
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Docker.sh
mv Docker.sh /etc/RJIDomoNas/Docker.sh

rm -rf /home/royjohan/.bashrc.old # Remove Oldest BashRC
rm -rf /root/.bashrc.old # Remove Oldest BashRC
cp /home/royjohan/.bashrc /home/royjohan/.bashrc.old # Save old bashRc
cp /root/.bashrc /root/.bashrc.old # Save old bashRc
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/.bashrc # Get new bashrc
mv -rf .bashrc /home/royjohan/.bashrc
cp -rf /home/royjohan/.bashrc /root/.bashrc
source /root/.bashrc # Restart alias.
source /home/royjohan/.bashrc # Restart alias.

rm -rf /etc/RJIDomoNas/Old/InstallDrives.sh # Remove Oldest Update
mv /etc/RJIDomoNas/InstallDrives.sh /etc/RJIDomoNas/Old/InstallDrives.sh # Save old Update
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/InstallDrives.sh #Get new Update
mv InstallDrives.sh /etc/RJIDomoNas/InstallDrives.sh

rm -rf /etc/RJIDomonas/Old/mycron
mv /etc/RJIDomonas/mycron /etc/RJIDomonas/Old/mycron
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/mycron # Get Crontab
mv mycron /etc/RJIDomonas/mycron
sudo crontab /etc/RJIDomonas/mycron # Set Crontab into crontab
