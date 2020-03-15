:: Install specific apps from a share
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
Title Common Programs Install. Do not close this window.
:: VARIABLES
:: ---------------------------------
:: Credentials
set username=domain\user
set passwd=password
:: Share Location
set share=\\synology\apps
:: ---------------------------------
:: Find Processor Architecture
if %PROCESSOR_ARCHITECTURE%==x86 goto ver_x86
if %PROCESSOR_ARCHITECTURE%==x64 goto ver_x64
:: Log onto Synology using sas\Administrator for the session.
net use "%share%" /user:%username% %passwd%
:ver_x86
echo x86 Architecture detected
echo --------------------------
echo.
echo Step 1/4 - Installing Firefox
"%share%\Firefox Setup 21.0.exe" -ms
echo Step 2/4 - Installing VLC Media Player
"%share%\vlc-2.0.6-win32.exe" /S
echo Step 3/4 - Installing Adobe Reader
"%share%\apps\AdbeRdr11002_en_US.exe" /sAll /rs /msi EULA_ACCEPT=YES
echo Step 4/4 - Installing 7-Zip
"%share%\7z920.exe" /S
goto exit
:ver_x64
echo x64 Architecture detected
echo --------------------------
echo.
:: 64-bit app commands here.
goto ver_x86 rem delete this line after 64-bit app silent switches have been found
:: End the session with Synology
:exit
net use %share% /delete
exit
