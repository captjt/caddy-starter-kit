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

caddy_download="/caddy_download"
etc_caddy_path="/etc/caddy"
etc_ssl_caddy_path="/etc/ssl/caddy"
var_www_path="/var/www"
caddyservice="/caddy.service"
caddyfile="/Caddyfile"
caddyfile_path=$HOME$caddyfile
caddyservice_path=$HOME$caddyservice
caddydownload_path=$HOME$caddy_download

# install wget for now... will do checks and use curl/wget in the future
sudo yum install wget --assumeyes

if [[ ! -d $caddydownload_path ]]; then
    echo "making /caddy_download directory for tarball"
    mkdir $HOME/caddy_files
fi

# This script will download and install the caddy binary and put it in your PATH
wget -P $HOME/caddy_files https://github.com/mholt/caddy/releases/download/v0.9.4/caddy_linux_amd64.tar.gz 
tar xf $HOME/caddy_files/caddy_linux_amd64.tar.gz -C $HOME/caddy_files/

# this will download the caddy.service file I am hosting in github and put it in your $HOME dir
wget -P $HOME https://raw.githubusercontent.com/jtaylor32/caddy-starter-kit/master/caddy.service


# copy caddy binary to be in our executable PATH (bin dir)
sudo cp $HOME/caddy_files/caddy_linux_amd64 /usr/local/bin/caddy
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy

# setup Caddy to be able to bind to our HTTP and SSL ports without being root
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

# grouping configuration for www-data group (standard 33)
sudo groupadd -g 33 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data

if [[ ! -d $etc_caddy_path ]]; then
    echo "making /etc/caddy directory and establishing ownership/permissions"
    sudo mkdir /etc/caddy
    sudo chown -R root:www-data /etc/caddy
fi

if [[ ! -d $etc_ssl_caddy_path ]]; then
    echo "making /etc/ssl/caddy directory and establishing ownership/permissions"
    sudo mkdir /etc/ssl/caddy
    sudo chown -R www-data:root /etc/ssl/caddy
    sudo chmod 0770 /etc/ssl/caddy
fi

if [[ ! -d $var_www_path ]]; then
    echo "making /var/www directory and establishing ownership/permissions"
    echo " >>> /var/www is where you will have to put your static files if you want caddy to serve them"
    sudo mkdir /var/www
    sudo chown www-data:www-data /var/www
    sudo chmod 555 /var/www
fi

if [[ ! -d $caddyfile_path ]]; then
    echo "moving your Caddyfile settings into place & establish ownership/permissions"
    sudo cp $HOME/Caddyfile /etc/caddy/
    sudo chown www-data:www-data /etc/caddy/Caddyfile
    sudo chmod 444 /etc/caddy/Caddyfile
else
    echo "make sure you have a Caddyfile saved in the home directory: $HOME"
    exit 0
fi

if [[ ! -d $caddyservice_path ]]; then
    echo "moving the caddy.service settings into place"
    sudo cp $HOME/caddy.service /etc/systemd/system/
    sudo chown root:root /etc/systemd/system/caddy.service
    sudo chmod 744 /etc/systemd/system/caddy.service
else
    echo "make sure you have a caddy.service saved in the home directory: $HOME"
    exit 0
fi

sudo systemctl daemon-reload
sudo systemctl start caddy.service
sudo systemctl enable caddy.service
sudo systemctl status caddy.service

echo "successfully installed and started the caddy server"
exit 0
