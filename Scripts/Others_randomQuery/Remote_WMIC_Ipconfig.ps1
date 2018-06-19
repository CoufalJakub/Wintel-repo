#Run ipconfig /all remotely and saves result as C:\temp\ipconfig.txt
#Use another script to copy/rename the results
WMIC /node:@servers.txt PROCESS CALL CREATE "cmd.exe /c ipconfig /all > C:\temp\ipconfig.txt" 
