#Queries snapshots based on name from user input
#Remove all comments if run in POWERCLI

Get-Module -Name VMware* -ListAvailable | Import-Module

Connect-VIServer localhost
$snap_name = Read-Host 'Snapshot name'
$snapshot_name = "*" + $snap_name + "*"

Get-VM | Get-Snapshot  | Where { $_.Name -like $snapshot_name } | Format-Table -Property VM, Name, Created, Description, @{N="Size";E={"{0:N2} GB" -f ($_.SizeGB)}} -autosize
pause