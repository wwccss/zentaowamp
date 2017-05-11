@echo off
set currentDir=%~dp0

echo First I need set the path for php and mysql
%currentDir%..\php\php.exe -c %currentDir%..\php\php.raw.ini set.php

echo Installing apache 2.4 as service...
%currentDir%..\apache\bin\httpd -k install -n apachezt
echo starting apache
net start apachezt

echo Installing mysql as service...
%currentDir%..\mysql\bin\mysqld.exe --install mysqlzt
echo starting mysql
net start mysqlzt

pause
