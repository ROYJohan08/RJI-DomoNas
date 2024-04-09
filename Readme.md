1. start with `sudo wget https://github.com/ROYJohan08/DomotikHomeNas/raw/main/Install.sh | bash`
2. next install drives with `sudo bash InstallDrives.sh`
3. for set MQTT password `sudo docker exec -it mqtt sh`, `mosquitto_passwd -C /mosquitto/config/password.txt hass`