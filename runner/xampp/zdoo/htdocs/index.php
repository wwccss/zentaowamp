<?php
error_reporting(0);

if(isset($_GET['mode']) and $_GET['mode'] == 'getlogo')
{
    header('Content-type: image/png');
    die(base64_decode('iVBORw0KGgoAAAANSUhEUgAAASwAAABYCAMAAAB4ZzokAAACEFBMVEUAAAD80Ar90gvqVjPqVjNdt+j90Qr80gvWXCNtwvlet+jqVTNet+j//4frVTNet+j90QvrVTP90QpivPF80f9dt+ddt+het+n90gtfuOlet+het+het+pet+heuOlcteddt+het+het+j90QteteZft+lguOpiuuxet+heuOhguuz/1A1mvu3/ZEtdt+j///9et+het+j90gr///9euOpeuOhfuOliuur/2A//0gphuOxGk8////9dt+j90gteuOlet+j/////0gv///9dt+jqVjL///9dtefvWjj////PYE/qVTJet+fqVjL///////9et+jrVjT///9guez/////3BHqVTPqVTLqVTLqVjP////////sVjTsVjTsVzbwWzZCjMv90Qv////////////////////rVjP///9et+f////////////pVTL90AvqVzL/0g1ljcThbiJqhrxtfbJandPoVzX80QvAZ2OlcoCNeZnrVjL/////0wzkaSbaXUL80QvXX0tdtuf80ArpVTIxcbheZq3JOinTVyLhaCZbtOZOn9hDjsxXruNeaK83e78zdLo7gcM0d7xdndZfbrJrdq5UqN5dk85gcbN0eKhdq+BJltJdsuVbseNKmdNea7I/iMhdicZdf7+OdZHjVzpdpNpdc7fYXEVRpdxderx9dp+XconFY1qhb362aGm7ZmPo+93JAAAAgnRSTlMAtHfNd/2WWvgI47SvA5aB7Fr6EwTsmXJpN7WfPpJqUfXx2dOmRDEa02MmJA0E6czHvpB3XlZLIhFHKv7lu4yGem1CFc2nf1oOCP75+OfdrIxLHh4PDvDaw2lYRUMyJRX119a/tKGSiIV2PDMn329gJ+7s6ung1baSi4l+Tin9wLWxrn0abgAACZFJREFUeNrc2dlPE1EUx/HjMiatrail1pZaSqViUWlRFpeiVtzqAoq4gYqyieAajVs0miMzD7gAivu+G7e/0dIW6TAzZ3rH0xc/CSGEJ765c+eXAtPZnT03M3+H5+09cgyEuLx1tRGPJ1Jb53WBiOLKcGlNwBOoKQ1XFkPekq0w4Q67lTMGBe28vGXm0RVgbl+kJObGHFWxBTUV+XTyFzlCEk6SQo4ivw1MNfY2dUbjzf0FijV3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'));
}

$config->langs['cn'] = '简体';
$config->langs['en'] = 'English';

$lang->cn->visit = '访问';

$lang->cn->links['zdoo']['link']       = '/zdoo/';
$lang->cn->links['zdoo']['text']       = 'Zdoo';
$lang->cn->links['zdoo']['target']     = '_self';

$lang->cn->title    = '欢迎使用Zdoo集成运行环境！';
$lang->cn->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a>";
$lang->cn->official = " <a href='http://zdoo.com' target='_blank'>Zdoo官网</a>";
$lang->cn->adminer  = "<a href='/adminer/' target='_blank'>数据库管理</a>";

$lang->en->visit = 'Visit ';

$lang->en->links['zdoo']['link']       = '/zdoo/';
$lang->en->links['zdoo']['text']       = 'zdoo';
$lang->en->links['zdoo']['target']     = '_self';

$lang->en->title    = 'Welcome to use zdoo!';
$lang->en->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a> ";
$lang->en->official = " <a href='http://zdoo.org' target='_blank'>Community</a>";
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
<link rel='stylesheet' href='../zdoo/theme/zui/css/min.css' type='text/css' media='screen' />
<script src='../zdoo/js/jquery/min.js?v=1.3.beta' type='text/javascript'></script>
<script src='../zdoo/js/zui/min.js?v=1.3.beta' type='text/javascript'></script>
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
