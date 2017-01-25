FROM php:5.6-apache

COPY ./vhost.conf ${APACHE_CONFDIR}/sites-available/

RUN a2ensite *.conf

RUN a2enmod rewrite

ARG DOCUMENT_ROOT=/var/www/public
ARG SERVER_NAME=localhost
ARG SERVER_ALIAS=localhost
ARG SERVER_ADMIN=email@email.com

ENV DOCUMENT_ROOT=${DOCUMENT_ROOT}
ENV SERVER_NAME=${SERVER_NAME}
ENV SERVER_ALIAS=${SERVER_ALIAS}
ENV SERVER_ADMIN=${SERVER_ADMIN}

RUN export DOCUMENT_ROOT=${DOCUMENT_ROOT}
RUN export SERVER_NAME=${SERVER_NAME}
RUN export SERVER_ALIAS=${SERVER_ALIAS}
RUN export SERVER_ADMIN=${SERVER_ADMIN}


#RUN sed -i ${DOCUMENT_ROOT} ${APACHE_CONFDIR}/sites-available/vhost.conf
#RUN sed -i ${SERVER_NAME} ${APACHE_CONFDIR}/sites-available/vhost.conf
#RUN sed -i ${SERVER_ALIAS} ${APACHE_CONFDIR}/sites-available/vhost.conf
#RUN sed -i ${SERVER_ADMIN} ${APACHE_CONFDIR}/sites-available/vhost.conf

#RUN cat ${APACHE_CONFDIR}/sites-available/vhost.conf

###############################################################################
# PDO E MySQL
###############################################################################
RUN docker-php-ext-install \
    mysql \
    mysqli \
    pdo \
    pdo_mysql \

###############################################################################
# xDebug
###############################################################################
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.cli_color=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=dockerhost" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini

###############################################################################
# ZipArchive
###############################################################################
RUN apt-get update \
    && apt-get install -y zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip

###############################################################################
# PHP Memcached
###############################################################################
RUN apt-get update \
  && apt-get install -y php5-memcached \
  && apt-get install -y build-essential memcached php-pear \
  && yes | pecl install memcached

###############################################################################
# Composer
###############################################################################

WORKDIR /tmp

RUN apt-get update -y && \
    apt-get install -y curl git php5-mcrypt && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update && \
    apt-get remove --purge curl -y && \
    apt-get clean

###############################################################################
# EXTRAS
###############################################################################

RUN rm /root/.bashrc

COPY .bashrc /root/.bashrc

COPY .bash_aliases /root/.bash_aliases

RUN /bin/bash ~/.bashrc

WORKDIR /var/www

EXPOSE 80 443 9000

CMD ["apache2-foreground"]