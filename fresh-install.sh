#!/bin/bash
echo "Welcome to the installation.."
echo "Creating a new user.. "
sudo adduser nginxuser
sudo adduser nginxuser sudo
sudo apt-get update -y
sudo apt-get install nginx php5-fpm php5-mysql php5-cli unzip varnish vsftpd ufw -y
sudo service php5-fpm restart
sudo service vsftpd restart
sudo service nginx restart
sudo service varnish restart
sudo usermod -a -G www-data  nginxuser
rm /etc/nginx/sites-available/default
cp default /etc/nginx/sites-available/default
rm /etc/nginx/nginx.conf
cp nginx.conf /etc/nginx/nginx.conf
sudo service nginx restart
echo "nginx with php5 installed on port 8080.."
echo "Changing ssh port to 9022 - NOTE THAT - NO MORE 22"
sed -i 's/22/9022/g' /etc/ssh/sshd_config
rm /etc/default/varnish
cp varnish /etc/default/varnish
rm cloudflare /etc/nginx/conf.d/cloudflare
cp cloudflare /etc/nginx/conf.d/cloudflare
echo "varnish installed on port 80"
rm /etc/varnish/default.vcl
cp default.vcl /etc/varnish/default.vcl
rm /etc/vsftpd.conf
cp vsftpd.conf /etc/vsftpd.conf
echo "ftp server installed on port 21"
sudo service php5-fpm restart
sudo service vsftpd restart
sudo service nginx restart
cp /lib/systemd/system/varnish.service /etc/systemd/system/
sed -i 's/6081/80/g' /etc/systemd/system/varnish.service
sudo service varnish restart
sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 9022
sudo ufw allow 80
sudo ufw allow 9022
sudo ufw allow 10090:10100/tcp
sudo ufw enable
rm default
rm default.vcl
rm fresh-install.sh
rm nginx.conf
rm varnish
rm vsftpd.conf
reboot