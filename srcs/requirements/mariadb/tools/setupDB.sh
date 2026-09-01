#!/bin/sh

# Ensure the socket directory exists and has the correct permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Check if the WORDPRESS database exists (instead of the default mysql db)
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    
    echo "Creating database and users..."
    # We don't need mysql_install_db because apt-get already did it.
    
    # Start MariaDB temporarily to safely inject the SQL commands
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Start the MariaDB server in the foreground
echo "Starting MariaDB..."
exec mysqld_safe