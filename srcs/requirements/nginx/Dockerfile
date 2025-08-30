FROM debian:bullseye-slim

RUN apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/ssl/certs /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/ssl/private/nginx-selfsigned.key \
      -out /etc/ssl/certs/nginx-selfsigned.crt \
      -subj "/C=ES/ST=Madrid/L=Madrid/O=Fanfan/CN=mhiguera.42.fr" && \
    chmod 600 /etc/ssl/private/nginx-selfsigned.key

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
