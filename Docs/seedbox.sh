#!/bin/sh

echo "Copie des fichier de .seed dans la seedbox" >> /data/log.log
cp -f -r -v /data/DownBox/.seed/* /data/SeedBox/ >> /dev/null

echo "Deplacement des fichier de .seed vers Downbox" >> /data/log.log
mv -f -v /data/DownBox/.seed/* /data/DownBox/ >> /data/log.log
echo "Fin de script" >> /data/log.log
