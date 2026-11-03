#!/bin/sh
# Roda como root na VM gw, depois do setup-gateway.sh.
set -e
cd "$(dirname "$0")"

apt-get install -y isc-dhcp-server

install -m 644 dhcpd.conf /etc/dhcp/dhcpd.conf
install -m 644 isc-dhcp-server /etc/default/isc-dhcp-server

dhcpd -t -cf /etc/dhcp/dhcpd.conf
systemctl restart isc-dhcp-server
