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
set VER=0.2A
set DATE=[24/6/13]
set FORUMURL=http://goo.gl/B93F5

set KFU_BIN=bin/
set KFU_SCRIPTS=scripts/

REM TOOLS
set ECHO=bin\echo
SET WGET=bin\wget
set WINGET-DL=bin\winget-dl.exe
set ADB=bin\adb.exe
set READINI=bin\read_ini
SET XMLPARSE=bin\xml.bat
SET AWK=bin\awk.exe
SET XMLPARSEAWK=bin\xmlparse.awk
set VERINI=http://dl.dropbox.com/s/xgbriipynniezth/versions.ini

REM Clear old errmsgs
set e=
set errmsg=


 rem Disclaimer
 cls
 color 4
 echo -----------------------------------------------------
 echo -              DISCLAIMER - V  1.2                  -
 echo -----------------------------------------------------
 echo * 
 echo * include std_disclaimer
 echo *
 echo * Your warranty is now void.
 echo *
 echo * I am not responsible for bricked devices, dead SD cards,
 echo * thermonuclear war, or you getting fired because the alarm app failed. Please
 echo * do some research if you have any concerns about features included in this
 echo * Utility before using it! YOU are choosing to make these modifications, and if
 echo * you point the finger at me for messing up your device, I will laugh at you.
 echo *
 echo ------------------------------------------------------
 echo - By Continuing you agree to these terms.            -
 echo - I higly suggest you have a fastboot cable on hand. -
 echo ------------------------------------------------------
 SET /P choice_disc="Continue? [Y/n]: "
 IF "%choice_disc%" == "n" cls && color && EXIT /B
 IF "%choice_disc%" == "N" cls && color && EXIT /B
 
 REM RESET COLOR 
 color
 

:LOOP
	IF NOT "%1" == "" (
		IF "%1" == "--help" (
			GOTO:HELP
		)
		IF "%1" == "--install-drivers" (
			CALL:READ_INI 1>nul
			GOTO:DRIVERS
		)
		IF "%1" == "--install-bootloader" (
			GOTO:BOOTLOADER
		)
		IF "%1" == "-v" (
			echo Using Verbose Output...
			echo.
			SET VERBOSE=1
			
			REM Temp untill seperate V_LOOP
			GOTO:MENU
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
			REM Debug function. Don't Use.
			REM Well, ok, it's Stable. But... Meh.
			GOTO:CALL
		)
		IF "%1" == "--version" (
			GOTO:VERSION
		)
		
		set errmsg=%1 is not a valid switch
		set e=1
		GOTO:HELP
	) ELSE (
		GOTO:MENU
	)
GOTO:MENU

:VERSION
	echo RDC - Kindle Fire Utility 2 (KFU2) - V%VER%
	echo.
	echo Version: %VER% - %DATE%
	echo.
	echo Do --help for more information.
GOTO:EXIT

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
	echo.	-v                            Verbose Output.
	echo.
	echo Bug reports and suggestions: [%FORUMURL%]
	if "%e%" == "1" echo. && echo Error: %errmsg%
GOTO:EXIT

:MENU
	cls
	ECHO ********************************
	ECHO *        KFU2 - V0.2A          *
	ECHO ********************************
	ECHO * By RainbowDashDC - Jared631  *
	ECHO ********************************
	set /p "=Initiallizing... " <nul
	
	REM Download Latest Versions.ini
	IF "%VERBOSE%" == "1" echo. && echo.	- Downloading Latest Versions.ini
	%WINGET-DL% %VERINI% bin/versions.ini 1>nul 2>nul
	IF "%VERBOSE%" == "1" echo.	- Setting Properites from the Versions.ini
	call:read_ini 1>general.log
	
	REM Download Latest Scripts
	IF "%VERBOSE%" == "1" echo.	- Downloading Latest AFT.bat and ROOT.bat for Root and ETC
	%WINGET-DL% %REBSCRIPT% scripts/aft.bat 1>nul 2>nul
	%WINGET-DL% %RURL% scripts/root.bat 1>nul 2>nul
	
	
	REM Closing Statements...
	IF "%VERBOSE%" == "1" echo DONE
	IF NOT "%VERBOSE%" == "1" ECHO OK
	CLS
GOTO:GUI

:GUI
	CALL:HEADER

	REM Loadup teh menu.
	for /f "tokens=1,2,* delims=_ " %%A in ('"findstr /b /c:":choice_" "%~f0""') do echo.  %%B  %%C
	

	set choice=
	echo.&set /p choice=Please make a selection or hit ENTER to exit: ||GOTO:EOF
	echo.&call:choice_%choice%
GOTO:GUI

:HEADER
	ECHO ***************************************
	ECHO *    Kindle Fire Utility - 2nd Gen    *
	ECHO ***************************************
	ECHO *      Version: V0.2A - [24/3/13]     *
	ECHO ***************************************
GOTO:EOF

:choice_1 Root
GOTO:ROOT

:choice_2 Recovery & Bootloader
GOTO:RECOV_BOOT

:choice_3 KFU2 Drivers (Install)
call kfu2 --install-drivers
EXIT /B


