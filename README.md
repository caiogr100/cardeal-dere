# Cardeal Ltda: infraestrutura de rede

Trabalho de Redes de Computadores (UFPel, 2026/2). A rede interna da Cardeal
Ltda, uma empresa fictícia, roda em quatro máquinas virtuais no VirtualBox com
Debian 12: um gateway, dois servidores e um cliente usado nos testes e nas
capturas.

## Máquinas e endereços

| VM      | IP                              | Serviços                                  |
| ------- | ------------------------------- | ----------------------------------------- |
| gw      | 192.168.10.1                    | gateway com NAT (nftables) e DHCP         |
| ns      | 192.168.10.10                   | DNS (BIND9) e arquivos (Samba)            |
| srv     | 192.168.10.20                   | Web (Apache) e e-mail (Postfix e Dovecot) |
| cliente | 192.168.10.100 a .200, via DHCP | Wireshark, Thunderbird e Firefox          |

A rede é a 192.168.10.0/24. Os nomes `www` e `mail` apontam para a srv, e
`files` aponta para a ns. Só o gw tem uma placa em NAT (a WAN); as outras VMs
saem para a internet passando por ele.

## Como montar

1. Instalar o VirtualBox e baixar a ISO netinst do Debian 12.
2. No Windows, rodar `vms\criar-vms.ps1 -Iso caminho\da\iso`. As VMs começam
   com a placa em NAT para conseguir baixar os pacotes.
3. Instalar o Debian em cada VM, usando o nome dela como hostname e
   `cardeal.local` como domínio. Só o cliente leva interface gráfica (XFCE).
4. Em cada VM, clonar este repositório e rodar como root, nesta ordem:
   - gw: `gateway/setup-gateway.sh` e depois `dhcp/setup-dhcp.sh`
   - ns: `dns/setup-dns.sh` e depois `samba/setup-samba.sh`
   - srv: `web/setup-web.sh` e depois `email/setup-email.sh`
   - cliente: `cliente/setup-cliente.sh usuario`
5. Desligar ns, srv e cliente e rodar `vms\ligar-na-lan.ps1`, que passa a
   placa delas para a rede interna `cardeal-lan`.

Os usuários de teste são ana e bruno, com a senha definida pela variável
`SENHA` (o padrão é `cardeal`).

## Pastas

Cada pasta de serviço guarda os arquivos de configuração e o script que os
instala. Em `relatorio/` ficam a primeira entrega, com o estudo de
viabilidade, e o relatório final. O desenho da rede está em
`topologia/topologia.png`.

## Autoria

Caio Garcez Ribeiro
