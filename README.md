# nginx-varnish-perfect-server

Usage :
Head to [digital ocean](https://m.do.co/c/6e83df0e17c6) or wherever, create a 5-10$ server, login as root, and run the following :
<br>
`curl -sL https://raw.githubusercontent.com/upggr/nginx-varnish-perfect-server/master/install.sh | sudo bash -`

When the server reboots, ssh on port 9022 as root and run the following to create your first wordpess installation :
`./install.sh yourdomain.com` (replacing with your domain, no www allowed)

Then, just visit domain.com (provided you have pointed dns to your ip) and point to your mysql server. 

Run ./install.sh for as many domains as needed.

Here you have it, 1.000.000 hits/per day capable wordpress instance for 10$

-- Scripts are still under development --
-- You need your own mysql server, this script does not install mysql --
