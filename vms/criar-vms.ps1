# Cria as quatro VMs no VirtualBox. Uso: .\criar-vms.ps1 -Iso C:\caminho\debian-12-netinst.iso
param([Parameter(Mandatory)][string]$Iso)

$vbox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$base = "$env:USERPROFILE\VirtualBox VMs"

function Nova-VM($nome, $ramMB, $discoGB) {
    & $vbox createvm --name $nome --ostype Debian_64 --register
    & $vbox modifyvm $nome --memory $ramMB --cpus 1 --nic1 nat
    $vdi = "$base\$nome\$nome.vdi"
    & $vbox createmedium disk --filename $vdi --size ($discoGB * 1024)
    & $vbox storagectl $nome --name SATA --add sata --controller IntelAhci
    & $vbox storageattach $nome --storagectl SATA --port 0 --device 0 --type hdd --medium $vdi
    & $vbox storageattach $nome --storagectl SATA --port 1 --device 0 --type dvddrive --medium $Iso
}

Nova-VM gw 1024 8
Nova-VM ns 1024 10
Nova-VM srv 1024 10
Nova-VM cliente 2048 20

# O gw tem uma segunda placa, ligada à rede interna (LAN).
& $vbox modifyvm gw --nic2 intnet --intnet2 cardeal-lan
