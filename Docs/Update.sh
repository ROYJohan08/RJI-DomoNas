#!/bin/bash
#Version 202501021737

#Save the version of the Update
touch /etc/RJIDocker/Version.ver
echo "#Version 202501021737" > /etc/RJIDocker/Version.ver

#UPDATE /etc/RJIDocker/Update_suite.sh
rm -rf /etc/RJIDocker/Update_suite.sh.old #Remove Oldest Update.sh
mv /etc/RJIDocker/Update_suite.sh /etc/RJIDocker/Update_suite.sh.old #Save old Update.sh
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update_suite.sh #Get new Update.sh
mv Update_suite.sh /etc/RJIDocker/Update_suite.sh #Move Udate.sh to the good directory
bash /etc/RJIDocker/Update_suite.sh &
