@echo off
set cdnow=%cd%
set version=32
set aa=-
set ab=  
set ac=  
title By Lenny / Fettesteil - v%version%
color f
if not exist data echo %cd%\data folder missing! & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\Ansi.dll echo error[1] [1] & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\ANSI32.dll echo error[1] [2]  & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\Dsp.dll echo error[1] [3]  & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\Fn.dll echo error[1] [4]  & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\zlib1.dll echo error[1] [5]  & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\wget.exe echo error[1] [6]  & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\zip.exe echo error[1] [6]  & timeout 3 /nobreak >nul & exit
if not exist %cd%\data\Bin\unzip.exe echo error[1] [6]  & timeout 3 /nobreak >nul & exit
SETLOCAL enabledelayedexpansion
	If "%1" Neq "LoadANSI" (
		SetLocal
		data\Bin\Ansi.dll "%~0" LoadANSI
		EndLocal
		Exit
	)
Mode 40,15
echo Suche nach Updates...

cd data/Bin
if exist version.txt del version.txt
start /min wget.exe fettesteil.bplaced.net/batch/version.txt
set a=0
:loop1
if exist version.txt goto loop1_end
set /a a=%a%+1
if %a%==1000 goto error1
goto loop1
:loop1_end
timeout 1 /nobreak >nul
for /f %%i in (version.txt) do set server_version=%%i
if /i %version% LSS %server_version% goto need_update
goto uptodate
goto error2
:need_update
echo Update gefunden!
timeout 1 /nobreak >nul
echo Download...
if exist update.zip del update.zip
start /min wget.exe fettesteil.bplaced.net/batch/update.zip
timeout 1 /nobreak>nul
set a=0
:loop2
if exist update.zip goto loop2_end
set /a a=%a%+1
if %a%==1000 goto error1
goto loop2
:loop2_end
echo Install...
if exist update rd /s /q update
unzip update.zip
cd update
start install.bat
timeout 2 /nobreak >nul
exit

:uptodate
echo Keine Updates gefunden!
timeout 1 /nobreak >nul
cls
Mode 80,30



:menu
cls
call :menu_call


choice /C WSD /N
if %errorlevel%==1 goto menu_up
if %errorlevel%==2 goto menu_down
if %errorlevel%==3 goto menu_enter
goto menu_call
:menu_up
if %aa%==- set aa=  &set ac=-&goto menu
if %ab%==- set ab=  &set aa=-&goto menu
if %ac%==- set ac=  &set ab=-&goto menu
:menu_down
if %aa%==- set aa=  &set ab=-&goto menu
if %ab%==- set ab=  &set ac=-&goto menu
if %ac%==- set ac=  &set aa=-&goto menu
:menu_enter
if %aa%==- goto spielen
if %ab%==- goto postfach
if %ac%==- goto einstellungen


:spielen
echo.
echo.
echo.
call :not_adviable_call
timeout 2 /nobreak >nul
goto menu
:postfach
echo.
echo [1;31m================================================================================
echo [1;30m                                  POSTFACH
echo [1;31m================================================================================
if exist postfach.bat del postfach.bat
start /min wget.exe fettesteil.bplaced.net/batch/postfach.bat
:postfach_loop
if exist postfach.bat goto postfach_loop_end
goto postfach_loop
:postfach_loop_end
call postfach.bat
echo.
echo [1;31m================================================================================
echo [1;30m                                  POSTFACH
echo [1;31m================================================================================
pause >nul
goto menu

:einstellungen
echo.
echo.
echo.
call :not_adviable_call
timeout 2 /nobreak >nul
goto menu
:menu_call
echo [1;37m-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
echo [1;33m Menu                   [1;33mSteuerung                [1;33mCopyright
echo [1;35m %aa%[1;36mSpielen               [1;36mW - Oben                [1;31m(C^) Lenny 2016
echo [1;35m %ab%[1;36mPostfach              [1;36mS - Unten               [1;31m(C^) FETTESTEIL 2016
echo [1;35m %ac%[1;36mEinstellungen         [1;36mD - Bestaetigen         [1;31m
echo [1;37m-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
goto exit
:not_adviable_call
echo.
echo [1;31m================================================================================
echo [1;30m                                  Not Adviable
echo [1;31m================================================================================
goto exit
:error2
color c
cls
echo Unbekannter fehler!
timeout 3 /nobreak >nul
:error1
color c
cls
echo Keine Verbindung zum Server!
timeout 3 /nobreak >nul
exit
:exit