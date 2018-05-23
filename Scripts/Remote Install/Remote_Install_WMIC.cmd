::Silent install on remote computer, needs source file on each computer

Set servers = GetObject(".\servers.txt")
For Each server in servers
	server = objComputer.CN
	WMIC /NODE:"server" /USER:"contoso\admin" /PASSWORD:"" PROCESS CALL CREATE "cmd.exe /c cd C:\temp & BES-Client.exe /S /v/qn /VINSTALLDIR="C:\IEM"" 
Next