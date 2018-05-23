# Queries all currently running services into file
$serverlist = gc servers.txt

foreach($server in $serverlist){
    write-output $server | out-file services.txt -append
    Get-WmiObject Win32_Service -comp $server  | 
        where{
            ($_.state -like "*running*")
            }|select DisplayName,Name,StartMode,State|ft -AutoSize | out-file services.txt -append
}