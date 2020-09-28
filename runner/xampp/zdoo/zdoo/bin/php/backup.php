<?php
/* Backup the db. */
error_reporting(E_ALL ^ E_NOTICE);
/* Include config.php and pclzip class. */
$productRoot  = dirname(dirname(dirname(__FILE__)));
$xamppRoot = dirname($productRoot);
$myConfig = $productRoot . '\system\config\config.php';
$zipClass = $productRoot . '/system/lib/pclzip/pclzip.class.php';
$mysqldump = $xamppRoot . '\mysql\bin\mysqldump.exe';

include $myConfig;
include $productRoot . '\system\config\my.php';
include $zipClass;

/* Init the backupRoot and dest directory. */
$backupRoot = $productRoot . "/backup";
$destDir    = $backupRoot . "/" . date('Ym');

if(!file_exists($backupRoot)) mkdir($backupRoot, 0777);
if(!file_exists($destDir))    mkdir($destDir, 0777);

/* Backup database. */
$dbRawFile = "db." . date('Ymd') . ".sql";
$password  = $config->db->password ?  "-p{$config->db->password}" : ' ';
$command   = "\"{$mysqldump}\" -u{$config->db->user} $password -P {$config->db->port} {$config->db->name} > {$dbRawFile}";

echo "Backup command: " . $command . "\n";
echo "Backuping database,";
system($command, $return);
if($return == 0)
{
    $dbZipFile = $destDir . "/"  . str_replace("sql", "zip", $dbRawFile);
    $archive  = new pclzip($dbZipFile);

    if($archive->create($dbRawFile))
    {
        unlink($dbRawFile);
        echo " successfully saved to $dbZipFile\n";
    }
    else
    {
        die("Error : " . $archive->errorInfo(true));
    }
}
else
{
    echo "Failed to backup database!\n";
}

/* Backup the attachments. */
chdir(dirname(dirname(dirname(__FILE__))) . "/www");
if(!is_dir('data/upload')) die(" No files needed backup.\n");

echo "Backuping files,";
$attachFile = $destDir . "/" . "file." . date('Ymd', time()) . ".zip";
$archive    = new pclzip($attachFile);
if($archive->create("data/upload", PCLZIP_OPT_REMOVE_PATH, "data")) die(" successfully saved to $attachFile\n");
die("Error : ".$archive->errorInfo(true));
