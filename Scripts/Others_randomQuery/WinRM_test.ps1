#Tests whether the WinRM service is running on a local or remote computer.

$names = Get-Content "servers.txt" 
@( 
foreach ($name in $names){ 
    write-output $name
    test-wsman -computername $name -authentication default
}) | Out-file -FilePath "winrm_results.txt"