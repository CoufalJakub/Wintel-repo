REM==========================================================================================
REM PLEASE BE AWARE: SERVICING (I.E. HOTFIXES AND SERVICE PACKS) WILL STILL REPLACE FILES 
REM IN THE ORIGINAL DIRECTORIES. THE LIKELIHOOD THAT FILES IN THE INETPUB DIRECTORIES HAVE 
REM TO BE REPLACED BY SERVICING IS LOW BUT FOR THIS REASON DELETING THE ORIGINAL DIRECTORIES
REM IS NOT POSSIBLE. 
REM FROM COMMAND LINE "MoveIISbat D[WHERE 'D' DRIVE TO MOVE INETPUB FOLDER]"
REM==========================================================================================


@echo off
IF "%1" == "" goto err
setlocal
set MOVETO=%1:\

IF NOT EXIST %MOVETO% goto err
%windir%\system32\inetsrv\appcmd add backup beforeRootMove

iisreset /stop

echo on

xcopy %systemdrive%\inetpub %MOVETO%inetpub /O /E /I /Q

@echo off

reg add HKLM\System\CurrentControlSet\Services\WAS\Parameters /v ConfigIsolationPath /t REG_SZ /d %MOVETO%inetpub\temp\appPools /f

%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/sites -siteDefaults.traceFailedRequestsLogging.directory:"%MOVETO%inetpub\logs
\FailedReqLogFiles"

%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/sites -siteDefaults.logfile.directory:"%MOVETO%inetpub\logs\logfiles"
%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/log -centralBinaryLogFile.directory:"%MOVETO%inetpub\logs\logfiles"
%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/log -centralW3CLogFile.directory:"%MOVETO%inetpub\logs\logfiles"
%windir%\system32\inetsrv\appcmd set config -section:system.applicationHost/sites -siteDefaults.ftpServer.logFile.directory:"%MOVETO%inetpub\logs\logfiles"
%windir%\system32\inetsrv\appcmd set config -section:system.ftpServer/log -centralLogFile.directory:"%MOVETO%inetpub\logs\logfiles"

%windir%\system32\inetsrv\appcmd set config -section:system.applicationhost/configHistory -path:%MOVETO%inetpub\history
%windir%\system32\inetsrv\appcmd set config -section:system.webServer/asp -cache.disktemplateCacheDirectory:"%MOVETO%inetpub\temp\ASP Compiled Templates"
%windir%\system32\inetsrv\appcmd set config -section:system.webServer/httpCompression -directory:"%MOVETO%inetpub\temp\IIS Temporary Compressed Files"
%windir%\system32\inetsrv\appcmd set vdir "Default Web Site/" -physicalPath:%MOVETO%inetpub\wwwroot
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='401'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='403'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='404'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='405'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='406'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='412'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='500'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='501'].prefixLanguageFilePath:%MOVETO%inetpub\custerr
%windir%\system32\inetsrv\appcmd set config -section:httpErrors /[statusCode='502'].prefixLanguageFilePath:%MOVETO%inetpub\custerr

reg add HKLM\Software\Microsoft\inetstp /v PathWWWRoot /t REG_SZ /d %MOVETO%inetpub\wwwroot /f 
reg add HKLM\Software\Microsoft\inetstp /v PathFTPRoot /t REG_SZ /d %MOVETO%inetpub\ftproot /f

if not "%ProgramFiles(x86)%" == "" reg add HKLM\Software\Wow6432Node\Microsoft\inetstp /v PathWWWRoot /t REG_EXPAND_SZ /d %MOVETO%inetpub\wwwroot /f 
if not "%ProgramFiles(x86)%" == "" reg add HKLM\Software\Wow6432Node\Microsoft\inetstp /v PathFTPRoot /t REG_EXPAND_SZ /d %MOVETO%inetpub\ftproot /f

iisreset /start
echo.
echo.
echo ===============================================================================
echo Moved IIS root directory from %systemdrive%\ to %MOVETO%.
echo.
echo Please verify if the move worked.
echo If something went wrong you can restore the old settings via 
echo     "APPCMD restore backup beforeRootMove" 
echo and 
echo     "REG delete HKLM\System\CurrentControlSet\Services\WAS\Parameters\ConfigIsolationPath"
echo You also have to reset the PathWWWRoot and PathFTPRoot registry values
echo in HKEY_LOCAL_MACHINE\Software\Microsoft\InetStp.
echo ===============================================================================

endlocal
goto success

:err
echo. 
echo New root drive letter required. 
echo Here an example how to move the IIS root to the F:\ drive:
echo. 
echo MOVEIISROOT.BAT D[WHERE 'D' DRIVE TO MOVE INETPUB FOLDER]
echo.
echo. 
:success