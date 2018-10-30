$servers = get-content servers.txt

@(
foreach ($srv in $servers){
Get-WMIObject Win32_OperatingSystem -ComputerName $srv | Select-Object version, csname, OSArchitecture


}) | out-file Architecture_result.txt
