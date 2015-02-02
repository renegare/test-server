FROM        renegare/php:5.5.9

RUN         apt-get install -y make

RUN         rm -rf /var/www/html/index.php
COPY        . /var/app
WORKDIR     /var/app
EXPOSE      80
ENTRYPOINT  ["/usr/bin/make"]
