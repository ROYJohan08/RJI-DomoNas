#!bin/sh

if mount | awk '{if ($3 == "/media/Archive") { exit 0}} ENDFILE{exit -1}'
then

    ##################################################
    #                  Create folders                #
    ##################################################
    
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
	
    ##################################################
    #                  Archive datas                 #
    ##################################################
    
	# Copie intégrale de docker, seedbox. Pas de copie de downbox car facilement récupérable.
 	cp -a -d -f -R -u -v /media/Runable/Docker/* /media/Archive/Runable/Docker/ 
	cp -a -d -f -R -u -v /media/Runable/SeedBox/* /media/Archive/Runable/SeedBox/ 
 	# Copie de tout les classes -A des différents disques serie.
	cp -a -d -f -R -u -v /media/Series01/*-A/ /media/Archive/Series/ 
	cp -a -d -f -R -u -v /media/Series02/*-A/ /media/Archive/Series/ 
	cp -a -d -f -R -u -v /media/Series03/*-A/ /media/Archive/Series/ 
 	# Copie de tout les classes -A des différents disques Films.
	cp -a -d -f -R -u -v /media/Films01/*-A.* /media/Archive/Films/ 
	cp -a -d -f -R -u -v /media/Films01/*/*-A.* /media/Archive/Films/ 
	cp -a -d -f -R -u -v /media/Docs01/"+18"/* /media/Archive/Docs/"+18"/ 
	cp -a -d -f -R -u -v /media/Docs01/Musiques/* /media/Archive/Docs/Musiques/ 
	cp -a -d -f -R -u -v /media/Docs01/Photographies/* /media/Archive/Docs/Photographies/ 
	cp -a -d -f -R -u -v /media/Docs01/Livres/* /media/Archive/Docs/Livres/ 
	cp -a -d -f -R -u -v /media/Docs01/Jeux/*-A.* /media/Archive/Docs/Jeux/ 

 	echo date "+%d/%m/%y %H:%M:%S" > /media/Archive/LastArchive.dt
fi

##################################################
#    @Date : 11/08/2025 08:50                    #
#    @Author : @ROYJohan                         #
#    @Version : 10b                              #
##################################################
