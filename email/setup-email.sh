#!/bin/sh
# Roda como root na VM srv, antes do setup-web.sh. A senha dos usuários vem de SENHA (padrão: cardeal).
set -e
cd "$(dirname "$0")"
SENHA="${SENHA:-cardeal}"

apt-get update
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string cardeal.local" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install -y postfix dovecot-imapd dovecot-pop3d

postconf -e "myhostname = mail.cardeal.local"
postconf -e "mydomain = cardeal.local"
postconf -e 'myorigin = $mydomain'
postconf -e 'mydestination = $myhostname, $mydomain, localhost.$mydomain, localhost'
postconf -e "mynetworks = 127.0.0.0/8 192.168.10.0/24"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "home_mailbox = Maildir/"
# Sem STARTTLS, pelo mesmo motivo do Dovecot
postconf -e "smtpd_tls_security_level = none"
postconf -e "smtp_tls_security_level = none"

install -m 644 dovecot-local.conf /etc/dovecot/local.conf

for u in ana bruno; do
    id "$u" >/dev/null 2>&1 || useradd -m -s /bin/bash "$u"
    echo "$u:$SENHA" | chpasswd
done

postfix check
systemctl restart postfix dovecot
