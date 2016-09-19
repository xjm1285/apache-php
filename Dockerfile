FROM debian:jessie
MAINTAINER Alex Brandt <alunduil@alunduil.com>

RUN apt-get -y -qq update && apt-get install -y wget && \
    echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
    echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
    wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg && \
    export DEBIAN_FRONTEND='noninteractive' && \
    apt-get -qq update && \
    apt-get install -y --no-install-recommends \
        apache2-mpm-event \
        ca-certificates \
        php7.0 \
        php7.0-json \
        php7.0-intl \
        php7.0-curl \
        php7.0-mysql \
        php7.0-mcrypt \
        php7.0-gd \
        php7.0-sqlite3 \
        php7.0-ldap \
        php7.0-opcache \
        php7.0-xmlrpc \
        php7.0-xsl \
        php7.0-bz2 \
        php7.0-redis \
        php7.0-memcached \
        php7.0-zip \
        php7.0-soap \
        php7.0-bcmath \
        php7.0-mbstring \
        php7.0-apcu \
        php-pear && \
    pear install mail_mime mail_mimedecode net_smtp net_idna2-beta auth_sasl net_sieve crypt_gpg && \
    rm -rf /var/lib/apt/lists/*
    
RUN sed -e 's|;date.timezone =|date.timezone = Asia/Shanghai|' -i /etc/php/7.0/apache2/php.ini && \
    sed -e 's|short_open_tag = Off|short_open_tag = On|' -i /etc/php/7.0/apache2/php.ini && \
    sed -e 's|;always_populate_raw_post_data|always_populate_raw_post_data = -1|' -i /etc/php/7.0/apache2/php.ini && \
    a2ensite 000-default && \
    a2ensite default-ssl && \
    a2enmod expires && \
    a2enmod headers && \
    a2enmod ssl && \
    a2enmod rewrite && \
    a2enmod info && \
    a2enmod mime && \
    a2enmod env && \
    a2enmod dir

EXPOSE 80 443
ENTRYPOINT [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]
CMD [ "-k", "start" ]
