:: Troubleshoot a computer that does not show anything on display
:: Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
:: Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
:: Last revised sometime between 2012 and 2013

:: between beep code and power supply: the thing must ask if there is a beep code when a psu is plugged in.
color 71
@ECHO off
cls
:start
cls
ECHO.========================================================== && ECHO.=
Welcome to the NO DISPLAY TROUBLESHOOTER! = &&
ECHO.========================================================== && ECHO. &&
ECHO.Unplug all cables except for Motherboard and CPU power. && ECHO.Make sure that there is a
Motherboard speaker plugged in. && ECHO.Test your monitor and display cable before starting. && ECHO.Turn
on the computer. Does the display work? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 = Exit
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto end
if '%choice%'=='2' goto onboard_prompt
if '%choice%'=='9' goto exit
ECHO "%choice%" is not valid, try again.
ECHO.
goto start

:onboard_prompt
cls
ECHO Is the computer you are working on using a Graphics Card? && ECHO. && ECHO.1 = Yes && ECHO.2 =
No && ECHO.9 = Back
set choice=
set/p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto new_gpu2
if '%choice%'=='2' goto ram_beep2
if '%choice%'=='9' goto start
ECHO "%choice%" is not valid, try again.
ECHO.
goto onboard_prompt

:ram_beep
cls
ECHO Take out the RAM. Is there a beep code? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 =
Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto new_ram
if '%choice%'=='2' goto new_psu
if '%choice%'=='9' goto start
ECHO "%choice%" is not valid, try again.
ECHO.
goto ram_beep

:ram_beep2
cls
ECHO Take out the RAM. Is there a beep code? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 =
Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto new_ram
if '%choice%'=='2' goto new_psu
if '%choice%'=='9' goto onboard_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto ram_beep2

:new_ram
cls
ECHO Try new RAM or RAM that worked previosly. Is your issue resolved? && ECHO. && ECHO.1 = Yes &&
ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto purchase_ram
if '%choice%'=='2' goto new_psu
if '%choice%'=='9' goto ram_beep
ECHO "%choice%" is not valid, try again.
ECHO.
goto ram_beep

:new_psu
cls
ECHO Try a new Power Supply or a Power Supply that worked previosly. && ECHO.Is your issue resolved? &&
ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto purchase_psu
if '%choice%'=='2' goto new_gpu
if '%choice%'=='9' goto new_ram
ECHO "%choice%" is not valid, try again.
ECHO.
goto new_psu

:new_gpu
cls
ECHO Plug in RAM that works, plug in a new Graphics Card and plug display cable into Graphics Card. Is your issue resolved? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto purchase_gpu
if '%choice%'=='2' goto new_cpu_prompt
if '%choice%'=='9' goto new_psu
ECHO "%choice%" is not valid, try again.
ECHO.
goto new_gpu

:new_gpu2
cls
ECHO Take out the Graphics Card, and plug the display cable in onboard. && ECHO.Is your issue resolved? &&
ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto end
if '%choice%'=='2' goto clr_cmos_prompt
if '%choice%'=='9' goto onboard_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto new_gpu2

:clr_cmos_prompt
cls
ECHO Do you want to reset the BIOS to make sure onboard is actually being used? && ECHO. && ECHO.1 = Yes
&& ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto clr_cmos
if '%choice%'=='2' goto ram_beep2
if '%choice%'=='9' goto onboard_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto clr_cmos_prompt

:clr_cmos
cls
ECHO Take out the CMOS battery. Use the clr_cmos jumper to clear the CMOS. Turn on the computer with the
CMOS battery out. && ECHO.Is your issue resolved? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9
= Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto end
if '%choice%'=='2' goto ram_beep2
if '%choice%'=='9' goto clr_cmos_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto clr_cmos

:new_cpu_prompt
cls
ECHO Do you want to try testing a new CPU to see if it resolves the problem? && ECHO. && ECHO.1 = Yes &&
ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto new_cpu
if '%choice%'=='2' goto clean_slots_prompt
if '%choice%'=='9' goto new_gpu
ECHO "%choice%" is not valid, try again.
ECHO.
goto new_cpu_prompt
:new_cpu
cls
ECHO Take out current CPU and put in a new one or one that worked previosly. && ECHO.Remember to plug
the fan back in. Is your issue resolved? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto purchase_cpu
if '%choice%'=='2' goto clean_slots_prompt
if '%choice%'=='9' goto new_cpu_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto new_cpu

:clean_slots_prompt
cls
ECHO Do you want to clean the slots to see if it resolves your problem? && ECHO. && ECHO.1 = Yes &&
ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto clean_slots
if '%choice%'=='2' goto purchase_mobo
if '%choice%'=='9' goto new_cpu_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto clean_slots

:clean_slots
cls
ECHO Use compressed air to clean out the RAM slots and Graphics Card slot. && ECHO.Plug the components
back in. Is your issue resolved? && ECHO. && ECHO.1 = Yes && ECHO.2 = No && ECHO.9 = Back
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto end
if '%choice%'=='2' goto purchase_mobo
if '%choice%'=='9' goto clean_slots_prompt
ECHO "%choice%" is not valid, try again.
ECHO.
goto purchase_mobo

:purchase_mobo
cls
ECHO Purchase a new Motherboard && ECHO. && ECHO.
pause
goto end2

:purchase_gpu
cls
ECHO Purchase a new Graphics Card && ECHO. && ECHO.
pause
goto end2

:purchase_ram
cls
ECHO Purchase new RAM
pause
goto end2

:purchase_psu
cls
ECHO Purchase a new Power Supply && ECHO. && ECHO.
pause
goto end2

:end
cls
ECHO Well done! You have sucessfully resolved your issue! && ECHO. && ECHO.
pause
goto end_final

:end2
cls
ECHO Oh well... You better start writing down system specs and quote a new component! && ECHO.(file
created by CALEB SARGEANT) && ECHO. && ECHO.
pause
goto end_final
:exit
exit
