' Send a message to a remote machine via psexec
' Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
' Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
' Last revised sometime between 2012 and 2013

'----------------------------------------------------------------------------------------------------------------------------
'Script Name : Notification.vbs
'Author : Matthew Beattie
'Created : 29/07/09
'Description : This script prompts the user with a notification message.
' : It is intended to be run using psexec.exe using the following syntax:
' :
' : psexec.exe -s -i -d \\computername
' : wscript.exe "\\servername\sharename\Notification.vbs" /message:"Hello World"
' :
' : It is assumed that the remote users have read permissions on the NTFS share to allow psexe to run the script.
'----------------------------------------------------------------------------------------------------------------------------
'Initialization Section
'----------------------------------------------------------------------------------------------------------------------------
Option Explicit
Dim wshShell, objFSO, scriptBaseName
'On Error Resume Next
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Set wshShell = CreateObject("Wscript.Shell")
  scriptBaseName = objFSO.GetBaseName(Wscript.ScriptFullName)
  If Err.Number <> 0 Then
    Wscript.Quit
  End If
'On Error Goto 0
'----------------------------------------------------------------------------------------------------------------------------
'Main Processing Section
'----------------------------------------------------------------------------------------------------------------------------
'On Error Resume Next
  ProcessScript
  If Err.Number <> 0 Then
    Wscript.Quit
  End If
'On Error Goto 0
'----------------------------------------------------------------------------------------------------------------------------
'Functions Processing Section
'----------------------------------------------------------------------------------------------------------------------------
'Name : ProcessScript -> Primary Function that controls all other script processing.
'Parameters : None ->
'Return : None ->
'----------------------------------------------------------------------------------------------------------------------------
Function ProcessScript
  Dim message, title
  message = WScript.Arguments.Named("message")
  If message = "" Then
    Wscript.Quit(0)
  End If
  MsgBox message, vbInformation, scriptBaseName
End Function
'----------------------------------------------------------------------------------------------------------------------------
