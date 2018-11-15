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
$sourceDir  = $argv[1];
$product    = $argv[2];
$xampp      = $sourceDir . '\xampp';
$output     = $sourceDir . '\release';

chdir($sourceDir);

/* rm useless files. */
error_reporting(E_ALL);
$file->removeDir('./xampp/cgi-bin');
$file->removeDir('./xampp/contrib');
$file->removeDir('./xampp/install');
$file->removeDir('./xampp/licenses');
$file->removeDir('./xampp/locale');
$file->removeDir('./xampp/mailoutput');
$file->removeDir('./xampp/mailtodisk');
$file->removeDir('./xampp/perl');
$file->removeDir('./xampp/sendmail');
$file->removeDir('./xampp/security');
$file->removeDir('./xampp/webdav');
$file->removeDir('./xampp/FileZillaFTP');
$file->removeDir('./xampp/MercuryMail');
$file->removeDir('./xampp/webalizer');
$file->removeDir('./xampp/tomcat');
$file->batchRemoveFile('./xampp/tmp/*');
$file->batchRemoveFile('./xampp/*.txt');
$file->batchRemoveFile('./xampp/*.bat');
$file->batchRemoveFile('./xampp/*.exe');
$file->batchRemoveFile('./xampp/*.ini');
$file->batchRemoveFile('./xampp/*.log');
$file->batchRemoveFile('./xampp/*.dat');

/* Process apache module. */
$file->batchRemoveFile('./xampp/apache/*.txt');
$file->batchRemoveFile('./xampp/apache/*.bat');
$file->rename('./xampp/apache/modules', './xampp/apache/modulesold');
$file->mkdir('./xampp/apache/modules');

$file->copyFile('./xampp/apache/modulesold/mod_access_compat.so', './xampp/apache/modules/mod_access_compat.so');
$file->copyFile('./xampp/apache/modulesold/mod_auth_basic.so',    './xampp/apache/modules/mod_auth_basic.so');
$file->copyFile('./xampp/apache/modulesold/mod_auth_basic.so',    './xampp/apache/modules/mod_auth_basic.so');
$file->copyFile('./xampp/apache/modulesold/mod_authz_core.so',    './xampp/apache/modules/mod_authz_core.so');
$file->copyFile('./xampp/apache/modulesold/mod_mime.so',          './xampp/apache/modules/mod_mime.so');
$file->copyFile('./xampp/apache/modulesold/mod_expires.so',       './xampp/apache/modules/mod_expires.so');
$file->copyFile('./xampp/apache/modulesold/mod_env.so',           './xampp/apache/modules/mod_env.so');
$file->copyFile('./xampp/apache/modulesold/mod_rewrite.so',       './xampp/apache/modules/mod_rewrite.so');
$file->copyFile('./xampp/apache/modulesold/mod_setenvif.so',      './xampp/apache/modules/mod_setenvif.so');
$file->copyFile('./xampp/apache/modulesold/mod_autoindex.so',     './xampp/apache/modules/mod_autoindex.so');
$file->copyFile('./xampp/apache/modulesold/mod_authz_user.so',    './xampp/apache/modules/mod_authz_user.so');
$file->copyFile('./xampp/apache/modulesold/mod_authz_host.so',    './xampp/apache/modules/mod_authz_host.so');
$file->copyFile('./xampp/apache/modulesold/mod_alias.so',         './xampp/apache/modules/mod_alias.so');
$file->copyFile('./xampp/apache/modulesold/mod_dir.so',           './xampp/apache/modules/mod_dir.so');
$file->copyFile('./xampp/apache/modulesold/mod_deflate.so',       './xampp/apache/modules/mod_deflate.so');
$file->copyFile('./xampp/apache/modulesold/mod_filter.so',        './xampp/apache/modules/mod_filter.so');
$file->copyFile('./xampp/apache/modulesold/mod_log_config.so',    './xampp/apache/modules/mod_log_config.so');
$file->copyFile('./xampp/apache/modulesold/mod_ssl.so',           './xampp/apache/modules/mod_ssl.so');
$file->removeDir('./xampp/apache/modulesold');

