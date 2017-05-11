@echo off
set currentDir=%~dp0

echo stopping apache 2.4
net stop apachezt
echo removing apache 2.4
%currentDir%..\apache\bin\httpd -k uninstall -n apachezt

del %currentDir%port.apache

echo stopping mysql
net stop mysqlzt
echo removing mysql
%currentDir%..\mysql\bin\mysqld.exe --remove mysqlzt

del %currentDir%port.mysql

pause
