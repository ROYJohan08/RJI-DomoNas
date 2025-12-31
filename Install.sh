#!/bin/bash

mkdir /etc/RJIDomoNas/
mkdir /etc/RJIDomoNas/Old/
mkdir /etc/RJIDomoNas/Log/
chmod -R 777 /etc/RJIDomoNas/
chown -R royjohan:royjohan /etc/RJIDomoNas/
echo "Creation des fichiers de travail : PASS" > /etc/RJIDomoNas/Log/Install.sh

apt-get update -y
apt-get full-upgrade -y
apt-get autoremove -y
apt-get autoclean -y
apt-get clean -y
echo "Installation des mises à jours et nettoyage des paquets : PASS" >> /etc/RJIDomoNas/Log/Install.sh

apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
add-apt-repository ppa:alessandro-strada/ppa
apt-get update -y
apt-get full-upgrade -y
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Installation de docker : PASS" >> /etc/RJIDomoNas/Log/Install.sh


apt-get install git-all -y
apt-get install net-tools -y
apt-get install iperf -y
ubuntu-drivers list --gpgpu
echo "Installation de Git, net-tools, iperf et des driver gpgpu : PASS" >> /etc/RJIDomoNas/Log/Install.sh

apt-get install smartmontools -y
echo "Installation des utilitaires de disks : PASS" >> /etc/RJIDomoNas/Log/Install.sh

apt-get install samba -y
service smbd stop
mv -f /etc/samba/smb.conf /etc/RJIDomoNas/Old/smb.conf
wget -O /etc/samba/smb.conf https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf
service smbd start
echo "Installation et configuration de samba : PASS" >> /etc/RJIDomoNas/Log/Install.sh

apt-get install glances -y
systemctl disable glances.service 
mv -f /etc/systemd/system/glances.service /etc/RJIDomoNas/Old/glances.service
wget -O /etc/systemd/system/glances.service https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/glances.service
systemctl enable glances.service
echo "Installation et configuration de glances : PASS" >> /etc/RJIDomoNas/Log/Install.sh

wget -O /etc/RJIDomoNas/InstallDrives.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh
sudo -u "$SUDO_USER" bash /etc/RJIDomoNas/InstallDrives.sh
echo "Instalation des disques par defaut : WARNING" >> /etc/RJIDomoNas/Log/Install.sh

FILE=/etc/RJIDomoNas/credentials.sh
if test -f "$FILE"; then
    echo "Le fichier de mot de passe est déjà présent : WARNING" >> /etc/RJIDomoNas/Log/Install.sh
else 
    wget -O /etc/RJIDomoNas/credentials.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/credentials.sh
    echo "Récupération du fichier de mot de passe par defaut : PASS" >> /etc/RJIDomoNas/Log/Install.sh
fi
FILE=/media/Runable/Docker/credentials.sh
if test -f "$FILE"; then
    rm -rf /etc/RJIDomoNas/credentials.sh
    cp /media/Runable/Docker/credentials.sh /etc/RJIDomoNas/credentials.sh
    echo "Remplacement du fichier de mot de passe par une sauvegarde : PASS" >> /etc/RJIDomoNas/Log/Install.sh
else 
    
fi

sudo -u "$SUDO_USER" bash /etc/RJIDomoNas/InstallDrives.sh
echo "Installation de tous les disques : PASS" >> /etc/RJIDomoNas/Log/Install.sh

wget -O /etc/RJIDomoNas/Docker.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh
bash /etc/RJIDomoNas/Docker.sh all
echo "Récupération et lancement de Docker.sh : PASS" >> /etc/RJIDomoNas/Log/Install.sh

rm -rf /home/royjohan/.bashrc.*
rm -rf /root/.bashrc.*
mv -f /home/royjohan/.bashrc /etc/RJIDomoNas/Old/royjohan.bashrc
mv -f /root/.bashrc /etc/RJIDomoNas/Old/root.bashrc
wget -O /home/royjohan/.bashrc https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc
cp -f /home/royjohan/.bashrc /root/.bashrc
sudo -u "$SUDO_USER" bash -c "source /home/royjohan/.bashrc"
source /root/.bashrc
echo "Modification des alias : PASS" >> /etc/RJIDomoNas/Log/Install.sh

wget -O /etc/RJIDomoNas/Update.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh
echo "Récupération du systeme de mises à jours : PASS" >> /etc/RJIDomoNas/Log/Install.sh

apt-get install cron -y
mv -f /etc/RJIDomoNas/mycron /etc/RJIDomoNas/Old/mycron
wget -O /etc/RJIDomoNas/mycron https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/mycron
sudo crontab /etc/RJIDomoNas/mycron
echo "Récupération et installation des taches cron : PASS" >> /etc/RJIDomoNas/Log/Install.sh

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
touch /etc/systemd/sleep.conf.d/nosuspend.conf
echo "[Sleep]" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowSuspend=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowHibernation=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowSuspendThenHibernate=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo "AllowHybridSleep=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
echo 'sleep-inactive-ac-type="blank"' >> /etc/gdm3/greeter.dconf-defaults
systemctl restart gdm3
echo "Supression de la veille : PASS" >> /etc/RJIDomoNas/Log/Install.sh

add-apt-repository ppa:deadsnakes/ppa
apt-get update -y
apt-get full-upgrade -y
apt-get install python3 -y
apt-get install python3-pip -y
echo "Instation de python : PASS" >> /etc/RJIDomoNas/Log/Install.sh

wget -O /etc/RJIDomoNas/Archive.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/main/Docs/Archive.sh
echo "Installation du systeme d'archivage : PASS" >> /etc/RJIDomoNas/Log/Install.sh
