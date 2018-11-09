#Query for current RAM, Pagefile, DesiredPagefile size(1,5xRAM) on multiple servers
$serverlist=get-content servers.txt  
$allobj = @() 
foreach ($server in $serverlist) {

 $physicalmem=get-wmiobject -computer $server Win32_ComputerSystem | % {$_.TotalPhysicalMemory} 
 $Pagefilesize=get-wmiobject -computer $server Win32_pagefileusage | % {$_.AllocatedBaseSize}
 $obj = new-object psobject -property @{
    Server = $server
    Memory =  $Physicalmem=[math]::round($physicalmem/1MB,0) 
    Pagefile = $pagefilesize
    DesiredSize = $physicalmem * 1.5
 } 
 $allobj += $obj

} 
Write-output $allobj | Format-Table Server, Memory, Pagefile, DesiredSize -Autosize | out-file RAM_pagefile.txt