/* Remove apache's error, icons, include, lib, logs directory. */
$file->removeDir('./xampp/apache/cgi-bin');
$file->removeDir('./xampp/apache/error');
$file->removeDir('./xampp/apache/icons');
$file->removeDir('./xampp/apache/include');
$file->removeDir('./xampp/apache/lib');
$file->removeDir('./xampp/apache/conf/extra');
$file->removeDir('./xampp/apache/conf/original');
$file->removeFile('./xampp/apache/conf/openssl.cnf');
$file->batchRemoveFile('./xampp/apache/logs/*.log');
$file->batchRemoveFile('./xampp/apache/*.pl');
$file->removeDir('./xampp/apache/manual');

$file->rename('./xampp/apache/bin', './xampp/apache/binold');
$file->mkdir('./xampp/apache/bin');

$file->copyFile('./xampp/apache/binold/htpasswd.exe',      './xampp/apache/bin/htpasswd.exe');
$file->copyFile('./xampp/apache/binold/httpd.exe',         './xampp/apache/bin/httpd.exe');
$file->copyFile('./xampp/apache/binold/libapr-1.dll',      './xampp/apache/bin/libapr-1.dll');
$file->copyFile('./xampp/apache/binold/libapriconv-1.dll', './xampp/apache/bin/libapriconv-1.dll');
$file->copyFile('./xampp/apache/binold/libaprutil-1.dll',  './xampp/apache/bin/libaprutil-1.dll');
$file->copyFile('./xampp/apache/binold/libhttpd.dll',      './xampp/apache/bin/libhttpd.dll');
$file->copyFile('./xampp/apache/binold/zlib1.dll',         './xampp/apache/bin/zlib1.dll');
$file->copyFile('./xampp/apache/binold/pv.exe',            './xampp/apache/bin/pv.exe');
$file->copyFile('./xampp/apache/binold/libeay32.dll',      './xampp/apache/bin/libeay32.dll');
$file->copyFile('./xampp/apache/binold/ssleay32.dll',      './xampp/apache/bin/ssleay32.dll');
$file->copyFile('./xampp/apache/binold/pcre.dll',          './xampp/apache/bin/pcre.dll');
$file->copyFile('./xampp/apache/binold/msvcr100.dll',      './xampp/apache/bin/msvcr100.dll');
$file->copyFile('./xampp/apache/binold/rotatelogs.exe',    './xampp/apache/bin/rotatelogs.exe');
$file->removeDir('./xampp/apache/binold');

/* Process the apache's config file. */
$file->copyFile($buildDir . "/httpd.$product.conf", './xampp/apache/conf/httpd.conf');

/* Remove useless config files. */
$file->removeDir('./xampp/apache/conf/ssl.crl');
$file->removeDir('./xampp/apache/conf/ssl.crt');
$file->removeDir('./xampp/apache/conf/ssl.csr');
$file->removeDir('./xampp/apache/conf/ssl.key');
$file->removeFile('./xampp/apache/conf/magic');
$file->removeFile('./xampp/apache/conf/charset.conv');

/* Empty the htdocs directory. */
$file->removeDir('./xampp/htdocs');
$file->mkdir('./xampp/htdocs');

/* Process mysql. */
$file->removeDir('./xampp/mysql/backup');
$file->removeDir('./xampp/mysql/include');
$file->removeDir('./xampp/mysql/lib');
$file->removeDir('./xampp/mysql/scripts');
$file->removeDir('./xampp/mysql/sql-bench');
$file->removeDir('./xampp/mysql/docs');
$file->removeDir('./xampp/mysql/support-files');

/* Process mysql's bin directory. */
$file->rename('./xampp/mysql/bin', './xampp/mysql/binold');
$file->mkdir('./xampp/mysql/bin');