:ALL
	ECHO Installing Drivers...
	call kfu2 --install-drivers
	ECHO Installing Root...
	call:ROOT
	ECHO Installing Recovery & Bootloader
	call scripts\aft.bat --all
	ECHO -------------------------------------------
	ECHO Done!
	ECHO Enjoy! :-)
	ECHO -------------------------------------------
	echo.
	echo Press Enter to Return to Menu.
	SET /P tssss=""
GOTO:GUI

:ROOT
	call scripts\root.bat
GOTO:GUI

:RECOVERY
	call scripts\aft.bat --recovery
GOTO:GUI

:RECOV_BOOT
	call scripts\aft.bat --all
GOTO:GUI

:BOOTLOADER
	call scripts\aft.bat --bootloader
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
	call %READINI% "bin\versions.ini" REBScript REBSCRIPT REBSCRIPT
	call %READINI% "bin\versions.ini" DVersion DVER DVER
	call %READINI% "bin\versions.ini" DDate DDATE DDATE
	call %READINI% "bin\versions.ini" DUrl DURL DURL
	call %READINI% "bin\versions.ini" REUrl REURL REURL
	call %READINI% "bin\versions.ini" BUrl BURL BURL
	call %READINI% "bin\versions.ini" RUrl RURL RURL
goto:eof

:DRIVERS
GOTO:DRIV

:DRIV
	%ECHO% "Installing Drivers..." [%TIME%] >> general.log
	IF EXIST "temp\kf2d" (
		echo Starting Installer...
		pushd "temp\kf2d"
		START /WAIT kfadbdrivers.exe
		popd
		echo Editing "%APPDATA%/.android/adb_usb.ini"
		IF EXIST "%APPDATA%/.android/adb_usb.ini" %ECHO% "0x1949" >> "%APPDATA%/.android/adb_usb.ini"
		IF NOT EXIST "%APPDATA%/.android/" (
			%ECHO% "%APPDATA%/.android/"
			%ECHO% "# ANDROID 3RD PARTY USB VENDOR ID LIST -- DO NOT EDIT." >> "%APPDATA%/.android/adb_usb.ini"
			%ECHO% "# USE 'android update adb' TO GENERATE." >> "%APPDATA%/.android/adb_usb.ini"
			%ECHO% "# 1 USB VENDOR ID PER LINE." >> "%APPDATA%/.android/adb_usb.ini"
			%ECHO% "0x1949" >> "%APPDATA%/.android/adb_usb.ini"
		)
		echo DONE
		GOTO:EXIT
	)
	SET /p "=Downloading Latest Drivers... " <nul
	IF NOT EXIST "temp" MKDIR temp
	%WGET% -O temp/Drivers.zip "%DURL%" 1>nul 2>nul || echo FAIL && echo E: Failed to Download Drivers. && EXIT /B 2
	echo OK
	cd temp
	SET /p "=Extracting Latest Drivers... " <nul
	..\bin\7z.exe x Drivers.zip 1>nul 2>nul || echo FAIL && echo E: Failed to Extract Drivers. && EXIT /B 3
	echo OK
	del /q /f Drivers.zip
	echo Starting Installer...
	cd kf2d
	START /WAIT kfadbdrivers.exe
	cd ../..
	echo Editing "%APPDATA%/.android/adb_usb.ini"
	IF EXIST "%APPDATA%/.android/adb_usb.ini" %ECHO% "0x1949" >> "%APPDATA%/.android/adb_usb.ini"
	IF NOT EXIST "%APPDATA%/.android/" (
		%ECHO% "%APPDATA%/.android/"
		%ECHO% "# ANDROID 3RD PARTY USB VENDOR ID LIST -- DO NOT EDIT." >> "%APPDATA%/.android/adb_usb.ini"
		%ECHO% "# USE 'android update adb' TO GENERATE." >> "%APPDATA%/.android/adb_usb.ini"
		%ECHO% "# 1 USB VENDOR ID PER LINE." >> "%APPDATA%/.android/adb_usb.ini"
		%ECHO% "0x1949" >> "%APPDATA%/.android/adb_usb.ini"
	)
	%ECHO% "Done - Success" >> general.log
	echo DONE
	GOTO:EXIT
	
	%ECHO% "Done - Fail" >> general.log
	echo E: Unspecified Error has Occured.
	EXIT /B 1
GOTO:EXIT

:CALL
	IF "%2" == "--help" (
		echo ----------------------------------
		echo - This is for Debugging Purposes -
		echo - Use with caution               -
		echo ----------------------------------
		echo.
		echo HELP -[ LIST OF FUNCTIONS ]-
		echo.
		echo ----------------------------------
		for /f "tokens=1,2,*" %%A in ('"findstr /b /c:":" "%~f0""') do echo. %%A %%B  %%C
		echo ----------------------------------
		GOTO:EXIT
	) ELSE (
		IF "%2" == "" (
			echo ----------------------------------
			echo - This is for Debugging Purposes -
			echo - Use with caution               -
			echo ----------------------------------
			echo.
			echo. E: No Input
			echo.
			echo ----------------------------------
			GOTO:EXIT
		)
	)
	echo ----------------------------------
	echo - This is for Debugging Purposes -
	echo - Use with caution               -
	echo ----------------------------------
	echo.
	echo Calling %2 ...
	echo.
	call %2
	echo.
	echo ----------------------------------
	echo %2 has been called.
GOTO:EXIT
	
:EXIT