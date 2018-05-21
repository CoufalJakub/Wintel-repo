#Sets/adds/creates registry value on remote computer

$servers = gc servers.txt
foreach ($server in $servers){
    #Opens HKLM on remote computer
    $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey(‘LocalMachine’, $server)
    #Path to adjacent key
    $Key= $Registry.CreateSubKey("SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ALLOW_USER32_EXCEPTION_HANDLER_HARDENING")
    #Use "String" "QWord" "Binary" instead of "DWORD"
    $Key.Setvalue(‘iexplore.exe’, ‘1’, ‘DWORD’)
}