----------------------------------------------------------------------------------
-- Define const value.
----------------------------------------------------------------------------------
CONTROL_TYPE      = 'chanzhi'
MOUSE_LEFT        = 49
MOUSE_PRESSED     = 1
MAX_PORT          = 65535
HOST              = '127.0.0.1'
SOCKET            = require("socket")
VC_REDIST_2005    = 'vcredist_x86_sp1.exe'
VC_REDIST_2008    = 'vcredist_x86.exe'
BUTTON_SIZE       = "50x20"
TMP_BAT           = 'tmp\\tmp.bat'
DRIVE_LETTER      = string.lower(string.sub(os.currentdir(), 0, 1))
BACKUP_FILE       = '\\xampp\\chanzhi\\bin\\php\\backup.php'
BACKUP_CMD        = 'cd ..\\chanzhi\\bin\\php & \\xampp\\php\\php.exe backup.php & cd ..\\..\\..\\control'
UPDATER_URL       = "http://www.chanzhi.net/updater-isLatest-%s-.json"
VERSION           = '1.1'
INIT_BAT          = "..\\chanzhi\\bin\\init.bat"
INIT_SUCCESSCODE  = 0
PHP_EXE           = DRIVE_LETTER .. ':\\xampp\\php\\php.exe'
APACHE_EXE        = DRIVE_LETTER .. ':\\xampp\\apache\\bin\\httpd.exe'
MYSQL_EXE         = DRIVE_LETTER .. ':\\xampp\\mysql\\bin\\mysql.exe'
PHPMYADMIN_README = DRIVE_LETTER .. ':\\xampp\\phpmyadmin\\README'
PHP_BAT           = 'tmp\\php.bat'
PMS_VERSION       = ''
LANG_FILE         = 'tmp\\lang'
OK_FILE           = 'tmp\\ok'
TMP_DIR           = '\\xampp\\control\\tmp\\'
PROCESS_EXIT      = '.\\tmp\\exist'
SOFT_VERSIONS     = 'tmp\\versions'

----------------------------------------------------------------------------------
-- Init apache and mysql table.
----------------------------------------------------------------------------------
php    = {}
apache = {}
mysql  = {}
system = {}

php.configFile = "..\\php\\php.ini"

apache.configFile  = "..\\apache\\conf\\httpd.conf"
apache.serviceName = 'apachezt'
apache.status      = 'stopped'
apache.port        = 80
apache.suggestPort = 88

mysql.configFile       = "..\\mysql\\my.ini"
mysql.oldConfigFile    = "..\\mysql\\bin\\my.ini"
mysql.myConfig         = "..\\chanzhi\\config\\my.php"
mysql.phpmyadminConfig = "..\\phpmyadmin\\config.inc.php"
mysql.serviceName      = 'mysqlzt'
mysql.status           = 'stopped'
mysql.port             = 3306
mysql.suggestPort      = 3308

system.configFile      = "..\\chanzhi\\config\\config.php"
system.versionFile     = "..\\chanzhi\\VERSION"

