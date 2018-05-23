#Silent install on remote computer, needs source file on each computer
Get-Content servers.txt | ForEach-Object{ 
    Invoke-Command -ComputerName $_ -ScriptBlock {& cmd.exe /c "C:\temp\BES-Client.exe /v/qn /VINSTALLDIR="C:\IEM"}
}