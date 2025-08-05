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
wget --output-document /etc/samba/smb.conf https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/smb.conf
service smbd start

##################################################
#                Update Docker.sh                #
##################################################

rm -rf /etc/RJIDomoNas/Old/Docker.sh
mv -f /etc/RJIDomoNas/Docker.sh /etc/RJIDomoNas/Old/Docker.sh.
wget --output-document /etc/RJIDomoNas/Docker.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Docker.sh

##################################################
#                 Update  .bashrc                #
##################################################

rm -rf /home/royjohan/.bashrc.*
rm -rf /root/.bashrc.*
cp /home/royjohan/.bashrc /home/royjohan/.bashrc.old
cp /root/.bashrc /root/.bashrc.old
wget --output-document /home/royjohan/.bashrc https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/.bashrc
yes | cp -rf /home/royjohan/.bashrc /root/.bashrc
source /root/.bashrc
source /home/royjohan/.bashrc

##################################################
#           Update InstallDrives.sh              #
##################################################

rm -rf /etc/RJIDomoNas/Old/InstallDrives.sh
mv -f /etc/RJIDomoNas/InstallDrives.sh /etc/RJIDomoNas/Old/InstallDrives.sh
wget --output-document /etc/RJIDomoNas/InstallDrives.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/InstallDrives.sh

##################################################
#                  Update mycron                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/mycron
mv -f /etc/RJIDomoNas/mycron /etc/RJIDomoNas/Old/mycron
wget --output-document /etc/RJIDomoNas/mycron https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/mycron
sudo crontab /etc/RJIDomoNas/mycron

##################################################
#              Update Archive.sh                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/Archive.sh
mv -f /etc/RJIDomoNas/Archive.sh /etc/RJIDomoNas/Old/Archive.sh
wget --output-document /etc/RJIDomoNas/Archive.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Archive.sh

##################################################
#              Update Renamer.sh                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/Renamer.sh
mv -f /etc/RJIDomoNas/Renamer.sh /etc/RJIDomoNas/Old/Renamer.sh
wget --output-document /etc/RJIDomoNas/Renamer.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Renamer.sh

##################################################
#    @Date : 05/08/2025 12:57                    #
#    @Author : @ROYJohan                         #
#    @Version : 10b                              #
##################################################
