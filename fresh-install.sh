#!/bin/bash
echo "Welcome to the installation.."
sudo apt-get update -y
sudo apt-get install nginx -y
sudo apt-get install php7.0-cli php7.0-curl php7.0-dev php7.0-fpm php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-opcache -y
sudo apt-get install mariadb-server mariadb-client -y
sudo apt-get install unzip varnish  phpmyadmin ufw  -y
sudo service php7.0-fpm restart
sudo service nginx restart
sudo service varnish restart
rm /etc/nginx/sites-available/default
cp default /etc/nginx/sites-available/default
rm /etc/nginx/nginx.conf
cp nginx.conf /etc/nginx/nginx.conf
rm cloudflare /etc/nginx/conf.d/cloudflare
cp cloudflare /etc/nginx/conf.d/cloudflare
sudo service nginx restart
rm /etc/php/7.0/fpm/php.ini
cp php.ini /etc/php/7.0/fpm/php.ini
sudo service php7.0-fpm restart
rm /etc/php/7.0/fpm/pool.d/www.conf
cp www.conf /etc/php/7.0/fpm/pool.d/www.conf
sudo service php7.0-fpm restart
rm /etc/default/varnish
cp varnish /etc/default/varnish
rm /etc/varnish/default.vcl
cp default.vcl /etc/varnish/default.vcl
cp /lib/systemd/system/varnish.service /etc/systemd/system/
sed -i 's/6081/80/g' /etc/systemd/system/varnish.service
sudo varnish restart

echo "nginx with php7 installed on port 8080.."
echo "Changing ssh port to 9022 - NOTE THAT - NO MORE 22"
sed -i 's/22/9022/g' /etc/ssh/sshd_config
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 9022
sudo ufw allow 80
sudo ufw enable
rm cloudflare
rm default
rm default.vcl
rm fresh-install.sh
rm install.sh
rm my.cnf
rm nginx.conf
rm php.ini
rm README.md
rm varnish
rm www.conf
sudo apt-get update -y
