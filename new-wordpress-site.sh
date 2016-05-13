#!/bin/bash
# Author: Ioannis Kokkinis
# Usage : new-wordpress-site.sh yoursite.com
NGINX_ALL_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'
WEB_DIR='/var/www'
SED=`which sed`
NGINX=`sudo which nginx`
CURRENT_DIR=`dirname $0`
WWWUSER=`www-data`

if [ -z $1 ]; then
	echo "Usage new-wordpress-site.sh domain.com" 
	exit 1
fi
DOMAIN=$1
PATTERN="^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$";
if [[ "$DOMAIN" =~ $PATTERN ]]; then
	DOMAIN=`echo $DOMAIN | tr '[A-Z]' '[a-z]'`
	echo "Creating hosting for:" $DOMAIN
else
	echo "is this a domain?"
	exit 1
fi

sudo mkdir $WEB_DIR/$DOMAIN
sudo mkdir $WEB_DIR/$DOMAIN/public_html
CONFIG=$NGINX_ALL_VHOSTS/$DOMAIN.conf
sudo cp $CURRENT_DIR/wordpress.template $CONFIG
sudo $SED -i "s/DOMAIN/$DOMAIN/g" $CONFIG
sudo $SED -i "s#ROOT#$WEB_DIR/$DOMAIN\/public_html#g" $CONFIG

sudo usermod -aG $USERNAME www-data
sudo chmod g+rxs $WEB_DIR/$DOMAIN
sudo chmod 600 $CONFIG

sudo $NGINX -t
if [ $? -eq 0 ];then
	# Create symlink
	sudo ln -s $CONFIG $NGINX_ENABLED_VHOSTS/$DOMAIN.conf
else
	echo "errors: $CONFIG";
	exit 1;
fi

sudo /etc/init.d/nginx reload

cd $WEB_DIR/$DOMAIN/public_html
wget http://wordpress.org/latest.tar.gz && tar xfz latest.tar.gz
mv wordpress/* ./
rmdir ./wordpress/ && rm -f latest.tar.gz
cd wp-content/plugins/
rm -rf akismet
rm hello.php
cd ..
cd ..
echo "define('FS_METHOD', 'direct');" >> wp-config-sample.php
sudo chown $WWWUSER:$WWWUSER $WEB_DIR/$DOMAIN/public_html -R
sudo chmod 0755 $WEB_DIR/$DOMAIN/public_html
sudo chmod 0644 $WEB_DIR/$DOMAIN/public_html/wp-config.php
sudo chmod g+w $WEB_DIR -R


echo -e "\nSite Created for $DOMAIN"
echo "--------------------------"
echo "Host: "`hostname`
echo "URL: $DOMAIN"
echo "User: $USERNAME"
echo "--------------------------"
exit 0;
