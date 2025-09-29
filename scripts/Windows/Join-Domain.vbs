' VBScript program to join a computer to a domain.
' Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
' Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
' Last revised sometime between 2012 and 2013

Option Explicit

Dim strDomain, strUser, strPassword, strOU
Dim objNetwork, strComputer, objComputer, lngReturnValue

Const JOIN_DOMAIN = 1
Const ACCT_CREATE = 2
Const ACCT_DELETE = 4
Const WIN9X_UPGRADE = 16
Const DOMAIN_JOIN_IF_JOINED = 32
Const JOIN_UNSECURE = 64
Const MACHINE_PASSWORD_PASSED = 128
Const DEFERRED_SPN_SET = 256
Const INSTALL_INVOCATION = 262144

' Credentials.
strDomain = "domain"
strUser = "username"
strPassword = "password"

' Specify the OU where the computer object will be created.
' I don't think this is needed...
' strOU = "ou=Computers,dc=sas,dc=cpt"

' Retrieve NetBIOS name of local computer.
Set objNetwork = CreateObject("WScript.Network")
strComputer = objNetwork.ComputerName

Set objComputer = GetObject("winmgmts:" _
  & "{impersonationLevel=Impersonate,authenticationLevel=Pkt}!\\" & _
  strComputer & "\root\cimv2{Win32_ComputerSystem.Name='" & _
    strComputer & "'")

lngReturnValue = objComputer.JoinDomainOrWorkGroup(strDomain, _
  strPassword, "sas\" & strUser, strOU, _
    JOIN_DOMAIN + ACCT_CREATE)

Wscript.Echo "ReturnValue = " & CStr(lngReturnValue)

' Return Code
Select Case lngReturnValue
  Case 008/03/2020 AutoJoinDomain
    Wscript.Echo "Success joining computer to the domain!"
  Case 5
    Wscript.Echo "Access is denied"
  Case 87
    Wscript.Echo "The parameter is incorrect"
  Case 110
    Wscript.Echo "The system cannot open the specified object"
  Case 1323
    Wscript.Echo "Unable to update the password"
  Case 1326
    Wscript.Echo "Logon failure: unknown username or bad password"
  Case 1355
    Wscript.Echo "The specified domain either does not exist or could not be contacted"
  Case 2224
    Wscript.Echo "The account already exists"
  Case 2691
    Wscript.Echo "The machine is already joined to the domain"
  Case 2692
    Wscript.Echo "The machine is not currently joined to a domain"
  Case Else
    Wscript.Echo "Unknown error"
End Select
