FROM debian:buster

ENV AUTOINDEX on

RUN apt-get update
RUN apt-get upgrade -y \
	&& apt install -y nginx \
	&& apt install -y vim \
	&& apt install -y wget \
	&& apt install -y mariadb-server 

COPY ./srcs/default /tmp/
COPY ./srcs/defaultOFF /tmp/
COPY ./srcs/index.php index.php

RUN apt install -y php7.3 php7.3-fpm php7.3-mysql php7.3-cli php7.3-pdo php7.3-gd php7.3-mbstring

WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz
RUN rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzf latest.tar.gz
RUN rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /var/www/html

RUN openssl req -nodes -x509 -days 365 -newkey rsa:2048 -subj "/C=FR/ST=France/L=Nice/O=42nice/OU=mtaouil/CN=localhost" -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

COPY ./srcs/start.sh ./
CMD bash start.sh
