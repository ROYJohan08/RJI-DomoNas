#!bin/sh

source /etc/RJIDocker/credentials.sh

PortLM=80
PortHA=1000
PortSB=1001
PortDB=1002
PortJF=1003
PortNC=1004
PortFB=1005
PortMQ=1007



ConfigHA="/media/Runable/Docker/HA-Config"
ConfigSB="/media/Runable/Docker/SB-Config"
ConfigDB="/media/Runable/Docker/DB-Config"
Config2DB="/media/Runable/Docker/DB-Config/custom"
ConfigJF="/media/Runable/Docker/JF-Config"
ConfigNC="/media/Runable/Docker/NC-Config"
ConfigFB="/media/Runable/Docker/FB-Config/"
ConfigLM="/media/Runable/Docker/LM-Config/"
ConfigMQ="/media/Runable/Docker/MQ-Config/"

DataSB="/media/Runable/SeedBox"
DataDB="/media/Runable/DownBox"
DataJF="/media/"
DataNC="/media/Docs/NC-Data"
DataFB="/"
DataLM="/media/Runable/Docker/LM-Data"
DataMQ="/media/Runable/Docker/MQ-Data"

case $1 in
	"homeassistant")
		sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $ConfigHA:/config -p $PortHA:8123 homeassistant/home-assistant:latest
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
		echo $VPNPass
		sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $Config2DB:/etc/openvpn/custom -v $DataDB:/data -v $ConfigDB:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VPNUser -e OPENVPN_PASSWORD=$VPNPass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/32 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:3.6
		sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped --link transmission -p $PortDB:8080 haugene/transmission-openvpn-proxy
	;;
	"jellyfin")
		sudo docker run -d --name jellyfin --restart=unless-stopped -e TZ=CET -v $ConfigJF:/config -v $DataJF:/media -p $PortJF:8096 -p 8920:8920 linuxserver/jellyfin:10.8.13
	;;
	"nextcloud")
		sudo docker run -d --name nextcloud --restart=unless-stopped -e TZ=CET -p $PortNC:80 -v $ConfigNC:/var/www/html/config -v $DataNC:/data nextcloud:18.0.4
	;;
	"lamp")
		sudo docker run -d --name lamp --restart=unless-stopped -e TZ=CET -v $DataLM:/var/www/html -p $PortLM:80 -p 3306:3306 lioshi/lamp:php7
	;;
	"filebrowser")
		sudo docker run -d --name filebrowser --restart=unless-stopped -e TZ=CET -v $DataFB:/srv -v $ConfigFB:/config/ -p $PortFB:80 filebrowser/filebrowser:v1.10.0
	;;
	"mqtt")
		sudo docker run -d --name mqtt --restart=unless-stopped -e TZ=CET -v $ConfigMQ:/mosquitto/config -v $DataMQ:/mosquitto/data -p $PortMQ:1883 -p 9001:9001  eclipse-mosquitto:2.0
	;;
esac
