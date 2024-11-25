#!bin/sh

source /etc/RJIDocker/credentials.sh

PortLM=80 # Lamp poer
PortHA=1000 # HomeAssistant port
PortJF=1001 # JellyFin port
PortFB=1002 # FileBrowser port
PortNC=1003 # NextCloud port
PortPO=1004 # Portainer port
PortSB=1005 # SeedBox Port 
PortDB=1006 # DownBox Port
PortMQ=1007 # MQTT Port

ConfigLM="/media/Runable/Docker/LM-Config/"
ConfigHA="/media/Runable/Docker/HA-Config"
ConfigJF="/media/Runable/Docker/JF-Config"
ConfigFB="/media/Runable/Docker/FB-Config/"
ConfigNC="/media/Runable/Docker/NC-Config"
ConfigPO="/media/Runable/Docker/PO-Config"
ConfigSB="/media/Runable/Docker/SB-Config"
ConfigDB="/media/Runable/Docker/DB-Config"
Config2DB="/media/Runable/Docker/DB-Config/custom"
ConfigMQ="/media/Runable/Docker/MQ-Config/"

DataLM="/media/Runable/Docker/LM-Data"
DataJF="/media/"
DataFB="/"
DataNC="/media/Docs/NC-Data"
DataSB="/media/Runable/SeedBox"
DataDB="/media/Runable/DownBox"
DataMQ="/media/Runable/Docker/MQ-Data"

case $1 in
	"init")
		case $2 in
			"lamp")
				sudo docker run -d --name lamp --restart=unless-stopped -e TZ=CET -v $DataLM:/var/www/html -p $PortLM:80 -p 3306:3306 lioshi/lamp:php7
			;;
   			"homeassistant")
				sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $ConfigHA:/config -p $PortHA:8123 homeassistant/home-assistant:stable
			;;
			"jellyfin")
				sudo docker run -d --name jellyfin --restart=unless-stopped -e TZ=CET -v $ConfigJF:/config -v $DataJF:/media -p $PortJF:8096 -p 8920:8920 linuxserver/jellyfin:10.8.13
			;;
			"filebrowser")
				sudo docker run -d --name filebrowser --restart=unless-stopped -e TZ=CET -v $DataFB:/srv -v $ConfigFB:/config/ -p $PortFB:80 filebrowser/filebrowser:v1.10.0
			;;
			"nextcloud")
				sudo docker run -d --name nextcloud --restart=unless-stopped -e TZ=CET -p $PortNC:80 -v $ConfigNC:/var/www/html/config -v $DataNC:/data nextcloud:18.0.4
			;;
			"portainer")
				sudo docker run -d --name portainer --privileged --restart=unless-stopped -e TZ=CET -p 8000:8000 -p 9443:9443 -p $PortPO:9000 -v /var/run/docker.sock:/var/run/docker.sock -v $ConfigSB:/data portainer/portainer-ce:latest
			;;
			"seedbox")
				sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $sbConfig/GUI/
				sudo mv transmission-web-control/src/ $sbConfig/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker run -d --name seedbox --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -p $PortSB:9091 -p 51413:51413 -p 51413:51413/udp -v $ConfigSB:/config -v $DataSB:/downloads/complete lscr.io/linuxserver/transmission:latest
				sudo docker exec seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
			;;
			"downbox")
				sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $Config2DB:/etc/openvpn/custom -v $DataDB:/data -v $ConfigDB:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VPNUser -e OPENVPN_PASSWORD=$VPNPass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/32 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:3.6
				sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped --link transmission -p $PortDB:8080 haugene/transmission-openvpn-proxy
			;;
			"mqtt")
				sudo docker run -d --name mqtt --restart=unless-stopped -e TZ=CET -v $ConfigMQ:/mosquitto/config -v $DataMQ:/mosquitto/data -p $PortMQ:1883 -p 9001:9001  eclipse-mosquitto:2.0
			;;
		esac
	;;
	"stop")
		case $2 in
			"homeassistant")
				sudo docker stop homeassistant
			;;
			"seedbox")
				sudo docker stop seedbox
			;;
			"downbox")
				sudo docker stop downbox
			;;
			"jellyfin")
				sudo docker stop jellyfin
			;;
			"nextcloud")
				sudo docker stop nextcloud
			;;
			"lamp")
				sudo docker stop lamp
			;;
			"filebrowser")
				sudo docker stop filebrowser
			;;
			"mqtt")
				sudo docker stop mqtt
			;;
		esac
	;;
	"rm")
		case $2 in
			"homeassistant")
				sudo docker stop homeassistant
				sudo docker rm homeassistant
			;;
			"seedbox")
				sudo docker stop seedbox
				sudo docker rm seedbox
			;;
			"downbox")
				sudo docker stop downbox
				sudo docker rm downbox
			;;
			"jellyfin")
				sudo docker stop jellyfin
				sudo docker rm jellyfin
			;;
			"nextcloud")
				sudo docker stop nextcloud
				sudo docker rm nextcloud
			;;
			"lamp")
				sudo docker stop lamp
				sudo docker rm lamp
			;;
			"filebrowser")
				sudo docker stop filebrowser
				sudo docker rm filebrowser
			;;
			"mqtt")
				sudo docker stop mqtt
				sudo docker rm mqtt
			;;
		esac
	;;
	"start")
		case $2 in
			"homeassistant")
				sudo docker start homeassistant
			;;
			"seedbox")
				sudo docker start seedbox
			;;
			"downbox")
				sudo docker start downbox
			;;
			"jellyfin")
				sudo docker start jellyfin
			;;
			"nextcloud")
				sudo docker start nextcloud
			;;
			"lamp")
				sudo docker start lamp
			;;
			"filebrowser")
				sudo docker start filebrowser
			;;
			"mqtt")
				sudo docker start mqtt
			;;
		esac
	;;
	"restart")
		case $2 in
			"homeassistant")
				sudo docker stop homeassistant
				sudo docker start homeassistant
			;;
			"seedbox")
				sudo docker stop seedbox
				sudo docker start seedbox
			;;
			"downbox")
				sudo docker stop downbox
				sudo docker start downbox
			;;
			"jellyfin")
				sudo docker stop jellyfin
				sudo docker start jellyfin
			;;
			"nextcloud")
				sudo docker stop nextcloud
				sudo docker start nextcloud
			;;
			"lamp")
				sudo docker stop lamp
				sudo docker start lamp
			;;
			"filebrowser")
				sudo docker stop filebrowser
				sudo docker start filebrowser
			;;
			"mqtt")
				sudo docker stop mqtt
				sudo docker start mqtt
			;;
		esac
	;;
	"recover")
		case $2 in
			"homeassistant")
				sudo vm rm homeassistant
				sudo vm init homeassistant
			;;
			"seedbox")
				sudo vm rm seedbox
				sudo vm init seedbox
			;;
			"downbox")
				sudo vm rm downbox
				sudo vm init downbox
			;;
			"jellyfin")
				sudo vm rm jellyfin
				sudo vm init jellyfin
			;;
			"nextcloud")
				sudo vm rm nextcloud
				sudo vm init nextcloud
			;;
			"lamp")
				sudo vm rm lamp
				sudo vm init lamp
			;;
			"filebrowser")
				sudo vm rm filebrowser
				sudo vm init filebrowser
			;;
			"mqtt")
				sudo vm rm mqtt
				sudo vm init mqtt
			;;
		esac
	;;
esac
