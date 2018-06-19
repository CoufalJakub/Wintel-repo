# Removes all snapshots with common name, that are older than x days
Get-Module -Name VMware* -ListAvailable | Import-Module
Connect-VIServer localhost


$maxtasks = 5
$days = 3
$CommonName = "SnapDel"


$snapshots = "*" + $CommonName + "*"
$all_snapshots = Get-VM | Get-Snapshot | Where { $_.Name -like $snapshots -and $_.Created -lt (Get-Date).AddDays(-$days)}

foreach($snapshot in $all_snapshots){
        Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$false
        $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
            while($tasks.Count -gt ($maxtasks-1)) {
                sleep 30
                $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
            }

}
