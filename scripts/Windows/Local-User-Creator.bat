:: Create a local user
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@ECHO off
:start
cls
ECHO =============================
ECHO == Wecome to USER CREATER! ==
ECHO == (by Caleb Sargeant) ==
ECHO =============================
ECHO.
set /p usrnme= Type in the Username:
set /p passwd= Type in the Password for %usrnme%:
net user %usrnme% %passwd% /add

choice /m "Is %usrnme% an Administrator?"
if errorlevel 2 goto adminno
if errorlevel 1 goto adminyes

:adminyes
net localgroup Administrators %usrnme% /add
goto createnewuserprompt

:adminno
goto exit

:createnewuserprompt
choice /m "Would you like to create another user?"
if errorlevel 2 goto exit
if errorlevel 1 goto start

:exit
%windir%\system32\lusrmgr.msc
exit
