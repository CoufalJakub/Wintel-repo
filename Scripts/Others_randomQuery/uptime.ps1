#Gather uptime of multiple servers

$servers = Get-Content "servers.txt" 
@( 
foreach($server in $servers){ 
  if(Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue){ 
    $wmi = Get-WmiObject Win32_OperatingSystem -computer $server -ErrorAction SilentlyContinue
    try{
      $LBTime = $wmi.ConvertToDateTime($wmi.Lastbootuptime)
      [TimeSpan]$uptime = New-TimeSpan $LBTime $(get-date)
    }Catch{  
    }
    Write-output "$server Uptime is  $($uptime.days) Days $($uptime.hours) Hours $($uptime.minutes) Minutes $($uptime.seconds) Seconds" 
  } 
  else{ 
    Write-output "$server is not pinging" 
  } 
}) | Out-GridView -Title 'Uptime'
