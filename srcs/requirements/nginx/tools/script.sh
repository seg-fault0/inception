#!/bin/sh

sed -i "s|listen 443 ssl;|listen ${NGINX_PORT:-443} ssl;|" /etc/nginx/conf.d/wimam.conf
sed -i "s|fastcgi_pass wordpress:9000;|fastcgi_pass wordpress:${WP_PORT:-9000};|" /etc/nginx/conf.d/wimam.conf

exec nginx -g "daemon off;"