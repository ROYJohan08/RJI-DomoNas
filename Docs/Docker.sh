#!bin/sh

Port-HA=1000
Port-SB=1001
Port-DB=1002
Port-JF=1003
Port-NC=1004
Port-FB=1005
Port-LM=80

Config-HA="/media/Runable/Docker/HA-Config"
Config-SB="/media/Runable/Docker/SB-Config"
Config-DB="/media/Runable/Docker/DB-Config"
Config-JF="/media/Runable/Docker/JF-Config"
Config-NC="/media/Runable/Docker/NC-Config"
Config-FB="/media/Runable/Docker/FB-Config/"
Config-LM="/media/Runable/Docker/LM-Config/"

Data-SB="/media/Runable/SeedBox"
Data-DB="/media/Runable/DownBox"
Data-JF="/media/"
Data-NC="/media/Docs/NC-Data"
Data-FB="/"
Data-LM="/media/Runable/Docker/LM-Data"

VPNUser=""
VPNPass=""
User=""
Pass=""
case $1 in
	"init")
		case $2 in
			"homeassistant")
				sudo docker \
					run \
					-d \
					--name homeassistant \
					--privileged \
					--restart=unless-stopped \
					-e TZ=CET \
					-v $Config-HA:/config \
					-p $Port-HA:8123 \
					homeassistant/home-assistant:2023.5.4
			;;
			"seedbox")
				sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $sbConfig/GUI/
				sudo mv transmission-web-control/src/ $sbConfig/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker \
					run \
					-d \
					--name seedbox \
					--privileged \
					--restart=unless-stopped \
					-e TZ=CET \
					-e USER=$User \
					-e PASS=$Pass \
					-p $Port-SB:9091 \
					-p 51413:51413 \
					-p 51413:51413/udp \
					-v $Config-SB:/config \
					-v $Data-SB:/downloads/complete  \
					lscr.io/linuxserver/transmission:latest
				sudo docker exec seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
			;;
			"downbox")
				sudo docker \
					run \
					-d \
					--name transmission \
					--privileged \
					--restart=unless-stopped \
					-e TZ=CET \
					-p 9091:9091  \
					-p 51415:51414 \
					-p 51415:51414/udp \
					--cap-add=NET_ADMIN \
					-e TRANSMISSION_WEB_UI=transmission-web-control \
					-v ${Config-DB}/custom:/etc/openvpn/custom \
					-v $Data-DB:/data \
					-v $Config-DB:/config \
					-e OPENVPN_PROVIDER=CUSTOM \
					-e OPENVPN_USERNAME=$VpnUser \
					-e OPENVPN_PASSWORD=$Vpnpass \
					-e UFW_ALLOW_GW_NET=true \
					-e UFW_EXTRA_PORTS=9910,23561,443,83,9091 \
					-e DROP_DEFAULT_ROUTE=true \
					-e TRANSMISSION_RPC_USERNAME="$User" \
					-e TRANSMISSION_RPC_PASSWORD="$Pass" \
					-e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true \
					-e TRANSMISSION_RPC_WHITELIST_ENABLED=false \
					-e LOCAL_NETWORK=192.168.1.0/24 \
					--log-driver json-file \
					--log-opt max-size=10m \
					haugene/transmission-openvpn:4.0
				sudo docker \
					run \
					-d \
					--name downboxproxy \
					--privileged \
					--restart=unless-stopped \
					-e TZ=CET \
					--link transmission \
					-p $Port-DB:8080 \
					haugene/transmission-openvpn-proxy:3.4
			;;
			"jellyfin")
				sudo docker \
					run \
					-d \
					--name jellyfin  \
					--restart=unless-stopped \
					-e TZ=CET \
					-v $Config-JF:/config \
					-v $Data-JF:/media \
					-p $Port-JF:8096 \
					-p 8920:8920 \
					linuxserver/jellyfin:10.8.13
			;;
			"nextcloud")
				sudo docker \
					run \
					-d \
					--name nextcloud \
					--restart=unless-stopped \
					-e TZ=CET \
					-p $Port-NC:80 \
					-v $Config-NC:/var/www/html/config \
					-v $Data-NC:/data \
					nextcloud:18.0.4
			;;
			"lamp")
				sudo docker \
					run \
					-d \
					--name lamp \
					--restart=unless-stopped \
					-e TZ=CET \
					-v $Data-LM:/var/www/html \
					-p $Port-LM:80 \
					-p 3306:3306 \
					lioshi/lamp:php7
			;;
            "filebrowser")
				sudo docker \
					run \
					-d \
					--name filebrowser \
					--restart=unless-stopped \
					-e TZ=CET \
					-v $Data-FB:/srv \
					-v $Config-FB:/config/ \
					-p $Port-FB:80 \
					filebrowser/filebrowser:v1.10.0
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
			"nextcloud")
				sudo docker start nextcloud
			;;
			"lamp")
				sudo docker start lamp
			;;
   			"filebrowser")
				sudo docker start filebrowser
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
			"nextcloud")
				sudo docker stop nextcloud
			;;
			"lamp")
				sudo docker stop lamp
			;;
   			"filebrowser")
				sudo docker stop filebrowser
			;;
		esac
	;;
	"del")
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
				sudo docker stop transmission
				sudo docker rm transmission
				sudo docker stop downboxproxy
				sudo docker rm downboxproxy
			;;
   			"jellyfin")
				sudo docker stop jellyfin
				sudo docker rm jellyfin
			;;
 			"emby")
				sudo docker stop emby
				sudo docker rm emby
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
				sudo docker stop transmission
				sudo docker start transmission
				sudo docker stop downboxproxy
				sudo docker start downboxproxy
			;;
   			"jellyfin")
				sudo docker stop jellyfin
				sudo docker start jellyfin
			;;
   			"emby")
				sudo docker stop emby
				sudo docker start emby
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
		esac
	;;
	"help")
 		echo "sudo bash Docker.sh [DEMANDE] [SERVICE]"
		echo ""
		echo "[DEMANDE] : "
		echo "-init : Create the docker"
		echo "-start : Run the docker"
		echo "-Restart : Restart the docker"
		echo "-del : Delete the docker"
		echo "-recover : Delete the docker and recreate it"
		echo ""
		echo "[SERVICE] : "
		echo "-homeassistant"
		echo "-seedbox"
		echo "-downbox"
		echo "-jellyfin"
		echo "-all"
	;;
	*)
		echo "Invalid command, please use help arg for help"
	;;
esac
