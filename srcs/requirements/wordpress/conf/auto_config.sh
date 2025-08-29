#!/bin/bash
set -ex

# Crear carpeta para PHP-FPM
mkdir -p /run/php
chown www-data:www-data /run/php

# Esperar a MariaDB
until mysql -h mariadb -u"$SQL_USER" -p"$SQL_PASSWORD" -e ";" ; do
    echo "Esperando a MariaDB..."
    sleep 2
done

# Crear wp-config.php si no existe
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Configurando WordPress automáticamente..."

    wp config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --path="/var/www/wordpress"

    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="/var/www/wordpress"

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root \
        --path="/var/www/wordpress"
fi

# Iniciar PHP-FPM en primer plano
exec php-fpm7.4 -F
