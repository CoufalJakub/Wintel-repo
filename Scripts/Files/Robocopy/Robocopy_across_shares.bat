::copies C:\monitoring to 10.0.0.1\C:\temp\monitoring
NET USE \\10.0.0.1\IPC$ /u:"contoso\admin" "Password"
robocopy "C:\monitoring" "\\10.0.0.1\c$\temp\monitoring"
NET USE \\10.0.0.1\IPC$ /D