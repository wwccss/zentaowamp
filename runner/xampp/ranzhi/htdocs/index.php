<?php
error_reporting(0);

if(isset($_GET['mode']) and $_GET['mode'] == 'getlogo')
{
    header('Content-type: image/png');
    die(base64_decode('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'));
}

$config->langs['cn'] = '简体';
$config->langs['en'] = 'English';

$lang->cn->visit = '访问';

$lang->cn->links['ranzhi']['link']       = '/ranzhi/';
$lang->cn->links['ranzhi']['text']       = '然之';
$lang->cn->links['ranzhi']['target']     = '_self';

$lang->cn->title    = '欢迎使用然之集成运行环境！';
$lang->cn->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a>";
$lang->cn->official = " <a href='http://www.ranzhi.org' target='_blank'>然之官网</a>";
$lang->cn->adminer  = "<a href='/adminer/' target='_blank'>数据库管理</a>";

$lang->en->visit = 'Visit ';

$lang->en->links['ranzhi']['link']       = '/ranzhi/';
$lang->en->links['ranzhi']['text']       = 'Ranzhi';
$lang->en->links['ranzhi']['target']     = '_self';

$lang->en->title    = 'Welcome to use ranzhi!';
$lang->en->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a> ";
$lang->en->official = " <a href='http://www.ranzhi.org/en' target='_blank'>Community</a>";
$lang->en->adminer  = "<a href='/adminer/' target='_blank'>MySQL</a>";

$acceptLang = stripos($_SERVER['HTTP_ACCEPT_LANGUAGE'], 'zh-CN') !== false ? 'cn' : 'en';
$acceptLang = isset($_GET['lang']) ? $_GET['lang'] : $acceptLang;
$clientLang = $lang->$acceptLang;

?>
<!DOCTYPE html>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
  <title><?php echo $clientLang->title;?></title>
  <style>
  </style>
</head>
<link rel='stylesheet' href='../ranzhi/theme/zui/css/min.css' type='text/css' media='screen' />
<script src='../ranzhi/js/jquery/min.js?v=1.3.beta' type='text/javascript'></script>
<script src='../ranzhi/js/zui/min.js?v=1.3.beta' type='text/javascript'></script>
<style>
body{background-color: #f1f1f1}
.container{padding: 0}
.modal-footer{text-align: left;}
.modal-footer > a{margin-left:5px;}
.modal-dialog{width: 450px; margin: auto; position: relative; margin-top: 10%;}

.modal-body{margin:20px 0px; text-align: center;}
.modal-body img{}

.dropdown{position: absolute; right: 15px; bottom: 10px; border: none;z-index: 999}
.dropdown.btn{padding: 0;overflow: visible;}
.dropdown a:hover,button a:active,.dropdown a:focus{text-decoration: none;}
.dropdown .dropdown-menu li{text-align: left}
.dropdown .caret{margin-left: 8px;}
.dropdown-toggle{padding: 6px 12px; display: inline-block;}
</style>
<body>
<div class='container'>
  <div class='modal-dialog'>
    <div class='modal-content'>
      <div class='modal-body'>
        <div class="row">
          <div class="col-xs-6 text-center" style="border-right: 1px solid #ddd;">
            <img src='?mode=getlogo' />
          </div>
          <div class="col-xs-6" style="margin-top:11px;">
			<?php foreach($clientLang->links as $linkID => $link):?>
			  <a id='product-<?php echo $linkID;?>' href="<?php echo $link['link']?>" class='btn btn-success' target='<?php echo $link['target']?>'><?php echo $clientLang->visit . $link['text'];?></a>
			<?php endforeach;?>
          </div>
        </div>
      </div>
    </div>
    <div class='modal-footer'>
      <?php echo $clientLang->xampp;?>
      <?php echo $clientLang->official ?>
      <?php echo $clientLang->adminer ?>
	    <div class='btn dropdown'>
        <a href='###' class='dropdown-toggle' data-toggle='dropdown'>
          &nbsp;&nbsp;<?php echo $config->langs[$acceptLang]?>
          <span class='caret'></span>
        </a>
        <ul class='dropdown-menu'>
          <?php foreach($config->langs as $langCode => $langName) echo "<li><a href='?lang=$langCode'>$langName</a></li>";?>
        </ul>
      </div>
    </div>
  </div>
</div>
</body>
</html>
