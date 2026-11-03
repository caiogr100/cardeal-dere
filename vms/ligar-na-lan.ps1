# Depois de instalar os pacotes, passa a placa de ns, srv e cliente da NAT para a rede interna.
# As VMs precisam estar desligadas.
$vbox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
foreach ($nome in "ns", "srv", "cliente") {
    & $vbox modifyvm $nome --nic1 intnet --intnet1 cardeal-lan
}
