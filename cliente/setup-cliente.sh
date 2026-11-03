#!/bin/sh
# Roda como root na VM cliente (Debian com XFCE), ainda com a placa em NAT.
# Uso: sh setup-cliente.sh nome-do-usuario
set -e
USUARIO="$1"
if [ -z "$USUARIO" ]; then
    echo "uso: $0 usuario"
    exit 1
fi

echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wireshark thunderbird smbclient dnsutils curl swaks

usermod -aG wireshark "$USUARIO"

# .local é reservado ao mDNS (RFC 6762). Sem esta troca, o cliente
# nem pergunta ao DNS por www.cardeal.local.
sed -i 's/^hosts:.*/hosts:          files dns/' /etc/nsswitch.conf
