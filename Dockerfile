FROM debian:jessie

MAINTAINER Glaubert Dumpierre <dumpierre@gmail.com>

ARG TZ=America/Porto_Velho
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /var/www