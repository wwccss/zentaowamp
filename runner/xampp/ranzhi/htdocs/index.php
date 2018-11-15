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
