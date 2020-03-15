:: Download putty to system32
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
cd \
mkdir puttytmp
cd puttytmp
echo > putty123.exe
bitsadmin /transfer Downloading_Putty... /download /priority normal
http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe c:\puttytmp\putty123.exe
move /y putty123.exe %windir%\system32\
cd %windir%\system32\
if exist putty.exe del putty.exe
cd \
rd /s /q puttytmp

:: Create Shortcut Script
:: By Tim Stitt
:: timstitt@pacific.net.au
:: 2DEC2009
:: Version 1.0
:: Based on the vbs script found here
:: http://forums11.itrc.hp.com/service/forums/questionanswer.do?admit=109447626+1259674254056+28353475&threadId=938788

:: CHECK FOR EXISTING myshortcut.vbs SCRIPT AND DELETE
cd %userprofile%\Desktop
  if exist myshortcut.vbs del myshortcut.vbs

:: CREATE myshortcut.vbs FILE CONTAINING ALL COMMANDS for the vb script to create a shortcut of your file
FOR /F "tokens=1* delims=;" %%B IN ("Set oWS = WScript.CreateObject("WScript.Shell")") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN ("sLinkFile = "%SystemRoot%\System32\putty.lnk"") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs

FOR /F "tokens=1* delims=;" %%B IN ("Set oLink = oWS.CreateShortcut(sLinkFile)") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" oLink.TargetPath = "%SystemRoot%\System32\putty123.exe"") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" ' oLink.Arguments = """) do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" ' oLink.Description = "Putty"") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" ' oLink.HotKey = "ALT+CTRL+F"") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" ' oLink.IconLocation = "%SystemRoot%\System32\putty123.exe,2"") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" oLink.WindowStyle = 3") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" ' oLink.WorkingDirectory = "%SystemRoot%\System32\putty123.exe"") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs
FOR /F "tokens=1* delims=;" %%B IN (" oLink.Save") do echo %%B>>%userprofile%\Desktop\myshortcut.vbs

:: EXECUTE myshortcut.vbs
CSCRIPT myshortcut.vbs

ECHO Your shortcut should now be created
pause
:: Delete vbs script
  del myshortcut.vbs

exit
