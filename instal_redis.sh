#!/bin/sh 
fuser -vki /var/lib/dpkg/lock
# install redis
apt-get -y update
apt-get -y install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
make test 
sudo make install
mkdir /etc/redis
cp /tmp/redis-stable/redis.conf /etc/redis

sed -i -e 's/supervised no/supervised systemd/g' /etc/redis/redis.conf
sed -i -e "s/dir \.\//dir \/var\/lib\/redis/g" /etc/redis/redis.conf

echo -n > /etc/systemd/system/redis.service
echo "[Unit]" >> /etc/systemd/system/redis.service
echo "Description=Redis In-Memory Data Store" >> /etc/systemd/system/redis.service
echo "After=network.target" >> /etc/systemd/system/redis.service
echo "" >> /etc/systemd/system/redis.service
echo "[Service]" >> /etc/systemd/system/redis.service
echo "User=redis" >> /etc/systemd/system/redis.service
echo "Group=redis" >> /etc/systemd/system/redis.service
echo "ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf" >> /etc/systemd/system/redis.service
echo "ExecStop=/usr/local/bin/redis-cli shutdown" >> /etc/systemd/system/redis.service
echo "Restart=always" >> /etc/systemd/system/redis.service
echo "" >> /etc/systemd/system/redis.service
echo "[Install]" >> /etc/systemd/system/redis.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/redis.service

adduser --system --group --no-create-home redis
mkdir /var/lib/redis
chown redis:redis /var/lib/redis
chmod 770 /var/lib/redis
systemctl enable redis


