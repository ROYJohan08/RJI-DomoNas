#!/bin/sh

# --------------------------------------------------
# CRÉATION DES POINTS DE MONTAGE
# --------------------------------------------------
# Utilisation de mkdir -p pour éviter les erreurs si le dossier existe déjà
mkdir -p /media/Films01 /media/Films02 /media/Series01 /media/Series02 /media/Series03 /media/Docs01 /media/Runable /media/Temp /media/Archive

# --------------------------------------------------
# AJOUT DANS /etc/fstab
# --------------------------------------------------
# Note : On ajoute 'nofail' pour éviter que le PC bloque au démarrage si un disque est débranché.
# On ajoute 'umask=000' pour donner les droits 777 (tout le monde) automatiquement au montage.

# Fonction pour ajouter proprement au fstab sans doublons (optionnel mais conseillé)
add_to_fstab() {
    UUID=$1
    MOUNT_POINT=$2
    if ! grep -qs "$UUID" /etc/fstab; then
        echo "UUID=$UUID $MOUNT_POINT auto nosuid,nodev,nofail,xtime,umask=000 0 0" >> /etc/fstab
    fi
}

add_to_fstab "07C1B017487CD384" "/media/Series01"
add_to_fstab "0C2020846A4195D6" "/media/Series02"
add_to_fstab "6877284162D6D93C" "/media/Series03"
add_to_fstab "23BF5EEE4C02F6EE" "/media/Films01"
add_to_fstab "E8D250EAD250BF0E" "/media/Films02"
add_to_fstab "1233D736318CD68C" "/media/Docs01"
add_to_fstab "00C52F7F6202AA50" "/media/Runable"
add_to_fstab "294D561D3EF1F925" "/media/Archive"

# --------------------------------------------------
# MONTAGE ET DROITS FINAUX
# --------------------------------------------------
mount -a

# On réapplique les droits après le montage pour les systèmes de fichiers Linux (ext4)
chmod -R 777 /media/
chown -R royjohan:royjohan /media/

echo "Disques montés avec accès universel."

##################################################
# @Date : 05/12/2025 12:48
# @Author : @ROYJohan
# @Version : 12c (Updated for permissions)
##################################################
