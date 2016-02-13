FROM alpine:3.3
MAINTAINER Hardware <contact@meshup.net>

ENV GID=991 UID=991 VERSION=2.14 DBHOST=mariadb DBUSER=selfoss DBNAME=selfoss

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    php-fpm \
    php-gd \
    php-mysql \
    php-mysqli \
    supervisor \
    tini@commuedge \
 && rm -f /var/cache/apk/*

RUN wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && rm -rf /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup

RUN chmod +x /usr/local/bin/startup

EXPOSE 80

CMD ["/usr/bin/tini","--","/usr/local/bin/startup"]