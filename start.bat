@echo off
cd /d %~dp0control

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

:normalStart
	start .\control.exe
	exit
:rootStart
	nircmd elevate .\control.exe
	exit
