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

$lang->cn->links['chanzhi']['link']       = '/chanzhi/';
$lang->cn->links['chanzhi']['text']       = '蝉知';
$lang->cn->links['chanzhi']['target']     = '_self';

$lang->cn->title    = '欢迎使用蝉知集成运行环境！';
$lang->cn->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a>";
$lang->cn->official = " <a href='http://www.chanzhi.org' target='_blank'>蝉知官网</a>";
$lang->cn->adminer  = "<a href='/adminer/' target='_blank'>数据库管理</a>";

$lang->en->visit = 'Visit ';

$lang->en->links['chanzhi']['link']       = '/chanzhi/';
$lang->en->links['chanzhi']['text']       = 'chanzhi';
$lang->en->links['chanzhi']['target']     = '_self';

$lang->en->title    = 'Welcome to use chanzhi!';
$lang->en->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a> ";
$lang->en->official = " <a href='http://www.chanzhi.org/en' target='_blank'>Community</a>";
$lang->en->adminer  = "<a href='/adminer/' target='_blank'>MySQL</a>";

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
<link rel='stylesheet' href='../chanzhi/zui/css/min.css?v=2.5.3' type='text/css' media='screen' />
<link rel='stylesheet' href='../chanzhi/template/default/theme/default/style.css' type='text/css' media='screen' />
<script src='../chanzhi/js/jquery/min.js?v=1.3.beta' type='text/javascript'></script>
<script src='../chanzhi/js/zui/min.js?v=1.3.beta' type='text/javascript'></script>
<style>body{background-color: #f1f1f1}
.container{padding: 0}
.modal-dialog{width: 800px}
.modal-footer{text-align: center;margin-top: 0;}

.table,.alert{margin: 0;}
.table+.alert{margin-top: 20px;}
.table.table-form>thead>tr>th, .table.table-form>tbody>tr>th, .table.table-form>tfoot>tr>th{color: #666}
.table.table-form>thead>tr>th, .table.table-form>tbody>tr>th, .table.table-form>tfoot>tr>th, .table.table-form>thead>tr>td, .table.table-form>tbody>tr>td, .table.table-form>tfoot>tr>td{vertical-align: middle;}
.table td.ok{color:green;}
.table td.fail{color:red;}
.table-form .text-center{text-align:center}

@media (max-width: 700px){.modal-dialog{padding: 0;} .modal-content{box-shadow: none;border-width: 1px 0;border-radius: 0}}
h3{font-size:16px; margin-bottom: 20px;}
blockquote{font-size:14px; padding:0px 20px; line-height:1.5; border:0}
#chanzhi{margin-top:30px}

.modal-dialog{position: relative; margin-top: 10%;}
.modal-header{position: absolute; right: 15px; top: 10px; border: none;z-index: 999}
.modal-body{padding: 20px 60px;}

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
      <div class="modal-header text-right">
        <div class='btn dropdown'>
          <a href='###' class='dropdown-toggle' data-toggle='dropdown'> <i class='icon-globe icon-large'></i>
            &nbsp;<?php echo $config->langs[$acceptLang]?>
            <span class='caret'></span>
          </a>
          <ul class='dropdown-menu'>
            <?php foreach($config->langs as $langCode => $langName) echo "<li><a href='?lang=$langCode'>$langName</a></li>";?>
          </ul>
        </div>
      </div>
      <div class='modal-body'>
        <h3><?php echo $clientLang->title;?></h3>
        <div>
        <div class="row">
          <div class="col-xs-6 text-center">
            <img src='?mode=getlogo' />
          </div>
          <div class="col-xs-6" style="border-left: 1px solid #ddd">
            <ul>
              <li><?php echo $clientLang->xampp;?></li>
              <li><?php echo $clientLang->official ?></li>
              <li><?php echo $clientLang->adminer ?></li>
            </ul>
          </div>
        </div>
        </div>
      </div>
    </div>
    <div class='modal-footer'>
      <p class='text-center'>
        <?php foreach($clientLang->links as $linkID => $link):?>
          <a id='product-<?php echo $linkID;?>' href="<?php echo $link['link']?>" class='btn btn-success' target='<?php echo $link['target']?>'><?php echo $clientLang->visit . $link['text'];?></a>
        <?php endforeach;?>
      </p>
    </div>
  </div>
</div>
</body>
</html>
