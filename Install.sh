#!/bin/bash

apt-get update -y # Update software.
apt-get full-upgrade -y # Update firmware.

#INSTALLATION OF DOCKER
apt-get install ca-certificates curl gnupg -y #Install certificate, copy from web and compiler.
install -m 0755 -d /etc/apt/keyrings #Copy file to a directory as uncompilated.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg #Get dependency from web and compil it.
chmod a+r /etc/apt/keyrings/docker.gpg #Give right to file.
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null #Add source to package list.
sudo add-apt-repository ppa:alessandro-strada/ppa # Add repository to default repo
apt-get update -y # Update software.
apt-get full-upgrade -y # Update firmware.
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y # Instlall Docker and Install docker dependency.


apt-get install net-tools -y # Install network tools.
apt-get install iperf -y #Install Ierf for local speedtest.

ubuntu-drivers list --gpgpu

## INSTALLATION OF SAMBA
apt-get install samba -y # Install samba.
service smbd stop #Stop Samba
rm -rf /etc/samba/smb.conf.old # Remove oldest config
mv /etc/samba/smb.conf /etc/samba/smb.conf.old # Save old config
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/smb.conf # Get samba config.
mv smb.conf /etc/samba/smb.conf #Set new config
service smbd start #Start samba

## INSTALLATION OF GLANCES
apt-get install glances -y #Install glances.
sudo systemctl disable glances.service #Disable glances
rm -rf /etc/systemd/system/glances.service.old
mv /etc/systemd/system/glances.service /etc/systemd/system/glances.service.old # Save old service
wget https://raw.githubusercontent.com/ROYJohan08/DomotikHomeNas/main/Docs/glances.service #Get glances services
mv glances.service /etc/systemd/system/glances.service # Save old service
sudo systemctl enable glances.service #Enable glances

# INSTALL DRIVES
rm -rf /etc/RJIDomonas/Old/InstallDrives.sh 
mv /etc/RJIDomonas/InstallDrives.sh /etc/RJIDomonas/Old/InstallDrives.sh
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/InstallDrives.sh # Get DriveInstaller
mv InstallDrives.sh /etc/RJIDomonas/Old/InstallDrives.sh

# INSTALL DOCKER LAUNCHER
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Docker.sh # Get Docker launcher
mkdir /etc/RJIDocker/ # Create launcher folder
mv Docker.sh /etc/RJIDocker/Docker.sh # Set the new Launcher


# INSTALL ALIAS
mv Docker.sh .bashrc .bashrc.old # Save old bashRc
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/.bashrc # Get new bashrc

# INSTALL UDATE TOOLS
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/Update.sh # Get Update.sh
mb Update.sh /etc/RJIDocker/Update.sh

# INSTALL CRONTAB
apt-get install cron -y #Install crontab
wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/mycron # Get Crontab
sudo crontab mycron # Set Crontab into crontab
rm mycron # Remove temp crontab

wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py

FILE=/etc/RJIDocker/credentials.sh # Locate default credential file
if test -f "$FILE"; then # If file exist
    echo "credentials set" #Nth
else 
    wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Docs/credentials.sh # Get default credentials
    mv credentials.sh /etc/RJIDocker/credentials.sh # Set default credential in place
fi
FILE=/media/Runable/Docker/credentials.sh # Get OverRight credentials
if test -f "$FILE"; then # if it exist
    rm -rf /etc/RJIDocker/credentials.sh #Remove old credentials
    cp /media/Runable/Docker/credentials.sh /etc/RJIDocker/credetials.sh # Set OverRight credentials
else 
    echo "no move" # Nth
fi

source /etc/RJIDocker/credentials.sh # Import credentials
echo -e "$Passpass\n$Passpass" | smbpasswd -a -s $User # Create new smbuser
