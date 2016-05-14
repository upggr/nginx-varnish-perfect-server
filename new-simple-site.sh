#!/bin/bash
# Author: Ioannis Kokkinis
# Usage : new-simple-site.sh yoursite.com
NGINX_ALL_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'
WEB_DIR='/var/www'
SED=`which sed`
NGINX=`sudo which nginx`
CURRENT_DIR=`dirname $0`

if [ -z $1 ]; then
	echo "Usage new-simple-site.sh domain.com"
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
sudo cp $CURRENT_DIR/simple.template $CONFIG
sudo $SED -i "s/DOMAIN/$DOMAIN/g" $CONFIG
sudo $SED -i "s#ROOT#$WEB_DIR/$DOMAIN\/public_html#g" $CONFIG

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
sudo chown www-data:www-data $WEB_DIR/$DOMAINpublic_html -R
sudo chmod 755 /var/www
sudo chmod g+w /var/www -R


echo -e "\nSite Created for $DOMAIN"
echo "--------------------------"
echo "Host: "`hostname`
echo "URL: $DOMAIN"
echo "User: $USERNAME"
echo "--------------------------"
exit 0;
