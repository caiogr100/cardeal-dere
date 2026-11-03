#!/bin/sh
# Roda como root na VM ns, ainda com a placa em NAT.
# Depois, desligar a VM e passar a placa para a rede interna (vms/ligar-na-lan.ps1).
set -e
cd "$(dirname "$0")"

apt-get update
apt-get install -y bind9 dnsutils

install -m 644 named.conf.options /etc/bind/named.conf.options
install -m 644 named.conf.local /etc/bind/named.conf.local
install -m 644 db.cardeal.local /etc/bind/db.cardeal.local
install -m 644 db.192.168.10 /etc/bind/db.192.168.10

named-checkconf
named-checkzone cardeal.local /etc/bind/db.cardeal.local
named-checkzone 10.168.192.in-addr.arpa /etc/bind/db.192.168.10
systemctl restart named

install -m 644 interfaces /etc/network/interfaces
printf 'search cardeal.local\nnameserver 192.168.10.10\n' > /etc/resolv.conf
