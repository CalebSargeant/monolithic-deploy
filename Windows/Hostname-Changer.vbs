' Change your hostname using VBS
' Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
' Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
' Last revised sometime between 2012 and 2013

Name = InputBox("Enter a new hostname.")
Password = "Isctm-trtc0tE"
Username = "domain\administrator"
Set objWMIService = GetObject("Winmgmts:root\cimv2")
' Call always gets only one Win32_ComputerSystem object.
For Each objComputer in _
  objWMIService.InstancesOf("Win32_ComputerSystem")

    Return = objComputer.rename(Name,Password,Username)
    If Return <> 0 Then
      WScript.Echo "Rename failed. Error = " & Err.Number
    Else
      WScript.Echo "Rename succeeded." & _
        " Changes will take effect after you restart this computer."
    End If

Next
