#!/bin/bash 
sudo su
apt-get update -y
apt-get install nginx -y
echo "Hello World" >> /tmp/index.html
touch /var/www/index.html
cd  /var/
chmod -R 777 www/
cp /tmp/index.html /var/www/index.html
cat << EOF >> /tmp/nginx1.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
#       worker_connections 768;
        # multi_accept on;
}

http {

server {

listen 80;

root /var/www/;

index index.html;

}
}
EOF
cp /tmp/nginx1.conf /etc/nginx/nginx.conf
chown -R www-data:www-data /var/www/
service nginx start

systemctl enable nginx
apt-get update -y
sudo apt install mysql-server -y
service nginx restart

