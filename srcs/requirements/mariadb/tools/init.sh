#!/bin/bash
set -e

# Variables de entorno del .env
# SQL_ROOT_PASSWORD, SQL_DATABASE, SQL_USER, SQL_PASSWORD

# Arrancar MariaDB en segundo plano
mysqld --user=mysql &

# Esperar a que MariaDB esté lista
echo "Esperando a que MariaDB esté lista..."
until mysql -u root -p"$SQL_ROOT_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "MariaDB lista."

# Asegurar que root tiene contraseña (solo si no tiene)
ROOT_NO_PASS=$(mysql -u root -e "SELECT 1;" >/dev/null 2>&1; echo $?)
if [ "$ROOT_NO_PASS" -eq 0 ]; then
    echo "Root sin contraseña detectado. Estableciendo contraseña..."
    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

# Crear base de datos si no existe
mysql -u root -p"$SQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Crear usuario y otorgar privilegios solo si no existe
USER_EXISTS=$(mysql -u root -p"$SQL_ROOT_PASSWORD" -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${SQL_USER}');")
if [ "$USER_EXISTS" -eq 0 ]; then
    mysql -u root -p"$SQL_ROOT_PASSWORD" -e "CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -u root -p"$SQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';"
    mysql -u root -p"$SQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
    echo "Usuario ${SQL_USER} creado y privilegios otorgados."
else
    echo "Usuario ${SQL_USER} ya existe. No se realizan cambios."
fi

# Mantener MariaDB corriendo en primer plano
wait
