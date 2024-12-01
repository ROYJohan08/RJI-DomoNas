sudo mkdir /media/Film
sudo mkdir /media/OldSeries
sudo mkdir /media/Serie
sudo mkdir /media/Docs
sudo mkdir /media/ArchiveSerie
sudo mkdir /media/Runable
sudo mkdir /media/Runable2
echo "/dev/disk/by-uuid/462BA08F23A7BB61 /media/OldSeries auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/23BF5EEE4C02F6EE /media/Film auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/6877284162D6D93C /media/Serie auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/2FB75EE05993C324 /media/Documents auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/0C2020846A4195D6 /media/ArchiveSerie auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/04C4848478981CC7 /media/Runable2 auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
echo "/dev/disk/by-uuid/F6809B44809B09EF /media/Runable auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab

sudo mount -a
