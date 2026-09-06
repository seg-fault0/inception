#!/bin/sh

echo "[mysqld]" > /etc/mysql/mariadb.conf.d/99-inception.cnf
echo "bind-address = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/99-inception.cnf
echo "port = ${MD_PORT}" >> /etc/mysql/mariadb.conf.d/99-inception.cnf

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

AUP=$(cat /run/secrets/db_alter_user_pw)
UP=$(cat /run/secrets/db_wp_user_pw)

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${AUP}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${UP}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

exec mysqld --user=mysql