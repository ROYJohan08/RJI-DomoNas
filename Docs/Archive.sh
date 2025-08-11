#!bin/sh

if mount | awk '{if ($3 == "/media/Archive") { exit 0}} ENDFILE{exit -1}'
then

    ##################################################
    #                  Create folders                #
    ##################################################

	echo "Archivage ---- Creation des dossiers... "
    mkdir /media/Archive/Runable/ >/dev/null
    mkdir /media/Archive/Docker/ >/dev/null
    mkdir /media/Archive/Films/ >/dev/null
    mkdir /media/Archive/Series/ >/dev/null
    mkdir /media/Archive/Docs/ >/dev/null
    mkdir /media/Archive/Docs/"+18"/ >/dev/null
    mkdir /media/Archive/Docs/Musiques/ >/dev/null
    mkdir /media/Archive/Docs/Photographies/ >/dev/null
    mkdir /media/Archive/Docs/Livres/ >/dev/null
    mkdir /media/Archive/Docs/Jeux/ >/dev/null
	echo "Archivage ---- Creation des dossiers... OK"
	
    ##################################################
    #                  Archive datas                 #
    ##################################################
    
	echo "Archivage ---- Archivage des Docker..."
 	cp -a -d -f -R -u -v /media/Runable/Docker/* /media/Archive/Runable/Docker/  >> /media/Archive/Log.dat
  	echo "Archivage ---- Archivage des Docker...OK"
   	echo "Archivage ---- Archivage de la SeedBox..."
	cp -a -d -f -R -u -v /media/Runable/SeedBox/* /media/Archive/Runable/SeedBox/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage de la SeedBox...OK"
  	echo "Archivage ---- Archivage des '-A' du disque Series01..."
	cp -a -d -f -R -u -v /media/Series01/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series01...OK"
  	echo "Archivage ---- Archivage des '-A' du disque Series02..."
	cp -a -d -f -R -u -v /media/Series02/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series02...OK"
  	echo "Archivage ---- Archivage des '-A' du disque Series03..."
	cp -a -d -f -R -u -v /media/Series03/*-A/ /media/Archive/Series/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Series03...OK"
  	echo "Archivage ---- Archivage des '-A' du disque Film01..."
	cp -a -d -f -R -u -v /media/Films01/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films01/*/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Film01...OK"
  	echo "Archivage ---- Archivage des '-A' du disque Film02..."
  	cp -a -d -f -R -u -v /media/Films01/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
	cp -a -d -f -R -u -v /media/Films01/*/*-A.* /media/Archive/Films/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' du disque Film02...OK"
  	echo "Archivage ---- Archivage des documents +18..."
	cp -a -d -f -R -u -v /media/Docs01/"+18"/* /media/Archive/Docs/"+18"/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des documents +18...OK"
  	echo "Archivage ---- Archivage des musiques..."
	cp -a -d -f -R -u -v /media/Docs01/Musiques/* /media/Archive/Docs/Musiques/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des musiques...OK"
  	echo "Archivage ---- Archivage des photos..."
	cp -a -d -f -R -u -v /media/Docs01/Photographies/* /media/Archive/Docs/Photographies/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des photos...OK"
  	echo "Archivage ---- Archivage des livres..."
	cp -a -d -f -R -u -v /media/Docs01/Livres/* /media/Archive/Docs/Livres/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des livres...OK"
  	echo "Archivage ---- Archivage des '-A' des jeux..."
	cp -a -d -f -R -u -v /media/Docs01/Jeux/*-A.* /media/Archive/Docs/Jeux/  >> /media/Archive/Log.dat
 	echo "Archivage ---- Archivage des '-A' des jeux...OK"
	echo "Archivage ---- Srockage de la date"
 	echo date "+%d/%m/%y %H:%M:%S" > /media/Archive/LastArchive.dt
  	echo "Archivage ---- Archivage ---- FIN"
fi

##################################################
#    @Date : 11/08/2025 08:50                    #
#    @Author : @ROYJohan                         #
#    @Version : 10b                              #
##################################################
