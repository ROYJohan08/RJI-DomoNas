#!bin/sh
if mount | awk '{if ($3 == "/media/Archive") { exit 0}} ENDFILE{exit -1}'
then
    echo "Check if Archive is mounted : OK"
    
	
	
    if ls "/media/Archive/" | awk '{if ($1 == "Runable") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Runable exist : OK"
     else
        echo "Check if Archive/Runable exist : KO"
		mkdir /media/Archive/Runable/
        echo "Creation of Archive/Runable : OK"
    fi
	if ls "/media/Archive/" | awk '{if ($1 == "Films") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Films exist : OK"
     else
        echo "Check if Archive/Films exist : KO"
		mkdir /media/Archive/Films/
        echo "Creation of Archive/Films : OK"
    fi
	if ls "/media/Archive/" | awk '{if ($1 == "Series") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Series exist : OK"
     else
        echo "Check if Archive/Series exist : KO"
		mkdir /media/Archive/Series/
        echo "Creation of Archive/Series : OK"
    fi
	if ls "/media/Archive/" | awk '{if ($1 == "Docs") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Docs exist : OK"
     else
        echo "Check if Archive/Docs exist : KO"
		mkdir /media/Archive/Docs/
        echo "Creation of Archive/Docs : OK"
    fi
	if ls "/media/Archive/" | awk '{if ($1 == "Runable") { exit 0}} ENDFILE{exit -1}'
    then
	
        if ls "/media/Archive/Runable/" | awk '{if ($1 == "Docker") { exit 0}} ENDFILE{exit -1}'
		then
			echo "Check if Archive/Runable/Docker exist : OK"
		else
			echo "Check if Archive/Runable/Docker exist : KO"
			mkdir /media/Archive/Runable/Docker/
			echo "Creation of Archive/Runable/Docker : OK"
		fi
		if ls "/media/Archive/Runable/" | awk '{if ($1 == "SeedBox") { exit 0}} ENDFILE{exit -1}'
		then
			echo "Check if Archive/Runable/SeedBox exist : OK"
		else
			echo "Check if Archive/Runable/SeedBox exist : KO"
			mkdir /media/Archive/Runable/SeedBox/
			echo "Creation of Archive/Runable/SeedBox : OK"
		fi
     else
        echo "Check if Archive/Runable exist : KO"
		exit 1
    fi
    
	
	
	cp -a -d -f -R -u -v /media/Runable/Docker/* /media/Archive/Runable/Docker/ &
	cp -a -d -f -R -u -v /media/Runable/SeedBox/* /media/Archive/Runable/SeedBox/ &
	cp -a -d -f -R -u -v /media/Series01/A-*/ /media/Archive/Series/ &
	cp -a -d -f -R -u -v /media/Series02/A-*/ /media/Archive/Series/ &
	cp -a -d -f -R -u -v /media/Series03/A-*/ /media/Archive/Series/ &
	cp -a -d -f -R -u -v /media/Series03/A-*/ /media/Archive/Series/ &
	cp -a -d -f -R -u -v /media/Films01/A-* /media/Archive/Films/ &
	cp -a -d -f -R -u -v /media/Films01/*/A-* /media/Archive/Films/ &
	cp -a -d -f -R -u -v /media/Docs01/ /media/Archive/Docs/ &
	
else
    echo "Check if Archive is mounted : KO"
    echo "Exit"
fi
