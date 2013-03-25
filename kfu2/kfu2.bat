@echo off
REM AUTHOR: RAINBOWDASHDC (@RAINDASHDC) (Jared631)
REM DATE: 24/03/13 (Started On)
REM DESC: Roots the Kindle Fire V2
rem -----------------------------------------------------------------------
REM <See DESC>
REM Copyright (C) <2013>  <RainbowDashDC> <RDCODING BRANCH OF RDINC>
REM
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with this program.  If not, see <http://www.gnu.org/licenses/>.
REM
rem -----------------------------------------------------------------------

REM Look mommy, no WGET!

REM VARIABLES
set VER=1.0
set DATE=[24/3/13]
set FORUMURL=

set KFU_BIN=bin/
set KFU_SCRIPTS=scripts/

REM TOOLS
set ECHO=bin\echo
set WINGET-DL=bin\winget-dl.exe
set ADB=bin\adb.exe
set READINI=bin\read_ini

:LOOP
	IF NOT "%1" == "" (
		IF "%1" == "--help" (
			GOTO:HELP
		)
		IF "%1" == "--install-drivers" (
			GOTO:DRIVERS
		)
		IF "%1" == "--install-bootloader" (
			GOTO:BOOTLOADER
		)
		IF "%1" == "--install-recovery" (
			GOTO:RECOVERY
		)
		IF "%1" == "--root" (
			GOTO:ROOT
		)
		IF "%1" == "--all-in-one" (
			GOTO:ALL
		)
		IF "%1" == "call" (
			GOTO:CALL
		)
		
		set errmsg=%1 is not a valid switch
		set e=1
		GOTO:HELP
	) ELSE (
		GOTO:MENU
	)
GOTO:MENU

:HELP
	echo RDC - Kindle Fire Utility 2 - %VER%
	echo.
	echo Rooty, Recovery, and Bootloaderness!
	echo USAGE: kfu2.bat [OPTION]... 
	echo.
	echo General:
	echo. 	--help                        Shows this help page.
	echo.	--version                     Shows the version.
	echo.	--install-drivers             Installs the drivers.
	echo.	--install-recovery            Install Recovery.
	echo.	--install-bootloader          Install Bootloader.
	echo.	--root                        Install Root.
	echo.	--all-in-one                  Install Root, Bootloader, and Recovery.
	echo.
	%ECHO% Bug reports and suggestions: [%FORUMURL%]
	if "%e%" == "1" echo. && echo Error: %errmsg%
GOTO:EXIT

:MENU
	ECHO ********************************
	ECHO *        KFU2 - V1.0           *
	ECHO ********************************
	ECHO * By RainbowDashDC - Jared631  *
	ECHO ********************************
	set /p "=Initiallizing... " <nul
	
	REM Download Latest Versions.ini
	%WINGET-DL% http://dl.dropbox.com/s/xgbriipynniezth/versions.ini bin/versions.ini 1>nul 2>nul
	call:read_ini 1>general.log
	
	REM Download Latest Scripts
	del /q /f scripts/*
	%WINGET-DL% %REBScript% scripts/aft.bat
	
	%ECHO% OK
	ping -n 2 localhost 1>nul
	CLS
GOTO:GUI

:GUI
	CALL:HEADER

	::Load up our menu selections
	for /f "tokens=1,2,* delims=_ " %%A in ('"findstr /b /c:":choice_" "%~f0""') do echo.  %%B  %%C
	

	set choice=
	echo.&set /p choice=Please make a selection or hit ENTER to exit: ||GOTO:EOF
	echo.&call:choice_%choice%
GOTO:GUI

:HEADER
	ECHO ***************************************
	ECHO *    Kindle Fire Utility - 2nd Gen    *
	ECHO ***************************************
	ECHO * Version: V1.0 - [24/3/13]           *
	ECHO ***************************************
GOTO:EOF

:choice_1 Root
GOTO:ROOT

:ROOT
	call scripts\root.bat
GOTO:GUI

:RECOVERY
	call scripts\aft.bat --recovery
GOTO:GUI

:BOOTLOADER
	call scripts\aft.bat --recovery
GOTO:GUI

:READ_INI
	call %READINI% "bin\versions.ini" Version CVER CVER
	call %READINI% "bin\versions.ini" Date CDATE CDATE
	call %READINI% "bin\versions.ini" RVersion RVER RVER
	call %READINI% "bin\versions.ini" RDate RDATE RDATE
	call %READINI% "bin\versions.ini" BVersion BVER BVER
	call %READINI% "bin\versions.ini" BDate BDATE BDATE
	call %READINI% "bin\versions.ini" REVersion REVER REVER
	call %READINI% "bin\versions.ini" REDate REDATE REDATE
	call %READINI% "bin\versions.ini" REBScript REBSCRIPT REBCRIPT
	call %READINI% "bin\versions.ini" DVersion DVER DVER
	call %READINI% "bin\versions.ini" DDate DDATE DDATE
	call %READINI% "bin\versions.ini" DUrl DURL DURL
	call %READINI% "bin\versions.ini" REUrl REURL REURL
	call %READINI% "bin\versions.ini" BUrl BURL BURL
	call %READINI% "bin\versions.ini" RUrl RURL RURL
goto:eof

:DRIVERS
	IF EXIST temp/kf2d/kfadbdrivers.exe (
		cd temp/kf2d
		START /WAIT kfadbdrivers.exe
		cd ../..
	) else (
		SET /p "=Downloading Latest Drivers... " <nul
		IF NOT EXIST "temp" MKDIR temp
		%WINGET-DL% %DURL% temp/Drivers.zip 1>nul 2>nul || echo FAIL && echo E: Failed to Download Drivers. && GOTO:EXIT
		echo OK
		cd temp
		SET /p "=Extracting Latest Drivers... " <nul
		..\bin\7z.exe x Drivers.zip 1>nul 2>nul || echo FAIL && echo E: Failed to Extract Drivers. && GOTO:EXIT
		echo OK
		del /q /f Drivers.zip
		echo Starting Installer...
		cd kf2d
		START /WAIT kfadbdrivers.exe
		cd ../..
		echo DONE
	)
GOTO:EXIT
	
:EXIT