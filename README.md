# nginx-varnish-perfect-server

Usage :
Head to [digital ocean](https://m.do.co/c/6e83df0e17c6) or wherever, create a 5-10$ server, login as root, and run the following :
<br>
`curl -sL https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/install.sh | sudo bash -`

When the server reboots, ssh on port 9022 as root and run the following to create your first wordpess installation :<br>
`./new-wordpress-site yourdomain.com` (replacing with your domain, no www allowed)

If you just want to install a simple site other than wordpress just run :<br> `./new-simple-site yourdomain.com`

Then, just visit domain.com (provided you have pointed dns to your ip) and point to your mysql server. 

Run the above commands for as many domains as you need. <br>
There is some basic hardening on this configuration, and a user is created for you to use for the ftp server. The user is : `nginxuser`<br>
You can run `sudo passwd username` as root to set the user's password and use this instead of root or for your ftp.

Here you have it, 1.000.000 hits/per day capable wordpress instance for 10$
<br>
-- Scripts are still under development --<br>
-- You need your own mysql server, this script does not install mysql --<br>
Script supports cloudflare, if you combine cloudflare dns and caching with varnish and w3 total cache, you cant go faster :)
