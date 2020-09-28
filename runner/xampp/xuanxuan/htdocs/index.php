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

$lang->cn->links['xxb']['link']       = '/xxb/';
$lang->cn->links['xxb']['text']       = '喧喧';
$lang->cn->links['xxb']['target']     = '_self';

$lang->cn->title = '欢迎使用喧喧集成运行环境！';
$lang->cn->official   = " <a href='http://www.xuanim.com' target='_blank'>喧喧官网</a>";
$lang->cn->adminer    = "<a href='/adminer/' target='_blank'>数据库管理</a>";

$lang->en->visit = 'Visit ';

$lang->en->links['xxb']['link']       = '/xxb/';
$lang->en->links['xxb']['text']       = 'XXB';
$lang->en->links['xxb']['target']     = '_self';

$lang->en->title      = 'Welcome to use xuanxuan!';
$lang->en->official   = " <a href='http://www.xuanim.com' target='_blank'>Community</a>";
$lang->en->adminer    = "<a href='/adminer/' target='_blank'>MySQL</a>";

$acceptLang = stripos($_SERVER['HTTP_ACCEPT_LANGUAGE'], 'zh-CN') !== false ? 'cn' : 'en';
$acceptLang = isset($_GET['lang']) ? $_GET['lang'] : $acceptLang;
$clientLang = $lang->$acceptLang;

?>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
  <title><?php echo $clientLang->title;?></title>
  <style>
  </style>
</head>
<link rel='stylesheet' href='../xxb/theme/zui/css/min.css' type='text/css' media='screen' />
<script src='../xxb/js/jquery/min.js?v=1.3.beta' type='text/javascript'></script>
<script src='../xxb/js/zui/min.js?v=1.3.beta' type='text/javascript'></script>
<style>body{background-color: #f6f5fb}
.container{padding: 0}
.modal-footer{text-align: left;}
.modal-footer > a{margin-left:5px;}
.modal-dialog{margin: auto; width: 450px; position: relative; margin-top: 10%; box-shadow: 0px 2px 10px rgba(93,56,198,0.1)}

.modal-body{margin:20px 0px; text-align: center;}
.modal-body img{}

.dropdown{position: absolute; right: 15px; bottom: 10px; border: none;z-index: 999}
.dropdown.btn{padding: 0;overflow: visible;}
.dropdown a:hover,button a:active,.dropdown a:focus{text-decoration: none;}
.dropdown .dropdown-menu li{text-align: left}
.dropdown .caret{margin-left: 8px;}
.dropdown-toggle{padding: 6px 12px; display: inline-block;}
.bg-primary {background-image: linear-gradient(-225deg, #6c3ed9 0%, #8960ef 100%); border-color: #6c3ed9; transition: background .2s;}
.bg-primary:hover {background-image: linear-gradient(-260deg, #6c3ed9 20%, #8960ef 100%); border-color: #8960ef;}
a {color: #8960ef}
a:hover {color: #6c3ed9}
</style>
<body>
<div class='container'>
  <div class='modal-dialog'>
    <div class='modal-content'>
      <div class='modal-body'>
        <div class="row">
          <div class="col-xs-6 text-center" style="border-right: 1px solid #e5e5e5;">
            <img src='?mode=getlogo' style="max-height: 150px" />
          </div>
          <div class="col-xs-6" style="margin-top:50px;">
			<?php foreach($clientLang->links as $linkID => $link):?>
			  <a id='product-<?php echo $linkID;?>' href="<?php echo $link['link']?>" class='btn btn-primary btn-lg bg-primary' target='<?php echo $link['target']?>'><?php echo $clientLang->visit . $link['text'];?> <i class="icon icon-arrow-right"></i></a>
			<?php endforeach;?>
          </div>
        </div>
      </div>
    </div>
    <div class='modal-footer'>
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
