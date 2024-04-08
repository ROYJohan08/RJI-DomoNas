#!/bin/bash

wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf # Get samba config.
rm -rf /etc/samba/smb.conf.old # Remove oldest config
mv /etc/samba/smb.conf /etc/samba/smb.conf.old # Save old config
mv smb.conf /etc/samba/smb.conf #Set new config
service smbd restart #Restart samba

wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh # Get Docker launcher
mkdir /etc/RJIDocker/ # Create launcher folder
rm -rf /etc/RJIDocker/Docker.sh # Remove old launcher
mv Docker.sh /etc/RJIDocker/Docker.sh # Set the new Launcher

rm -rf .bashrc.old # Remove Oldest BashRC
mv .bashrc .bashrc.old# Save old bashRc
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc #Get new bashrc
source .bashrc
