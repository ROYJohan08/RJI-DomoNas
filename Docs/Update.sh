#!/bin/bash

##################################################
#              Installing upgrade                #
##################################################

apt-get update -y
apt-get full-upgrade -y
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y

##################################################
#              Create work folders               #
##################################################

mkdir /etc/RJIDomoNas/
mkdir /etc/RJIDomoNas/Old/

##################################################
#                Install docker                  #
##################################################

apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
add-apt-repository ppa:alessandro-strada/ppa
apt-get update -y
apt-get full-upgrade -y
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

##################################################
#                 Install net tools              #
##################################################


apt-get install git-all -y
apt-get install net-tools -y
apt-get install iperf -y
ubuntu-drivers list --gpgpu

##################################################
#              Install disk tools                #
##################################################

apt-get install smartmontools -y

##################################################
#                    Install Samba               #
##################################################

apt-get install samba -y
service smbd stop
rm -rf /etc/samba/smb.conf.*
mv -f /etc/samba/smb.conf /etc/samba/smb.conf.old
wget -O /etc/samba/smb.conf https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf
service smbd start

##################################################
#                   Install Glances              #
##################################################

apt-get install glances -y
systemctl disable glances.service 
rm -rf /etc/systemd/system/glances.service.*
mv -f /etc/systemd/system/glances.service /etc/systemd/system/glances.service.old
wget -O /etc/systemd/system/glances.service https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/glances.service
systemctl enable glances.service

##################################################
#            Install InstallDrives.sh            #
##################################################

rm -rf /etc/RJIDomoNas/Old/InstallDrives.sh
mv -f /etc/RJIDomoNas/InstallDrives.sh /etc/RJIDomoNas/Old/InstallDrives.sh
wget -O /etc/RJIDomoNas/InstallDrives.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh
bash /etc/RJIDomoNas/InstallDrives.sh

##################################################
#                Install Docker.sh               #
##################################################

rm -rf /etc/RJIDomoNas/Old/Docker.sh
mv -f /etc/RJIDomoNas/Docker.sh /etc/RJIDomoNas/Old/Docker.sh
wget -O /etc/RJIDomoNas/Docker.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh

##################################################
#                Install .bashrc                 #
##################################################

rm -rf /home/royjohan/.bashrc.*
rm -rf /root/.bashrc.*
mv -f /home/royjohan/.bashrc /home/royjohan/.bashrc.old
mv -f /root/.bashrc /root/.bashrc.old
wget -O /home/royjohan/.bashrc https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc
cp -f /home/royjohan/.bashrc /root/.bashrc
sudo -u royjohan bash -c "source /home/royjohan/.bashrc"
source /root/.bashrc

##################################################
#              Install Update.sh                 #
##################################################

rm -rf /etc/RJIDomoNas/Old/Update.sh
mv -f /etc/RJIDomoNas/Update.sh /etc/RJIDomoNas/Old/Update.sh
wget -O /etc/RJIDomoNas/Update.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh

##################################################
#                Install crontab                 #
##################################################

apt-get install cron -y
rm -rf /etc/RJIDomoNas/Old/mycron
mv -f /etc/RJIDomoNas/mycron /etc/RJIDomoNas/Old/mycron
wget -O /etc/RJIDomoNas/mycron https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/mycron
sudo crontab /etc/RJIDomoNas/mycron

##################################################
#                Install nohibernate             #
##################################################

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
touch /etc/systemd/sleep.conf.d/nosuspend.conf
echo "[Sleep]" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowSuspend=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowHibernation=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowSuspendThenHibernate=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowHybridSleep=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo 'sleep-inactive-ac-type="blank"' >> /etc/gdm3/greeter.dconf-defaults
systemctl restart gdm3

##################################################
#                Install python                  #
##################################################

add-apt-repository ppa:deadsnakes/ppa
apt-get update -y
apt-get full-upgrade -y
apt-get install python3 -y
apt-get install python3-pip -y

##################################################
#               Set credential dataS             #
##################################################

FILE=/etc/RJIDomoNas/credentials.sh
if test -f "$FILE"; then
    echo "credentials set"
else 
    wget -O /etc/RJIDomoNas/credentials.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/credentials.sh
fi
FILE=/media/Runable/Docker/credentials.sh
if test -f "$FILE"; then
    rm -rf /etc/RJIDomoNas/credentials.sh
    cp /media/Runable/Docker/credentials.sh /etc/RJIDomoNas/credentials.sh
else 
    echo "no move"
fi

##################################################
#               Install Archive.sh               #
##################################################

rm -rf /etc/RJIDomoNas/Old/Archive.sh
mv -f /etc/RJIDomoNas/Archive.sh /etc/RJIDomoNas/Old/Archive.sh
wget -O /etc/RJIDomoNas/Archive.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/main/Docs/Archive.sh

##################################################
#                Create smb User                 #
##################################################

source /etc/RJIDomoNas/credentials.sh # Import credentials
echo -e "$Passpass\n$Passpass" | smbpasswd -a -s $User # Create new smbuser



##################################################
#    @Date : 05/12/2025 12:35                    #
#    @Author : @ROYJohan                         #
#    @Version : 12b                              #
##################################################
