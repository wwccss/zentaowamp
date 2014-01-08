lang = {}
lang.title  = {}
lang.button = {}
lang.prompt = {}
lang.menu = {}
lang.url = {}

-------------------------------------
-- Url
lang.url.officialSite   = "http://www.zentao.net"
lang.url.proHelp        = "http://www.zentao.net/help-book-zentaoprohelp.html"
lang.url.opensourceHelp = "http://www.zentao.net/help-book-zentaopmshelp.html"
lang.url.flowChart      = "http://www.zentao.net/help-read-79236.html"
lang.url.faq            = "http://www.zentao.net/ask-faq.html"
lang.url.forum          = "http://www.zentao.net/forum"
-------------------------------------

-------------------------------------
-- Menu.
-------------------------------------
lang.title.service         = '服务(S)'
lang.menu.viewService      = "查看服务(V)"
lang.menu.uninstallService = "卸载服务(U)"

lang.title.more        = '更多(M)'
lang.menu.initBat      = "生成脚本(I)"
lang.menu.database     = "数 据 库(D)"
lang.menu.backup       = "备份禅道(B)"
lang.menu.checkVersion = "检查更新(C)"
lang.title.lang        = '语    言(L)'
lang.menu.zhcn         = '中文(Z)'
lang.menu.en           = 'English(E)'

lang.title.help        = '帮助(H)'
lang.menu.officialSite = "禅道官网(O)"
lang.menu.officialHelp = '帮助文档(D)'
lang.menu.flowChart    = "流 程 图(C)"
lang.menu.faq          = "常见问题(F)"
lang.menu.forum        = "官方论坛(T)"

lang.menu.exit         = '退出(X)'

-------------------------------------
-- Buttons.
-------------------------------------
lang.button.start        = "启动禅道"
lang.button.running      = '运行中...'
lang.button.access       = "访问禅道"
lang.button.stop         = "停止禅道"
lang.button.stopped      = '已停止'
lang.button.officialSite = '禅道官网'

lang.button.ok      = '确定'
lang.button.cancel  = '取消'
lang.button.save    = '保存'
lang.button.install = '安装'

-------------------------------------
-- Dialog title.
-------------------------------------
lang.title.controlPanel       = '禅道集成运行环境'
lang.title.configPort         = '服务端口配置'
lang.title.alarm              = '提示'
lang.title.warning            = '警告'
lang.title.exit               = '退出'
lang.title.backupSuccessfully = '备份成功'

-------------------------------------
-- Prompt.
-------------------------------------
lang.prompt.newLine = "\n"

lang.prompt.fileUnfindable = '找不到%s'

-- Install VC.
lang.prompt.withoutVC2005Redistributable = '检测到没有VC++ 2005 redistributable环境，请先安装'
lang.prompt.withoutVC2008Redistributable = '检测到没有VC++ 2008 redistributable环境，请先安装'

-- Control panel version and current dir.
lang.prompt.currentDir = '当前目录：%s'
lang.prompt.panel      = '禅道控制面板 %s'
lang.prompt.trayTip    = lang.prompt.version

-- Xampp is not under root directory.
lang.prompt.wrongPath = "请将禅道一键安装包解压到根目录, 例如：D:\\xampp"

-- Control Panel is running.
lang.prompt.panelIsRunning = '控制面板已经启动'

-- Uninstall service.
lang.prompt.tryToUninstallService = '正在努力移除%s服务......'
lang.prompt.uninstallSuccessfully = '移除%s服务成功'
lang.prompt.uninstallFailed       = '移除%s服务失败'
lang.prompt.serviceUnfindable     = "%s服务未安装"

-- Init bat.
lang.prompt.initBatSuccessfully  = '成功生成批处理文件, 请到%s下查看。'
lang.prompt.initBatFailed        = '执行失败。'

-- Backup data.
lang.prompt.mysqlNotRunning   = '未启动mysql，只备份文件数据。'
lang.prompt.backuping         = '正在备份禅道...'
lang.prompt.backupAlarm       = "成功备份到%s目录, 是否进入该目录查看？"

-- Check new version.
lang.button.getNewVersion    = '获取新版本'
lang.prompt.cannotGetUpdater = '获取不到服务器信息, 网络错误或配置文件%s版本号配置错误。'
lang.prompt.isLatest         = '您现在的禅道版本已经是最新版本！'

-- Start ZenTao.
lang.prompt.tryToStartServices   = '正在努力启动服务中......'
lang.prompt.tryToInstallService  = '正在努力安装%s服务......'
lang.prompt.installSuccessfully  = '安装%s服务成功'
lang.prompt.serviceIsRunning     = '%s服务正常运行中, 端口号:%d'
lang.prompt.startSuccessfully    = '禅道已经正常启动，点击“访问禅道”按钮进行访问'
lang.prompt.startFailed          = '启动%s失败'
lang.prompt.installFailed        = '安装%s服务失败'
lang.prompt.tryToStart           = '正在尝试启动......'
lang.prompt.unknownServiceStatus = '未知的服务状态'
lang.prompt.serviceExists        = '%s服务已经存在'
lang.prompt.wrongConfig          = '%s配置文件错误'
lang.prompt.wrongConfigPrompt    = '打开配置文件所在目录?'

-- Stop ZenTao.
lang.prompt.tryToStopServices       = '正在努力停止服务中......'
lang.prompt.stopServiceSuccessfully = '%s服务停止成功'
lang.prompt.stopServiceFailed       = '%s服务停止失败'
lang.prompt.stopSuccessfully        = '禅道已经停止，点击“启动禅道”按钮启动禅道'
lang.prompt.serviceIsStopped        = '%s服务已经停止'

-- Port is conflict.
lang.prompt.portIsConflict = '%s%d端口冲突'
lang.prompt.suggestPort    = '，建议使用：'

lang.version = {}
lang.version.php        = 'php版本：%s'
lang.version.apache     = 'apache版本：%s'
lang.version.mysql      = 'mysql版本：%s'
lang.version.phpmyadmin = 'phpmyadmin版本：%s'
