#Creates snapshots with name from user input
#Requires VM names in servers.txt
#Remove all comments if run in POWERCLI

Get-Module -Name VMware* -ListAvailable | Import-Module
Connect-VIServer localhost

$snap_name = Read-Host 'Snapshot name'

$vmlist = Get-Content Servers.txt
foreach($VM1 in $VMlist) {
    $VM = $VM1 + "*"
    New-Snapshot -VM $vm -Name $snap_name
}