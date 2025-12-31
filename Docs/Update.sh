#!/bin/bash

mkdir /etc/RJIDomoNas/ > /dev/null
mkdir /etc/RJIDomoNas/Old/ > /dev/null
mkdir /etc/RJIDomoNas/Log/ > /dev/null
chmod -R 777 /etc/RJIDomoNas/ > /dev/null
chown -R royjohan:royjohan /etc/RJIDomoNas/ > /dev/null
echo "Creation des fichiers de travail: SUCCESS" > /etc/RJIDomoNas/Log/Update.log

apt-get update -y > /dev/null
apt-get full-upgrade -y > /dev/null
apt-get autoremove -y > /dev/null
apt-get autoclean -y > /dev/null
apt-get clean -y > /dev/null
echo "Installation des mises à jours et nettoyage des paquets: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install ca-certificates curl gnupg -y > /dev/null
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg > /dev/null
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
add-apt-repository ppa:alessandro-strada/ppa
apt-get update -y > /dev/null
apt-get full-upgrade -y > /dev/null
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y > /dev/null
echo "Installation de docker: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log


apt-get install git-all -y > /dev/null
apt-get install net-tools -y > /dev/null
apt-get install iperf -y > /dev/null
ubuntu-drivers list --gpgpu > /dev/null
echo "Installation de Git, net-tools, iperf et des driver gpgpu: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install smartmontools -y > /dev/null
echo "Installation des utilitaires de disks: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install samba -y > /dev/null
service smbd stop > /dev/null
mv -f /etc/samba/smb.conf /etc/RJIDomoNas/Old/smb.conf > /dev/null
wget -O /etc/samba/smb.conf https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf > /dev/null
service smbd start > /dev/null
echo "Installation et configuration de samba: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

apt-get install glances -y > /dev/null
systemctl disable glances.service  > /dev/null
mv -f /etc/systemd/system/glances.service /etc/RJIDomoNas/Old/glances.service > /dev/null
wget -O /etc/systemd/system/glances.service https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/glances.service > /dev/null
systemctl enable glances.service > /dev/null
echo "Installation et configuration de glances: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

wget -O /etc/RJIDomoNas/InstallDrives.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh > /dev/null
sudo -u "$SUDO_USER" bash /etc/RJIDomoNas/InstallDrives.sh > /dev/null
echo "Instalation des disques par defaut : WARNING" >> /etc/RJIDomoNas/Log/Update.log

FILE=/etc/RJIDomoNas/credentials.sh
if test -f "$FILE"; then
    echo "Le fichier de mot de passe est déjà présent : WARNING" >> /etc/RJIDomoNas/Log/Update.log
else 
    wget -O /etc/RJIDomoNas/credentials.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/credentials.sh > /dev/null
    echo "Récupération du fichier de mot de passe par defaut: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log
fi
FILE=/media/Runable/Docker/credentials.sh
if test -f "$FILE"; then
    rm -rf /etc/RJIDomoNas/credentials.sh > /dev/null
    cp /media/Runable/Docker/credentials.sh /etc/RJIDomoNas/credentials.sh > /dev/null
    echo "Remplacement du fichier de mot de passe par une sauvegarde: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log
fi

bash /etc/RJIDomoNas/InstallDrives.sh > /dev/null
echo "Installation de tous les disques: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

wget -O /etc/RJIDomoNas/Docker.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh > /dev/null
echo "Récupération de Docker.sh: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

rm -rf /home/royjohan/.bashrc.* > /dev/null
rm -rf /root/.bashrc.* > /dev/null
mv -f /home/royjohan/.bashrc /etc/RJIDomoNas/Old/royjohan.bashrc > /dev/null
mv -f /root/.bashrc /etc/RJIDomoNas/Old/root.bashrc > /dev/null
wget -O /home/royjohan/.bashrc https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc > /dev/null
cp -f /home/royjohan/.bashrc /root/.bashrc > /dev/null
sudo -u "$SUDO_USER" bash -c "source /home/royjohan/.bashrc" > /dev/null
source /root/.bashrc > /dev/null
echo "Modification des alias: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log

wget -O /etc/RJIDomoNas/Archive.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/main/Docs/Archive.sh > /dev/null
echo "Installation du systeme d'archivage: SUCCESS" >> /etc/RJIDomoNas/Log/Update.log
echo "Fin du SCRIPT" >> /etc/RJIDomoNas/Log/Update.log
