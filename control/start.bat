@echo off
cd /d %~dp0control

net start
if %ERRORLEVEL% == 1 goto withoutNet

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products" /s | find "Microsoft Visual C++ 2005 Redistributable" 
if %ERRORLEVEL% == 1 goto installVC2005

set info=ver
%info% | find "5.0" > null
if %ERRORLEVEL% == 0 goto normalStart
	
%info% | find "5.1" > null
if %ERRORLEVEL% == 0 goto normalStart

%info% | find "5.2" > null
if %ERRORLEVEL% == 0 goto normalStart

%info% | find "6.0" > null
if %ERRORLEVEL% == 0 goto rootStart

%info% | find "6.1" > null
if %ERRORLEVEL% == 0 goto rootStart

%info% | find "6.2" > null
if %ERRORLEVEL% == 0 goto rootStart

:withoutNet
	echo "Without net command..., starting /xampp/services/install.bat"
        cd /d %~dp0services
        .\install.bat
	pause
        exit

:installVC2005
        start .\vcredist_x86_sp1.exe
        exit

:normalStart
	start .\control.exe
	exit
:rootStart
	nircmd elevate .\control.exe
	exit
