#!/bin/bash
set -e

# Leer variables del entorno (ya vienen del .env)
# SQL_ROOT_PASSWORD, SQL_DATABASE, SQL_USER, SQL_PASSWORD

# Iniciar MariaDB en segundo plano
mysqld --user=mysql &

# Esperar a que MariaDB esté lista
until mysql -u root -p"$SQL_ROOT_PASSWORD" -e "SELECT 1;" ; do
    echo "Esperando a MariaDB..."
    sleep 2
done

# Crear base de datos y usuario si no existen
mysql -u root -p"$SQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
mysql -u root -p"$SQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -u root -p"$SQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';"
mysql -u root -p"$SQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Mantener MariaDB corriendo
wait
