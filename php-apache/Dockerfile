FROM php:5.6-apache

COPY ./vhost.conf ${APACHE_CONFDIR}/sites-available/

RUN a2ensite *.conf

RUN a2enmod rewrite

RUN a2dissite 000-default.conf \
    default-ssl.conf

RUN echo "ServerName localhost" >> ${APACHE_CONFDIR}/apache2.conf

ARG TZ
ARG DOCUMENT_ROOT
ARG SERVER_NAME
ARG SERVER_ALIAS
ARG SERVER_ADMIN
ARG NODE_VERSION

ENV TZ=${TZ}
ENV DOCUMENT_ROOT=${DOCUMENT_ROOT}
ENV SERVER_NAME=${SERVER_NAME}
ENV SERVER_ALIAS=${SERVER_ALIAS}
ENV SERVER_ADMIN=${SERVER_ADMIN}
ENV NODE_VERSION=${NODE_VERSION}

RUN export DOCUMENT_ROOT=${DOCUMENT_ROOT}
RUN export SERVER_NAME=${SERVER_NAME}
RUN export SERVER_ALIAS=${SERVER_ALIAS}
RUN export SERVER_ADMIN=${SERVER_ADMIN}

###############################################################################
# AJUSTA A HORA DO SERVIDOR
###############################################################################
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###############################################################################
# PDO E MySQL
###############################################################################
RUN apt-get update && apt-get install -y libpq-dev postgresql-client \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql mysql mysqli pdo_mysql sockets

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
# PHP Memcached / GD
###############################################################################
RUN apt-get update \
  && apt-get install -y php5-memcached php5-gd \
  && apt-get install -y build-essential memcached php-pear \
  && yes | pecl install memcached

###############################################################################
# Composer
###############################################################################

WORKDIR /tmp

RUN apt-get update -y && \
    apt-get install -y curl git php5-mcrypt mc && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update && \
    apt-get clean

WORKDIR ~/

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && . ~/.bashrc \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && nvm alias ${NODE_VERSION}

###############################################################################
# EXTRAS
###############################################################################

COPY .bash_aliases /root/.bash_aliases

RUN . ~/.bashrc

WORKDIR /var/www

EXPOSE 80 443 9000

CMD ["apache2-foreground"]