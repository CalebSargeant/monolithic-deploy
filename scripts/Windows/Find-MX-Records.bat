:: Find MX records of a domain with nslookup
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
echo Copy all text from your list and paste into the .bat file. Press enter at the last entry.
pause
cls

::Prompt user for dyndns name
:::::::::::::::::::::::::::::::::::::
:nslookupmx
set /p name=Enter client dyndns name:

::Save the nslookup
nslookup -query=mx %name% >> tmp.log

:: Log file: Make a heading with the dyndns name
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo ================================================= >> nslookupmx.txt
echo %name% >> nslookupmx.txt
echo ================================================= >> nslookupmx.txt

:: Log file:Trim the tmp file for neatness
:::::::::::::::::::::::::::::::::::::::::::::::
findstr /c:"mail exchanger" tmp.log >> nslookupmx.txt
echo. >> nslookupmx.txt
del tmp.log

cls
goto nslookupmx

pause
