#Starts all stopped automatic services on computers from servers.txt

$servers = gc servers.txt
foreach($server in $servers){
    Get-WmiObject Win32_Service -comp $server  | 
        where{
            ($_.state -like "*stopped*" -and $_.Startmode -like "*auto*")
            }| start-service
}
