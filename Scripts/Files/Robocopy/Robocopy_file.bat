::robocopy source, destination, file to copy
for /f %%a in (servers.txt) do robocopy "C:\temp" "\\%%a\c$\temp" NSC.ini