#!/bin/sh
source /etc/RJIDomoNas/credentials.sh

add_to_fstab() {
    local UUID=$1
    local MOUNT_POINT=$2
    if [ -n "$UUID" ] && ! grep -q "$UUID" /etc/fstab; then
        echo "L'UUID n'existe pas dans le fstab, ajout de l'UUID $UUID sur $MOUNT_POINT" >> /etc/RJIDomoNas/Log/default.log
        mkdir -p "$MOUNT_POINT"
        echo "UUID=$UUID $MOUNT_POINT auto nosuid,nodev,nofail,umask=000 0 0" >> /etc/fstab
        echo "Ecriture dans le /etc/fstab de : UUID=$UUID $MOUNT_POINT auto nosuid,nodev,nofail,umask=000 0 0" >> /etc/RJIDomoNas/Log/default.log
    else
        echo "L'UUID $UUID est vide ou déjà présent dans /etc/fstab." >> /etc/RJIDomoNas/Log/default.log
    fi
}
add_to_fstab $UIDSeries01 "/media/Series01"
add_to_fstab $UIDSeries02 "/media/Series02"
add_to_fstab $UIDSeries03 "/media/Series03"
add_to_fstab $UIDFilms01 "/media/Films01"
add_to_fstab $UIDFilms02 "/media/Films02"
add_to_fstab $UIDDocs01 "/media/Docs01"
add_to_fstab "00C52F7F6202AA50" "/media/Runable"

echo "Montage de tous les disques" >> /etc/RJIDomoNas/Log/default.log
mount -a --onlyonce

echo "Ajout des droits 777 sur tous les médias" >> /etc/RJIDomoNas/Log/default.log
chmod -R 777 /media/
echo "Ajout de royjohan comme propriétaire sur tout les medias" >> /etc/RJIDomoNas/Log/default.log
chown -R royjohan:royjohan /media/

echo "Disques montés avec success." >> /etc/RJIDomoNas/Log/default.log
