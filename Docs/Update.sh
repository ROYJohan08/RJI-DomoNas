#!/bin/bash

rm -rf /etc/samba/smb.conf.old # Remove oldest config
mv /etc/samba/smb.conf /etc/samba/smb.conf.old # Save old config
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf # Get samba config.
mv smb.conf /etc/samba/smb.conf # Set new config
service smbd restart # Restart samba

mkdir /etc/RJIDocker/ # Create launcher folder
rm -rf /etc/RJIDocker/Docker.sh # Remove old launcher
mv /etc/RJIDocker/Docker.sh /etc/RJIDocker/Docker.sh.old # Save old config.
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh # Get Docker launcher
mv Docker.sh /etc/RJIDocker/Docker.sh # Set the new Launcher

rm -rf .bashrc.old # Remove Oldest BashRC
mv .bashrc .bashrc.old # Save old bashRc
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc # Get new bashrc
source .bashrc # Restart alias.

rm -rf Update.sh.old # Remove Oldest Update
mv /etc/RJIDocker/Update.sh /etc/RJIDocker/Update.sh.old # Save old Update
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh #Get new Update
mv Update.sh /etc/RJIDocker/Update.sh # Move to folder

rm -rf InstallDrives.sh.old # Remove Oldest Update
mv InstallDrives.sh InstallDrives.sh.old # Save old Update
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh #Get new Update

wget https://github.com/ROYJohan08/RJI-DomoNas/raw/main/Docs/mycron # Get Crontab
sudo crontab mycron # Set Crontab into crontab
rm mycron # Remove temp crontab
