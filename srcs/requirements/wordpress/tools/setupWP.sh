#!/bin/sh

cd /var/www/html

if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    wget https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    rm latest.tar.gz

    cd /var/www/html/wordpress

    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    sed -i "s/localhost/mariadb:3306/g" wp-config.php

	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    wp core install \
        --url="https://wimam.42.fr" \
        --title="My WordPress Site" \
        --admin_user="sitechief" \
        --admin_password="SecureBossPassword123!" \
        --admin_email="chief@yourdomain.com" \
        --allow-root \
        --path='/var/www/html/wordpress'

    wp user create \
        authoruser \
        author@yourdomain.com \
        --role=author \
        --user_pass="SecureUserPassword123!" \
        --allow-root \
        --path='/var/www/html/wordpress'
fi

chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

exec /usr/sbin/php-fpm8.2 -F