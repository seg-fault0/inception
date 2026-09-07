#!/bin/sh

set -e

mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/wimam.key \
    -out /etc/nginx/ssl/wimam.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=42/OU=42/CN=${WP_PORT:-9000}"

rm -f /etc/nginx/sites-available/default \
	/etc/nginx/sites-enabled/default \
	/etc/nginx/conf.d/default.conf

sed -i "s|listen 443 ssl;|listen ${NGINX_PORT:-443} ssl;|" /etc/nginx/conf.d/wimam.conf
sed -i "s|fastcgi_pass wordpress:9000;|fastcgi_pass wordpress:${WP_PORT:-9000};|" /etc/nginx/conf.d/wimam.conf

exec nginx -g "daemon off;"