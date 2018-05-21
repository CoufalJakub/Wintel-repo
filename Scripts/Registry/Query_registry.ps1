#Queries registry on remote computers

$servers = gc servers.txt
foreach ($server in $servers){
    #Opens HKLM on remote computer
    $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey(‘LocalMachine’, $server)
    #Path to adjacent key
    $Key= $Registry.OpenSubKey("System\CurrentControlSet\Services\TCPIP\Parameters",$True)
    #Registry value to query
    $Reg = $Key.getvalue(‘SearchList’) 
    "$server, $Reg" | out-file -filepath Registry_Query_results.txt -append
}