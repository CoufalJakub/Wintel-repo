#Script presses F13 every 2minutes for 12hours to disable locking of windows
$Null = [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
$allowclose = (get-date).touniversaltime().addhours(12)
while($allowclose -gt (get-date).touniversaltime()){
    [System.Windows.Forms.SendKeys]::SendWait("{F13}")
    [System.Windows.Forms.SendKeys]::SendWait("{F13}")
    write-host "." -nonewline
    start-sleep -seconds 120
}

