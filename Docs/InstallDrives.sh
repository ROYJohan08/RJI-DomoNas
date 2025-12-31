#!/bin/sh
source /etc/RJIDomoNas/credentials.sh

echo "Cration des dossiers si ils n'existent pas"
mkdir -p /media/Films01 /media/Films02 /media/Series01 /media/Series02 /media/Series03 /media/Docs01 /media/Runable /media/Temp /media/Archive


add_to_fstab() {
    UUID=$1
    MOUNT_POINT=$2
    if ! grep -qs "$UUID" /etc/fstab; then
        echo "L'UUID n'existe pas dans le fstab, ajout de l'UUID $UUID avec le point de montage $MOUNT_POINT dans le fstab"
        echo "UUID=$UUID $MOUNT_POINT auto nosuid,nodev,nofail,xtime,umask=000 0 0" >> /etc/fstab
    fi
}
add_to_fstab $UIDSeries01 "/media/Series01"
add_to_fstab $UIDSeries02 "/media/Series02"
add_to_fstab $UIDSeries03 "/media/Series03"
add_to_fstab $UIDFilms01 "/media/Films01"
add_to_fstab $UIDFilms02 "/media/Films02"
add_to_fstab $UIDDocs01 "/media/Docs01"
add_to_fstab $UIDRunable "/media/Runable"
add_to_fstab $UIDArchive "/media/Archive"

echo "Montage de tous les disques"
mount -a --onlyonce

echo "Ajout des droits 777 sur tous les médias"
chmod -R 777 /media/
echo "Ajout de royjohan comme propriétaire"
chown -R royjohan:royjohan /media/

echo "Disques montés."
