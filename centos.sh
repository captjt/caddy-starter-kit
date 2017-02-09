#!/usr/bin/env bash
#
#           Caddy Starter Kit(Centos)
#
# Once the script finishes you can do typical systemctl calls on caddy.service
#   sudo systemctl enable caddy.service
#   sudo systemctl stop caddy.service
#   sudo systemctl restart caddy.service
#   sudo systemctl status caddy.service
#   etc.

# This script will download and install the caddy binary and put it in your PATH
wget -qO- https://getcaddy.com | bash

# this will download the caddy.service file I am hosting in github and put it in your $HOME dir
wget https://raw.githubusercontent.com/jtaylor32/caddy-starter-kit/master/caddy.service

etc_caddy_path="/etc/caddy"
etc_ssl_caddy_path="/etc/ssl/caddy"
var_www_path="/var/www"
caddyservice="/caddy.service"
caddyfile="/Caddyfile"
caddyfile_path=$HOME$caddyfile
caddyservice_path=$HOME$caddyservice

# sudo chown root:root /usr/local/bin/caddy
# sudo chmod 755 /usr/local/bin/caddy

# create a www-data user for caddy to serve static files later on
sudo groupadd -g 33 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data

if [[ ! -d $etc_caddy_path ]]; then
    echo "making /etc/caddy directory and establishing ownership"
    sudo mkdir /etc/caddy
    sudo chown -R root:www-data /etc/caddy
fi

if [[ ! -d $etc_ssl_caddy_path ]]; then
    echo "making /etc/ssl/caddy directory and establishing ownership"
    sudo mkdir /etc/ssl/caddy
    sudo chown -R www-data:root /etc/ssl/caddy
    sudo chmod 0770 /etc/ssl/caddy
fi

if [[ ! -d $var_www_path ]]; then
    echo "making /var/www directory and establishing ownership"
    echo " >>> /var/www is where you will have to put your static files if you want caddy to serve them"
    sudo mkdir /var/www
    sudo chown www-data:www-data /var/www
    sudo chmod 555 /var/www
fi

if [[ ! -d $caddyfile_path ]]; then
    echo "moving your Caddyfile settings into place"
    sudo cp $HOME/Caddyfile /etc/caddy/
    sudo chown www-data:www-data /etc/caddy/Caddyfile
    sudo chmod 444 /etc/caddy/Caddyfile
else
    echo "make sure you have a Caddyfile saved in the home directory: $HOME"
    trap EXIT
fi

if [[ ! -d $caddyservice_path ]]; then
    echo "moving the caddy.service settings into place"
    sudo cp $HOME/caddy.service /etc/systemd/system/
    sudo chown root:root /etc/systemd/system/caddy.service
    sudo chmod 744 /etc/systemd/system/caddy.service
else
    echo "make sure you have a caddy.service saved in the home directory: $HOME"
    trap EXIT
fi

sudo systemctl daemon-reload
sudo systemctl start caddy.service
sudo systemctl enable caddy.service
sudo systemctl status caddy.service

echo "successfully installed and started the caddy server"
trap EXIT
