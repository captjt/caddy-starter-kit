<a href="https://caddyserver.com"><img src="https://caddyserver.com/resources/images/caddy-lower.png" alt="Caddy" width="200"></a>
<img src="https://lh3.googleusercontent.com/MjBg-tZSC0bzca-YbIa_IuR0-yHpXLfaINtdcEkF9ARE_xNArijKgt2ksQPYX6W-hA=w170" width="50">
<a href="https://www.centos.org/"><img src="http://seeklogo.com/images/C/centos-logo-494F57D973-seeklogo.com.png" alt="Centos" width="50"></a>

Caddy Starter Kit
=================
The sole purpose of mine while doing this project is to automated a way for the great technologies of Caddy and Centos flavored Linux to be integrated. I made this solely for a proof-of-concept that I can actually do this. I do not recommend this to be the one source of truth when trying to install Caddy on Centos.  

What The Script Executes
========================
1. Creates a "caddy_download" directory in $HOME
2. Downloads Caddy tarbal & extracts that tarbal (all inside #1 directory)
3. Downloads the [caddy.service](./caddy.service) file to $HOME directory
4. Copies the Caddy binary to the `/usr/local/bin` directory & change ownership/executable rights
5. Allows Caddy to bind to HTTP/SSL ports
6. Sets up www-data group (standard is 33 on Linux)
7. Creates an `/etc/caddy` directory for Caddy settings & establish ownership/permissions
8. Creates an `/etc/ssl/caddy` directory for your TLS certificates -- make sure to keep this directory safe
9. Creates a `/var/www` directory for your sites static files & establish ownsership/permissions
10. Copies your Caddyfile (must be in $HOME) to #6
11. Copies the `caddy.service` file (from #3) to the `/etc/systemd/system` directory & establish ownsership/permissions
12. Reloads `daemon`
13. Starts `caddy.service`
14. Enables `caddy.service`
15. Shows status of `caddy.service`

How To Install
==============

```bash
wget -O- https://raw.githubusercontent.com/jtaylor32/caddy-starter-kit/master/centos.sh | bash
```

Misc.
=====
You must have a Caddyfile located in the `$HOME` directory. Also, make sure that Caddyfile is a valid Caddyfile -- you might run into issues when you have the wrong syntax, etc.

If you would like to serve static files with Caddy just drop them into the `/var/www` directory.

You can `start, stop, enable, disable, status, ...` like any typical `systemctl` command would take on the `caddy.service` file.

Make sure you backup and keep track of the certificates inside of the `/etc/ssl/caddy` directory.

This is truly only a proof-of-concept at the moment. **NOT** production ready.

Acknowledgements
================
Thanks to all the people/communities around Caddy & Centos. Both are fantastic software products!
