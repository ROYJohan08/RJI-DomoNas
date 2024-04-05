#!bin/sh
#HomeAssistant variables
haConfig="/media/Runable/Docker/HA-Config"
haPort=1000
#Seedbox variables
sbConfig="/media/Runable/Docker/SB-Config"
sbTelechargement="/media/Runable/SeedBox"
sbPort=1001
#Downbox variables
dbConfig="/media/Runable/Docker/DB-Config"
dbOvpn="/media/Runable/Docker/DB-Config/custom"
dbTelechargement="/media/Runable/DownBox"
dbPort=1002
#Jellyfin variables
jfConfig="/media/Runable/Docker/JF-Config"
jfCache="/media/Runable/Docker/JF-Cache"
jfMedia="/media/"
jfPort=1003
#Emby variables
emConfig="/media/Runable/Docker/EM-Config"
emCache="/media/Runable/Docker/EM-Cache"
emMedia="/media/"
emPort=1003
#Nextcloud variables
ncConfig="/media/Runable/Docker/NC-Config"
ncData="/media/Docs/NC-Data"
ncPort=1004
#FileBrowser variables
fbRoot="/media/Runable/Docker/FB-Config"
fbDatabase="/media/Runable/Docker/FB-Database/"
fbConfig="/media/Runable/Docker/FB-Config/"
fbData="/"
fbPort=1005
#LampVariable
lmMedia="/media/Runable/Docker/LM-Data"
lmPort=80
#General variables.
VPNUser=""
VPNPass=""
User=""
Pass=""
case $1 in
	"init")
		case $2 in
			"homeassistant")
				sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $haConfig:/config -p $haPort:8123 homeassistant/home-assistant:latest
			;;
			"seedbox")
				sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $sbConfig/GUI/
				sudo mv transmission-web-control/src/ $sbConfig/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker run -d --name seedbox --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -p $sbPort:9091 -p 51413:51413 -p 51413:51413/udp -v $sbConfig:/config -v $sbTelechargement:/downloads/complete  lscr.io/linuxserver/transmission:latest
				sudo docker exec seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
			;;
			"downbox")
				sudo docker run -d --name transmission --privileged --restart=unless-stopped -e TZ=CET -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $dbOvpn:/etc/openvpn/custom -v /media/Runable/Telechargements:/data -v $dbConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VpnUser -e OPENVPN_PASSWORD=$Vpnpass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/24 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:latest
				sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped -e TZ=CET --link transmission -p $dbPort:8080 haugene/transmission-openvpn-proxy:latest
			;;
			"jellyfin")
				sudo docker run -d --name jellyfin  --restart=unless-stopped -e TZ=CET -v $jfConfig:/config -v $jfCache:/cache -v $jfMedia:/media -p $jfPort:8096 -p 8920:8920 linuxserver/jellyfin:latest
			;;
   			"emby")
				sudo docker run -d  --name emby  --restart=unless-stopped -e TZ=CET -v $emConfig:/config -v $emMedia:/mnt/share1 --net=host  --device /dev/dri:/dev/dri  --gpus all  -p $emPort:8096 -p 8920:8920 --env GIDLIST=100 --restart emby/embyserver:latest
			;;
			"nextcloud")
				sudo docker run -d --name nextcloud --restart=unless-stopped -e TZ=CET -p $ncPort:80 -v $ncConfig:/var/www/html/config -v $ncData:/data nextcloud:latest
			;;
			"lamp")
				sudo docker run -d --name lamp --restart=unless-stopped -e TZ=CET -v $lmMedia:/var/www/html -p $lmPort:80 -p 3306:3306 lioshi/lamp:latest
			;;
                        "filebrowser")
				sudo docker run -d --name filebrowser --restart=unless-stopped -e TZ=CET -v $fbData:/srv -v $fbDatabase:/database/ -v $fbConfig:/config/ -p $fbPort:80 filebrowser/filebrowser:latest
			;;
			"all")
				sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $haConfig:/config -p $haPort:8123 homeassistant/home-assistant:latest
				sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $sbConfig/GUI/
				sudo mv transmission-web-control/src/ $sbConfig/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker run -d --name seedbox --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -p $sbPort:9091 -p 51413:51413 -p 51413:51413/udp -v $sbConfig:/config -v $sbTelechargement:/downloads/complete  lscr.io/linuxserver/transmission:latest
				sudo docker exec seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
   				sudo docker run -d --name transmission --privileged --restart=unless-stopped -e TZ=CET -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $dbOvpn:/etc/openvpn/custom -v /media/Runable/Telechargements:/data -v $dbConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VpnUser -e OPENVPN_PASSWORD=$Vpnpass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/24 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:latest
				sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped -e TZ=CET --link transmission -p $dbPort:8080 haugene/transmission-openvpn-proxy:latest
    				sudo docker run -d --name jellyfin  --restart=unless-stopped -e TZ=CET -v $jfConfig:/config -v $jfCache:/cache -v $jfMedia:/media -p $jfPort:8096 -p 8920:8920 linuxserver/jellyfin:latest
				sudo docker run -d --name nextcloud --restart=unless-stopped -e TZ=CET -p $ncPort:80 -v $ncConfig:/var/www/html/config -v $ncData:/data nextcloud:latest
    				sudo docker run -d --name lamp --restart=unless-stopped -e TZ=CET -v $lmMedia:/var/www/html -p $lmPort:80 -p 3306:3306 lioshi/lamp:latest
	sudo docker run -d --name filebrowser --restart=unless-stopped -e TZ=CET -v $fbData:/srv -v $fbDatabase:/database/ -v $fbConfig:/config/ -p $fbPort:80 filebrowser/filebrowser:latest
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
			"all")
				sudo docker start homeassistant
				sudo docker start seedbox
    			sudo docker start downbox
    			sudo docker start jellyfin
				sudo docker start nextcloud
				sudo docker start lamp
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
			"all")
				sudo docker stop homeassistant
				sudo docker stop seedbox
    			sudo docker stop downbox
    			sudo docker stop jellyfin
				sudo docker stop nextcloud
				sudo docker stop lamp
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
			"nextcloud")
				sudo docker stop nextcloud
				sudo docker rm nextcloud
			;;
			"lamp")
				sudo docker stop lamp
				sudo docker rm lamp
			;;
			"all")
				sudo docker stop homeassistant
				sudo docker rm homeassistant
    			sudo docker stop seedbox
				sudo docker rm seedbox
    			sudo docker stop transmission
				sudo docker rm transmission
				sudo docker stop downboxproxy
				sudo docker rm downboxproxy
    			sudo docker stop jellyfin
				sudo docker rm jellyfin
				sudo docker stop nextcloud
				sudo docker rm nextcloud
				sudo docker stop lamp
				sudo docker rm lamp
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
			"nextcloud")
				sudo docker stop nextcloud
				sudo docker start nextcloud
			;;
			"lamp")
				sudo docker stop lamp
				sudo docker start lamp
			;;
			"all")
				sudo docker stop homeassistant
				sudo docker start homeassistant
    			sudo docker stop seedbox
				sudo docker start seedbox
    			sudo docker stop transmission
				sudo docker start transmission
				sudo docker stop downboxproxy
				sudo docker start downboxproxy
    			sudo docker stop jellyfin
				sudo docker start jellyfin
				sudo docker stop nextcloud
				sudo docker start nextcloud
				sudo docker stop lamp
				sudo docker start lamp
			;;
		esac
	;;
	"recover")
		case $2 in
			"homeassistant")
				sudo docker stop homeassistant
				sudo docker rm homeassistant
				sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $haConfig:/config -p $haPort:8123 homeassistant/home-assistant
			;;
			"seedbox")
				sudo docker stop seedbox
				sudo docker rm seedbox
    			sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $sbConfig/GUI/
				sudo mv transmission-web-control/src/ $sbConfig/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker run -d --name seedbox --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -p $sbPort:9091 -p 51413:51413 -p 51413:51413/udp -v $sbConfig:/config -v $sbTelechargement:/downloads/complete  lscr.io/linuxserver/transmission:latest
				sudo docker exec seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
			;;
			"downbox")
				sudo docker stop transmission
				sudo docker rm transmission
				sudo docker stop downboxproxy
				sudo docker rm downboxproxy
    			#sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $dbOvpn:/etc/openvpn/custom -v $dbTelechargement:/data/completed -v $dbConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VpnUser -e OPENVPN_PASSWORD=$Vpnpass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/24 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:3.6
				sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $dbOvpn:/etc/openvpn/custom -v /media/Runable/Telechargements:/data -v $dbConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VpnUser -e OPENVPN_PASSWORD=$Vpnpass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/24 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:3.6
				sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped --link transmission -p $dbPort:8080 haugene/transmission-openvpn-proxy
			;;
   			"jellyfin")
				sudo docker stop jellyfin
				sudo docker rm jellyfin
    			sudo docker run -d --name jellyfin  --restart=unless-stopped -v $jfConfig:/config -v $jfCache:/cache -v $jfMedia:/media -p $jfPort:8096 -p 8920:8920 linuxserver/jellyfin:latest
			;;
			"nextcloud")
				sudo docker stop nextcloud
				sudo docker rm nextcloud
    			sudo docker run -d --name nextcloud --restart=unless-stopped -p $ncPort:80 -v $ncConfig:/var/www/html/config -v $ncData:/data nextcloud
			;;
			"lamp")
				sudo docker stop lamp
				sudo docker start lamp
				sudo docker run -d --name lamp --restart=unless-stopped -v $lmMedia:/var/www/html -p $lmPort:80 -p 3306:3306 lioshi/lamp:php5
			;;
			"all")
				sudo docker stop homeassistant
				sudo docker rm homeassistant
				sudo docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=CET -v $haConfig:/config -p $haPort:8123 homeassistant/home-assistant
				sudo docker stop seedbox
				sudo docker rm seedbox
    			sudo git clone https://github.com/ronggang/transmission-web-control.git
				sudo mkdir $sbConfig/GUI/
				sudo mv transmission-web-control/src/ $sbConfig/GUI/
				sudo rm -rf transmission-web-control/
				sudo docker run -d --name seedbox --privileged --restart=unless-stopped -e TZ=CET -e USER=$User -e PASS=$Pass -p $sbPort:9091 -p 51413:51413 -p 51413:51413/udp -v $sbConfig:/config -v $sbTelechargement:/downloads/complete  lscr.io/linuxserver/transmission:latest
				sudo docker exec seedbox cp -r /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.html.old
				sudo docker exec seedbox cp -r /config/GUI/src/index.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/index.moble.html /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/favicon.ico /usr/share/transmission/public_html/
				sudo docker exec seedbox cp -r /config/GUI/src/tr-web-control/ /usr/share/transmission/public_html/
				sudo docker stop transmission
				sudo docker rm transmission
				sudo docker stop downboxproxy
				sudo docker rm downboxproxy
    			#sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $dbOvpn:/etc/openvpn/custom -v $dbTelechargement:/data/completed -v $dbConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VpnUser -e OPENVPN_PASSWORD=$Vpnpass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/24 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:3.6
				sudo docker run -d --name transmission --privileged --restart=unless-stopped -p 9091:9091  -p 51415:51414 -p 51415:51414/udp --cap-add=NET_ADMIN -e TRANSMISSION_WEB_UI=transmission-web-control -v $dbOvpn:/etc/openvpn/custom -v /media/Runable/Telechargements:/data -v $dbConfig:/config -e OPENVPN_PROVIDER=CUSTOM -e OPENVPN_USERNAME=$VpnUser -e OPENVPN_PASSWORD=$Vpnpass -e UFW_ALLOW_GW_NET=true -e UFW_EXTRA_PORTS=9910,23561,443,83,9091 -e DROP_DEFAULT_ROUTE=true -e TRANSMISSION_RPC_USERNAME="$User" -e TRANSMISSION_RPC_PASSWORD="$Pass" -e TRANSMISSION_RPC_AUTHENTICATION_REQUIRED=true -e TRANSMISSION_RPC_WHITELIST_ENABLED=false -e LOCAL_NETWORK=192.168.1.0/24 --log-driver json-file --log-opt max-size=10m haugene/transmission-openvpn:3.6
				sudo docker run -d --name downboxproxy --privileged --restart=unless-stopped --link transmission -p $dbPort:8080 haugene/transmission-openvpn-proxy
				sudo docker stop jellyfin
				sudo docker rm jellyfin
    			sudo docker run -d --name jellyfin  --restart=unless-stopped -v $jfConfig:/config -v $jfCache:/cache -v $jfMedia:/media -p $jfPort:8096 -p 8920:8920 linuxserver/jellyfin:latest
				sudo docker stop nextcloud
				sudo docker rm nextcloud
    			sudo docker run -d --name nextcloud --restart=unless-stopped -p $ncPort:80 -v $ncConfig:/var/www/html/config -v $ncData:/data nextcloud
				sudo docker stop lamp
				sudo docker start lamp
				sudo docker run -d --name lamp --restart=unless-stopped -v $lmMedia:/var/www/html -p $lmPort:80 -p 3306:3306 lioshi/lamp:php5
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
