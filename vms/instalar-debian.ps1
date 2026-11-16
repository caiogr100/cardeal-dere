# Instala o Debian sozinho nas VMs, sem passar pelas telas do instalador.
# Uso: .\instalar-debian.ps1 -Iso C:\caminho\debian-12-netinst.iso [-Vms gw,ns] [-Senha cardeal]
# O usuário criado é o "caio", e o root fica com a mesma senha.
param(
    [Parameter(Mandatory)][string]$Iso,
    [string[]]$Vms = @("gw", "ns", "srv", "cliente"),
    [string]$Senha = "cardeal"
)

$vbox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$preseed = Join-Path $PSScriptRoot "preseed.cfg"
# Com "powershell -File", a lista chega como um texto só ("ns,srv").
$Vms = $Vms -split ","

foreach ($vm in $Vms) {
    $modelo = $preseed
    if ($vm -eq "cliente") {
        $modelo = Join-Path $env:TEMP "preseed-cliente.cfg"
        (Get-Content $preseed) -replace "standard, ssh-server$", "standard, ssh-server, xfce-desktop" |
            Set-Content -Encoding ascii $modelo
    }
    & $vbox unattended install $vm --iso=$Iso --user=caio --password=$Senha `
        --full-user-name=caio --hostname="$vm.cardeal.local" --locale=pt_BR `
        --country=BR --time-zone=America/Sao_Paulo --script-template=$modelo
    if ($LASTEXITCODE -ne 0) { throw "falhou ao preparar a VM $vm" }
    # Disco primeiro: vazio, cai no DVD; depois da instalação, já dá boot no sistema.
    & $vbox modifyvm $vm --boot1 disk --boot2 dvd --boot3 none --boot4 none
    & $vbox startvm $vm --type headless
}
