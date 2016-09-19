FROM debian:wheezy
MAINTAINER Alex Brandt <alunduil@alunduil.com>

COPY ZendGuardLoader.so /usr/lib/php5/ZendGuardLoader.so
RUN apt-get -qq update && \
    apt-get install -qq --no-install-recommends apache2 ca-certificates php5 php-pear php5-mysql php5-common php5-mcrypt php5-gd php5-curl php5-intl && \
    pear install mail_mime mail_mimedecode net_smtp net_idna2-beta auth_sasl net_sieve crypt_gpg && \
    rm -rf /var/lib/apt/lists/*
    
RUN sed -e 's|;date.timezone =|date.timezone = Asia/Shanghai|' -i /etc/php5/apache2/php.ini && \
    sed -e 's|short_open_tag = Off|short_open_tag = On|' -i /etc/php5/apache2/php.ini && \
    sed -e "/;zend.multibyte =/a\zend_extension=/usr/lib/php5/ZendGuardLoader.so" -i /etc/php5/apache2/php.ini && \
    sed -e "/;zend.multibyte =/a\zend_loader.enable=1" -i /etc/php5/apache2/php.ini && \
    a2ensite 000-default && \
    a2enmod expires && \
    a2enmod headers && \
    a2enmod ssl && \
    a2enmod rewrite && \
    a2enmod info && \
    a2enmod mime && \
    a2enmod php5 && \
    a2enmod env && \
    a2enmod actions && \
    a2enmod dir

EXPOSE 80 443
ENTRYPOINT [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]
CMD [ "-k", "start" ]
