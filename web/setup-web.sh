#!/bin/sh
# Roda como root na VM srv, ainda com a placa em NAT.
set -e
cd "$(dirname "$0")"

apt-get update
apt-get install -y apache2

install -d /var/www/cardeal
install -m 644 index.html /var/www/cardeal/index.html
install -m 644 cardeal.conf /etc/apache2/sites-available/cardeal.conf

a2dissite 000-default
a2ensite cardeal
apache2ctl configtest
systemctl reload apache2

install -m 644 interfaces /etc/network/interfaces
printf 'search cardeal.local\nnameserver 192.168.10.10\n' > /etc/resolv.conf
