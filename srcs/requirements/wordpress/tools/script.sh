#!/bin/sh

while ! nc -z mariadb ${MD_PORT}; do
    sleep 2
done

sed -i "s|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:${WP_PORT}|" /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php

cd /var/www/html

if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    wget https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    rm latest.tar.gz

    cd /var/www/html/wordpress

    cp wp-config-sample.php wp-config.php

    PW=$(cat /run/secrets/db_wp_user_pw)
    sed -i "s|database_name_here|$MYSQL_DATABASE|" wp-config.php
    sed -i "s|username_here|$MYSQL_USER|" wp-config.php
    sed -i "s|password_here|$PW|" wp-config.php    
    sed -i "s|localhost|mariadb:${MD_PORT}|" wp-config.php

    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    ADMIN_PW=$(cat /run/secrets/wp_admin_pw)
    wp core install \
        --url="https://wimam.42.fr" \
        --title="My WordPress Site" \
        --admin_user="$WP_SUPER_USER" \
        --admin_password="$ADMIN_PW" \
        --admin_email="$SUPER_USER_EMAIL" \
        --allow-root \
        --path='/var/www/html/wordpress'

    USER_PW=$(cat /run/secrets/wp_user_pw)
    wp user create \
        "$WP_USER" \
        "$USER_EMAIL" \
        --role=author \
        --user_pass="$USER_PW" \
        --allow-root \
        --path='/var/www/html/wordpress'
fi

chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

exec /usr/sbin/php-fpm8.2 -F