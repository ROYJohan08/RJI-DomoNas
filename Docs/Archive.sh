#!/bin/sh

source /etc/RJIDomoNas/credentials.sh

mount -U "$UIDArchive" /media/Archive
echo "Montage du disque Archive" >> /etc/RJIDomoNas/Log/default.log

if mount | grep -q 'on /media/Archive '
then
	echo "Archivage ---- Creation des dossiers... " >> /etc/RJIDomoNas/Log/default.log
	mkdir -p /media/Archive/Runable/Docker/ \
         /media/Archive/Films/ \
         /media/Archive/Series/ \
         /media/Archive/Docs/18/ \
         /media/Archive/Docs/Musiques/ \
         /media/Archive/Docs/Photographies/ \
         /media/Archive/Docs/Livres/ \
         /media/Archive/Docs/Jeux/ > /dev/null
	echo "Archivage ---- Creation des dossiers... OK" >> /etc/RJIDomoNas/Log/default.log

	echo "Archivage ---- Archivage des Docker..." >> /etc/RJIDomoNas/Log/default.log
 	cp -a -d -f -R -u -v /media/Runable/Docker/* /media/Archive/Runable/Docker/  >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des Docker...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des '-A' du disque Series01..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Series01/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series01...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des '-A' du disque Series02..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Series02/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series02...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des '-A' du disque Series03..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Series03/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series03...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des '-A' du disque Film01..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Films01/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films01/*/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Film01...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des '-A' du disque Film02..." >> /etc/RJIDomoNas/Log/default.log
  	cp -a -d -f -R -u -v /media/Films02/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films02/*/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Film02...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des documents +18..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v "/media/Docs01/18/"* "/media/Archive/Docs/18/"  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des documents +18...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des musiques..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Docs01/Musiques/* /media/Archive/Docs/Musiques/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des musiques...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des photos..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Docs01/Photographies/* /media/Archive/Docs/Photographies/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des photos...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des livres..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Docs01/Livres/* /media/Archive/Docs/Livres/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des livres...OK" >> /etc/RJIDomoNas/Log/default.log
  	echo "Archivage ---- Archivage des '-A' des jeux..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Docs01/Jeux/*-A.* /media/Archive/Docs/Jeux/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' des jeux...OK" >> /etc/RJIDomoNas/Log/default.log
	echo "Archivage ---- Archivage de la SeedBox..." >> /etc/RJIDomoNas/Log/default.log
	cp -a -d -f -R -u -v /media/Runable/DownBox/SeedBox/* /media/Archive/Runable/SeedBox/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage de la SeedBox...OK" >> /etc/RJIDomoNas/Log/default.log
 	echo "$(date "+%d/%m/%y %H:%M:%S")" > /media/Archive/LastArchive.dt
  	echo "Archivage ---- Archivage ---- FIN"  >> /etc/RJIDomoNas/Log/default.log

	umount $(findmnt -n -o TARGET --source UUID="$UIDArchive")
	echo "Damontage du disque Archive" >> /etc/RJIDomoNas/Log/default.log
	
fi
