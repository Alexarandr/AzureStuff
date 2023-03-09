#az network vnet create --name vm-alex --resource-group m2i-formation  
#az network nic create --name custom-nic-alex
#az vm create --name vm-alex --resource-group m2i-formation --image UbuntuLTS --size Standard_B1s --admin-username alex --admin-password Azure123456789. --nics custom-nic-alex --location centralus 
# Objet avec les informations de l'adresse IP
# Objet avec les informations de l'adresse IP
$ip = @{
    Name = 'public-ip-az-powershell-alex'
    ResourceGroupName = 'm2i-formation'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
    Location  = "centralus"
}
# Création de l'adresse ip
$ipConfig = New-AzPublicIpAddress @ip

# Objet avec les informations du groupe de sécurité

$netSecurityGroup = @{
    Name = "security-group-az-powershell-alex"
    ResourceGroupName = "m2i-formation"
    Location  = "eastus"
}

# Création d'un security group
$nsc = New-AzNetworkSecurityGroup @netSecurityGroup

# Création des règles de sécurité
$nsc | Add-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 102 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 | Set-AzNetworkSecurityGroup

$nsc | Add-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow SSH" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 | Set-AzNetworkSecurityGroup


# Création d'une machine virtuelle

$infoVm = @{
    Name = 'vm-az-powershell-alex'
    ResourceGroupName = 'm2i-formation'
    Location  = "centralus"
    SecurityGroupName = $nsc
    Image ="UbuntuLTS"
    PublicIpAddressName = $ipConfig
}

$vm = New-AzVM @infoVm -Credential (Get-Credential)
