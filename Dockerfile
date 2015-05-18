FROM debian:jessie

ENV OWNCLOUD_VERSION=8.0.3
ENV MAX_UPLOAD_SIZE=30G

RUN apt-get update \
    && apt-get install -y curl cron bzip2 smbclient nginx supervisor libav-tools libreoffice-writer \
    php5-cli php5-gd php5-pgsql php5-sqlite php5-mysqlnd php5-curl php5-intl \
    php5-mcrypt php5-ldap php5-gmp php5-apcu php5-imagick php5-fpm

RUN curl -L https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 | tar -xj -C /var/www

RUN mkdir /docker-entrypoint.d /var/www/owncloud/user-apps

COPY data/docker-entrypoint /docker-entrypoint
COPY data/supervisord.conf /etc/supervisor/conf.d/owncloud.conf
COPY data/nginx.conf /etc/nginx/nginx.conf

VOLUME /var/www/owncloud/config
VOLUME /var/www/owncloud/data
VOLUME /var/www/owncloud/user-apps
WORKDIR /var/www/owncloud

RUN chown -R www-data:www-data /var/www/owncloud

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint"]
CMD ["supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
