require "imlua"
require "cdlua"
require "cdluaim"
require "iuplua"
require "iupluaim"
require "iupluacd"
require "ex"
require "lfs"

----------------------------------------------------------------------------------
-- Define const value.
----------------------------------------------------------------------------------
MOUSE_LEFT    = 49
MOUSE_PRESSED = 1
MAX_PORT      = 65535
HOST          = '127.0.0.1'
SOCKET        = require("socket")
VC_DOWNLINK   = 'http://www.microsoft.com/en-us/download/confirmation.aspx?id=29'
LABEL_SIZE    = '40x10'
BUTTON_SIZE   = "50x15"

----------------------------------------------------------------------------------
-- Init apache and mysql table.
----------------------------------------------------------------------------------
apache = {}
mysql  = {}
apache.configFile  = "..\\apache\\conf\\httpd.conf" 
apache.serviceName = 'apachezt'
apache.status      = 'stopped'
apache.port        = 80
apache.suggestPort = 88

mysql.configFile  = "..\\mysql\\my.ini" 
mysql.myConfig    = "..\\zentao\\config\\my.php"
mysql.serviceName = 'mysqlzt'
mysql.status      = 'stopped'
mysql.port        = 3306 
mysql.suggestPort = 3308 

----------------------------------------------------------------------------------
-- Get and Set the language.  
----------------------------------------------------------------------------------
-- Get Language for LANG file.
function getLang()
    local langFile = io.open('LANG', 'r')
    if(langFile == nil) then return 'zh-cn' end
    if(string.find(langFile:read('*a'), 'en') ~= nil) then langFile:close() return 'en' end
    return 'zh-cn'
end

-- Set Language to LANG file.
function setLang(lang)
    local langFile = io.open('LANG', 'w')
    if(langFile ~= nil) then langFile:write(lang) langFile:close() end
end

-- init lang value and load the lua language file
lang = getLang()
dofile(lang .. '.lua')

----------------------------------------------------------------------------------
-- Adjust a process running or not.
----------------------------------------------------------------------------------
function processIsRunning(process)
    local processCount = 0
    os.execute('tasklist > tasklist')
    local file = io.open('tasklist', 'r')
    if(file == nil) then return processCount end

    tasklist = file:read('*a')
    for s in string.gfind(tasklist, process) do processCount = processCount + 1 end

    return processCount
end

----------------------------------------------------------------------------------
-- If controlPanel is running, warning and exit
----------------------------------------------------------------------------------
if(processIsRunning('controlPanel') > 1) then
    local warningDialog = iup.messagedlg{dialogtype = "WARNING", title = prompt.warning, value = prompt.panelIsRunning}
    warningDialog:popup()
    warningDialog:destroy()
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

    return port and port or 0 
end

-- File can't be found.
function fileUnfindable(file)
    local dlg = iup.messagedlg{dialogType = 'WARNING', title = prompt.warning, value = string.format(prompt.fileUnfindable, file), 'OK'}
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
        if(not updateZentaoConfig(port)) then return false end
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

function updateZentaoConfig(port)
    local file = io.open(mysql.myConfig, 'r')
    if(file == nil) then return false end
    local output = ''
    for line in file:lines() do
        if(string.find(line, 'port') ~= nil) then 
          line = string.gsub(line, string.sub(line, string.find(line, '%d+')), port) 
        end
        output = output .. line .. "\n"
    end
    file:close()
    
    local file = io.open(mysql.myConfig, 'w')
    result = file:write(output)
    file:close()

    return result
end

----------------------------------------------------------------------------------
-- Control panel dialog.
----------------------------------------------------------------------------------
controlPanel = {}
controlPanel.langLabel    = iup.label{ size = LABEL_SIZE,  title = lang == 'en' and '中文' or 'English'}
controlPanel.siteLabel    = iup.label{ size = LABEL_SIZE,  title = label.site}
controlPanel.startButton  = iup.button{size = BUTTON_SIZE, title = button.start}
controlPanel.accessButton = iup.button{size = BUTTON_SIZE, title = button.access}
controlPanel.stopButton   = iup.button{size = BUTTON_SIZE, title = button.stop}
controlPanel.moreButton   = iup.button{size = BUTTON_SIZE, title = button.more}
controlPanel.exitButton   = iup.button{size = BUTTON_SIZE, title = button.exit}
controlPanel.output       = iup.text{expand="Yes", readonly="Yes", bgcolor="232 232 232", font = "tahoma, 9", appendnewline = "No", multiline = "Yes"}

controlPanel.trayImage  = iup.LoadImage("favicon.ico")
controlPanel.logo       = iup.label{image = iup.LoadImage("logo.png")}
controlPanel.headerBox = iup.hbox
{
    controlPanel.logo,
    iup.hbox
    {
        controlPanel.langLabel,
        controlPanel.siteLabel,
        EXPAND = 'NO',
        margin = '0x0',
        gap = 0
    },
    alignment = 'ALEFT',
    gap = 200
}

