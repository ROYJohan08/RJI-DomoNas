#!/bin/bash
#Version 202501021744

#Save the version of the Update
touch /etc/RJIDocker/Version.ver
echo "#Version 202501021744" > /etc/RJIDocker/Version.ver

mkdir /etc/RJIDocker/ # Create launcher folder
mkdir /etc/RJIDocker/old # Create launcher folder

#UPDATE /etc/RJIDocker/Update_suite.sh
rm -rf /etc/RJIDocker/old/Update_suite.sh.old #Remove Oldest Update.sh
mv /etc/RJIDocker/Update_suite.sh /etc/RJIDocker/old/Update_suite.sh.old #Save old Update.sh
wget https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Update_suite.sh #Get new Update.sh
mv Update_suite.sh /etc/RJIDocker/Update_suite.sh #Move Udate.sh to the good directory
bash /etc/RJIDocker/Update_suite.sh &
