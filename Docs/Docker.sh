#!/bin/sh

source /etc/RJIDomoNas/credentials.sh
# Do 'id royjohan' and run
USER_ID=1000
GROUP_ID=1000

LMPort=80
LMData="/media/Runable/Docker/LM-Data"

HAPort=1000
HAConfig="/media/Runable/Docker/HA-Config"

JFPort=1001
JFConfig="/media/Runable/Docker/JF-Config"
JFCache="/media/Runable/Docker/JF-Cache"
JFData="/media/"

FBPort=1006
FBConfig="/media/Runable/Docker/FB-Config/"
FBData="/media/"
FBBase="/media/Runable/Docker/FB-Database/"

POPort=1005
PODocker="/var/run/docker.sock"
POConfig="/media/Runable/Docker/PO-Config"

GOPort=1004
GOConfig="/media/Runable/Docker/GO-Config/"

MQPort=1007
MQConfig="/media/Runable/Docker/MQ-Config/"
MQData="/media/Runable/Docker/MQ-Data"
MQPassword="/mosquitto/config/password.txt"

DBPort=1002
DBConfig="/media/Runable/Docker/DB-Config"
DBCustom="/media/Runable/Docker/DB-Config/custom"
DBData="/media/Runable/DownBox"

SBPort=1003
SBConfig="/media/Runable/Docker/SB-Config"
SBData="/media/Runable/SeedBox" 

