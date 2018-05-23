#Query Powershell version remotely
$servers = Get-Content "servers.txt" 
@( 
foreach ($server in $servers) 
{ 
    Invoke-Command  -Computername $server -Scriptblock {$PSVersionTable.psversion}
}) | Out-file -FilePath "ps1_results.txt"