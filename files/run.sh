#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /DATA/htdocs ] ; then
  chown -R nginx:nginx /DATA
  mkdir -p /DATA/htdocs
  chown nginx:www-data /DATA/htdocs
fi

# start php-fpm
mkdir -p /DATA/logs/php-fpm
php-fpm

# start watch.sh
chmod +x /DATA/htdocs/watch.sh
./watch.sh &

#specific to lavarel
php /DATA/htdocs/artisan koel:generate-jwt-secret
php /DATA/htdocs/artisan key:generate

# start nginx
mkdir -p /DATA/logs/nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx

php /DATA/htdocs/artisan serve --host 0.0.0.0 &
nginx

