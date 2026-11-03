#!/bin/sh
# Roda como root na VM gw.
set -e
cd "$(dirname "$0")"

apt-get update
apt-get install -y nftables

install -m 644 interfaces /etc/network/interfaces
install -m 644 99-roteamento.conf /etc/sysctl.d/99-roteamento.conf
install -m 755 nftables.conf /etc/nftables.conf

sysctl --system
systemctl enable --now nftables
nft -f /etc/nftables.conf
systemctl restart networking
