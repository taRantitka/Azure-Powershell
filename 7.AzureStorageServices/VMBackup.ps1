$VmName = "myproject-vm"
$VmResourceGroup = "AzureResourceGroup2"
 
$vm = Get-AzVm -Name $VmName -ResourceGroupName $VmResourceGroup

Write-Output "VM $($vm.name) OS Disk Snapshot Begin"
$snapshotdisk = $vm.StorageProfile
     
 
$OSDiskSnapshotConfig = New-AzSnapshotConfig -SourceUri $snapshotdisk.OsDisk.ManagedDisk.id -CreateOption Copy -Location eastus -OsType Windows
$snapshotNameOS = "$($snapshotdisk.OsDisk.Name)_snapshot_$(Get-Date -Format ddMMyy)"
 
try {
    New-AzSnapshot -ResourceGroupName $VmResourceGroup -SnapshotName $snapshotNameOS -Snapshot $OSDiskSnapshotConfig -ErrorAction Stop
} catch {
    $_
}
     
Write-Output "VM $($vm.name) OS Disk Snapshot End"
