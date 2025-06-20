#!bin/sh

source /etc/RJIDocker/credentials.sh

PortLM=80   # Lamp port
PortHA=1000 # HomeAssistant port
PortJF=1001 # JellyFin port
PortDB=1002 # DownBox port
PortSB=1003 # SeedBox port 
PortGO=1004 # Grocy port
PortPO=1005 # Portainer port
PortFB=1006 # FileBrowser port
PortMQ=1007 # MQTT port

ConfigLM="/media/Runable/Docker/LM-Config/"        # Lamp config folder
ConfigHA="/media/Runable/Docker/HA-Config"         # HomeAssistant config folder
ConfigJF="/media/Runable/Docker/JF-Config"         # Jellyfin config folder
ConfigFB="/media/Runable/Docker/FB-Config/"        # FileBrowser config folder
ConfigPO="/media/Runable/Docker/PO-Config"         # Portainer config folder
ConfigSB="/media/Runable/Docker/SB-Config"         # SeedBox config folder
ConfigDB="/media/Runable/Docker/DB-Config"         # Downbox config folder
Config2DB="/media/Runable/Docker/DB-Config/custom" # Downbox config folder ovpn
ConfigMQ="/media/Runable/Docker/MQ-Config/"        # Mosquito config folder
ConfigGO="/media/Runable/Docker/GO-Config/"        # Grocy config folder

DataLM="/media/Runable/Docker/LM-Data"             # Lamp data folder
DataJF="/media/"                                   # Jellyfin data folder
DataFB="/"                                         # FileBrowser data folder
DataSB="/media/Runable/SeedBox"                    # Seedbox data folder
DataDB="/media/Runable/DownBox"                    # DownBox data folder
DataMQ="/media/Runable/Docker/MQ-Data"             # Mosquito data folder

case $1 in
	"init")
		case $2 in
			"lamp")
				sudo docker run -d --name lamp --restart=unless-stopped -e TZ=CET -v $DataLM:/var/www/html -p $PortLM:80 -p 3306:3306 lioshi/lamp:php7
			;;
   			"homeassistant")
				sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $ConfigHA:/config -p 6666:6666 -p 6667:6667 -p $PortHA:8123 homeassistant/home-assistant:latest
			;;
			"jellyfin")
				sudo docker run -d --name jellyfin --restart=unless-stopped -e TZ=CET -v $ConfigJF:/config -v $DataJF:/media -p $PortJF:8096 -p 8920:8920 linuxserver/jellyfin:nightly
			;;
			"filebrowser")
				sudo docker run -d --name filebrowser --privileged --restart=unless-stopped -e TZ=CET -v $DataFB:/srv -v $ConfigFB:/config/ -p $PortFB:80 filebrowser/filebrowser:v1.10.0
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
				sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $Config2DB:/etc/openvpn/custom -v $DataDB:/data -v $ConfigDB:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VPNUser -e OPENVPN_PASSWORD=$VPNPass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e OPENVPN_PROVIDER=CUSTOM -e LOCAL_NETWORK=192.168.1.0/32 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:latest
				sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped --link transmission -p $PortDB:8080 haugene/transmission-openvpn-proxy:latest
			;;
			"mqtt")
				sudo docker run -d --name mqtt --restart=unless-stopped -e TZ=CET -v $ConfigMQ:/mosquitto/config -v $DataMQ:/mosquitto/data -p $PortMQ:1883 -p 9001:9001  eclipse-mosquitto:2.0
			;;
   			"grocy")
				sudo docker run -d --name grocy --restart=unless-stopped -e TZ=CET -v $ConfigGO:/config  -p $PortGO:80  lscr.io/linuxserver/grocy:latest
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
				sudo docker stop transmission
    				sudo docker stop downboxproxy
			;;
			"jellyfin")
				sudo docker stop jellyfin
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
   			"grocy")
				sudo docker stop grocy
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
				sudo docker stop downboxproxy
				sudo docker rm downboxproxy
				sudo docker stop transmission
				sudo docker rm transmission
			;;
			"jellyfin")
				sudo docker stop jellyfin
				sudo docker rm jellyfin
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
   			"grocy")
				sudo docker stop grocy
				sudo docker rm grocy
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
				sudo docker start transmission
    				sudo docker start downboxproxy
			;;
			"jellyfin")
				sudo docker start jellyfin
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
			"grocy")
				sudo docker start grocy
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
				sudo docker stop downboxproxy
				sudo docker start downboxproxy
    				sudo docker stop transmission
				sudo docker start transmission
			;;
			"jellyfin")
				sudo docker stop jellyfin
				sudo docker start jellyfin
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
   			"grocy")
				sudo docker stop grocy
				sudo docker start grocy
			;;
		esac
	;;
	"recover")
		case $2 in
			"homeassistant")
				sudo bash /etc/RJIDomoNas/Docker.sh rm homeassistant
				sudo bash /etc/RJIDomoNas/Docker.sh init homeassistant
			;;
			"seedbox")
				sudo bash /etc/RJIDomoNas/Docker.sh rm seedbox
				sudo bash /etc/RJIDomoNas/Docker.sh init seedbox
			;;
			"downbox")
				sudo bash /etc/RJIDomoNas/Docker.sh rm downbox
				sudo bash /etc/RJIDomoNas/Docker.sh init downbox
			;;
			"jellyfin")
				sudo bash /etc/RJIDomoNas/Docker.sh rm jellyfin
				sudo bash /etc/RJIDomoNas/Docker.sh init jellyfin
			;;
			"lamp")
				sudo bash /etc/RJIDomoNas/Docker.sh rm lamp
				sudo bash /etc/RJIDomoNas/Docker.sh init lamp
			;;
			"filebrowser")
				sudo bash /etc/RJIDomoNas/Docker.sh rm filebrowser
				sudo bash /etc/RJIDomoNas/Docker.sh init filebrowser
			;;
			"mqtt")
				sudo bash /etc/RJIDomoNas/Docker.sh rm mqtt
				sudo bash /etc/RJIDomoNas/Docker.sh init mqtt
			;;
   			"grocy")
				sudo bash /etc/RJIDomoNas/Docker.sh rm grocy
				sudo bash /etc/RJIDomoNas/Docker.sh init grocy
			;;
		esac
	;;
esac