case $1 in
	"all")
		sudo docker run -d --name Lamp --restart=unless-stopped -e TZ=CET -v $LMData:/app -p $LMPort:80 -p 3306:3306 mattrayner/lamp:latest
		sudo docker run -d --name Homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $HAConfig:/config -p 6666:6666 -p 6667:6667 -p $HAPort:8123 homeassistant/home-assistant:latest
		sudo docker run -d --name Jellyfin --restart=unless-stopped -e TZ=CET -e PUID=$USER_ID -e PGID=$GROUP_ID -v $JFConfig:/config -v $JFData:/media -v $JFCache:/cache -p $JFPort:8096 -p 8920:8920 jellyfin/jellyfin:latest
		sudo docker run -d --name Filebrowser --privileged --restart=unless-stopped -e TZ=CET -v $FBData:/srv -v $FBBase:/database -v $FBConfig:/config/ -p $FBPort:80 filebrowser/filebrowser:latest
		sudo docker run -d --name Portainer --privileged --restart=unless-stopped -e TZ=CET -p 8000:8000 -p 9443:9443 -p $POPort:9000 -v $PODocker:/var/run/docker.sock -v $POConfig:/data portainer/portainer-ce:latest
		sudo docker run -d --name Grocy --restart=unless-stopped -e TZ=CET -v $GOConfig:/config  -p $GOPort:80  lscr.io/linuxserver/grocy:latest
		sudo docker run -d --name Mqtt --restart=unless-stopped -e TZ=CET -v $MQConfig:/mosquitto/config -v $MQData:/mosquitto/data -p $MQPort:1883 -p 9001:9001  eclipse-mosquitto:latest
		sudo docker run -d --name transmission --privileged --restart=unless-stopped -e PUID=$USER_ID -e PGID=$GROUP_ID -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $DBCustom:/etc/openvpn/custom -v $DBData:/data -v $DBConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VPNUser -e OPENVPN_PASSWORD=$VPNPass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e OPENVPN_PROVIDER=CUSTOM -e LOCAL_NETWORK=192.168.1.0/32 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:latest
		sudo docker run -d --name dDBProxy --privileged --restart=unless-stopped --link transmission -p $DBPort:8080 haugene/transmission-openvpn-proxy:latest
		sudo docker run -d --name Seedbox --privileged --restart=unless-stopped -e PUID=$USER_ID -e PGID=$GROUP_ID -e TZ=CET -e USER=$User -e PASS=$Pass -e TRANSMISSION_WEB_HOME=/config/GUI -p $SBPort:9091 -p 51413:51413 -p 51413:51413/udp -v $SBConfig:/config -v $SBData:/downloads/complete lscr.io/linuxserver/transmission:latest
		sudo docker exec Mqtt sh -c "mosquitto_passwd -c $MQPassword hass"
		sudo git clone https://github.com/ronggang/transmission-web-control.git
		sudo mkdir $SBConfig/GUI/
		sudo mv -f transmission-web-control/src/ $SBConfig/GUI/
		sudo rm -rf transmission-web-control/
		sudo docker exec Seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
		sudo docker exec Seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
		sudo docker exec Seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
		sudo docker exec Seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
		sudo docker exec Seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
	;;
	"lamp")
		sudo docker run -d --name Lamp --restart=unless-stopped -e TZ=CET -v $LMData:/app -p $LMPort:80 -p 3306:3306 mattrayner/lamp:latest
	;;
	"homeassistant")
		sudo docker run -d --name Homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $HAConfig:/config -p 6666:6666 -p 6667:6667 -p $HAPort:8123 homeassistant/home-assistant:latest
	;;
	"jellyfin")
		sudo docker run -d --name Jellyfin --restart=unless-stopped -e TZ=CET -v $JFConfig:/config -v $JFData:/media -v $JFCache:/cache -p $JFPort:8096 -p 8920:8920 jellyfin/jellyfin:latest
	;;
	"filebrowser")
		sudo docker run -d --name Filebrowser --privileged --restart=unless-stopped -e TZ=CET -v $FBData:/srv -v $FBBase:/database -v $FBConfig:/config/ -p $FBPort:80 filebrowser/filebrowser:latest
	;;
	"portainer")
		sudo docker run -d --name Portainer --privileged --restart=unless-stopped -e TZ=CET -p 8000:8000 -p 9443:9443 -p $POPort:9000 -v $PODocker:/var/run/docker.sock -v $POConfig:/data portainer/portainer-ce:latest
	;;
	"grocy")
		sudo docker run -d --name Grocy --restart=unless-stopped -e TZ=CET -v $GOConfig:/config  -p $GOPort:80  lscr.io/linuxserver/grocy:latest
	;;
	"mqtt")
		sudo docker run -d --name Mqtt --restart=unless-stopped -e TZ=CET -v $MQConfig:/mosquitto/config -v $MQData:/mosquitto/data -p $MQPort:1883 -p 9001:9001  eclipse-mosquitto:latest
        sudo docker exec Mqtt sh -c "mosquitto_passwd -c $MQPassword hass"
	;;
	"downbox")
		sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $DBCustom:/etc/openvpn/custom -v $DBData:/data -v $DBConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VPNUser -e OPENVPN_PASSWORD=$VPNPass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e OPENVPN_PROVIDER=CUSTOM -e LOCAL_NETWORK=192.168.1.0/32 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:latest
		sudo docker run -d --name Dbproxy --privileged --restart=unless-stopped --link transmission -p $DBPort:8080 haugene/transmission-openvpn-proxy:latest
	;;
	"seedbox")
		sudo docker run -d --name Seedbox --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -e TRANSMISSION_WEB_HOME=/config/GUI -p $SBPort:9091 -p 51413:51413 -p 51413:51413/udp -v $SBConfig:/config -v $SBData:/downloads/complete lscr.io/linuxserver/transmission:latest
		sudo git clone https://github.com/ronggang/transmission-web-control.git
		sudo mkdir $SBConfig/GUI/
		sudo mv -f transmission-web-control/src/ $SBConfig/GUI/
		sudo rm -rf transmission-web-control/
		sudo docker exec Seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
		sudo docker exec Seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
		sudo docker exec Seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
		sudo docker exec Seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
		sudo docker exec Seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
	;;
esac

##################################################
#    @Date : 05/12/2025 12:14                    #
#    @Author : @ROYJohan                         #
#    @Version : 12b                              #
##################################################
