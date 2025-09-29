:: Choose a variety of IP Address configuration to change to
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@ECHO off
cls
:start
ECHO.
ECHO 1. Change to Static IP Address
ECHO 2. Obtain an IP Address Automatically
ECHO 3. Exit

set choice=
set /p choice=Change My IP Setting To:
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto static
if '%choice%'=='2' goto dynamic
if '%choice%'=='3' goto end
ECHO "%choice%" is not valid, try again.
ECHO.
goto start

:static
ECHO Changing to Static IP Address . . .
netsh interface ip set address "Local Area Connection" static 10.0.0.55 255.0.0.0 none
goto end

:dynamic
ECHO Changing to Dynamic IP Address . . .
netsh interface ip set address "Local Area Connection" dhcp
ipconfig /renew "Local Area Connection"
goto end

:end
