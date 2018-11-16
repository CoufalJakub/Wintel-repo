#Finds IP address from hostname

$servers = get-content servers.txt

foreach($server in $servers){
    $ip = [System.Net.Dns]::GetHostAddresses($server)
    
    write-host $server $ip.IPAddressToString
}
