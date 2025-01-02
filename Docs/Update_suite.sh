#!/bin/bash
#Version 202501021741

mkdir /etc/RJIDocker/ # Create launcher folder
mkdir /etc/RJIDocker/old # Create launcher folder

rm -rf /etc/RJIDocker/old/Update.sh.old #Remove Oldest Update.sh
mv /etc/RJIDocker/Update_suite.sh /etc/RJIDocker/old/Update.sh.old #Save old Update.sh
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh #Get new Update.sh
mv Update_suite.sh /etc/RJIDocker/Update.sh #Move Udate.sh to the good directory

rm -rf /etc/RJIDocker/old/smb.conf.old # Remove oldest config
mv /etc/samba/smb.conf /etc/RJIDocker/old/smb.conf.old # Save old config
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf -P /etc/samba/ # Get samba config.
service smbd restart # Restart samba


rm -rf /etc/RJIDocker/old/Docker.sh.old # Remove oldest launcher
mv /etc/RJIDocker/Docker.sh /etc/RJIDocker/old/Docker.sh.old # Save old config.
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh -P /etc/RJIDocker/ # Get Docker launcher

rm -rf /etc/RJIDocker/old/.bashrc.old # Remove Oldest BashRC
cp ~/.bashrc /etc/RJIDocker/old/.bashrc.old # Save old bashRc
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc -P /etc/RJIDocker/ -O .bashrc.new > /dev/null # Get new bashrc
cp -rf /etc/RJIDocker/.bashrc.new ~/.bashrc
cp -rf /etc/RJIDocker/.bashrc.new /home/royjohan/.bashrc
source ~/.bashrc # Restart alias.
source /home/royjohan/.bashrc # Restart alias.

rm -rf /etc/RJIDocker/old/InstallDrives.sh.old # Remove Oldest Update
mv /etc/RJIDocker/InstallDrives.sh /etc/RJIDocker/old/InstallDrives.sh.old # Save old Update
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh -P /etc/RJIDocker/ > /dev/null #Get new Update

wget https://github.com/ROYJohan08/RJI-DomoNas/raw/main/Docs/mycron -P ~/ # Get Crontab
sudo crontab ~/mycron # Set Crontab into crontab
rm ~/mycron # Remove temp crontab

rm -rf /etc/RJIDocker/old/TvShowStorage.py.old # Remove Oldest Update
mv /etc/RJIDocker/TvShowStorage.py /etc/RJIDocker/old/TvShowStorage.py.old # Save old Update
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/TvShowStorage.py -P /etc/RJIDocker/  > /dev/null
