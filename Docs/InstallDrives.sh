sudo mkdir /media/Films01
sudo mkdir /media/Films02
sudo mkdir /media/Series01
sudo mkdir /media/Series02
sudo mkdir /media/Series03
sudo mkdir /media/Docs01
sudo mkdir /media/Runable
echo "/dev/disk/by-uuid/462BA08F23A7BB61 /media/Series01 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/6877284162D6D93C /media/Series02 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/0C2020846A4195D6 /media/Series03 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/23BF5EEE4C02F6EE /media/Films01 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/04C4848478981CC7 /media/Films02 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/2FB75EE05993C324 /media/Docs01 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/F6809B44809B09EF /media/Runable auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab

sudo mount -a
