#!/bin/bash

##################################################
#              Installing upgrade                #
##################################################

apt-get update -y
apt-get full-upgrade -y

##################################################
#              Create work folders               #
##################################################

mkdir /etc/RJIDomoNas/ > /dev/null
mkdir /etc/RJIDomoNas/Old/ > /dev/null

##################################################
#                   Update samba                 #
##################################################

service smbd sto
rm -rf /etc/samba/smb.conf.*
mv -f /etc/samba/smb.conf /etc/samba/smb.conf.old
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/smb.conf
mv -f ./smb.conf /etc/samba/smb.conf
service smbd start

##################################################
#                Update Docker.sh                #
##################################################

rm -rf /etc/RJIDomoNas/Old/Docker.sh
mv -f /etc/RJIDomoNas/Docker.sh /etc/RJIDomoNas/Old/Docker.sh.
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Docker.sh
mv -f ./Docker.sh /etc/RJIDomoNas/Docker.sh

##################################################
#                 Update  .bashrc                #
##################################################

rm -rf /home/royjohan/.bashrc.*
rm -rf /root/.bashrc.*
cp /home/royjohan/.bashrc /home/royjohan/.bashrc.old
cp /root/.bashrc /root/.bashrc.old
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/.bashrc
yes | cp -rf .bashrc /home/royjohan/.bashrc
yes | cp -rf /home/royjohan/.bashrc /root/.bashrc
source /root/.bashrc
source /home/royjohan/.bashrc

##################################################
#           Update InstallDrives.sh              #
##################################################

rm -rf /etc/RJIDomoNas/Old/InstallDrives.sh
mv -f /etc/RJIDomoNas/InstallDrives.sh /etc/RJIDomoNas/Old/InstallDrives.sh
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/InstallDrives.sh
mv ./InstallDrives.sh /etc/RJIDomoNas/InstallDrives.sh

##################################################
#                  Update mycron                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/mycron
mv -f /etc/RJIDomoNas/mycron /etc/RJIDomoNas/Old/mycron
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/mycron
mv -f ./mycron /etc/RJIDomoNas/mycron
sudo crontab /etc/RJIDomoNas/mycron

##################################################
#              Update Archive.sh                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/Archive.sh
mv -f /etc/RJIDomoNas/Archive.sh /etc/RJIDomoNas/Old/Archive.sh
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Archive.sh
mv -f ./Archive.sh /etc/RJIDomoNas/Archive.sh

##################################################
#              Update Renamer.sh                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/Renamer.sh
mv -f /etc/RJIDomoNas/Renamer.sh /etc/RJIDomoNas/Old/Renamer.sh
wget -r https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Renamer.sh
mv -f ./Renamer.sh /etc/RJIDomoNas/Renamer.sh

##################################################
#    @Date : 05/08/2025 12:57                    #
#    @Author : @ROYJohan                         #
#    @Version : 10b                              #
##################################################
