require "imlua"
require "cdlua"
require "cdluaim"
require "iuplua"
require "iupluaim"
require "iupluacd"
require "ex"
require "lfs"
require "json"
local http  = require "socket.http"
local initEncode = package.loadlib("encode.dll","luaopen_encode")
initEncode()

----------------------------------------------------------------------------------
-- Define const value.
----------------------------------------------------------------------------------
MOUSE_LEFT    = 49
MOUSE_PRESSED = 1
MAX_PORT      = 65535
HOST          = '127.0.0.1'
SOCKET        = require("socket")
VC_REDIST     = 'vcredist_x86.exe'
BUTTON_SIZE   = "50x20"
TMP_BAT       = 'tmp\\tmp.bat'
DRIVE_LETTER  = string.lower(string.sub(os.currentdir(), 0, 1))
BACKUP_CMD    = 'cd ..\\zentao\\bin & \\xampp\\php\\php.exe backup.php & cd ..\\..\\controlPanel'
UPDATER_URL   = "http://www.zentao.net/updater-isLatest-%s-.json"
VERSION       = 'controlPanel_1.0'
PHP_BAT       = 'tmp\\php.bat'
PMS_VERSION   = ''
LANG_FILE     = 'tmp\\lang'
OK_FILE       = 'tmp\\ok'
TMP_FILE      = '\\xampp\\controlPanel\\tmp\\tmp'

----------------------------------------------------------------------------------
-- Init apache and mysql table.
----------------------------------------------------------------------------------
apache = {}
mysql  = {}
zentao = {}

apache.configFile  = "..\\apache\\conf\\httpd.conf" 
apache.serviceName = 'apachezt'
apache.status      = 'stopped'
apache.port        = 80
apache.suggestPort = 88

mysql.configFile       = "..\\mysql\\my.ini" 
mysql.oldConfigFile    = "..\\mysql\\bin\\my.ini" 
mysql.myConfig         = "..\\zentao\\config\\my.php"
mysql.phpmyadminConfig = "..\\admin\\phpmyadmin\\config.inc.php"
mysql.serviceName      = 'mysqlzt'
mysql.status           = 'stopped'
mysql.port             = 3306 
mysql.suggestPort      = 3308 

zentao.configFile      = "..\\zentao\\config\\config.php"

----------------------------------------------------------------------------------
-- Rewrite ex.spawn method.
----------------------------------------------------------------------------------
function exSpawn(command) 
    os.remove(OK_FILE)
    command = command .. ' > ' .. TMP_FILE .. ' 2>&1 & echo ok > ' .. OK_FILE
    local batFile = io.open(TMP_BAT, 'w')
    batFile:write(command)
    batFile:close()
    ex.spawn{"wscript.exe", "spawn.vbs", TMP_BAT}

    local okFile = io.open(OK_FILE, 'r') 
    while not okFile do os.sleep(0.1) okFile = io.open(OK_FILE, 'r') end
    okFile:close()
    os.remove(OK_FILE)
    return true
end

----------------------------------------------------------------------------------
--- Get the version of pms. 
----------------------------------------------------------------------------------
function getPmsVersion()
    local file = io.open(zentao.configFile, 'r')
    if not file then return '' end
    for line in file:lines() do
        if string.find(line, ">version") then 
            line = (string.sub(line, string.find(line, "=") + 1, string.find(line, ";") - 1))
            return string.gsub(line, "[%s*|'|\"]", '')
        end
    end
end
PMS_VERSION = getPmsVersion()
UPDATER_URL = string.format(UPDATER_URL, PMS_VERSION)

