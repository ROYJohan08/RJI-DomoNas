#!/bin/bash

apt-get update -y # Update software.
apt-get full-upgrade -y # Update firmware.

#FolderCreation
mkdir /etc/RJIDomoNas/
mkdir /etc/RJIDomoNas/old/

#Install Docker
apt-get install ca-certificates curl gnupg -y #Install certificate, copy from web and compiler.
install -m 0755 -d /etc/apt/keyrings #Copy file to a directory as uncompilated.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg #Get dependency from web and compil it.
chmod a+r /etc/apt/keyrings/docker.gpg #Give right to file.
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null #Add source to package list.
sudo add-apt-repository ppa:alessandro-strada/ppa # Add repository to default repo
apt-get update -y # Update software.
apt-get full-upgrade -y # Update firmware.
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y # Instlall Docker and Install docker dependency.

#Install Net tools
apt-get install net-tools -y # Install network tools.
apt-get install iperf -y #Install Ierf for local speedtest.
ubuntu-drivers list --gpgpu

#Install Samba
apt-get install samba -y #Install samba.
service smbd stop #Stop Samba
rm -rf /etc/samba/smb.conf.old #Remove oldest config
mv /etc/samba/smb.conf /etc/samba/smb.conf.old #Save old config
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf #Get samba config.
mv smb.conf /etc/samba/smb.conf #Set new config
service smbd start #Start samba

## INSTALLATION OF GLANCES
apt-get install glances -y #Install glances.
sudo systemctl disable glances.service #Disable glances
rm -rf /etc/systemd/system/glances.service.old #Remove oldest config
mv /etc/systemd/system/glances.service /etc/systemd/system/glances.service.old #Save old service
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/glances.service #Get glances services config
mv glances.service /etc/systemd/system/glances.service #Set new config
sudo systemctl enable glances.service #Enable glances

# INSTALL DRIVES
rm -rf /etc/RJIDomoNas/Old/InstallDrives.sh  #Remove oldest config
mv /etc/RJIDomoNas/InstallDrives.sh /etc/RJIDomoNas/Old/InstallDrives.sh #Save old config
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh # Get DriveInstaller
mv InstallDrives.sh /etc/RJIDomoNas/Old/InstallDrives.sh #Set new DriveInstaller

# INSTALL DOCKER LAUNCHER
rm -rf /etc/RJIDomoNas/Old/Docker.sh #Remove oldest launcher
mv /etc/RJIDomoNas/Docker.sh /etc/RJIDomoNas/Old/Docker.sh
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh # Get Docker launcher
mv Docker.sh /etc/RJIDomoNas/Docker.sh # Set the new Launcher

# INSTALL ALIAS
rm -rf /home/royjohan/.bashrc.old #Remove oldest alias.
rm -rf /root/.bashrc.old #Remove oldest alias.
mv /home/royjohan/.bashrc /home/royjohan/.bashrc.old # Save old bashRc
mv /root/.bashrc /root/.bashrc.old # Save old bashRc
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc # Get new bashrc
mv .bashrc /home/royjohan/.bashrc
cp /home/royjohan/.bashrc /root/.bashrc

# INSTALL UDPATE TOOLS
rm -rf /etc/RJIDomoNas/Old/Update.sh #Remove oldest configuration
mv /etc/RJIDomoNas/Update.sh /etc/RJIDomoNas/Old/Update.sh #SDave old conf
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh # Get Update.sh
mv Update.sh /etc/RJIDomoNas/Update.sh #Move conf to corect folder.

# INSTALL CRONTAB
apt-get install cron -y #Install crontab
rm -rf /etc/RJIDomoNas/Old/mycron #Remove oldest conf
mv /etc/RJIDomoNas/mycron /etc/RJIDomoNas/Old/mycron #Save old configuration
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/mycron # Get Crontab
mv mycron /etc/RJIDomoNas/mycron #Move mycron to correct folder
sudo crontab /etc/RJIDomoNas/mycron # Set Crontab into crontab

#Install python correct way
rm -rf /etc/RJIDomoNas/Old/get-pip.py
mv /etc/RJIDomoNas/get-pip.py /etc/RJIDomoNas/Old/get-pip.py
wget https://bootstrap.pypa.io/get-pip.py
mv get-pip.py /etc/RJIDomoNas/get-pip.py
sudo python3 /etc/RJIDomoNas/get-pip.py

FILE=/etc/RJIDomoNas/credentials.sh # Locate default credential file
if test -f "$FILE"; then # If file exist
    echo "credentials set" #Nth
else 
    wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/credentials.sh # Get default credentials
    mv credentials.sh /etc/RJIDomoNas/credentials.sh # Set default credential in place
fi
FILE=/media/Runable/Docker/credentials.sh # Get OverRight credentials
if test -f "$FILE"; then # if it exist
    rm -rf /etc/RJIDomoNas/credentials.sh #Remove old credentials
    cp /media/Runable/Docker/credentials.sh /etc/RJIDomoNas/credetials.sh # Set OverRight credentials
else 
    echo "no move" # Nth
fi

#Install Archivage.
wget "https://raw.githubusercontent.com/ROYJohan08/RJI-DomoNas/refs/heads/main/Docs/Archive.sh"
mv Archive.sh /etc/RJIDomoNas/Archive.sh

source /etc/RJIDomoNas/credentials.sh # Import credentials
echo -e "$Passpass\n$Passpass" | smbpasswd -a -s $User # Create new smbuser
