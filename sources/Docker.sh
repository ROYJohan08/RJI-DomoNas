#!/bin/bash

# Chargement des variables
if [ -f /etc/RJIDomoNas/credentials.sh ]; then
    source /etc/RJIDomoNas/credentials.sh
else
    echo "Erreur : /etc/RJIDomoNas/credentials.sh non trouvé."
    exit 1
fi

# Fonction pour nettoyer le dossier temporaire git
clean_git() {
    sudo rm -rf transmission-web-control/
}

case $1 in
    "lamp")
        sudo docker run -d --name lamp --restart=unless-stopped \
            -e TZ=CET -v "$PathDkLamp":/app -p "$PortLamp":80 -p 3306:3306 \
            mattrayner/lamp:latest
    ;;

    "jellyfin")
        sudo docker run -d --name jellyfin --restart=unless-stopped \
            -e TZ=CET -v "$PathDkJellyFin1":/config -v "$PathDkJellyFin3":/media \
            -v "$PathDkJellyFin2":/cache -p "$PortJellyFin":8096 -p 8920:8920 \
            -e PUID=$USER_ID -e PGID=$GROUP_ID \
            --device /dev/dri/renderD128:/dev/dri/renderD128 \
            jellyfin/jellyfin:latest
    ;;

    "mqtt")
        sudo docker run -d --name mqtt --restart=unless-stopped \
            -e TZ=CET -v "$PathDkMqtt1":/mosquitto/config -v "$PathDkMqtt2":/mosquitto/data \
            -p "$PortMqtt":1883 -p 9001:9001 \
            eclipse-mosquitto:latest
        # Attendre un peu que le conteneur soit prêt avant l'exec
        sleep 2
        sudo docker exec mqtt sh -c "mosquitto_passwd -c $PathDkMqtt3 $Username"
    ;;

    "seedbox")
        sudo docker run -d --name seedbox --privileged --restart=unless-stopped \
            -e TZ=CET -v "$PathDkSeedBox1":/config -v "$PathDkSeedBox2":/downloads \
            -p "$PortSeedBox":9091 -p 51413:51413 -p 51413:51413/udp \
            -e PUID=$USER_ID -e PGID=$GROUP_ID -e USER="$Username" -e PASS="$HighPassword" \
            -e TRANSMISSION_DOWNLOAD_DIR=/downloads/SeedBox \
            lscr.io/linuxserver/transmission:latest
        
        # Installation Interface Web alternative
        sudo git clone https://github.com/ronggang/transmission-web-control.git
        sudo mkdir -p "$PathDkSeedBox1/GUI/"
        sudo cp -r transmission-web-control/src/* "$PathDkSeedBox1/GUI/"
        clean_git
        
        # Application de l'interface dans le conteneur
        sudo docker exec seedbox cp -r /config/GUI/index.html /usr/share/transmission/public_html/index.html
    ;;

    "all")
        # Appeler chaque cas un par un pour éviter la duplication de code
        $0 lamp
        $0 jellyfin
        $0 mqtt
        $0 seedbox
        # ... ajoute les autres ici
    ;;

    *)
        echo "Usage: $0 {all|lamp|homeassistant|jellyfin|filebrowser|portainer|grocy|mqtt|downbox|seedbox|freshrss}"
    ;;
esac
