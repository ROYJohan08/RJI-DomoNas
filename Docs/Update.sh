#!/bin/bash

rm -rf /etc/samba/smb.conf.old # Remove oldest config
mv /etc/samba/smb.conf /etc/samba/smb.conf.old # Save old config
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf -P /etc/samba/ > /dev/null # Get samba config.
service smbd restart # Restart samba

mkdir /etc/RJIDocker/ # Create launcher folder

rm -rf /etc/RJIDocker/Docker.sh.old # Remove oldest launcher
mv /etc/RJIDocker/Docker.sh /etc/RJIDocker/Docker.sh.old # Save old config.
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh -P /etc/RJIDocker/ > /dev/null # Get Docker launcher

rm -rf ~/.bashrc.old # Remove Oldest BashRC
cp ~/.bashrc ~/.bashrc.old # Save old bashRc
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc -P /etc/RJIDocker/ -O .bashrc.new > /dev/null # Get new bashrc
cp -rf /etc/RJIDocker/.bashrc.new ~/.bashrc
cp -rf /etc/RJIDocker/.bashrc.new /home/royjohan/.bashrc
source ~/.bashrc # Restart alias.
source /home/royjohan/.bashrc # Restart alias.

rm -rf /etc/RJIDocker/Update.sh.old # Remove Oldest Update
mv /etc/RJIDocker/Update.sh /etc/RJIDocker/Update.sh.old # Save old Update
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh -P /etc/RJIDocker/ > /dev/null #Get new Update

rm -rf /etc/RJIDocker/InstallDrives.sh.old # Remove Oldest Update
mv /etc/RJIDocker/InstallDrives.sh /etc/RJIDocker/InstallDrives.sh.old # Save old Update
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh -P /etc/RJIDocker/ > /dev/null #Get new Update

wget https://github.com/ROYJohan08/RJI-DomoNas/raw/main/Docs/mycron -P ~/ # Get Crontab
sudo crontab ~/mycron # Set Crontab into crontab
rm ~/mycron # Remove temp crontab

rm -rf /etc/RJIDocker/TvShowStorage.py.old # Remove Oldest Update
mv /etc/RJIDocker/TvShowStorage.py /etc/RJIDocker/TvShowStorage.py.old # Save old Update
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/TvShowStorage.py -P /etc/RJIDocker/  > /dev/null
