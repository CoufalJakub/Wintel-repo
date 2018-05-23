::Stop service on remote computers
for /f %%a in (.\servers.txt) do sc \\%%a stop SNMP