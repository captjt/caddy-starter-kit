#!/usr/bin/env bash
#
#           Caddy Starter Script (Centos)
#
# Once the script finishes you can do typical systemctl calls on caddy.service
#   sudo systemctl enable caddy.service
#   sudo systemctl stop caddy.service
#   sudo systemctl restart caddy.service
#   sudo systemctl status caddy.service
#   etc.

sudo yum install wget --assumeyes

mkdir caddy_files
cd caddy_files

# This script will download and install the caddy binary and put it in your PATH
wget -qO- https://getcaddy.com | bash

sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy

sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

# create a www-data user for caddy to serve static files later on
sudo groupadd -g 33 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data

sudo mkdir /etc/caddy
sudo chown -R root:www-data /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R www-data:root /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy

# this is where you will have to put your html files if you want caddy to serve them
sudo mkdir /var/www
sudo chown www-data:www-data /var/www
sudo chmod 555 /var/www

# make sure your custom Caddyfile is located in the $HOME directory of the server (for now)
sudo cp $HOME/Caddyfile /etc/caddy/
sudo chown www-data:www-data /etc/caddy/Caddyfile
sudo chmod 444 /etc/caddy/Caddyfile

# make sure the caddy.service file is located in the same directory as this file
sudo cp $HOME/caddy.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 744 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl start caddy.service
