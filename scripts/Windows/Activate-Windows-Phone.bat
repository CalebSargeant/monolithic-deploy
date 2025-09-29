:: Open up license page where one phones Microsoft
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

@echo off
cscript.exe %windir%\system32\slmgr.vbs
start /wait cscript \\%hostname%\c:\users\cptadmin\desktop\share
