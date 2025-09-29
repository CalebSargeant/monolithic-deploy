:: Backup the userprofile
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@ECHO OFF
cd \

ver | find "2003" > nul
if %ERRORLEVEL% == 0 goto ver_2003

ver | find "XP" > nul
if %ERRORLEVEL% == 0 goto ver_xp

ver | find "2000" > nul
if %ERRORLEVEL% == 0 goto ver_2000

if not exist %SystemRoot%\system32\systeminfo.exe goto warnthenexit

systeminfo | find "OS Name" > %TEMP%\osname.txt
FOR /F "usebackq delims=: tokens=2" %%i IN (%TEMP%\osname.txt) DO set vers=%%i

echo %vers% | find "Windows 7" > nul
if %ERRORLEVEL% == 0 goto ver_7

echo %vers% | find "Windows Server 2008" > nul
if %ERRORLEVEL% == 0 goto ver_2008

echo %vers% | find "Windows Vista" > nul
if %ERRORLEVEL% == 0 goto ver_vista

:ver_2003
color 0a
echo Windows Server 2003 Detected
echo.
goto diskpartXCopy

:ver_xp
echo Windows XP Detected
echo.
goto diskpartXCopy

:ver_2000
echo Windows 2000 Detected
echo.
goto diskpartXCopy

:ver_7
echo Windows 7 Detected
echo.
goto diskpartRoboCopy

:ver_2008
echo Windows Server 2008 Detected

echo.
goto diskpartRoboCopy

:ver_vista
echo Windows Vista Detected
echo.
goto diskpartRobocopy

:diskpartRoboCopy
echo list volume | diskpart
goto StartRobocopy

:diskpartXCopy
echo list volume | diskpart
goto StartXCopy

:StartXCopy
set /p choice=Backup the User Data to Drive (Ltr):
if '%choice%'=='a' goto xcopy
if '%choice%'=='b' goto xcopy
if '%choice%'=='c' goto xcopy
if '%choice%'=='d' goto xcopy
if '%choice%'=='e' goto xcopy
if '%choice%'=='f' goto xcopy
if '%choice%'=='g' goto xcopy
if '%choice%'=='h' goto xcopy
if '%choice%'=='i' goto xcopy
if '%choice%'=='j' goto xcopy
if '%choice%'=='k' goto xcopy
if '%choice%'=='l' goto xcopy
if '%choice%'=='m' goto xcopy
if '%choice%'=='n' goto xcopy
if '%choice%'=='o' goto xcopy
if '%choice%'=='p' goto xcopy
if '%choice%'=='q' goto xcopy
if '%choice%'=='r' goto xcopy
if '%choice%'=='s' goto xcopy
if '%choice%'=='t' goto xcopy
if '%choice%'=='u' goto xcopy
if '%choice%'=='v' goto xcopy
if '%choice%'=='w' goto xcopy
if '%choice%'=='x' goto xcopy
if '%choice%'=='y' goto xcopy
if '%choice%'=='z' goto xcopy
if not '%choice%'=='' ECHO "%choice%" is not valid. Enter a letter.
goto StartXCopy

:xcopy
XCOPY %appdata%\Microsoft\Outlook\*.* %choice%:\UserData\Outlook\nk2\ /S /E /H /Y

XCOPY %localappdata%\"Application Data"\Microsoft\Outlook\*.* %choice%:\UserData\Outlook\pst\ /S /E /H /Y
XCOPY %appdata%\Microsoft\Signatures\*.* %choice%:\UserData\Outlook\Signatures\ /S /E /H /Y
XCOPY %userprofile%\"My Documents"\*.* %choice%:\UserData\Data\"My Documents"\ /S /E /H /Y
XCOPY %userprofile%\Desktop\*.* %choice%:\UserData\Desktop\ /S /E /H /Y
XCOPY %appdata%\Mozilla\Firefox\Profiles\*.* %choice%:\UserData\InternetData\FF\ /S /E /H /Y
XCOPY %userprofile%\Favorites\*.* %choice%:\UserData\InternetData\IE\ /S /E /H /Y
XCOPY %localappdata%\Google\Chrome\*.* %choice%:\UserData\InternetData\GC\ /S /E /H /Y
pause
goto exit

:StartRobocopy
set /p choice=Backup the User Data to Drive (Ltr):
if '%choice%'=='a' goto robocopy
if '%choice%'=='b' goto robocopy
if '%choice%'=='c' goto robocopy
if '%choice%'=='d' goto robocopy
if '%choice%'=='e' goto robocopy
if '%choice%'=='f' goto robocopy
if '%choice%'=='g' goto robocopy
if '%choice%'=='h' goto robocopy
if '%choice%'=='i' goto robocopy
if '%choice%'=='j' goto robocopy
if '%choice%'=='k' goto robocopy
if '%choice%'=='l' goto robocopy
if '%choice%'=='m' goto robocopy
if '%choice%'=='n' goto robocopy
if '%choice%'=='o' goto robocopy
if '%choice%'=='p' goto robocopy
if '%choice%'=='q' goto robocopy
if '%choice%'=='r' goto robocopy
if '%choice%'=='s' goto robocopy
if '%choice%'=='t' goto robocopy
if '%choice%'=='u' goto robocopy
if '%choice%'=='v' goto robocopy
if '%choice%'=='w' goto robocopy
if '%choice%'=='x' goto robocopy
if '%choice%'=='y' goto robocopy
if '%choice%'=='z' goto robocopy
if not '%choice%'=='' ECHO "%choice%" is not valid. Enter a letter.
goto StartRoboCopy

:robocopy
ROBOCOPY %appdata%\Microsoft\Outlook\ %choice%:\UserData\Outlook\nk2\ /S /EFSRAW /COPY:DAT /R: /W{1 /BYTES
ROBOCOPY %localappdata%\"Application Data"\Microsoft\Outlook\ %choice%:\UserData\Outlook\pst\ /S /EFSRAW /COPY:DAT /R: /W{1 /BYTES
ROBOCOPY %appdata%\Microsoft\Signatures\ %choice%:\UserData\Outlook\Signatures\ /S /EFSRAW /COPY:DAT /R: /W{1 /BYTES
ROBOCOPY %userprofile%\ %choice%:\UserData\Data\"My Documents"\ /S /EFSRAW /COPY:DAT /R: /W{1 /BYTES
ROBOCOPY %appdata%\Mozilla\Firefox\Profiles\ %choice%:\UserData\InternetData\FF\ /S /EFSRAW /COPY:DAT /R: /W{1 /BYTES
ROBOCOPY %localappdata%\Google\Chrome\ %choice%:\UserData\InternetData\GC\ /S /EFSRAW /COPY:DAT /R: /W{1 /BYTES
pause
goto exit

:exit
exit
