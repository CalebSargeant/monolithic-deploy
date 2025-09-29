:: Install MS Office
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
Title Microsoft Office Installation. Do not close this window.
echo This installation is only supported for Windows 7 and XP.

:: VARIABLES
:: ------------------------------
:: Microsoft Office 2010 Location
set office2010=\\synology\apps\microsoft\office\Office 2010 STD

:: Microsoft Office 2007 Location
set office2007=\\synology\apps\microsoft\office\Office 2007 SBE

:: Credentials
set username=domain\user
set passwd=password

:: ------------------------------
:: Make a temporary location for Office .msp file
mkdir c:\temp

ver | find "XP" > nul
if %ERRORLEVEL% == 0 goto ver_xp

if not exist %SystemRoot%\system32\systeminfo.exe goto warnthenexit

systeminfo | find "OS Name" > %TEMP%\osname.txt
FOR /F "usebackq delims=: tokens=2" %%i IN (%TEMP%\osname.txt) DO set vers=%%i

echo %vers% | find "Windows 7" > nul
if %ERRORLEVEL% == 0 goto ver_7

goto warnthenexit

:ver_7
echo Windows 7 detected ...
echo Installing Office 2010 ...
net use "%office2010%" /user:%username% %passwd%
xcopy "%office2010%\updates\autoinstalloffice2010.msp" c:\temp /s /e /h /y
"%office2010%\setup" /adminfile "c:\temp\AutoInstallOffice2010.MSP"
net use "%office2010%" /delete
goto exit

:ver_xp
echo Windows XP detected ...
echo Installing Office 2007 ...
net use "%office2007%" /user:%username% %passwd%
xcopy "%office2007%\updates\autoinstalloffice2007.msp" c:\temp /s /e /h /y
"%office2007%\setup" /adminfile "c:\temp\AutoInstallOffice2007.MSP"
net use "%office2007%" /delete07/03/2020 AutoOfficeInstall
goto exit

:warnthenexit
echo Machine undetermined.
exit

:exit
rmdir c:\temp /q /s
exit
