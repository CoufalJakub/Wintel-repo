::Start service on remote computers
for /f %%a in (.\servers.txt) do sc \\%%a start SNMP