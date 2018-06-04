#Silent install on remote computer, needs source file on each computer

WMIC /NODE:@servers.txt /USER:"contoso\admin" /PASSWORD:"" PROCESS CALL CREATE "cmd.exe /c cd C:\temp & BES-Client.exe /S /v/qn /VINSTALLDIR="C:\IEM"" 
