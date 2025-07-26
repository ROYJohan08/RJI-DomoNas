#!bin/sh
if mount | awk '{if ($3 == "/media/Archive") { exit 0}} ENDFILE{exit -1}'
then
    echo "Check if Archive is mounted : OK"
    if ls "/media/Archive/" | awk '{if ($1 == "Runable") { exit 0}} ENDFILE{exit -1}'
    then
        echo "Check if Archive/Runable exist : OK"
        cp -a -d -f -R -u -v /media/Runable/* /media/Archive/Runable/
    else
        echo "Check if Archive/Runable exist : KO"
    fi
else
    echo "Check if Archive is mounted : KO"
fi
