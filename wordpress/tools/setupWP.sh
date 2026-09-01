#!/bin/sh

# Move to the mounted volume directory
cd /var/www/html

# Check for wp-config.php instead of just the directory to ensure it actually installed
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wget https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    rm latest.tar.gz

    # Move into the newly extracted wordpress folder
    cd /var/www/html/wordpress

    echo "Configuring wp-config.php..."
    cp wp-config-sample.php wp-config.php

    # Inject the database environment variables
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    
    # Point WordPress to the MariaDB container on port 3306
    sed -i "s/localhost/mariadb:3306/g" wp-config.php

    # Set proper permissions so Nginx and PHP can read/write
    chown -R www-data:www-data /var/www/html/wordpress
    chmod -R 755 /var/www/html/wordpress
fi

echo "Starting PHP-FPM..."
# Execute PHP-FPM in the foreground to keep the container running
exec /usr/sbin/php-fpm8.2 -F