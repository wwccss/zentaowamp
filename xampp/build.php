<?php
$buildDir = dirname(__FILE__);
chdir($buildDir);

/* If zfile.class.php not found, try to download it from github. */
if(!is_file('zfile.class.php')) 
{
    $zfile = 'https://raw.github.com/easysoft/zentaopms/master/lib/zfile/zfile.class.php';
    file_put_contents('zfile.class.php', file_get_contents($zfile));
}

/* Include the file class. */
include './zfile.class.php';
$file = new zfile();

/* set xampp package and 7-zip command. */
if(count($argv) != 3) die("php build.php sourceDir product=zentao|chanzhi|common.\n");
$sourceDir  = rtrim(rtrim($argv[1], '/'), '\\');
$product    = $argv[2];
$xampp      = $sourceDir . '\xampp';
$output     = $sourceDir . "\\xampp_$product";

chdir($sourceDir);

/* rm useless files. */
error_reporting(E_ALL);
if(is_dir($output))$file->removeDir($output);
$file->mkdir($output);
$file->mkdir($output . '\tmp');

/* Process apache module. */
$file->mkdir($output . '\apache');
$file->mkdir($output . '\apache\logs');
$file->mkdir($output . '\apache\conf');
$file->mkdir($output . '\apache\conf\sites');
$file->mkdir($output . '\apache\modules');
$file->mkdir($output . '\apache\bin');

$file->mkdir($output . '\apache\auth');
touch($output . '\apache\auth\.htaccess');

$file->copyFile($xampp . '\apache\modules\mod_access_compat.so', $output . '\apache\modules\mod_access_compat.so');
$file->copyFile($xampp . '\apache\modules\mod_auth_basic.so',    $output . '\apache\modules\mod_auth_basic.so');
$file->copyFile($xampp . '\apache\modules\mod_auth_basic.so',    $output . '\apache\modules\mod_auth_basic.so');
$file->copyFile($xampp . '\apache\modules\mod_authn_core.so',    $output . '\apache\modules\mod_authn_core.so');
$file->copyFile($xampp . '\apache\modules\mod_authn_file.so',    $output . '\apache\modules\mod_authn_file.so');
$file->copyFile($xampp . '\apache\modules\mod_authz_core.so',    $output . '\apache\modules\mod_authz_core.so');
$file->copyFile($xampp . '\apache\modules\mod_mime.so',          $output . '\apache\modules\mod_mime.so');
$file->copyFile($xampp . '\apache\modules\mod_expires.so',       $output . '\apache\modules\mod_expires.so');
$file->copyFile($xampp . '\apache\modules\mod_env.so',           $output . '\apache\modules\mod_env.so');
$file->copyFile($xampp . '\apache\modules\mod_rewrite.so',       $output . '\apache\modules\mod_rewrite.so');
$file->copyFile($xampp . '\apache\modules\mod_setenvif.so',      $output . '\apache\modules\mod_setenvif.so');
$file->copyFile($xampp . '\apache\modules\mod_autoindex.so',     $output . '\apache\modules\mod_autoindex.so');
$file->copyFile($xampp . '\apache\modules\mod_authz_user.so',    $output . '\apache\modules\mod_authz_user.so');
$file->copyFile($xampp . '\apache\modules\mod_authz_host.so',    $output . '\apache\modules\mod_authz_host.so');
$file->copyFile($xampp . '\apache\modules\mod_alias.so',         $output . '\apache\modules\mod_alias.so');
$file->copyFile($xampp . '\apache\modules\mod_dir.so',           $output . '\apache\modules\mod_dir.so');
$file->copyFile($xampp . '\apache\modules\mod_deflate.so',       $output . '\apache\modules\mod_deflate.so');
$file->copyFile($xampp . '\apache\modules\mod_filter.so',        $output . '\apache\modules\mod_filter.so');
$file->copyFile($xampp . '\apache\modules\mod_log_config.so',    $output . '\apache\modules\mod_log_config.so');
$file->copyFile($xampp . '\apache\modules\mod_ssl.so',           $output . '\apache\modules\mod_ssl.so');

$file->copyFile($xampp . '\apache\conf\mime.types',           $output . '\apache\conf\mime.types');

