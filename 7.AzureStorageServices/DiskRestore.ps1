$SnapshotName = "myproject-vm_disk1_0758da962a044c5cab77910f2d7bd856_snapshot_310521"
$SnapshotResourceGroup = "AzureResourceGroup2"
$DiskNameOS = "vm-snapshotdisk"
 
$snapshotinfo = Get-AzSnapshot -ResourceGroupName $SnapshotResourceGroup -SnapshotName $snapshotName
 
New-AzDisk -DiskName $DiskNameOS (New-AzDiskConfig  -Location eastus -CreateOption Copy -SourceResourceId $snapshotinfo.Id) -ResourceGroupName $SnapshotResourceGroup