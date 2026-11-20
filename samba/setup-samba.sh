#!/bin/sh
# Roda como root na VM ns, antes do setup-dns.sh. A senha dos usuários vem de SENHA (padrão: cardeal).
set -e
cd "$(dirname "$0")"
SENHA="${SENHA:-cardeal}"

apt-get update
apt-get install -y samba smbclient

groupadd -f funcionarios
for u in ana bruno; do
    id "$u" >/dev/null 2>&1 || useradd -M -s /usr/sbin/nologin -G funcionarios "$u"
    printf '%s\n%s\n' "$SENHA" "$SENHA" | smbpasswd -a -s "$u"
done

install -d -m 2775 -g funcionarios /srv/samba/publico
install -m 644 smb.conf /etc/samba/smb.conf

testparm -s
systemctl restart smbd
