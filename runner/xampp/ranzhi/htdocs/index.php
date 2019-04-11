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
          <div class="col-xs-6" style="margin-top:48px;">
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
