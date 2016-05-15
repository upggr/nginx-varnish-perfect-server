# The perfect superfast webserver
<b>UPDATE</b> - Now with PHP7 / mariadb /nginx / varnish for UBUNTU 16


<b>Usage</b> :<br>
Head to [digital ocean](https://m.do.co/c/6e83df0e17c6) or wherever, create a 5-10$ server (UBUNTU 16+), login as root, and run the following :
<br>
`curl -sL https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/install.sh | sudo bash -`

Run the following to create your first wordpess installation :<br>
`./new-wordpress-site.sh yourdomain.com` (replacing with your domain, no www allowed)

If you just want to install a simple site other than wordpress just run :<br> `./new-simple-site.sh yourdomain.com`

Then, just visit domain.com (provided you have pointed dns to your ip) and point to your mysql server.

Run the above commands for as many domains as you need. <br>

Here you have it, 1.000.000 hits/per day capable wordpress instance for 10$
<br>
Script supports cloudflare, if you combine cloudflare dns and caching with varnish and w3 total cache, you cant go faster :)
<br>
<br>
<b>Extras:</b><br>
<b>Configuring mysql</b>: <br>
All you have to do is run `sudo mysql_secure_installation` and answer the questions. You might want to allow root to login and remove it later, and you HAVE to set a password for mysql root.<br>
<br>
<b>Configuring phpmyadmin</b>: <br>
Run `sudo apt-get install phpmyadmin -y` and follow the steps. Note that in the first step, you are presented with 2 options, apache and lighthttpd - do not select either. Reboot in the end.<br>
You will also need a new mysql user other than root to login remotely to this phpmyadmin instance. (if you do want something like a root user). Lets assume you want a superuser with username : `mysqluser` and password : `mypassword` :<br>
`sudo mysql -uroot -p`<br>
`CREATE USER 'mysqluser'@'localhost' IDENTIFIED BY 'mypassword';`<br>
`GRANT ALL PRIVILEGES ON *.* TO 'mysqluser'@'localhost' WITH GRANT OPTION;`<br>
<br>
<b>Configuring a database for your wordpress site</b> : <br>
`sudo nano /etc/phpmyadmin/config.inc.php `
Add the following lines under i++ :
`$cfg['Servers'][$i]['host']          = '<remote-server-address>'; // Remote MySQL hostname or IP address`<br>
`$cfg['Servers'][$i]['port']          = '';          // MySQL port - leave blank for default port`<br>
`$cfg['Servers'][$i]['socket']        = '';          // Path to the socket - leave blank for default socket`<br>
`$cfg['Servers'][$i]['connect_type']  = 'tcp';       // How to connect to MySQL server ('tcp' or 'socket')`<br>
`$cfg['Servers'][$i]['extension']     = 'mysql';     // The php MySQL extension to use ('mysql' or 'mysqli')`<br>
`$cfg['Servers'][$i]['compress']      = FALSE;       // Use compressed protocol for the MySQL connection`<br>
`$cfg['Servers'][$i]['auth_type']     = 'config';    // Authentication method (config, http or cookie based)?`<br>
`$cfg['Servers'][$i]['user']          = '<db-username>';     // Remote MySQL user`<br>
`$cfg['Servers'][$i]['password']      = '<db-password>';     // Remote MySQL password`<br>
Go into your phpmyadmin and see the servers tab :) <br>
<br>
<b>Copy all data from a remote phpmyadmin mysql or mariadb database</b> : <br>
Just head to http://your.ip/phpmyadmin and create a new database. Then while in this database , go under privileges and add a new user / password. Do not touch any of the options, just create.<br>
<br>
<b>FTP access</b>: <br>
No need for FTP access! Just use SFTP on port 22.<br>
<br>
<b>Cloning a github repository and have it pull continuously in the newly created host</b>: <br>
`sudo apt-get install git`<br>
`sudo su - www-data -s /bin/bash`<br>
`ssh-keygen -t rsa -b 4096 -C "your.github@email.com"`<br>
`eval "$(ssh-agent -s)"`<br>
`ssh-add /var/www/.ssh/id_rsa`<br>
`cat /var/www/.ssh/id_rsa.pub` <===  Copy the output of this. Then head to your github repo or account and add this as a deploy key.<br>
Go to your web directory (`cd /var/www/yourdomain.com/public_html`)<br>
Run `git clone git@github.com:upggr/nginx-varnish-perfect-server.git .` <=== Just replace this address with the repository you are cloning<br>
create a new file : `gitpull.php` in your root (obviously, add it to your repo too so it is not removed with each pull)<br>
Add the following in the file : `<?php exec(git pull) ?>`<br>
Back in your github, under webhooks in your project settings, add the url : `http://yourwebsite.com/gitpull.php`<br>
<br>
<b>Easily copy other files from other webservers using ftp</b>: <br>
go to your public_html (`cd /var/www/yourdomain.com/public_html`)<br>
`sudo wget --ftp-user='username' --ftp-password='password' -nH --cut-dirs=2 -m ftp://your.other.old.host/site/wwwroot/*` (note the --cut-dirs=2 because the files are 2 subfolders deep in this example (/site/wwwroot/)<br>
<br>
<b>Exclude one of your websites from varnish</b>: <br>
`sudo nano /etc/varnish/default.vcl`<br>
`if (req.http.host == "www.yourdomain.com" && req.url == "/") {return (pass);}`<br>
<br>