$file->copyFile($xampp . '\apache\bin\htpasswd.exe',      $output . '\apache\bin\htpasswd.exe');
$file->copyFile($xampp . '\apache\bin\httpd.exe',         $output . '\apache\bin\httpd.exe');
$file->copyFile($xampp . '\apache\bin\libapr-1.dll',      $output . '\apache\bin\libapr-1.dll');
$file->copyFile($xampp . '\apache\bin\libapriconv-1.dll', $output . '\apache\bin\libapriconv-1.dll');
$file->copyFile($xampp . '\apache\bin\libaprutil-1.dll',  $output . '\apache\bin\libaprutil-1.dll');
$file->copyFile($xampp . '\apache\bin\libhttpd.dll',      $output . '\apache\bin\libhttpd.dll');
$file->copyFile($xampp . '\apache\bin\zlib1.dll',         $output . '\apache\bin\zlib1.dll');
$file->copyFile($xampp . '\apache\bin\pv.exe',            $output . '\apache\bin\pv.exe');
$file->copyFile($xampp . '\apache\bin\libeay32.dll',      $output . '\apache\bin\libeay32.dll');
$file->copyFile($xampp . '\apache\bin\ssleay32.dll',      $output . '\apache\bin\ssleay32.dll');
$file->copyFile($xampp . '\apache\bin\pcre.dll',          $output . '\apache\bin\pcre.dll');
$file->copyFile($xampp . '\apache\bin\msvcr100.dll',      $output . '\apache\bin\msvcr100.dll');

$file->mkdir($output . '\htdocs');

/* Process mysql. */
/* Set mysql root password. */
exec($xampp . '\mysql\bin\mysqld.exe --install tmpMysql');
exec('net start tmpMysql ');
exec($xampp . '\mysql\bin\mysqladmin.exe -uroot password 123456');
exec($xampp . '\mysql\bin\mysql.exe -uroot -p123456 < ' . $buildDir . '\createuser.sql');
exec('net stop tmpMysql ');
exec($xampp . '\mysql\bin\mysqld.exe --remove tmpMysql');

$file->mkdir($output . '\mysql');

/* Process mysql's bin directory. */
$file->mkdir($output . '\mysql\bin');
$file->copyFile($xampp . '\mysql\bin\mysql.exe',      $output . '\mysql\bin\mysql.exe');
$file->copyFile($xampp . '\mysql\bin\mysqld.exe',     $output . '\mysql\bin\mysqld.exe');
$file->copyFile($xampp . '\mysql\bin\mysqldump.exe',  $output . '\mysql\bin\mysqldump.exe');
$file->copyFile($xampp . '\mysql\bin\myisamchk.exe',  $output . '\mysql\bin\myisamchk.exe');

/* Process mysql's share diectory. */
$file->mkdir($output . '\mysql\share');
$file->mkdir($output . '\mysql\share\english');
$file->copyFile($xampp . '\mysql\share\english\errmsg.sys', $output . '\mysql\share\english\errmsg.sys');

/* Process mysql's data directory. */
$file->mkdir($output . '\mysql\data');
$file->copyDir($xampp . '\mysql\data\mysql', $output . '\mysql\data\mysql');
$file->copyDir($xampp . '\mysql\data\performance_schema', $output . '\mysql\data\performance_schema');

/* Process mysql's conf file. */
$file->copyFile($buildDir . '\my.ini', $output . '\mysql\my.ini');

/* Processing php. */
$file->mkdir($output . '\php');
$file->mkdir($output . '\php\logs');

$file->copyFile($xampp . '\php\php7apache2_4.dll', $output . '\php\php7apache2_4.dll');
$file->copyFile($xampp . '\php\php7ts.dll',        $output . '\php\php7ts.dll');
$file->copyFile($xampp . '\php\ssleay32.dll',      $output . '\php\ssleay32.dll');
$file->copyFile($xampp . '\php\libeay32.dll',      $output . '\php\libeay32.dll');
$file->copyFile($xampp . '\php\libsasl.dll',       $output . '\apache\bin\libsasl.dll');
$file->copyFile($xampp . '\php\libsasl.dll',       $output . '\php\libsasl.dll');
$file->copyFile($xampp . '\php\libssh2.dll',       $output . '\php\libssh2.dll');
$file->copyFile($xampp . '\php\libssh2.dll',       $output . '\apache\bin\libssh2.dll');
$file->copyFile($xampp . '\php\nghttp2.dll',       $output . '\php\nghttp2.dll');
$file->copyFile($xampp . '\php\nghttp2.dll',       $output . '\apache\bin\nghttp2.dll');
$file->copyFile($xampp . '\php\php.exe',      	   $output . '\php\php.exe');
$file->copyFile($xampp . '\php\php.gif',      	   $output . '\php\php.gif');

