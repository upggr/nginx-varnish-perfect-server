#!/bin/bash
echo "Welcome to the installation.."
echo "Creating a new user.. "
read -p 'Username: ' nginxuser
echo "You entered: $uservar - setting up user..."
sudo useradd nginxuser
echo "Setting the user's password.."
passwd nginxuser
echo "adding user to sudo"
sudo usermod -a -G sudo nginxuser
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
echo "varnish installed on port 80"
rm /etc/varnish/default.vcl
cp default.vcl /etc/varnish/default.vcl
rm /etc/vsftpd.conf
cp vsftpd.conf /etc/vsftpd.conf
echo "ftp server installed on port 21"
sudo service php5-fpm restart
sudo service vsftpd restart
sudo service nginx restart
sudo service varnish restart
sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 9022
sudo ufw allow 80
sudo ufw allow 9022
sudo ufw allow 10090:10100/tcp
sudo ufw enable
reboot