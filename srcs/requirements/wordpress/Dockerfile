FROM debian:bullseye-slim

# Instalar dependencias
RUN apt update && apt upgrade -y && \
    apt install -y wget \
    php7.4 \
    php-fpm \
    php-mysql \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Descargar y descomprimir WordPress
WORKDIR /var/www
RUN wget https://es.wordpress.org/wordpress-6.0-es_ES.tar.gz && \
    tar -xzf wordpress-6.0-es_ES.tar.gz && \
    rm wordpress-6.0-es_ES.tar.gz && \
    chown -R root:root wordpress

WORKDIR /var/www/wordpress

# Configurar PHP-FPM para escuchar en wordpress:9000
RUN sed -i 's|^listen = .*|listen = wordpress:9000|' /etc/php/7.4/fpm/pool.d/www.conf && \
    echo 'clear_env = no' >> /etc/php/7.4/fpm/pool.d/www.conf

# Copiar script de inicialización
COPY ./conf/auto_config.sh /auto_config.sh
RUN chmod +x /auto_config.sh

# Instalar WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

ENTRYPOINT ["/auto_config.sh"]
