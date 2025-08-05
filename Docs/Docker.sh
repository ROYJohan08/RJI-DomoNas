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
				sudo docker run -d --name la --restart=unless-stopped -e TZ=CET -v $DataLM:/var/www/html -p $PortLM:80 -p 3306:3306 lioshi/lamp:php7
			;;
   			"homeassistant")
				sudo docker run -d --name ha --privileged --restart=unless-stopped -e TZ=CET -v $ConfigHA:/config -p 6666:6666 -p 6667:6667 -p $PortHA:8123 homeassistant/home-assistant:latest
			;;
			"jellyfin")
				sudo docker run -d --name jf --restart=unless-stopped -e TZ=CET -v $ConfigJF:/config -v $DataJF:/media -p $PortJF:8096 -p 8920:8920 linuxserver/jellyfin:nightly
			;;
			"filebrowser")
				sudo docker run -d --name fb --privileged --restart=unless-stopped -e TZ=CET -v $DataFB:/srv -v $ConfigFB:/config/ -p $PortFB:80 filebrowser/filebrowser:latest
			;;
			"portainer")
				sudo docker run -d --name po --privileged --restart=unless-stopped -e TZ=CET -p 8000:8000 -p 9443:9443 -p $PortPO:9000 -v /var/run/docker.sock:/var/run/docker.sock -v $ConfigSB:/data portainer/portainer-ce:latest
			;;
			"seedbox")
				sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $ConfigSB/GUI/
				sudo mv -f transmission-web-control/src/ $ConfigSB/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker run -d --name sb --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -e TRANSMISSION_WEB_HOME=/config/GUI -p $PortSB:9091 -p 51413:51413 -p 51413:51413/udp -v $ConfigSB:/config -v $DataSB:/downloads/complete lscr.io/linuxserver/transmission:latest
				sudo docker exec sb cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec sb cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec sb cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec sb cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec sb cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
			;;
			"downbox")
				sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $Config2DB:/etc/openvpn/custom -v $DataDB:/data -v $ConfigDB:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VPNUser -e OPENVPN_PASSWORD=$VPNPass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e OPENVPN_PROVIDER=CUSTOM -e LOCAL_NETWORK=192.168.1.0/32 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:latest
				sudo docker run -d --name dbp --privileged --restart=unless-stopped --link transmission -p $PortDB:8080 haugene/transmission-openvpn-proxy:latest
			;;
			"mqtt")
				sudo docker run -d --name mq --restart=unless-stopped -e TZ=CET -v $ConfigMQ:/mosquitto/config -v $DataMQ:/mosquitto/data -p $PortMQ:1883 -p 9001:9001  eclipse-mosquitto:2.0
                sudo docker exec -it mq sh & mosquitto_passwd -C /mosquitto/config/password.txt hass
			;;
   			"grocy")
				sudo docker run -d --name go --restart=unless-stopped -e TZ=CET -v $ConfigGO:/config  -p $PortGO:80  lscr.io/linuxserver/grocy:latest
			;;
		esac
	;;
esac

##################################################
#    @Date : 05/08/2025 12:48                    #
#    @Author : @ROYJohan                         #
#    @Version : 10b                              #
##################################################
