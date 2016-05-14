# The perfect superfast webserver
UPDATE - Now with PHP7 and mysql for UBUNTU 16


Usage :
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
Configuring mysql : <br>
All you have to do is run `sudo mysql_secure_installation` and answer the questions. You might want to allow root to login and remove it later, and you HAVE to set a password for mysql root.
<br>
<br>
Configuring phpmyadmin : <br>
Run `sudo apt-get install phpmyadmin -y` and follow the steps. Note that in the first step, you are presented with 2 options, apache and lighthttpd - do not select either.<br><br>
Configuring a database for your wordpress site : <br>
Just had to http://your.ip/phpmyadmin and create a new database. Then while in this database , go under privileges and add a new user / password. Do not touch any of the options, just create.
<br>
<br>
FTP access: <br>
No need for FTP access! Just use SFTP on port 22.
<br>
<br>
Cloning a github repository and have it pull continuously in the newly created host: <br>
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
<br>
Easily copy other files from other webservers using ftp: <br>
go to your public_html (`cd /var/www/yourdomain.com/public_html`)<br>
`sudo wget --ftp-user='username' --ftp-password='password' -nH --cut-dirs=2 -m ftp://your.other.old.host/site/wwwroot/*` (note the --cut-dirs=2 because the files are 2 subfolders deep in this example (/site/wwwroot/)<br>
<br>
<br>

Exclude one of your websites from varnish <br>
`sudo nano /etc/varnish/default.vcl`<br>
`if (req.http.host == "www.yourdomain.com" && req.url == "/") {return (pass);}`<br>
<br>
<br>
