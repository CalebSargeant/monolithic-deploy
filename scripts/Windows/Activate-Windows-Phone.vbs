' Open up license page where one phones Microsoft
' Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
' Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
' Last revised sometime between 2012 and 2013

Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run "slui 4", 9
Wscript.Sleep 1000
WshShell.SendKeys "{TAB}"
WshShell.SendKeys "{TAB}"
WshShell.SendKeys "{TAB}"
WshShell.SendKeys "south"
WshShell.SendKeys "{ENTER}"
