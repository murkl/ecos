FROM gists/lighttpd

COPY ./ecos /var/www/ecos
COPY ./web/ /var/www/