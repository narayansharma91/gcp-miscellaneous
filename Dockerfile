########################### Docker file for Laravel application ##################################3
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
WORKDIR /var/www/html
RUN apt-get install -y \
    php7.1-fpm \
    curl \
    wget \
    vim \
    git \
    unzip \
    php7.1-curl \
    php7.1-gd \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-xml \
    php7.1-zip \
    php7.1-mysqli \
    nginx
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer
COPY . /var/www/html
CMD cd /var/www/html
RUN composer install
RUN rm -rf /var/cache/apk/*
ADD nginx.conf/default /etc/nginx/sites-available/default
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
RUN chmod +x cloud_sql_proxy
RUN mkdir /cloudsql
RUN chmod 777 /cloudsql
ADD start.sh /
RUN chmod +x /start.sh
RUN chmod 777 -R storage bootstrap/cache
EXPOSE 80
CMD ["/start.sh"]