$file->copyFile('./xampp/mysql/binold/mysql.exe',      './xampp/mysql/bin/mysql.exe');
$file->copyFile('./xampp/mysql/binold/mysqld.exe',     './xampp/mysql/bin/mysqld.exe');
$file->copyFile('./xampp/mysql/binold/mysqld.exe',     './xampp/mysql/bin/mysqld.exe');
$file->copyFile('./xampp/mysql/binold/mysqldump.exe',  './xampp/mysql/bin/mysqldump.exe');
$file->copyFile('./xampp/mysql/binold/myisamchk.exe',  './xampp/mysql/bin/myisamchk.exe');
$file->removeFile('./xampp/mysql/binold/my.ini');

$file->removeDir('./xampp/mysql/binold');

/* Process mysql's share diectory. */
$file->rename('./xampp/mysql/share', './xampp/mysql/shareold');
$file->mkdir('./xampp/mysql/share');
$file->mkdir('./xampp/mysql/share/english');
$file->copyFile('./xampp/mysql/shareold/english/errmsg.sys', './xampp/mysql/share/english/errmsg.sys');
$file->removeDir('./xampp/mysql/shareold');
$file->removeFile('./xampp/mysql/resetroot.bat');

/* Process mysql's data directory. */
$file->removeDir('./xampp/mysql/data/test');
$file->removeDir('./xampp/mysql/data/webauth');
$file->removeDir('./xampp/mysql/data/cdcol');
$file->removeDir('./xampp/mysql/data/phpmyadmin');
$file->batchRemoveFile('./xampp/mysql/data/ib*');
$file->batchRemoveFile('./xampp/mysql/data/mysql*');

/* Remove mysql's useless config files. */
$file->batchRemoveFile('./xampp/mysql/my-*');
$file->removeFile('./xampp/mysql/README');
$file->removeFile('./xampp/mysql/COPYING');

/* Process mysql's conf file. */
$file->copyFile($buildDir . '/my.ini', './xampp/mysql/my.ini');

/* Processing php. */
$file->removeDir('./xampp/php/cfg');
$file->removeDir('./xampp/php/extras');
$file->removeDir('./xampp/php/data');
$file->removeDir('./xampp/php/DB');
$file->removeDir('./xampp/php/dev');
$file->removeDir('./xampp/php/docs');
$file->removeDir('./xampp/php/PEAR');
$file->removeDir('./xampp/php/tests');
$file->removeDir('./xampp/php/Text');
$file->removeDir('./xampp/php/tmp');
$file->removeDir('./xampp/php/www');
$file->removeDir('./xampp/php/scripts');
$file->batchRemoveFile('./xampp/php/dbunit*');
$file->batchRemoveFile('./xampp/php/*.bat');
$file->batchRemoveFile('./xampp/php/*.txt');
$file->batchRemoveFile('./xampp/php/php.ini-*');
$file->batchRemoveFile('./xampp/php/*.reg');
$file->batchRemoveFile('./xampp/php/pci*');
$file->batchRemoveFile('./xampp/php/*.phar');
$file->batchRemoveFile('./xampp/php/php-*.exe');
$file->batchRemoveFile('./xampp/php/phpcov');
$file->batchRemoveFile('./xampp/php/phptok');
$file->batchRemoveFile('./xampp/php/phpunit');
$file->batchRemoveFile('./xampp/php/*.php');
$file->batchRemoveFile('./xampp/php/phpcs');
$file->batchRemoveFile('./xampp/php/phpdoc');
$file->batchRemoveFile('./xampp/php/phpuml');
$file->batchRemoveFile('./xampp/php/*.sh');
$file->batchRemoveFile('./xampp/php/logs/*');
$file->batchRemoveFile('./xampp/php/php7embed.lib');

$file->rename('./xampp/php/php7apache2_4.dll', './xampp/php/php7apache2_4.bak');
$file->rename('./xampp/php/php7ts.dll',   './xampp/php/php7ts.bak');
$file->rename('./xampp/php/ssleay32.dll', './xampp/php/ssleay32.dll.bak');
$file->rename('./xampp/php/libeay32.dll', './xampp/php/libeay32.dll.bak');
$file->rename('./xampp/php/libsasl.dll',  './xampp/php/libsasl.dll.bak');
$file->batchRemoveFile('./xampp/php/*.dll');
$file->rename('./xampp/php/php7apache2_4.bak', './xampp/php/php7apache2_4.dll');
$file->rename('./xampp/php/php7ts.bak', './xampp/php/php7ts.dll');
$file->rename('./xampp/php/ssleay32.dll.bak', './xampp/php/ssleay32.dll');
$file->rename('./xampp/php/libeay32.dll.bak', './xampp/php/libeay32.dll');
$file->copyFile('./xampp/php/libsasl.dll.bak', './xampp/apache/bin/libsasl.dll');
$file->rename('./xampp/php/libsasl.dll.bak',  './xampp/php/libsasl.dll');

