<?php
error_reporting(0);

if(isset($_GET['mode']) and $_GET['mode'] == 'getlogo')
{
    header('Content-type: image/png');
    die(base64_decode('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'));
}

$config->langs['cn'] = '简体';
$config->langs['en'] = 'English';

$lang->cn->links['zentao']['link']       = '/zentao/';
$lang->cn->links['zentao']['text']       = '开源版';
$lang->cn->links['zentao']['target']     = '_self';

$lang->cn->title    = '欢迎使用禅道集成运行环境！';
$lang->cn->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a>";
$lang->cn->official = " <a href='http://www.zentao.net' target='_blank'>禅道官网</a>";
$lang->cn->adminer  = "<a href='/adminer/' target='_blank'>数据库管理</a>";

$lang->en->links['zentao']['link']       = '/zentao/';
$lang->en->links['zentao']['text']       = 'Zentao';
$lang->en->links['zentao']['target']     = '_self';

$lang->en->links['zentaopro']['link']    = '/pro/';
$lang->en->links['zentaopro']['text']    = 'ZenTao Pro';
$lang->en->links['zentaopro']['target']  = '_self';

$lang->en->title    = 'Welcome to ZenTao!';
$lang->en->xampp    = " <a href='http://www.apachefriends.org/en/xampp.html' target='_blank'>xampp</a> ";
$lang->en->official = " <a href='http://www.zentao.pm/forum/' target='_blank'>Community</a>";
$lang->en->adminer  = "<a href='/adminer/' target='_blank'>MySQL</a>";

$acceptLang = stripos($_SERVER['HTTP_ACCEPT_LANGUAGE'], 'zh-CN') !== false ? 'cn' : 'en';
$acceptLang = isset($_GET['lang']) ? $_GET['lang'] : $acceptLang;
$clientLang = $lang->$acceptLang;

?>
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
  <title><?php echo $clientLang->title;?></title>
  <link rel='stylesheet' href='../zentao/theme/zui/css/min.css' type='text/css' media='screen' />
  <link rel='stylesheet' href='../zentao/theme/default/style.css' type='text/css' media='screen' />
<style>
html {background-color:#1183fb;}
#welcome{font-size:20px; border-bottom:1px solid #efefef; padding:10px}
#logo{width:120px; border-right:1px solid #efefef}
body {background: #1183fb linear-gradient(-90deg, #0a48d1 0%, #1183fb 100%)}
.container{padding: 0}
.modal-dialog{width: 800px}
.modal-footer{text-align: center;margin-top: 0; padding: 10px 15px;}

.modal-dialog{position: relative; margin-top: 10%;}
.modal-body{padding: 20px 60px;}

.nav>li>a {padding: 5px 10px}
.nav.nav-pills > li.active > a, .nav.nav-pills > li.active > a:hover, .nav.nav-pills > li.active > a:focus {background: none; color: #1a4f85}
</style>
</head>
<script src='../zentao/js/jquery/lib.js' type='text/javascript'></script>
<body>
<div class='container'>
  <div class='modal-dialog' style="width: 600px">
    <div class='modal-content'>
      <div class='modal-body'>
        <div class="row">
          <div class="col-xs-4 text-center">
            <img src='?mode=getlogo' />
          </div><?php  ?>
          <div class="col-xs-8" style="border-left: 1px solid #ddd; padding: 25px 0 35px 50px">
            <h3 style="margin-bottom: 20px"><?php echo $clientLang->title;?></h3>
            <?php foreach($clientLang->links as $linkID => $link) echo "<a id='$linkID' href='$link[link]' class='btn' target='$link[target]'>$link[text]</a> &nbsp; &nbsp; ";?>
          </div>
        </div>
      </div>
    </div>
    <div class='modal-footer'>
      <ul class='pull-left nav nav-pills'><?php foreach($config->langs as $langCode => $langName){$activeClass = $langCode == $acceptLang?'active':''; echo "<li class='$activeClass'><a href='?lang=$langCode'>$langName</a></li>";}?></ul>
      <ul class='pull-right nav nav-pills'>
        <li><?php echo $clientLang->xampp;?></li>
        <li><?php echo $clientLang->official ?></li>
        <li><?php echo $clientLang->adminer ?></li>
        <li><?php echo $clientLang->phpinfo ?></li>
      </ul>
    </div>
  </div>
</div>
</body>
<script>
$('#zentao').addClass('btn-success');
$('#zentaopro').addClass('btn-danger');
$(function()
{
	$.getJSON('/pro/api-getLicenses.html', function(data)
	{
	if(!data) return false;
        if(data.company == 'try') $('#zentaopro').append('<?php echo $_GET['lang'] == 'en' ? ' try' : ' 试用'?>');
        <?php
        $allLife    = $_GET['lang'] == 'en' ? 'All Life' : '永久授权';
        $expireDate = $_GET['lang'] == 'en' ? 'Expire Date : ' : '到期时间：';
        $unlimited  = $_GET['lang'] == 'en' ? 'Unlimited' : '不限人数';
        $limitUser  = $_GET['lang'] == 'en' ? 'Authorized : ' : '授权人数：';
        ?>
        var expireDate = data.expireDate.toLowerCase() == 'all life' ? '<?php echo $allLife;?>' : '<?php echo $expireDate;?>' + data.expireDate;
        var users      = data.user == 0 ? '<?php echo $unlimited;?>' : '<?php echo $limitUser;?>' + data.user;
		$('#zentaopro').attr('title', expireDate + ' ' + users);
	});
});
</script>
</html>