controlPanel.buttonBox = iup.frame
{
    iup.hbox
    {
        iup.fill{},
        controlPanel.startButton,
        controlPanel.accessButton,
        controlPanel.stopButton,
        controlPanel.moreButton,
        controlPanel.exitButton,
        gap="5"
    },
    title=''
}
controlPanel.box = iup.vbox{iup.fill{}, controlPanel.headerBox, controlPanel.buttonBox, controlPanel.output, margin = '10x10'}

controlPanel.dialog = iup.dialog
{
    controlPanel.box, 
    title = dialogTitle.controlPanel,
    tray = "YES", 
    traytip = prompt.trayTip,
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
        local rightMenu = iup.menu{iup.item {title = item.exit, action = function() controlPanel.dialog.tray = "NO" controlPanel.dialog:hide() end}}
        rightMenu:popup(iup.MOUSEPOS, iup.MOUSEPOS)
    end
    return iup.DEFAULT
end

----------------------------------------------------------------------------------
-- Set start/stop button status.
----------------------------------------------------------------------------------
function controlPanel.setButtonStatus()
  if(apache.status == 'running' and mysql.status == 'running') then
      controlPanel.startButton.title  = button.running
      controlPanel.startButton.active = 'NO'

      controlPanel.stopButton.title  = button.stop
      controlPanel.stopButton.active = 'YES'
  end

  if(apache.status == 'stopped') then 
      controlPanel.accessButton.active = 'NO' 
  else
      controlPanel.accessButton.active = 'YES' 
  end
 
  if(apache.status == 'stopped' and mysql.status == 'stopped') then
      controlPanel.startButton.title  = button.start
      controlPanel.startButton.active = 'YES'

      controlPanel.stopButton.title  = button.stopped
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
-- The event of click lang label.
----------------------------------------------------------------------------------
-- When click the lang label.
function controlPanel.langLabel:button_cb(btn, press)
    if(btn ~= MOUSE_LEFT or press ~= MOUSE_PRESSED) then return false end
    if(lang == 'en') then 
        dofile('zh-cn.lua') 
        lang = 'zh-cn'
        changeButtonLang(lang)
        setLang(lang)
    else
        dofile('en.lua')
        lang = 'en'
        changeButtonLang(lang)
        setLang(lang)
    end
end

-- Change button title.
function changeButtonLang(lang)
    controlPanel.dialog.title       = dialogTitle.controlPanel
    controlPanel.langLabel.title    = lang == 'en' and '中文' or 'English'
    controlPanel.siteLabel.title    = label.site
    controlPanel.startButton.title  = button.start
    controlPanel.accessButton.title = button.access
    controlPanel.stopButton.title   = button.stop
    controlPanel.moreButton.title   = button.more
    controlPanel.exitButton.title   = button.exit
end

----------------------------------------------------------------------------------
-- The event of click site label.
----------------------------------------------------------------------------------
function controlPanel.siteLabel:button_cb(btn, press)
    if(btn ~= MOUSE_LEFT or press ~= MOUSE_PRESSED) then return false end
    os.execute("start http://www.zentao.net")
end

----------------------------------------------------------------------------------
-- The event of click startButton.
----------------------------------------------------------------------------------
function controlPanel.startButton:action()
    controlPanel.dialog.cursor = 'busy'
    print(prompt.divider)
    print(prompt.tryToStartServices)
    print(prompt.newLine)
    apache.port   = getConfigPort('apache')
    mysql.port    = getConfigPort('mysql')
    updateZentaoConfig(mysql.port)
    apache.status = startService(apache.serviceName, apache.port)
    mysql.status  = startService(mysql.serviceName,  mysql.port)
    if(apache.status ~= 'running') then apache.suggestPort = getSuggestPort(apache.port) end
    if(mysql.status  ~= 'running') then mysql.suggestPort  = getSuggestPort(mysql.port)  end

    if(apache.status ~= 'running' or mysql.status ~= 'running') then 
        configPort()
    else
        print(prompt.newLine)
        print(prompt.startSuccessfully)
        controlPanel.setButtonStatus()
    end
    controlPanel.dialog.cursor = 'arrow'
end

function getSuggestPort(currentPort)
    local suggestPort = currentPort + 1
    if(suggestPort == MAX_PORT) then return '' end
    if(SOCKET.connect(HOST, suggestPort) == nil) then return suggestPort end
    return getSuggestPort(suggestPort)
end

-- Start service.
function startService(serviceName, port)
    local serviceStatus = getServiceStatus(serviceName)
    if(serviceStatus == 'running') then 
        print(string.format(prompt.serviceIsRunning, serviceName, port)) 
    elseif(serviceStatus == 'failed') then
        serviceStatus = installService(serviceName, port)
    elseif(serviceStatus == 'stopped') then
        print(string.format(prompt.serviceExists, serviceName), prompt.tryToStart)
        os.execute('net start ' .. serviceName)
        serviceStatus = getServiceStatus(serviceName)
        if(serviceStatus == 'running') then 
            print(string.format(prompt.serviceIsRunning, serviceName, port)) 
        elseif(serviceStatus == 'stopped') then
            if(uninstallService(serviceName) == 'failed') then serviceStatus = installService(serviceName, port) end
        end
    elseif(serviceStatus == 'unknown') then
        print(prompt.unknownServiceStatus)
    end

    return serviceStatus
end

-- Get service status.
function getServiceStatus(serviceName)
    os.execute('sc query ' .. serviceName .. ' > ' .. serviceName .. 'Status')
    f = io.open(serviceName .. 'Status', 'r')
    content = f:read('*a')
    f:close()

    if(string.find(content, 'RUNNING') ~= nil) then  
        return 'running' 
    elseif(string.find(content, 'STOPPED') ~= nil) then
        return 'stopped'
    elseif(string.find(content, '1060') ~= nil) then
        return 'failed'
    elseif(string.find(content, 'PENDING') ~= nil) then
        return getServiceStatus(serviceName)
    end

    return 'unknown'
end

-- Install service.
function installService(serviceName, port)
    print(prompt.newLine)
    local serviceStatus = getServiceStatus(serviceName)
    local process = ''
    local killProcess
    local installCommand

    if(serviceName == apache.serviceName) then 
        process        = 'httpd'
        killProcess    = "tskill " .. process
        installCommand = "..\\apache\\bin\\httpd -k install -n " .. apache.serviceName .. ' 2> installApache' 
    end

    if(serviceName == mysql.serviceName)  then 
        process        = 'mysqld'
        killProcess    = "tskill " .. process
        installCommand = "..\\mysql\\bin\\mysqld.exe --install "  .. mysql.serviceName  .. ' 2> installMysql'
    end
    
    if(processIsRunning(process) >= 1) then os.execute(killProcess) end
    c = SOCKET.connect(HOST, port)
    if(c == nil) then 
        print(string.format(prompt.tryToInstallService, serviceName))
        if(os.execute(installCommand ) == 0) then 
            print(string.format(prompt.installSuccessfully, serviceName))
            os.execute('net start ' .. serviceName) 
            serviceStatus = getServiceStatus(serviceName)
            if(serviceStatus == 'running') then print(string.format(prompt.serviceIsRunning, serviceName, port)) end 
        else
	    if(serviceName == apache.serviceName and isNeedVC()) then 
                installVC() 
            else
                print(string.format(prompt.installFailed, serviceName))
            end
            serviceStatus = 'failed'
        end
    else
        print(string.format(prompt.portIsConfict, serviceName, port), string.format(prompt.installFailed, serviceName))
        serviceStatus = 'failed'
    end

    return serviceStatus
end

-- Adjust if need vc environment.
function isNeedVC()
    local file = io.open('installApache', 'r')
    if(file == ni) then return false end
    if(string.find(file:read('*a'), 'sxstrace')) then return true end
    return false
end

-- Install vc environment.
function installVC()
    local buttonPress = iup.Alarm(prompt.common, prompt.withoutVC, prompt.down, prompt.cancel)
    if(buttonPress == 1) then os.execute('start ' .. VC_DOWNLINK) end
    controlPanel.dialog.tray = "NO" 
    os.exit()
end

------------------------------------
-- Config dialog.
------------------------------------
config = {}
config.apacheLabel     = nil
config.apachePortInput = nil
config.apacheBox       = nil 

config.mysqlLabel      = nil
config.mysqlPortInput  = nil
config.mysqlBox        = nil 
config.saveButton      = iup.button{title = button.save, size = BUTTON_SIZE}
 
-- Init config dialog and show it.
function configPort()
    if(apache.status ~= 'running') then
        config.apacheLabel     = iup.label{title = apache.serviceName .. string.format(label.portIsConflict, apache.port), expand="Yes"} 
        config.apachePortInput = iup.text{value = apache.suggestPort, filter = 'number', spin = 'YES', spinmax = MAX_PORT, nc = 5}
        config.apacheBox       = iup.hbox{config.apacheLabel, config.apachePortInput} 
    end

    if(mysql.status ~= 'running') then 
        config.mysqlLabel     = iup.label{title = mysql.serviceName .. string.format(label.portIsConflict, mysql.port), expand="Yes"} 
        config.mysqlPortInput = iup.text{value = mysql.suggestPort, filter = 'number', spin = 'YES', spinmax = MAX_PORT, nc = 5}
        config.mysqlBox       = iup.hbox{config.mysqlLabel, config.mysqlPortInput} 
    end
    
    config.dialog = iup.dialog
    {
        iup.vbox
        {
            config.apacheBox, 
            config.mysqlBox, 
            config.saveButton,
        },
        margin="10x10",
        gap="10",
        alignment="ACENTER",
        title = dialogTitle.configPort
    }   
    config.dialog:popup()
    
  --if(config.mysqlReadonly == false)  then iup.SetFocus(config.mysqlPortInput) end
  --if(config.apacheReadonly == false) then iup.SetFocus(config.apachePortInput) end
     config.dialog:destroy()
end

------------------------------------
-- When click save button.
------------------------------------
function config.saveButton:action()
    local apachePort
    local mysqlPort

    if(config.apachePortInput ~= nil) then
        apachePort = config.apachePortInput.value
        if(SOCKET.connect(HOST, apachePort) == nil) then 
           if(setConfigPort('apache', apachePort)) then 
               uninstallService(apache.serviceName)
               apache.status = startService(apache.serviceName, apachePort) 
           end
        end
    end
    
    if(config.mysqlPortInput ~= nil) then
        mysqlPort = config.mysqlPortInput.value
        if(SOCKET.connect(HOST, mysqlPort) == nil) then 
           if(setConfigPort('mysql', mysqlPort)) then 
               uninstallService(mysql.serviceName)
               mysql.status = startService(mysql.serviceName, mysqlPort) 
           end
        end
     end
    
    if(apache.status ~= 'running' or mysql.status ~= 'running') then 
        configPort()
    else
        print(prompt.startSuccessfully)
        controlPanel.setButtonStatus()
    end
end

----------------------------------------------------------------------------------
-- When click access button.
----------------------------------------------------------------------------------
function controlPanel.accessButton:action()
    apache.port = getConfigPort('apache')
    os.execute("start http://" .. HOST .. ':' .. apache.port)
end

----------------------------------------------------------------------------------
-- When click stop button.
----------------------------------------------------------------------------------
function controlPanel.stopButton:action()
    controlPanel.dialog.cursor = 'busy'
    print(prompt.divider)
    print(prompt.tryToStopServices)
    print(prompt.newLine)
    apache.status = stopService(apache.serviceName)
    mysql.status  = stopService(mysql.serviceName)
    if(apache.status ~= 'running' and mysql.status ~= 'running') then print(prompt.newLine) print(prompt.stopSuccessfully) end
    controlPanel.setButtonStatus()
    controlPanel.dialog.cursor = 'arrow'
end

-- Stop a service.
function stopService(serviceName)
    local serviceStatus = getServiceStatus(serviceName)
    if(serviceStatus == 'failed')  then print(string.format(prompt.serviceUnfindable, serviceName)) return serviceStatus end
    if(serviceStatus == 'stopped') then print(string.format(prompt.serviceIsStopped, serviceName))  return serviceStatus end
    if(serviceStatus == 'running') then 
        os.execute("net stop " .. serviceName) 
        serviceStatus = getServiceStatus(serviceName)
        if(serviceStatus == 'stopped') then print(string.format(prompt.stopServiceSuccessfully, serviceName)) end
    end

    return serviceStatus
end

-- Uninstall a service.
function uninstallService(serviceName)
    print(prompt.newLine)
    print(string.format(prompt.tryToUninstallService, serviceName))
    if(getServiceStatus(serviceName) == 'running') then 
        print(string.format(prompt.tryToStopService, serviceName))
        os.execute('net stop ' .. serviceName) 
        if(getServiceStatus(serviceName) == 'stopped') then 
            print(string.format(prompt.stopServiceSuccessfully, serviceName))
        else
            print(string.format(prompt.stopServiceFailed, serviceName))
        end
    end
    if(getServiceStatus(serviceName) == 'stopped') then 
        os.execute('sc delete ' .. serviceName) 
        if(getServiceStatus(serviceName) == 'failed') then
            print(string.format(prompt.uninstallSuccessfully, serviceName)) 
        end
    end
    return getServiceStatus(serviceName)
end

----------------------------------------------------------------------------------
-- When click more button.
----------------------------------------------------------------------------------
function controlPanel.moreButton:action()
    os.execute("start /b services.msc");
end

----------------------------------------------------------------------------------
-- When click exit button.
----------------------------------------------------------------------------------
function controlPanel.exitButton:action()
    controlPanel.dialog.tray = 'NO'
    return iup.CLOSE
end

----------------------------------------------------------------------------------
-- Show control panel dialog.
----------------------------------------------------------------------------------
controlPanel.dialog:showxy(iup.RIGHT, iup.RIGHT)

print(prompt.version)
print(string.format(prompt.currentDir, os.currentdir()))
controlPanel.initValues()
controlPanel.setButtonStatus()

iup:MainLoop()
