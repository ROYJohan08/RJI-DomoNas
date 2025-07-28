sudo mkdir /media/Films01
sudo mkdir /media/Films02
sudo mkdir /media/Series01
sudo mkdir /media/Series02
sudo mkdir /media/Series03
sudo mkdir /media/Docs01
sudo mkdir /media/Runable
sudo mkdir /media/Temp
sudo mkdir /media/Archive


echo "/dev/disk/by-uuid/07C1B017487CD384 /media/Series01 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/0C2020846A4195D6 /media/Series02 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/6877284162D6D93C /media/Series03 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/23BF5EEE4C02F6EE /media/Films01 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/E8D250EAD250BF0E /media/Films02 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/2FB75EE05993C324 /media/Docs01 auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/E8DA9EC8DA9E9304 /media/Runable auto noatime 0 1" >> /etc/fstab
echo "/dev/disk/by-uuid/294D561D3EF1F925 /media/Archive auto noatime 0 1" >> /etc/fstab

sudo mount -a --onlyonce
