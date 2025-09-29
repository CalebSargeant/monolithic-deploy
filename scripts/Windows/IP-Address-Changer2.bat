:: Choose a variety of IP Address configuration to change to
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off

:::::::::::::::
:: VARIABLES ::
:::::::::::::::::::::::::::::
set subnetmask=255.255.255.0
set gateway=192.168.102.1
set dns1=192.168.102.251
set dns2=192.168.102.249
:::::::::::::::::::::::::::::

setlocal enableextensions enabledelayedexpansion

for /f %%i in (PCS.TXT) do (
  SET bHOSTUP=0
  ping -n 2 %%i |find "TTL=" && SET bHOSTUP=1
  IF !bHOSTUP! equ 1 (
    CALL :HOSTUP %%i
  ) else (
    CALL :HOSTDOWN %%i
  )
)

:HOSTUP
echo Host %1 is UP
cls

:HOSTDOWN
echo Host %1 is DOWN
@CHOICE /C:12 /M "Set Ip Address as: %1"
IF ERRORLEVEL 2 goto no
IF ERRORLEVEL 1 goto yes
goto eof

:yes
ECHO You have pressed "Y"!
netsh interface ip set address "Local Area Connection" static %ipaddr% %subnetmask% %gateway% 1
netsh interface ip add dns name="Local Area Connection" addr=%dns1% index=1
netsh interface ip add dns name="Local Area Connection" addr=%dns2% index=2
exit

:no
echo u hav pressed n
pause

:EOF
