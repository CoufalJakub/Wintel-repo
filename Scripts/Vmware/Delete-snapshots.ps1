#Deletes snapshots based on user input, with maximum running tasks at once(default 7)
#Remove all comments if run in POWERCLI

Get-Module -Name VMware* -ListAvailable | Import-Module

Connect-VIServer localhost

#Maximum running of 7 removals
$maxtasks = 7
$name = Read-Host 'Snapshot name'

#Dumbproofing against deleting all snapshots
if($name -ne "" -and $name -ne "*"){
    $snapshots = $name + "*"

    $all_snapshots = Get-VM | Get-Snapshot | Where { $_.Name -like $snapshots }

    foreach($snapshot in $all_snapshots){
        Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$false
        #Checks how many "Remove Snapshot tasks" are running
        $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
            while($tasks.Count -gt ($maxtasks-1)) {
                sleep 30
                $tasks = Get-Task -Status "Running" | where {$_.Name -eq "RemoveSnapshot_Task"}
            }

    }
}else{
    write-output "Use proper snapshot name"
}