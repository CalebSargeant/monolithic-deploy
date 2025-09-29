:: Create an AD user
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
:start
set /p domain=Domain (if example.com then type example):
if %domain%==.com goto start
echo Active Directory Users Created: >> createaduser.log
echo ------------------------------- >> createaduser.log
echo. >> createaduser.log
:start
cls
set /p name=Name:
set /p surname=Surname:
powershell New-ADUser -SamAccountName %name% -Name "%name%" -givenname %name% -Surname %surname% -UserPrincipalName %name%@%domain% -AccountPassword (ConvertTo-SecureString -AsPlainText "ctu@123" -Force) -Enabled $true -PasswordNeverExpires $true -Path 'CN=Users,DC=%domain%,DC=com'
echo %name% %surname% >> createaduser.log
goto start
