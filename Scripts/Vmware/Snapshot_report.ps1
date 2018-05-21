#Makes list of all snapshots
Get-Module -Name VMware* -ListAvailable | Import-Module

Connect-VIServer localhost
 
Get-VM | Get-Snapshot | Format-Table -Property VM, Name, Created, Description, @{N="Size";E={"{0:N2} GB" -f ($_.SizeGB)}} -autosize | Out-String -Width 4096 | out-file snapshot_report.csv