/* Process php ini file. */
$file->copyFile($buildDir . '/php.ini', './xampp/php/php.ini');
$file->copyFile($buildDir . '/php.ini', './xampp/php/php.raw.ini');

/* Process php's ext directory. */
$file->rename('./xampp/php/ext', './xampp/php/extold');
$file->mkdir('./xampp/php/ext');
$file->copyFile('./xampp/php/extold/php_bz2.dll',       './xampp/php/ext/php_bz2.dll');
$file->copyFile('./xampp/php/extold/php_gd2.dll',       './xampp/php/ext/php_gd2.dll');
$file->copyFile('./xampp/php/extold/php_imap.dll',      './xampp/php/ext/php_imap.dll');
$file->copyFile('./xampp/php/extold/php_mbstring.dll',  './xampp/php/ext/php_mbstring.dll');
$file->copyFile('./xampp/php/extold/php_mysql.dll',     './xampp/php/ext/php_mysql.dll');
$file->copyFile('./xampp/php/extold/php_mysqli.dll',    './xampp/php/ext/php_mysqli.dll');
$file->copyFile('./xampp/php/extold/php_pdo_mysql.dll', './xampp/php/ext/php_pdo_mysql.dll');
$file->copyFile('./xampp/php/extold/php_sockets.dll',   './xampp/php/ext/php_sockets.dll');
$file->copyFile('./xampp/php/extold/php_openssl.dll',   './xampp/php/ext/php_openssl.dll');
$file->copyFile('./xampp/php/extold/php_ldap.dll',      './xampp/php/ext/php_ldap.dll');
$file->copyFile('./xampp/php/extold/php_curl.dll',      './xampp/php/ext/php_curl.dll');
$file->copyFile('./xampp/php/extold/php_opcache.dll',   './xampp/php/ext/php_opcache.dll');
$file->removeDir('./xampp/php/extold');

/* Process phpmyadmin. */
$file->removeDir('./xampp/phpMyAdmin');
$file->mkdir('./xampp/adminer');
$file->copyFile(dirname(__FILE__) . '/adminer.php', './xampp/adminer/adminer.php');
$file->copyFile(dirname(__FILE__) . "/adminer.{$product}.php", './xampp/adminer/index.php');
$file->copyFile(dirname(__FILE__) . '/adminer.css', './xampp/adminer/adminer.css');

/* Process the svn. */
if($product == 'zentao')
{
    $file->copyDir($buildDir . '/svn/sliksvn/', './xampp/sliksvn');
    $file->mkdir('./xampp/zentao/module/svn/ext/config');
    $file->copyFile($buildDir . '/svn/svn.php', './xampp/zentao/module/svn/ext/config/svn.php');
}
else
{
    $file->removeDir('./xampp/sliksvn/');
    $file->removeDir('./xampp/zentao/');
}

/* Copy index.php. */
$indexFile = "index.$product.php";
$remoteIndexFile = "https://raw.github.com/easysoft/zentaolamp/master/$indexFile";
file_put_contents('./xampp/htdocs/index.php', file_get_contents($remoteIndexFile));

/* Copy ioncube loader. */
$file->copyFile($buildDir . '/php_ioncube.dll', './xampp/php/ext/php_ioncube.dll');

/* Copy serive bat file. */
$file->copyDir($buildDir . '/services', './xampp/services');

/* Copy the readme.txt. */
$file->copyFile($buildDir . "/readme.$product.txt", './xampp/readme.txt');

/* Remove useless dir. */
$file->removeDir('anonymous');
$file->removeDir('SCRATCH');
$file->removeDir('src');
