#!/bin/bash

wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf
rm -rf /etc/samba/smb.conf.old
mv /etc/samba/smb.conf /etc/samba/smb.conf.old
mv smb.conf /etc/samba/smb.conf

wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh
mkdir /etc/RJIDocker/
rm -rf /etc/RJIDocker/Docker.sh
mv Docker.sh /etc/RJIDocker/Docker.sh

rm -rf .bashrc.old
mv .bashrc .bashrc.old
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc
