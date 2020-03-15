:: Choose a variety of IP Address configuration to change to
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

color 0a
@ECHO off
:start
cls
ECHO ===================================
ECHO == Wecome to IP ADDRESS CHANGER! ==
ECHO == (by Caleb Sargeant) ==
ECHO ===================================
ECHO.

:start
echo Welcome, %USERNAME%
echo What would you like to do?
echo.
echo 1. Change to a Static IP Address for LAN
echo 2. Change to a Static IP Address for Internet
echo 3. Change to a Static IP Address with Static DNS Settings
echo 4. Obtain IP Address Automatically
echo.
echo 8. Go to Connectivity Tools
echo 9. Go to Predefined Settings
echo 0. Quit
echo.

set /p choice="Enter your choice: "
if "%choice%"=="1" goto static_lan
if "%choice%"=="2" goto static_internet
if "%choice%"=="3" goto static_dns
if "%choice%"=="4" goto dhcp
if "%choice%"=="8" goto conn_tools
if "%choice%"=="9" goto predefined
if "%choice%"=="0" exit
echo Invalid choice: %choice%
echo.
pause
cls
goto start

:static_lan
cls
set /p ipaddr= Type in the IP Address:
set /p subnet= Type in the Subnet Mask:
netsh interface ip set address "Local Area Connection" static %ipaddr% %subnet% none
exit

:static_internet
cls
set /p ipaddr= Type in the IP Address:
set /p subnet= Type in the Subnet Mask:
set /p gateway= Type in the Default Gateway:
exit

:static_dns
cls
set /p ipaddr= Type in the IP Address:
set /p subnet= Type in the Subnet Mask:
set /p gateway= Type in the Default Gateway:
set /p pridns= Type in the Primary DNS Server Address:
set /p secdns= Type in the Secondary DNS Server Address:
exit

:dhcp
cls
echo Obtaining IP Address Automatically . . .
echo.
netsh interface ip set address "Local Area Connection" dhcp
ipconfig /renew "Local Area Connection"
exit

:conn_tools
cls
echo Which tool would you like to use?
echo.
echo 1. Renew Automatic IP
echo 2. Flush Cache
echo 3. Release and Renew Automatic IP
echo 4. All of the above

set /p choice3="Enter your choice: "
if "%choice3%"=="1" goto renew
if "%chouce3%"=="2" goto flushdns
if "%choice3%"=="3" goto release
if "%choice3%"=="4" goto all
echo Invalid choice: %choice2%
echo.
pause
cls
goto conn_tools

:renew
cls
ipconfig /renew
exit

:flushdns
cls
ipconfig /flushdns
exit
