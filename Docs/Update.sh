#!/bin/bash

mkdir /etc/RJIDomoNas/
mkdir /etc/RJIDomoNas/Old/
mkdir /etc/RJIDomoNas/Log/
chmod -R 777 /etc/RJIDomoNas/
chown -R royjohan:royjohan /etc/RJIDomoNas/
echo "Creation des fichiers de travail : PASS" > /etc/RJIDomoNas/Log/Update.log

apt-get update -y
apt-get full-upgrade -y
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
echo "Installation des mises à jours et nettoyage des paquets : PASS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
add-apt-repository ppa:alessandro-strada/ppa
apt-get update -y
apt-get full-upgrade -y
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Installation de docker : PASS" >> /etc/RJIDomoNas/Log/Update.log


apt-get install git-all -y
apt-get install net-tools -y
apt-get install iperf -y
ubuntu-drivers list --gpgpu
echo "Installation de Git, net-tools, iperf et des driver gpgpu : PASS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install smartmontools -y
echo "Installation des utilitaires de disks : PASS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install samba -y
service smbd stop
mv -f /etc/samba/smb.conf /etc/RJIDomoNas/Old/smb.conf
wget -O /etc/samba/smb.conf https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf
service smbd start
echo "Installation et configuration de samba : PASS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install glances -y
systemctl disable glances.service 
mv -f /etc/systemd/system/glances.service /etc/RJIDomoNas/Old/glances.service
wget -O /etc/systemd/system/glances.service https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/glances.service
systemctl enable glances.service
echo "Installation et configuration de glances : PASS" >> /etc/RJIDomoNas/Log/Update.log

wget -O /etc/RJIDomoNas/InstallDrives.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh
sudo -u "$SUDO_USER" bash /etc/RJIDomoNas/InstallDrives.sh
echo "Instalation des disques par defaut : WARNING" >> /etc/RJIDomoNas/Log/Update.log

FILE=/etc/RJIDomoNas/credentials.sh
if test -f "$FILE"; then
    echo "Le fichier de mot de passe est déjà présent : WARNING" >> /etc/RJIDomoNas/Log/Update.log
else 
    wget -O /etc/RJIDomoNas/credentials.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/credentials.sh
    echo "Récupération du fichier de mot de passe par defaut : PASS" >> /etc/RJIDomoNas/Log/Update.log
fi
FILE=/media/Runable/Docker/credentials.sh
if test -f "$FILE"; then
    rm -rf /etc/RJIDomoNas/credentials.sh
    cp /media/Runable/Docker/credentials.sh /etc/RJIDomoNas/credentials.sh
    echo "Remplacement du fichier de mot de passe par une sauvegarde : PASS" >> /etc/RJIDomoNas/Log/Update.log
fi

sudo -u "$SUDO_USER" bash /etc/RJIDomoNas/InstallDrives.sh
echo "Installation de tous les disques : PASS" >> /etc/RJIDomoNas/Log/Update.log

wget -O /etc/RJIDomoNas/Docker.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh
echo "Récupération de Docker.sh : PASS" >> /etc/RJIDomoNas/Log/Update.log

rm -rf /home/royjohan/.bashrc.*
rm -rf /root/.bashrc.*
mv -f /home/royjohan/.bashrc /etc/RJIDomoNas/Old/royjohan.bashrc
mv -f /root/.bashrc /etc/RJIDomoNas/Old/root.bashrc
wget -O /home/royjohan/.bashrc https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc
cp -f /home/royjohan/.bashrc /root/.bashrc
sudo -u "$SUDO_USER" bash -c "source /home/royjohan/.bashrc"
source /root/.bashrc
echo "Modification des alias : PASS" >> /etc/RJIDomoNas/Log/Update.log

wget -O /etc/RJIDomoNas/Archive.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/main/Docs/Archive.sh
echo "Installation du systeme d'archivage : PASS" >> /etc/RJIDomoNas/Log/Update.log
