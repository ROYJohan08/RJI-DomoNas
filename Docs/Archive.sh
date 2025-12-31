#!/bin/sh

mount -a --onlyonce
if mount | grep -q 'on /media/Archive '
then
	echo "Archivage ---- Creation des dossiers... " >> /media/Archive/Log.dat
	mkdir -p /media/Archive/Runable/Docker/ \
         /media/Archive/Films/ \
         /media/Archive/Series/ \
         /media/Archive/Docs/18/ \
         /media/Archive/Docs/Musiques/ \
         /media/Archive/Docs/Photographies/ \
         /media/Archive/Docs/Livres/ \
         /media/Archive/Docs/Jeux/ >/dev/null
	echo "Archivage ---- Creation des dossiers... OK" >> /media/Archive/Log.dat

	echo "Archivage ---- Archivage des Docker..." >> /media/Archive/Log.dat
 	cp -a -d -f -R -u -v /media/Runable/Docker/* /media/Archive/Runable/Docker/  >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des Docker...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des '-A' du disque Series01..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Series01/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series01...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des '-A' du disque Series02..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Series02/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series02...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des '-A' du disque Series03..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Series03/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series03...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des '-A' du disque Film01..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films01/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films01/*/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Film01...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des '-A' du disque Film02..." >> /media/Archive/Log.dat
  	cp -a -d -f -R -u -v /media/Films02/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films02/*/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Film02...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des documents +18..." >> /media/Archive/Log.dat
	
	
	
	
	
	cp -a -d -f -R -u -v "/media/Docs01/18/"* "/media/Archive/Docs/18/"  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des documents +18...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des musiques..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Docs01/Musiques/* /media/Archive/Docs/Musiques/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des musiques...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des photos..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Docs01/Photographies/* /media/Archive/Docs/Photographies/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des photos...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des livres..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Docs01/Livres/* /media/Archive/Docs/Livres/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des livres...OK" >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des '-A' des jeux..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Docs01/Jeux/*-A.* /media/Archive/Docs/Jeux/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' des jeux...OK" >> /media/Archive/Log.dat
	echo "Archivage ---- Srockage de la date" >> /media/Archive/Log.dat
	echo "Archivage ---- Archivage de la SeedBox..." >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Runable/DownBox/SeedBox/* /media/Archive/Runable/SeedBox/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage de la SeedBox...OK" >> /media/Archive/Log.dat
 	echo "$(date "+%d/%m/%y %H:%M:%S")" > /media/Archive/LastArchive.dt
  	echo "Archivage ---- Archivage ---- FIN" >> /media/Archive/Log.dat
fi

##################################################
#    @Date : 05/12/2025 12:45                    #
#    @Author : @ROYJohan                         #
#    @Version : 12b                              #
##################################################
