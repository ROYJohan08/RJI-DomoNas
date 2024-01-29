#!/bin/bash
sudo su # Get root privilege.
apt-get update -y # Update software.
apt-get full-upgrade -y # Update firmware.
apt-get install notepadqq -y # Install notepad++.
apt-get install terminator -y # Install terminator.
apt-get install samba -y # Install samba
apt-get install net-tools -y # Install network tools.
apt-get install ca-certificates curl gnupg -y # Install Docker - Install certificate, copy from web et compiler.
install -m 0755 -d /etc/apt/keyrings # Install Docker - Copy file to aa directory as uncompilated.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg # Install Docker - Get dependency from web and compil it.
chmod a+r /etc/apt/keyrings/docker.gpg # IInstall Docker - Give right to file.
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null # Install Docker - Add source to package list.
apt-get update -y # Install Docker - Update package list.
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y # Instlall Docker - Install docker dependency.
apt-get install xfce4 xfce4-goodies xrdp -y # Install XRDP - VNC.
echo "xfce4-session" | tee .xsession # Install XRDP - Add file to session.
