' Change machine's IP Address
' Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
' Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
' Last revised sometime between 2012 and 2013

Dim strIPAddress
Dim strSubnetMask
Dim strGateway
Dim intGatewayMetric
Dim strDns1
Dim strDns2
strIPAddress = InputBox("Enter an IP Address. A valid IP address is 192.168.102.x.","IP Address Changer")

strSubnetMask = "255.255.255.0"
strGateway = "192.168.102.1"
intGatewayMetric = 1
strDns1 = "192.168.102.251"
strDns2 = "192.168.102.249"

Set objShell = WScript.CreateObject("Wscript.Shell")
objShell.Run "netsh interface ip set address name=""Local Area Connection"" static " & strIPAddress & " " &
strSubnetMask & " " & strGateway & " " & intGatewayMetric, 0, True
objShell.Run "netsh interface ip set dns name=""Local Area Connection"" static "& strDns1, 0, True
objShell.Run "netsh interface ip add dns name=""Local Area Connection"" addr="& strDns2, 0, True
Set objShell = Nothing
WScript.Quit
