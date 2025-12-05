#!/bin/sh

# --------------------------------------------------
# CRÉATION DES POINTS DE MONTAGE (ROBUSTE)
# --------------------------------------------------
mkdir -p /media/Films01 /media/Films02 /media/Series01 /media/Series02 /media/Series03 /media/Docs01 /media/Runable /media/Temp /media/Archive

# --------------------------------------------------
# ATTRIBUTION DES DROITS D'UTILISATION (Assurez-vous que l'utilisateur 'royjohan' a les droits)
# --------------------------------------------------
chown royjohan:royjohan /media/Films01 /media/Films02 /media/Series01 /media/Series02 /media/Series03 /media/Docs01 /media/Runable /media/Archive

# --------------------------------------------------
# AJOUT DANS /etc/fstab (Conditionnel : évite les doublons)
# --------------------------------------------------

# /media/Series01
UUID_SERIES1="07C1B017487CD384"
if ! grep -q "$UUID_SERIES1" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_SERIES1 /media/Series01 auto noatime 0 1" >> /etc/fstab
fi

# /media/Series02
UUID_SERIES2="0C2020846A4195D6"
if ! grep -q "$UUID_SERIES2" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_SERIES2 /media/Series02 auto noatime 0 1" >> /etc/fstab
fi

# /media/Series03
UUID_SERIES3="6877284162D6D93C"
if ! grep -q "$UUID_SERIES3" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_SERIES3 /media/Series03 auto noatime 0 1" >> /etc/fstab
fi

# /media/Films01
UUID_FILMS1="23BF5EEE4C02F6EE"
if ! grep -q "$UUID_FILMS1" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_FILMS1 /media/Films01 auto noatime 0 1" >> /etc/fstab
fi

# /media/Films02
UUID_FILMS2="E8D250EAD250BF0E"
if ! grep -q "$UUID_FILMS2" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_FILMS2 /media/Films02 auto noatime 0 1" >> /etc/fstab
fi

# /media/Docs01
UUID_DOCS1="1233D736318CD68C"
if ! grep -q "$UUID_DOCS1" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_DOCS1 /media/Docs01 auto noatime 0 1" >> /etc/fstab
fi

# /media/Runable
UUID_RUNABLE="00C52F7F6202AA50"
if ! grep -q "$UUID_RUNABLE" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_RUNABLE /media/Runable auto noatime 0 1" >> /etc/fstab
fi

# /media/Archive
UUID_ARCHIVE="294D561D3EF1F925"
if ! grep -q "$UUID_ARCHIVE" /etc/fstab; then
    echo "/dev/disk/by-uuid/$UUID_ARCHIVE /media/Archive auto noatime 0 1" >> /etc/fstab
fi

# --------------------------------------------------
# MONTAGE DES NOUVEAUX PÉRIPHÉRIQUES
# --------------------------------------------------
mount -a --onlyonce


##################################################
# @Date : 05/12/2025 12:48
# @Author : @ROYJohan
# @Version : 12b
##################################################
