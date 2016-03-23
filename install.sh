#!/bin/bash
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/default
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/default.vcl
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/newsite.sh
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/nginx-installer.sh
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/nginx.conf
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/varnish
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/vsftpd.conf
wget https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/wordpress.template
chmod a+x newsite.sh
chmod a+x nginx-installer.sh
sudo sh ./nginx-installer.sh
