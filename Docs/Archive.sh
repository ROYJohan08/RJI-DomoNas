#!bin/sh
if mount | awk '{if ($3 == "/media/Archive") { exit 0}} ENDFILE{exit -1}'
then
    echo "Check if Archive is mounted : OK"
    
    if ls "/media/Archive/" | awk '{if ($1 == "Runable") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Runable exist : OK"
     else
        echo "Check if Archive/Runable exist : KO"
        echo "Creation of Archive/Runable : OK"
        mkdir /media/Archive/Runable/
    fi
    
    if ls "/media/Archive/" | awk '{if ($1 == "Runable") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Runable exist : OK"

        if ls "/media/Archive/Runable" | awk '{if ($1 == "Docker") { exit 0}} ENDFILE{exit -1}'
        then
            echo "Check if Archive/Runable/Docker exist : OK"
        else
            echo "Check if Archive/Runable/Docker exist : KO"
            echo "Creation of Archive/Runable/Docker : OK"
            mkdir /media/Archive/Runable/Docker/
        fi
        if ls "/media/Archive/Runable" | awk '{if ($1 == "Docker") { exit 0}} ENDFILE{exit -1}'
        then
            echo "Check if Archive/Runable/Docker exist : OK"
            echo "Copping files..."
            cp -a -d -f -R -u -v /media/Runable/Docker/* /media/Archive/Runable/Docker/
            echo "Copping files... OK"
        else
            echo "Check if Archive/Runable/Docker exist : KO"
            echo "Exit"
    fi
        
     else
        echo "Check if Archive/Runable exist : KO"
        echo "Exit"
        
    fi
    
else
    echo "Check if Archive is mounted : KO"
    echo "Exit"
fi
