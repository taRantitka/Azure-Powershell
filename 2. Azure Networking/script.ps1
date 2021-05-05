$RG = New-AzureRmResourceGroup -Nmae AdatumRG - Location westeurope
$GWSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet - AddressPrefix 192.168.200.0/28
New-AzureRmVirtualNetwork -ResourceGroupName $RG.ResourceGroupName -Name AdatumVnet -AddressPrefix 192.168.0.0/16 -Subnet $GWSubnet -Location westeurope
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $RG.ResourceGroupName -Name AdatumVnet
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $GWSubnet.Name -VirtualNetwork $vnet
$pip = New-AzureRmPublicIpAddress -Name AdatumIP -ResourceGroupName $RG.ResourceGroupName -Location westeurope -AllocationMethod Dynamic
$ipconfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name GWIPConfig -Subnet $subnet -PublicIpAddress $pip
New-AzureRmVirtualNetworkGateway -Name AdatumGateway -ResourceGroupName $RG.ResourceGroupName -Location westeurope -IpConfigurations $ipconfig -GatewayType Vpn -VpnType RouteBased -EnableBgp $false -GatewaySku Standard

$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature -Subject "CN-AdatumRootCertificate" -KeyExportPolicy Exportable -HashAlgorithm sha256 -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign

New-SelfSignedCertificate -Type Custom -KeySpec Signature -Subject "CN-AdatumClientCertificate" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My" -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

$P2SRootCertName = "AdatumRootCert.cer"
$filePathForCert = "C:\AdatumRootCert.cer"
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2($filePathForCert)
$CertBase64 = [system.convert]::ToBase64String($cert.RawData)

$Gateway = Get-AzureRmVirtualNetworkGateway -ResourceGroupName $RG.ResourceGroupName -Name AdatumGateway
$VPNClientAddressPool = "172.16.201.0/24"

$Gateway.BgpSettings = $null 

Set-AzureRmVirtualNetworkGateway -VirtualNetworkGateway $Gateway -VpnClientAddressPool $VPNClientAddressPool
Add-AzureRmVpnClientRootCertificate -VpnClientRootCertificateName $P2SRootCertName -VirtualNetworkGatewayName $Gateway.Name -ResourceGroupName $RG.ResourceGroupName - PublicCertData
Get-AzureRmVpnClientPackage -ResourceGroupName AdatumRG -VirtualNetworkGatewayName $Gateway.Name -ProcessorArchitecture Amd64