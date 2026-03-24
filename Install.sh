#!/bin/bash

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then 
  echo "Veuillez lancer ce script en tant que root (sudo)."
  exit
fi

# --- Détection du Mode ---
if [ ! -d "/etc/RJIDomoNas/" ]; then
    MODE="INSTALL"
    LOG_FILE="/etc/RJIDomoNas/Log/Install.log"
    echo "--- Démarrage du mode INSTALLATION ---"
else
    MODE="UPDATE"
    LOG_FILE="/etc/RJIDomoNas/Log/Update.log"
    echo "--- Démarrage du mode MISE À JOUR ---"
fi

# --- Configuration de l'environnement ---
mkdir -p /etc/RJIDomoNas/Old/
mkdir -p /etc/RJIDomoNas/Log/
chmod -R 777 /etc/RJIDomoNas/
chown -R royjohan:royjohan /etc/RJIDomoNas/
echo "Initialisation des fichiers : SUCCESS" > "$LOG_FILE"

# --- Mise à jour système ---
echo "Mise à jour des paquets système..."
apt-get update -y > /dev/null
apt-get full-upgrade -y > /dev/null
apt-get autoremove -y > /dev/null
apt-get autoclean -y > /dev/null
echo "Maintenance paquets : SUCCESS" >> "$LOG_FILE"

# --- Installation Docker & Dépendances ---
apt-get install ca-certificates curl gnupg -y > /dev/null
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2>/dev/null
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
add-apt-repository ppa:alessandro-strada/ppa -y > /dev/null
apt-get update -y > /dev/null
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y > /dev/null
echo "Installation/Update Docker : SUCCESS" >> "$LOG_FILE"

# --- Utilitaires divers ---
apt-get install git-all net-tools iperf smartmontools samba glances -y > /dev/null
ubuntu-drivers list --gpgpu > /dev/null
echo "Utilitaires (Git, Net, Disques, Samba, Glances) : SUCCESS" >> "$LOG_FILE"

# --- Configuration Samba ---
service smbd stop > /dev/null
[ -f /etc/samba/smb.conf ] && mv -f /etc/samba/smb.conf /etc/RJIDomoNas/Old/smb.conf
wget -qO /etc/samba/smb.conf https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/NAS/smb.conf
service smbd start > /dev/null

# --- Configuration Glances ---
systemctl disable glances.service > /dev/null
[ -f /etc/systemd/system/glances.service ] && mv -f /etc/systemd/system/glances.service /etc/RJIDomoNas/Old/glances.service
wget -qO /etc/systemd/system/glances.service https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/NAS/glances.service
systemctl enable glances.service > /dev/null

# --- Gestion des disques et Credentials ---
wget -qO /etc/RJIDomoNas/InstallDrives.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/NAS/InstallDrives.sh
# On lance l'installation des disques
sudo -u "$SUDO_USER" bash /etc/RJIDomoNas/InstallDrives.sh

if [ ! -f /etc/RJIDomoNas/credentials.sh ]; then
    wget -qO /etc/RJIDomoNas/credentials.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/NAS/credentials.sh
fi

if [ -f /media/Runable/Docker/credentials.sh ]; then
    cp -f /media/Runable/Docker/credentials.sh /etc/RJIDomoNas/credentials.sh
    echo "Restauration credentials depuis sauvegarde : SUCCESS" >> "$LOG_FILE"
fi

# --- Docker.sh ---
wget -qO /etc/RJIDomoNas/Docker.sh https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/NAS/Docker.sh
if [ "$MODE" == "INSTALL" ]; then
    bash /etc/RJIDomoNas/Docker.sh all
    echo "Lancement Docker.sh (Initial) : SUCCESS" >> "$LOG_FILE"
fi

# --- Bashrc & Aliases ---
rm -rf /home/royjohan/.bashrc.* /root/.bashrc.*
[ -f /home/royjohan/.bashrc ] && mv -f /home/royjohan/.bashrc /etc/RJIDomoNas/Old/royjohan.bashrc
wget -qO /home/royjohan/.bashrc https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/NAS/.bashrc
cp -f /home/royjohan/.bashrc /root/.bashrc
# On applique les changements pour la session actuelle
source /root/.bashrc

# --- Scripts additionnels (Archive & Seedbox) ---
wget -qO /etc/RJIDomoNas/Archive.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/main/Docs/NAS/Archive.sh
wget -qO /etc/Runable/DownBox/seedbox.sh https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/NAS/seedbox.sh 2>/dev/null

# --- Blocs spécifiques à l'INSTALLATION initiale ---
if [ "$MODE" == "INSTALL" ]; then
    # Cron
    apt-get install cron -y > /dev/null
    wget -qO /etc/RJIDomoNas/mycron https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/NAS/mycron
    sudo crontab /etc/RJIDomoNas/mycron

    # Désactivation Veille
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    echo -e "[Sleep]\nAllowSuspend=no\nAllowHibernation=no\nAllowSuspendThenHibernate=no\nAllowHybridSleep=no" > /etc/systemd/sleep.conf.d/nosuspend.conf
    echo 'sleep-inactive-ac-type="blank"' >> /etc/gdm3/greeter.dconf-defaults
    systemctl restart gdm3 2>/dev/null

    # Python
    add-apt-repository ppa:deadsnakes/ppa -y > /dev/null
    apt-get update -y > /dev/null
    apt-get install python3 python3-pip -y > /dev/null
fi

echo "Fin du SCRIPT ($MODE)" >> "$LOG_FILE"
echo "Opération terminée avec succès en mode $MODE."
