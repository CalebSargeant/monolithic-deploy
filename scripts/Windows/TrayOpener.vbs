' Open the DVD-Rom Tray, open it if closed
' Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
' Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
' Last revised sometime between 2012 and 2013

' I want to deploy this via GPO one day :)

Set oWMP = CreateObject("WMPlayer.OCX.7" )
Set colCDROMs = oWMP.cdromCollection
if colCDROMs.Count >= 1 then
do
For i = 0 to colCDROMs.Count - 1
colCDROMs.Item(i).Eject
Next ' cdrom
For i = 0 to colCDROMs.Count - 1
colCDROMs.Item(i).Eject
Next ' cdrom
loop
End If
