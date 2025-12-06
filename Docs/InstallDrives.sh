#!/bin/sh

# --------------------------------------------------
# CRÉATION DES POINTS DE MONTAGE (ROBUSTE)
# --------------------------------------------------
mkdir /media/Films01 
mkdir /media/Films02
mkdir/media/Series01
mkdir/media/Series02
mkdir/media/Series03
mkdir /media/Docs01 
mkdir /media/Runable
mkdir /media/Temp 

# --------------------------------------------------
# AJOUT DANS /etc/fstab (Conditionnel : évite les doublons)
# --------------------------------------------------

echo "/dev/disk/by-uuid/07C1B017487CD384 /media/Series01 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/0C2020846A4195D6 /media/Series02 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/6877284162D6D93C /media/Series03 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/23BF5EEE4C02F6EE /media/Films01 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/E8D250EAD250BF0E /media/Films02 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/1233D736318CD68C /media/Docs01 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/00C52F7F6202AA50 /media/Runable auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/294D561D3EF1F925 /media/Archive auto noatime 0 1" >> /etc/fstab

# --------------------------------------------------
# MONTAGE DES NOUVEAUX PÉRIPHÉRIQUES
# --------------------------------------------------
mount -a --onlyonce


##################################################
# @Date : 05/12/2025 12:48
# @Author : @ROYJohan
# @Version : 12b
##################################################