/* Process php ini file. */
$file->copyFile($buildDir . '\php.ini', $output . '.\php\php.ini');

/* Process php's ext directory. */
$file->mkdir($output . '\php\ext');
$file->copyFile($xampp . '\php\ext\php_bz2.dll',       $output . '\php\ext\php_bz2.dll');
$file->copyFile($xampp . '\php\ext\php_gd2.dll',       $output . '\php\ext\php_gd2.dll');
$file->copyFile($xampp . '\php\ext\php_imap.dll',      $output . '\php\ext\php_imap.dll');
$file->copyFile($xampp . '\php\ext\php_mbstring.dll',  $output . '\php\ext\php_mbstring.dll');
$file->copyFile($xampp . '\php\ext\php_mysqli.dll',    $output . '\php\ext\php_mysqli.dll');
$file->copyFile($xampp . '\php\ext\php_pdo_mysql.dll', $output . '\php\ext\php_pdo_mysql.dll');
$file->copyFile($xampp . '\php\ext\php_sockets.dll',   $output . '\php\ext\php_sockets.dll');
$file->copyFile($xampp . '\php\ext\php_openssl.dll',   $output . '\php\ext\php_openssl.dll');
$file->copyFile($xampp . '\php\ext\php_ldap.dll',      $output . '\php\ext\php_ldap.dll');
$file->copyFile($xampp . '\php\ext\php_curl.dll',      $output . '\php\ext\php_curl.dll');
$file->copyFile($xampp . '\php\ext\php_opcache.dll',   $output . '\php\ext\php_opcache.dll');

/* Process adminer. */
$file->mkdir($output . '\adminer');
$file->copyFile(dirname(__FILE__) . '\adminer.php', $output . '\adminer\index.php');
$file->copyFile(dirname(__FILE__) . "\adminer.{$product}.php", $output . '.\xampp\adminer\index.php');
$file->copyFile(dirname(__FILE__) . '\adminer.css', $output . '\adminer\adminer.css');

$file->mkdir($output . '\runner');
$file->copyFile(dirname(dirname(__FILE__)) . '\runner\start.exe', $output . '\start.exe');
$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\common\runner', $output . '\runner');
$file->copyFile($buildDir . '\readme.txt', $output . '\readme.txt');

/* Process the svn. */
if($product == 'zentao')
{
    $file->copyDir($buildDir . '\svn\sliksvn', $output . '\sliksvn');
    $file->mkdir($output . '\zentao\module\svn\ext\config');
    $file->copyFile($buildDir . '\svn\svn.php', $output . '\zentao\module\svn\ext\config\svn.php');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\zentao\htdocs', $output . '\htdocs');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\zentao\runner', $output . '\runner');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\zentao\zentao', $output . '\zentao');
	$file->copyFile(dirname(dirname(__FILE__)) . '\runner\xampp\zentao\readme.txt', $output . '\readme.txt');
}
elseif($product == 'chanzhi')
{
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\chanzhi\htdocs', $output . '\htdocs');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\chanzhi\runner', $output . '\runner');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\chanzhi\chanzhi', $output . '\chanzhi');
	$file->copyFile(dirname(dirname(__FILE__)) . '\runner\xampp\chanzhi\readme.txt', $output . '\readme.txt');
}
elseif($product == 'ranzhi')
{
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\ranzhi\htdocs', $output . '\htdocs');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\ranzhi\runner', $output . '\runner');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\ranzhi\ranzhi', $output . '\ranzhi');
	$file->copyFile(dirname(dirname(__FILE__)) . '\runner\xampp\ranzhi\readme.txt', $output . '\readme.txt');
}
elseif($product == 'yidou')
{
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\yidou\htdocs', $output . '\htdocs');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\yidou\runner', $output . '\runner');
	$file->copyDir(dirname(dirname(__FILE__))  . '\runner\xampp\yidou\yidou', $output . '\yidou');
	$file->copyFile(dirname(dirname(__FILE__)) . '\runner\xampp\yidou\readme.txt', $output . '\readme.txt');
}

/* Copy ioncube loader. */
$file->copyFile($buildDir . '\php_ioncube.dll', $output . '\php\ext\php_ioncube.dll');

/* Copy serive bat file. */
$file->copyDir($buildDir . '\services', $output . '\services');
