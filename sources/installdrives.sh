#!/bin/sh
source /etc/RJIDomoNas/credentials.sh

add_to_fstab() {
    local UUID=$1
    local MOUNT_POINT=$2
    if [ -n "$UUID" ] && ! grep -q "$UUID" /etc/fstab; then
        echo "L'UUID n'existe pas dans le fstab, ajout de l'UUID $UUID sur $MOUNT_POINT" >> /etc/RJIDomoNas/Log/default.log
        sudo -u "$SUDO_USER" mkdir -p "$MOUNT_POINT"
        sudo -u "$SUDO_USER" echo "UUID=$UUID $MOUNT_POINT auto nosuid,nodev,nofail,umask=000 0 0" >> /etc/fstab
        echo "Ecriture dans le /etc/fstab de : UUID=$UUID $MOUNT_POINT auto nosuid,nodev,nofail,umask=000 0 0" >> /etc/RJIDomoNas/Log/default.log
    else
        echo "L'UUID $UUID est vide ou déjà présent dans /etc/fstab." >> /etc/RJIDomoNas/Log/default.log
    fi
}
add_to_fstab $UidDocs01 $PathDocs01
add_to_fstab $UidSeries01 $PathSeries01
add_to_fstab $UidSeries02 $PathSeries02
add_to_fstab $UidSeries03 $PathSeries03
add_to_fstab $UidFilms01 $PathFilms01
add_to_fstab $UidFilms02 $PathFilms02

add_to_fstab "00C52F7F6202AA50" $PathRunable

echo "Montage de tous les disques" >> /etc/RJIDomoNas/Log/default.log
mount -a --onlyonce

echo "Ajout des droits 777 sur tous les médias" >> /etc/RJIDomoNas/Log/default.log
chmod -R 777 /media/
echo "Ajout de royjohan comme propriétaire sur tout les medias" >> /etc/RJIDomoNas/Log/default.log
chown -R royjohan:royjohan /media/

echo "Disques montés avec success." >> /etc/RJIDomoNas/Log/default.log
