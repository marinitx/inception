FROM debian:bullseye-slim

# Instalar MariaDB
RUN apt update && apt install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Copiar configuración personalizada
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copiar script de inicialización
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Crear carpeta de socket de MariaDB
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

EXPOSE 3306

# Iniciar MariaDB con el script
CMD ["/init.sh"]
