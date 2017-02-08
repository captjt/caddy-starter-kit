Caddy Starter Kit
=====================

This is a POC to get a full install -> setup -> start of Caddy on a Centos Machine

To install and run script ...

```bash
wget -O- https://raw.githubusercontent.com/jtaylor32/caddy-starter-kit/master/centos.sh | bash
```

If you want to serve static files after running this install you will need to either `cp` or `mv` your files to the `/var/www` directory so that Caddy can serve those files.