----------------------------------------------------------------------------------
-- Sub string between start string and end string.
----------------------------------------------------------------------------------
function subString(string, startStr, endStr, notInclude)
    local i, j = string.find(string, startStr)
    local x, y = string.find(string, endStr)
    if notInclude then 
        startStr = string.gsub(startStr, '%%', '')
        endStr   = string.gsub(endStr, '%%', '')
        return string.sub(string, i + #startStr, y - #endStr) 
    end

    return string.sub(string, i, y)
end

----------------------------------------------------------------------------------
-- Get and Set the language.  
----------------------------------------------------------------------------------
-- Get Language for LANG file.
function getLang()
    local langFile = io.open(LANG_FILE, 'r')
    if langFile == nil then return 'zh-cn' end
    if string.find(langFile:read('*a'), 'en') ~= nil then langFile:close() return 'en' end
    return 'zh-cn'
end

-- Set Language to LANG file.
function setLang(language)
    local langFile = io.open(LANG_FILE, 'w')
    if langFile then langFile:write(language) langFile:close() end
end

-- init lang value and load the lua language file
language = getLang()
dofile(language .. '.lua')

----------------------------------------------------------------------------------
-- Show the message dialog.
----------------------------------------------------------------------------------
function showPromptDialog(message, type, title)
    type  = type  or 'WARNING'
    title = title or lang.prompt.warning
    local warningDialog = iup.messagedlg{dialogtype = type, title = title, value = message}
    warningDialog:popup()
    warningDialog:destroy()
end

----------------------------------------------------------------------------------
-- Adjust the xampp is under the root directory.
----------------------------------------------------------------------------------
if not string.find(os.currentdir(), ':\\xampp') then showPromptDialog(lang.prompt.wrongPath) os.exit() end

----------------------------------------------------------------------------------
-- Check the my.ini of mysql insure the all the config path is absolute path.
----------------------------------------------------------------------------------

function checkMysqlConfig()
    if io.open(mysql.oldConfigFile, 'r') then exSpawn('copy ' .. mysql.oldConfigFile .. ' ' .. mysql.configFile) end
    local file = io.open(mysql.configFile, 'r')

    -- Change the directory of my.ini
    if not file then return end

    local output = ''
    for line in file:lines() do
        if string.find(line, ':/xampp') then
            s, e = string.find(line, ':/xampp')
            if s then 
                configDriveLetter = string.sub(line, s - 1, s - 1)
                if string.lower(configDriveLetter) ~= DRIVE_LETTER then
                    line = string.gsub(line, configDriveLetter .. ':/xampp', DRIVE_LETTER .. ':/xampp')
                end
            end
        elseif string.find(line, '/xampp') then
            line = string.gsub(line, '/xampp', DRIVE_LETTER .. ':/xampp')
        end

        output = output .. line .. '\n'
    end
    file:close()

    local file = io.open(mysql.configFile, 'w')
    file:write(output)
    file:close()
end
checkMysqlConfig()


----------------------------------------------------------------------------------
-- Copy the php.bat to %SYSTEM%\system32 path.
----------------------------------------------------------------------------------
function copyPhpBat()
    local phpBatContent = DRIVE_LETTER .. ':\\xampp\\php\\php.exe %*' 
    local phpBatFile = io.open(PHP_BAT, 'w')
    phpBatFile:write(phpBatContent)
    phpBatFile:close()

    exSpawn('copy ' .. PHP_BAT .. ' ' .. '%SYSTEMROOT%\\system32\\')
end
copyPhpBat()

----------------------------------------------------------------------------------
-- Adjust a process running or not.
----------------------------------------------------------------------------------
function processIsRunning(process)
    local processCount = 0
    exSpawn('tasklist')
    local file = io.open(TMP_FILE, 'r')
    if(file == nil) then return processCount end

    tasklist = file:read('*a')
    for s in string.gfind(tasklist, process) do processCount = processCount + 1 end

    return processCount
end

----------------------------------------------------------------------------------
-- If controlPanel is running, warning and exit
----------------------------------------------------------------------------------
if(processIsRunning('controlPanel') > 1) then
    showPromptDialog(lang.prompt.panelIsRunning)
    os.exit()
end

----------------------------------------------------------------------------------
-- Get and Set the config port.  
----------------------------------------------------------------------------------
function getConfigPort(serviceName)
    local configFile
    local matchString

    if(serviceName == 'apache') then 
        configFile  = apache.configFile
        matchString = 'Listen'
    end
    
    if(serviceName == 'mysql')  then 
        configFile  = mysql.configFile
        matchString = 'port'
    end

    local file = io.open(configFile, 'r')
    if(file == nil) then fileUnfindable(configFile) end

    for line in file:lines() do
        if(string.find(line, matchString) ~= nil) then 
            port = string.sub(line, string.find(line, '%d+')) 
            break
        end
    end
    file:close()

    return port and port or 0 
end

-- File can't be found.
function fileUnfindable(file)
    local dlg = iup.messagedlg{dialogType = 'WARNING', title = lang.prompt.warning, value = string.format(lang.prompt.fileUnfindable, file), 'OK'}
    dlg:popup()
    dlg:destroy()
    controlPanel.dialog.tray = "NO" 
    os.exit()
end

-- Set config port.
function setConfigPort(serviceName, port)
    local configFile
    local matchString

    if(serviceName == 'apache') then 
        configFile   = apache.configFile
        matchString1 = 'Listen'
        matchString2 = 'ServerName'
    end
    if(serviceName == 'mysql')  then 
        updateConfig(mysql.myConfig, port)
        updateConfig(mysql.phpmyadminConfig, port)
        configFile   = mysql.configFile
        matchString1 = 'port'
    end
    
    local file = io.open(configFile, 'r')
    if(file == nil) then return false end
    local output = ''
    for line in file:lines() do
        if(string.find(line, matchString1) ~= nil or (matchString2 ~= nil and string.find(line, matchString2) ~= nil)) then 
          line = string.gsub(line, string.sub(line, string.find(line, '%d+')), port) 
        end
        output = output .. line .. "\n"
    end
    file:close()
    
    local file = io.open(configFile, 'w')
    result = file:write(output)
    file:close()

    return result
end

function updateConfig(configFile, port)
    local file = io.open(configFile, 'r')
    if(file == nil) then return false end
    local output = ''
    for line in file:lines() do
        if(string.find(line, 'port') ~= nil) then 
          line = string.gsub(line, string.sub(line, string.find(line, '%d+')), port) 
        end
        output = output .. line .. "\n"
    end
    file:close()
    
    local file = io.open(configFile, 'w')
    result = file:write(output)
    file:close()

    return result
end

----------------------------------------------------------------------------------
-- Control panel dialog.
----------------------------------------------------------------------------------
controlPanel = {}
controlPanel.item = {}
table.foreach(lang.menu, function(i, name) 
    key = 'K_' .. subString(name, '%(', '%)', true)
    controlPanel.item[i] = iup.item{title = name, key = key} 
end)

function controlPanel.item.viewService:action()
    exSpawn("start /b services.msc")
end

-- Uninstall a service.
function uninstallService(serviceName)
    print(string.format(lang.prompt.tryToUninstallService, serviceName))
    if(getServiceStatus(serviceName) == 'running') then 
        print(string.format(lang.prompt.tryToStopServices, serviceName))
        exSpawn('net stop ' .. serviceName) 
        if(getServiceStatus(serviceName) == 'stopped') then 
            print(string.format(lang.prompt.stopServiceSuccessfully , serviceName))
        else
            print(string.format(lang.prompt.stopServiceFailed, serviceName))
        end
    end
    if(getServiceStatus(serviceName) == 'stopped') then 
        exSpawn('sc delete ' .. serviceName) 
        if(getServiceStatus(serviceName) == 'failed') then
            print(string.format(lang.prompt.uninstallSuccessfully, serviceName)) 
        end
    end

    return getServiceStatus(serviceName)
end

function controlPanel.item.uninstallService:action()
    apache.status = getServiceStatus(apache.serviceName)
    mysql.status  = getServiceStatus(mysql.serviceName)
    if apache.status == 'failed' then
        print(string.format(lang.prompt.serviceUnfindable, apache.serviceName))
    else
        apache.status = uninstallService(apache.serviceName) 
    end

    if mysql.status  == 'failed' then 
        print(string.format(lang.prompt.serviceUnfindable, mysql.serviceName), lang.prompt.newLine)
    else
        mysql.status = uninstallService(mysql.serviceName) 
    end

    controlPanel.setButtonStatus()
end

function controlPanel.item.database:action()
    if apache.status == 'running' and mysql.status == 'running' then
        exSpawn("start http://" .. HOST .. ':' .. apache.port .. '/phpmyadmin')
    else
        showPromptDialog(lang.prompt.stopSuccessfully)
    end
end

function controlPanel.item.backup:action()
    if mysql.status ~= 'running' then showPromptDialog(lang.prompt.mysqlNotRunning) end

    controlPanel.dialog.cursor = 'busy'

    print(lang.prompt.backuping)
    exSpawn(BACKUP_CMD)
    print(lang.title.backupSuccessfully)

    local destDir = string.upper(DRIVE_LETTER) .. ':\\xampp\\zentao\\backup\\' .. os.date("%Y%m")
    local backupDlg = iup.Alarm(lang.title.backupSuccessfully, string.format(lang.prompt.backupAlarm, destDir), lang.button.ok, lang.button.cancel)
    if backupDlg == 1 then exSpawn('explorer ' .. destDir) end

    controlPanel.dialog.cursor = 'arrow'
end

function httpRequest(API)
    local response = {}
    local headers  = {}
    headers['User-Agent']      = VERSION
    headers['Accept-Language'] = "zh-cn"

    http.request{url = API, headers = headers, method = "GET", sink = ltn12.sink.table(response)}
    return response
end

function controlPanel.item.checkVersion:action()
    local result = httpRequest(UPDATER_URL)
    if table.getn(result) == 0  or not pcall(json.decode, table.concat(result)) then showPromptDialog(string.format(lang.prompt.cannotGetUpdater, zentao.configFile)) return false end
    result = json.decode(table.concat(result))

    if result.status ~= 'success' then showPromptDialog(string.format(lang.prompt.cannotGetUpdater, zentao.configFile)) return end

    result.data = json.decode(result.data)
    if result.data.latestNote == '' then
        showPromptDialog(string.format(lang.prompt.isLatest), '', lang.prompt.common)
    else
        local note = encode.u82a(result.data.latestNote)
        local newVersionUrl = subString(note, 'http', 'html')
        note = string.gsub(note, '<[^>]*>', '')
        local buttonPress = iup.Alarm(lang.title.alarm, note, lang.button.getNewVersion, lang.button.cancel)
        if buttonPress == 1 then exSpawn('start ' .. newVersionUrl) end
    end
end

function controlPanel.item.zhcn:action()
    dofile('zh-cn.lua')
    language = 'zh-cn'
    changeButtonLang()
    setLang(language)
end

function controlPanel.item.en:action()
    dofile('en.lua')
    language = 'en'
    changeButtonLang()
    setLang(language)
end

-- Change button title.
function changeButtonLang()
    controlPanel.menu.service.title = lang.title.service
    controlPanel.menu.more.title    = lang.title.more
    controlPanel.menu.help.title    = lang.title.help
    controlPanel.item.exit.title    = lang.menu.exit

    controlPanel.item.viewService.title      = lang.menu.viewService
    controlPanel.item.uninstallService.title = lang.menu.uninstallService

    controlPanel.item.database.title         = lang.menu.database
    controlPanel.item.backup.title           = lang.menu.backup
    controlPanel.item.checkVersion.title     = lang.menu.checkVersion

    controlPanel.menu.lang.title             = lang.title.lang

    controlPanel.item.officialSite.title = lang.menu.officialSite
    controlPanel.item.officialHelp.title = lang.menu.officialHelp
    controlPanel.item.flowChart.title    = lang.menu.flowChart   
    controlPanel.item.faq.title          = lang.menu.faq         
    controlPanel.item.forum.title        = lang.menu.forum       
    
    controlPanel.dialog.title             = lang.title.controlPanel
    controlPanel.startButton.title        = lang.button.start
    controlPanel.accessButton.title       = lang.button.access
    controlPanel.stopButton.title         = lang.button.stop
    controlPanel.officialSiteButton.title = lang.button.officialSite
end

function controlPanel.item.officialSite:action()
    exSpawn('start http://www.zentao.net')
end

function controlPanel.item.officialHelp:action()
    if string.find(PMS_VERSION, 'pro') then 
        exSpawn('start http://www.zentao.net/help-book-zentaoprohelp.html')
    else
        exSpawn('start http://www.zentao.net/help-book-zentaopmshelp.html')
    end
end

function controlPanel.item.flowChart:action()
    exSpawn('start http://www.zentao.net/help-read-79236.html')
end

function controlPanel.item.faq:action()
    exSpawn('start http://www.zentao.net/ask-faq.html')
end

function controlPanel.item.forum:action()
    exSpawn('start http://www.zentao.net/forum')
end

function controlPanel.item.exit:action()
    controlPanel.dialog.tray = 'NO'
    return iup.CLOSE
end

controlPanel.menu = {}
controlPanel.menu.service = iup.submenu{iup.menu{controlPanel.item.viewService, controlPanel.item.uninstallService}; title = lang.title.service, key = 'K_S'}

controlPanel.menu.lang    = iup.submenu{iup.menu{controlPanel.item.zhcn, controlPanel.item.en}; title = lang.title.lang, key = 'K_L'}
controlPanel.menu.more    = iup.submenu{iup.menu{controlPanel.item.database, controlPanel.item.backup, controlPanel.item.checkVersion, iup.separator{}, controlPanel.menu.lang}; title = lang.title.more, key = 'K_M'}

controlPanel.menu.help    = iup.submenu{iup.menu{controlPanel.item.officialSite, controlPanel.item.officialHelp, iup.separator{}, controlPanel.item.flowChart, controlPanel.item.faq, controlPanel.item.forum}; title = lang.title.help, key = 'K_H'}

controlPanel.mainMenu     = iup.menu{controlPanel.menu.service, controlPanel.menu.more, controlPanel.menu.help, controlPanel.item.exit}

controlPanel.startButton        = iup.button{size = BUTTON_SIZE, title = lang.button.start}
controlPanel.accessButton       = iup.button{size = BUTTON_SIZE, title = lang.button.access}
controlPanel.stopButton         = iup.button{size = BUTTON_SIZE, title = lang.button.stop}
controlPanel.officialSiteButton = iup.button{size = BUTTON_SIZE, title = lang.button.officialSite}
controlPanel.output             = iup.text{expand="Yes", readonly="Yes", bgcolor="232 232 232", font = "tahoma, 9", appendnewline = "No", multiline = "Yes"}

controlPanel.trayImage  = iup.LoadImage("favicon.ico")

controlPanel.buttonBox = iup.hbox{
    controlPanel.startButton,
    iup.fill{},
    controlPanel.accessButton,
    iup.fill{},
    controlPanel.stopButton,
    iup.fill{},
    controlPanel.officialSiteButton,
}

controlPanel.box = iup.vbox{iup.fill{}, controlPanel.buttonBox, controlPanel.output, margin = '10x10'}

controlPanel.dialog = iup.dialog
{
    menu = controlPanel.mainMenu,
    controlPanel.box, 
    title = lang.title.controlPanel,
    tray = "YES", 
    traytip = lang.prompt.trayTip,
    trayimage = controlPanel.trayImage, 
    size='300x200',
    resize = 'NO',
    icon =controlPanel.trayImage
}

function controlPanel.dialog:close_cb()
    controlPanel.dialog.tray = "NO" 
end

function controlPanel.dialog:show_cb(state)
    if(state == iup.MINIMIZE) then controlPanel.dialog.hidetaskbar = "YES" end
end


function controlPanel.dialog:trayclick_cb(b, press)
    if b == 1 and press == 1 then controlPanel.dialog:show() end
    
    if b == 3 and press == 1 then 
        local rightMenu = iup.menu{iup.item {title = lang.title.exit, action = function() controlPanel.dialog.tray = "NO" controlPanel.dialog:hide() end}}
        rightMenu:popup(iup.MOUSEPOS, iup.MOUSEPOS)
    end
    return iup.DEFAULT
end

----------------------------------------------------------------------------------
-- Set start/stop button status.
----------------------------------------------------------------------------------
function controlPanel.setButtonStatus()
    if apache.status == 'running' and mysql.status == 'running' then
        controlPanel.startButton.title  = lang.button.running
        controlPanel.startButton.active = 'NO'

        controlPanel.accessButton.active = 'YES' 

        controlPanel.stopButton.title  = lang.button.stop
        controlPanel.stopButton.active = 'YES'
    end
    
    if apache.status == 'stopped' then controlPanel.accessButton.active = 'NO' end
    
    if(apache.status == 'stopped' and mysql.status == 'stopped') or (apache.status == 'failed' and mysql.status == 'failed') then
        controlPanel.startButton.title  = lang.button.start
        controlPanel.startButton.active = 'YES'
    
        controlPanel.accessButton.active = 'NO'
    
        controlPanel.stopButton.title  = lang.button.stopped
        controlPanel.stopButton.active = 'NO'
    end
end

----------------------------------------------------------------------------------
-- Rewrite print() for output text.
----------------------------------------------------------------------------------
function print(...)
    local arg = {...}
    local str
    for i,v in ipairs(arg) do
        if (i > 1) then str = str .. "\t" end
        if (str) then
            str = str .. tostring(v)
        else
            str = tostring(v)
        end
    end
--    str = os.date() .. ' ' .. str
    controlPanel.output.append = tostring(str) .. "\n"
end

----------------------------------------------------------------------------------
-- Init apache/mysql value.
----------------------------------------------------------------------------------
function controlPanel.initValues()
    apache.status      = getServiceStatus(apache.serviceName)
    apache.port        = getConfigPort('apache')
    apache.suggestPort = apache.port == 80 and 88 or 80

    mysql.status       = getServiceStatus(mysql.serviceName)
    mysql.port         = getConfigPort('mysql')
    mysql.suggestPort  = mysql.port == 3306 and 3308 or 3306
end

----------------------------------------------------------------------------------
-- The event of click startButton.
----------------------------------------------------------------------------------
function controlPanel.startButton:action()
    controlPanel.dialog.cursor = 'busy'
    print(lang.prompt.tryToStartServices)
    apache.port   = getConfigPort('apache')
    mysql.port    = getConfigPort('mysql')
    updateConfig(mysql.myConfig, mysql.port)
    apache.status = startService(apache.serviceName, apache.port)
    mysql.status  = startService(mysql.serviceName,  mysql.port)
    if apache.status ~= 'running' then apache.suggestPort = getSuggestPort(apache.port) end
    if mysql.status  ~= 'running' then mysql.suggestPort  = getSuggestPort(mysql.port)  end

    if apache.status ~= 'running' or mysql.status ~= 'running' then 
        configPort()
        controlPanel.setButtonStatus()
    else
        print(lang.prompt.startSuccessfully)
        controlPanel.setButtonStatus()
    end
    controlPanel.dialog.cursor = 'arrow'
    print(lang.prompt.newLine)
end

function getSuggestPort(currentPort)
    local suggestPort = currentPort + 1
    if suggestPort == MAX_PORT then return '' end
    if SOCKET.connect(HOST, suggestPort) == nil then return suggestPort end
    return getSuggestPort(suggestPort)
end

-- Start service.
function startService(serviceName, port)
    local serviceStatus = getServiceStatus(serviceName)
    if serviceStatus == 'running' then 
        print(string.format(lang.prompt.serviceIsRunning, serviceName, port)) 
    elseif serviceStatus == 'failed' then
        serviceStatus = installService(serviceName, port)
    elseif serviceStatus == 'stopped' then
        print(string.format(lang.prompt.serviceExists, serviceName), lang.prompt.tryToStart)
        exSpawn('net start ' .. serviceName)
        serviceStatus = getServiceStatus(serviceName)
        if(serviceStatus == 'running') then 
            print(string.format(lang.prompt.serviceIsRunning, serviceName, port)) 
        elseif(serviceStatus == 'stopped') then
            if(uninstallService(serviceName) == 'failed') then serviceStatus = installService(serviceName, port) end
        end
    elseif serviceStatus == 'unknown' then
        print(lang.prompt.unknownServiceStatus)
    end

    return serviceStatus
end

-- Get service status.
function getServiceStatus(serviceName)
    os.remove(TMP_FILE)
    exSpawn('sc query ' .. serviceName)
    local file = io.open(TMP_FILE, 'r')
    content = file:read('*a')
    file:close()

    if string.find(content, 'RUNNING') ~= nil then  
        return 'running' 
    elseif string.find(content, 'STOPPED') ~= nil then
        return 'stopped'
    elseif string.find(content, '1060') ~= nil then
        return 'failed'
    elseif string.find(content, 'PENDING') ~= nil then
        os.sleep(0.1)
        return getServiceStatus(serviceName)
    end

    return 'unknown'
end

-- Install service.
function installService(serviceName, port)
    local serviceStatus = getServiceStatus(serviceName)
    local process = ''
    local killProcess
    local installCommand

    if(serviceName == apache.serviceName) then 
        process        = 'httpd'
        killProcess    = "tskill " .. process
        installCommand = "..\\apache\\bin\\httpd -k install -n " .. apache.serviceName
    end

    if(serviceName == mysql.serviceName)  then 
        process        = 'mysqld'
        killProcess    = "tskill " .. process
        installCommand = "..\\mysql\\bin\\mysqld.exe --install " .. mysql.serviceName
    end
    
    if(processIsRunning(process) >= 1) then exSpawn(killProcess) end
    c = SOCKET.connect(HOST, port)
    if(c == nil) then 
        print(string.format(lang.prompt.tryToInstallService, serviceName))
        os.remove(TMP_FILE)
        exSpawn(installCommand)
        local installResult = getInstallResult()

        if installResult == 'installed' then 
            print(string.format(lang.prompt.installSuccessfully, serviceName))
            exSpawn('net start ' .. serviceName) 
            serviceStatus = getServiceStatus(serviceName)
            if(serviceStatus == 'running') then print(string.format(lang.prompt.serviceIsRunning, serviceName, port)) end 
        elseif installResult == 'withoutVC' and serviceName == apache.serviceName then
            installVC() 
        elseif not installResult then
            print(string.format(lang.prompt.installFailed, serviceName))
            serviceStatus = 'failed'
        end

    else
        print(string.format(lang.prompt.portIsConflict, serviceName, port), string.format(lang.prompt.installFailed, serviceName))
        serviceStatus = 'failed'
    end

    return serviceStatus
end

-- Adjust if need vc environment.
function getInstallResult()
    local file = io.open(TMP_FILE, 'r')
    if not file then return false end

    local content = file:read('*a')
    if string.find(content, 'sxstrace')  then file:close() return 'withoutVC' end
    if string.find(content, 'installed') then file:close() return 'installed' end

    return false
end

-- Install vc environment.
function installVC()
    local buttonPress = iup.Alarm(lang.prompt.common, lang.prompt.withoutVC, lang.prompt.install, lang.prompt.cancel)
    if buttonPress == 1 then exSpawn('start ' .. VC_REDIST) end
    controlPanel.dialog.tray = "NO" 
    os.exit()
end

------------------------------------
-- Config dialog.
------------------------------------
-- Init config dialog and show it.
function configPort()
    config = {}
    config.saveButton = iup.button{title = lang.button.save, size = BUTTON_SIZE}

    if apache.status ~= 'running' then
        config.apacheLabel     = iup.label{title = string.format(lang.prompt.portIsConflict, apache.serviceName, apache.port) .. lang.prompt.suggestPort, expand="Yes"} 
        config.apachePortInput = iup.text{value = apache.suggestPort, filter = 'number', spin = 'YES', spinmax = MAX_PORT, nc = 5}
        config.apacheBox       = iup.hbox{config.apacheLabel, config.apachePortInput} 
    end

    if mysql.status ~= 'running' then 
        config.mysqlLabel     = iup.label{title = string.format(lang.prompt.portIsConflict, mysql.serviceName, mysql.port) .. lang.prompt.suggestPort, expand="Yes"} 
        config.mysqlPortInput = iup.text{value = mysql.suggestPort, filter = 'number', spin = 'YES', spinmax = MAX_PORT, nc = 5}
        config.mysqlBox       = iup.hbox{config.mysqlLabel, config.mysqlPortInput} 
    end

    ------------------------------------
    -- When click save button.
    ------------------------------------
    function config.saveButton:action()
        config.dialog.cursor = 'busy'
        local apachePort
        local mysqlPort
   
        if config.apachePortInput ~= nil then
            apachePort = config.apachePortInput.value
            if(SOCKET.connect(HOST, apachePort) == nil) then 
               if(setConfigPort('apache', apachePort)) then 
                   uninstallService(apache.serviceName)
                   apache.status = startService(apache.serviceName, apachePort) 
               end
            end
        end
        
        if config.mysqlPortInput ~= nil then
            mysqlPort = config.mysqlPortInput.value
            if(SOCKET.connect(HOST, mysqlPort) == nil) then 
               if(setConfigPort('mysql', mysqlPort)) then 
                   uninstallService(mysql.serviceName)
                   mysql.status = startService(mysql.serviceName, mysqlPort) 
               end
            end
         end
        
        if apache.status ~= 'running' or mysql.status ~= 'running' then 
            configPort()
        else
            print(lang.prompt.startSuccessfully)
            config.dialog.visible = 'NO'
        end
    end
    
    config.dialog = iup.dialog
    {
        iup.vbox
        {
            config.apacheBox, 
            config.mysqlBox, 
            iup.hbox
            {
                iup.fill{},
                config.saveButton,
                iup.fill{}
            }
        },
        margin="10x10",
        gap="10",
        title = lang.title.configPort
    }   
    config.dialog:popup()
end

----------------------------------------------------------------------------------
-- When click access button.
----------------------------------------------------------------------------------
function controlPanel.accessButton:action()
    apache.port = getConfigPort('apache')
    exSpawn("start http://" .. HOST .. ':' .. apache.port)
end

----------------------------------------------------------------------------------
-- When click stop button.
----------------------------------------------------------------------------------
function controlPanel.stopButton:action()
    controlPanel.dialog.cursor = 'busy'
    print(lang.prompt.tryToStopServices)
    apache.status = stopService(apache.serviceName)
    mysql.status  = stopService(mysql.serviceName)
    if apache.status ~= 'running' and mysql.status ~= 'running' then print(lang.prompt.stopSuccessfully) end
    controlPanel.setButtonStatus()
    controlPanel.dialog.cursor = 'arrow'
    print(lang.prompt.newLine)
end

-- Stop a service.
function stopService(serviceName)
    local serviceStatus = getServiceStatus(serviceName)
    if serviceStatus == 'failed'  then print(string.format(lang.prompt.serviceUnfindable, serviceName)) return serviceStatus end
    if serviceStatus == 'stopped' then print(string.format(lang.prompt.serviceIsStopped, serviceName))  return serviceStatus end
    if serviceStatus == 'running' then 
        exSpawn("net stop " .. serviceName) 
        serviceStatus = getServiceStatus(serviceName)
        if serviceStatus == 'stopped' then print(string.format(lang.prompt.stopServiceSuccessfully, serviceName)) end
    end

    return serviceStatus
end

----------------------------------------------------------------------------------
-- When click officialSite button.
----------------------------------------------------------------------------------
function controlPanel.officialSiteButton:action()
    exSpawn('start http://www.zentao.net')
end

----------------------------------------------------------------------------------
-- Show control panel dialog.
----------------------------------------------------------------------------------
controlPanel.dialog:showxy(iup.RIGHT, iup.RIGHT)

print(lang.prompt.version)
print(string.format(lang.prompt.currentDir, os.currentdir()))
print(lang.prompt.newLine)
controlPanel.initValues()
controlPanel.setButtonStatus()

iup:MainLoop()
