require "imlua"
require "cdlua"
require "cdluaim"
require "iuplua"
require "iupluacd"
require "ex"
require "lfs"

function getLang()
    local langFile = io.open('LANG', 'r')
    if(langFile == nil) then return 'zh-cn' end
    if(string.find(langFile:read('*a'), 'en') ~= nil) then langFile:close() return 'en' end
    return 'zh-cn'
end

function setLang(lang)
    local langFile = io.open('LANG', 'w')
    if(langFile ~= nil) then langFile:write(lang) langFile:close() end
end

lang = getLang()
dofile(lang .. '.lua')

apache = {}
mysql  = {}
apache.configFile = "D:\\xampp\\apache\\conf\\httpd.conf" 
apache.status     = 'stopped'
apache.port       = 80

mysql.configFile  = "D:\\xampp\\mysql\\bin\\my.ini" 
mysql.status      = 'stopped'
mysql.port        = 80

-- Define the components of control panel
controlPanel = {}
controlPanel.langButton   = iup.label{title = lang == 'en' and '中文' or 'English'}
controlPanel.startButton  = iup.button{size = button.size, title = button.start}
controlPanel.accessButton = iup.button{size = button.size, title = button.access}
controlPanel.stopButton   = iup.button{size = button.size, title = button.stop}
controlPanel.moreButton   = iup.button{size = button.size, title = button.more}
controlPanel.exitButton   = iup.button{size = button.size, title = button.exit}
controlPanel.output       = iup.text{expand="Yes", readonly="Yes", bgcolor="232 232 232", font = "tahoma, 9", appendnewline = "No", multiline = "Yes"}

function controlPanel.langButton:button_cb(btn, press, x, y, stat)
  if(btn ~= 49 or press ~= 1) then return false end
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

function changeButtonLang(lang)
    controlPanel.dialog.title       = dialogTitle.controlPanel
    controlPanel.langButton.title    = lang == 'en' and '中文' or 'English'
    controlPanel.startButton.title  = button.start
    controlPanel.accessButton.title = button.access
    controlPanel.stopButton.title   = button.stop
    controlPanel.moreButton.title   = button.more
    controlPanel.exitButton.title   = button.exit
end

-- image = im.FileImageLoad("zentao.bmp")
-- controlPanel.canvas = iup.canvas{rastersize = image:Width().."x"..image:Height(), border = "NO"}
-- controlPanel.canvas.image = image
--
-- function controlPanel.canvas:map_cb()      
--   self.canvas = cd.CreateCanvas(cd.IUP, self)
-- end
--
-- function controlPanel.canvas:action()     
--   self.canvas:Activate()
--   self.canvas:Clear()
--   self.image:cdCanvasPutImageRect(self.canvas, 0, 0, 0, 0, 0, 0, 0, 0) -- use default values
-- end

-- Rewrite print for output
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

-- Start ZenTao
function controlPanel.startButton:action()
    print(prompt.tryToStartServices)
    apachePortConfict, apacheConfictPort = startService('apachezt', apache.port)
    mysqlPortConfict, mysqlConfictPort   = startService('mysqlzt',  mysql.port)

    if(apachePortConfict or mysqlPortConfict) then 
        configPort(apachePortConfict, apacheConfictPort, mysqlPortConfict, mysqlConfictPort)
    else
        print(prompt.startSuccessfully)
        controlPanel.setButtonStatus()
    end
end

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
    if(file == nil) then return '' end
    for line in file:lines() do
        if(string.find(line, matchString) ~= nil) then 
            port = string.sub(line, string.find(line, '%d+')) 
            break
        end
    end

    return port and port or '' 
end

function setConfigPort(serviceName, port)
    local configFile
    local matchString

    if(serviceName == 'apache') then 
        configFile   = apache.configFile
        matchString1 = 'Listen'
        matchString2 = 'ServerName'
    end
    if(serviceName == 'mysql')  then 
        configFile   = mysql.configFile
        matchString1 = 'port'
    end
    
    local file = io.open(configFile, 'r')
    if(file == nil) then return false end
    output = ''
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

function startService(serviceName, port)
    isConfict   = false
    confictPort = port

    serviceStatus = getServiceStatus(serviceName)
    if(serviceStatus == 'running') then 
        print(string.format(prompt.serviceIsRunning, serviceName, port)) 
    elseif(serviceStatus == 'failed') then
        isConfict = installService(serviceName, port)
    elseif(serviceStatus == 'stopped') then
        os.execute('sc start ' .. serviceName)
        print(string.format(prompt.serviceIsExist, serviceName), prompt.tryToStart)
        startStatus = getServiceStatus(serviceName)
        if(startStatus == 'running') then 
            print(string.format(prompt.serviceIsRunning, serviceName, port)) 
        elseif(startStatus == 'stopped') then
            isConfict = true
            local socket = require("socket")
            c = socket.connect('127.0.0.1', port)
            if(c == nil) then confictport = '' end
            print(string.format(prompt.portIsConfict, serviceName, confictPort), string.format(prompt.startFailed, serviceName)) 
        end
    elseif(serviceStatus == 'unknown') then
        print(prompt.unknownServiceStatus)
    end

    return isConfict, confictPort
end

function getServiceStatus(serviceName)
    os.execute('sc query ' .. serviceName .. ' > ' .. serviceName .. 'Status')
    f = io.open(serviceName .. 'Status', 'r')
    content = f:read('*a')
    f:close()

    if(string.find(content, 'RUNNING') ~= nil) then  
        return 'running' 
    elseif(string.find(content, 'STOPPED') ~= nil) then
        return 'stopped'
    elseif(string.find(content, 'FAILED') ~= nil) then
        return 'failed'
    elseif(string.find(content, 'PENDING') ~= nil) then
        return getServiceStatus(serviceName)
    end

    return 'unknown'
end

function installService(serviceName, port)
    isConfict = false
    local process = ''
    local killProcess
    local installService

    if(serviceName == 'apachezt') then 
        process        = 'httpd'
        killProcess    = "tskill " .. process
        installService = "d:\\xampp\\apache\\bin\\httpd -k install -n apachezt" 
    end

    if(serviceName == 'mysqlzt')  then 
        process        = 'mysqld'
        killProcess    = "tskill " .. process
        installService = "d:\\xampp\\mysql\\bin\\mysqld.exe --install mysqlzt"  
    end
    
    if(processIsRunning(process)) then os.execute(killProcess) end
    local socket = require("socket")
    c = socket.connect('127.0.0.1', port)
    if(c == nil) then 
        print(string.format(prompt.tryToInstallService, serviceName))
        status = os.execute(installService)
        if(status == 0) then 
            if(os.execute('sc start ' .. serviceName) == 0) then print(string.format(prompt.installSuccessfully, serviceName)) end
        else
            print(string.format(prompt.installFailed, serviceName))
            isConfict = true
        end
    else
        print(string.format(prompt.portIsConfict, serviceName, port), string.format(prompt.installFailed, serviceName))
        portConfict = true
    end

    return portConfict
end

function processIsRunning(process)
    os.execute('tasklist > tasklist')
    local file = io.open('tasklist', 'r')
    if(file == nil) then return false end

    tasklist = file:read('*a')
    if(string.find(tasklist, process)) then return true end
    return false
end

config = {}
config.apacheReadonly  = true
config.mysqlReadonly   = true
config.apacheLabel     = iup.label{title = label.apachePort, expand = "Yes"} 
config.mysqlLabel      = iup.label{title = label.mysqlPort,  expand = "Yes"} 
config.apacheNotice    = nil
config.mysqlNotice     = nil
config.apachePortInput = nil
config.mysqlPortInput  = nil
config.apacheBox       = nil 
config.mysqlBox        = nil 
config.saveButton      = iup.button{title = button.save}
 
function configPort(apachePortConfict, apachePort, mysqlPortConfict, mysqlPort)
    config.apacheReadonly  = not apachePortConfict 
    config.mysqlReadonly   = not mysqlPortConfict 
    config.apacheNotice    = iup.label{title = config.apacheReadonly and string.format(label.portIsNormal, apachePort) or string.format(label.portIsConfict, apachePort), expand="Yes"} 
    config.mysqlNotice     = iup.label{title = config.mysqlReadonly  and string.format(label.portIsNormal, mysqlPort)  or string.format(label.portIsConfict, mysqlPort), expand="Yes"} 
    config.apachePortInput = iup.text{value = apachePort, readonly=(config.apacheReadonly and "YES") or "NO", bgcolor = (config.apacheReadonly and "200 200 200") or "255 255 255"}
    config.mysqlPortInput  = iup.text{value = mysqlPort,  readonly=(config.mysqlReadonly and "YES") or "NO",  bgcolor = (config.mysqlReadonly and "200 200 200") or "255 255 255"}
    config.apacheBox       = iup.hbox{config.apacheLabel, config.apachePortInput, config.apacheNotice}
    config.mysqlBox        = iup.hbox{config.mysqlLabel,  config.mysqlPortInput, config.mysqlNotice}
    
    config.dialog = iup.dialog{iup.vbox{config.apacheBox, config.mysqlBox, config.saveButton}, margin="10x10", gap="10", alignment="ACENTER", title = dialogTitle.configPort}   
    config.dialog:popup()
    
  --if(config.mysqlReadonly == false)  then iup.SetFocus(config.mysqlPortInput) end
  --if(config.apacheReadonly == false) then iup.SetFocus(config.apachePortInput) end
     config.dialog:destroy()
end

function config.saveButton:action()
    local apachePortConfict = false
    local apacheConfictPort = nil
    local mysqlPortConfict  = false
    local mysqlConfictPort  = nil
    local apachePort = config.apachePortInput.value
    local mysqlPort  = config.mysqlPortInput.value
    if(config.apacheReadonly == false) then
        if(setConfigPort('apache', apachePort)) then 
            uninstallService('apachezt')
            apachePortConfict, apacheConfictPort = startService('apache', apachePort) 
        end
    end
   
    if(config.mysqlReadonly == false) then
        if(setConfigPort('mysql', mysqlPort)) then 
            uninstallService('mysqlzt')
            mysqlPortConfict, mysqlConfictPort = startService('mysql', mysqlPort) 
        end
    end
   
    if(apachePortConfict or mysqlPortConfict) then 
        configPort(apachePortConfict, apacheConfictPort, mysqlPortConfict, mysqlConfictPort)
    end
end

-- Access ZenTao
function controlPanel.accessButton:action()
    os.execute("start http://127.0.0.1:" .. apache.port)
end

-- Stop ZenTao
function controlPanel.stopButton:action()
    print(prompt.tryToStopServices)
    stopStatus1 = stopService('apachezt')
    stopStatus2 = stopService('mysqlzt')
    controlPanel.setButtonStatus()
end

function stopService(serviceName)
    if(getServiceStatus(serviceName) == 'failed')  then print(string.format(prompt.serviceUnfindable, serviceName)) return true end
    if(getServiceStatus(serviceName) == 'stopped') then print(string.format(prompt.serviceIsStopped, serviceName))  return true end
    if(getServiceStatus(serviceName) == 'running') then 
        os.execute("sc stop " .. serviceName) 
        if(getServiceStatus(serviceName) == 'stopped') then 
            print(string.format(prompt.stopServiceSuccessfully, serviceName))
            return true
        end
    end

    return false
end

function uninstallService(serviceName)
    if(getServiceStatus(serviceName) == 'running') then os.execute('sc stop ' .. serviceName) end
    if(getServiceStatus(serviceName) == 'stopped') then 
        os.execute('sc delete ' .. serviceName)
        if(getServiceStatus(serviceName) == 'failed') then return true end
    end
    if(getServiceStatus(serviceName) == 'failed') then return true end

    return false
end

-- More setting
function controlPanel.moreButton:action()
    result = os.execute("cmd.exe /C services.msc");
end

-- Exit ZenTao
function controlPanel.exitButton:action()
    return iup.CLOSE
end

function controlPanel.versionInfo()
    print(prompt.version)
    print(string.format(prompt.currentDir, os.currentdir()))
end

function controlPanel.initValues()
    apache.status = getServiceStatus('apachezt')
    apache.port   = getConfigPort('apache')

    mysql.status  = getServiceStatus('mysqlzt')
    mysql.port    = getConfigPort('mysql')
end

function controlPanel.setButtonStatus()
  if(apache.status == 'running' and mysql.status == 'running') then
      print(prompt.startSuccessfully)
      controlPanel.startButton.title  = button.running
      controlPanel.startButton.active = 'NO'

      controlPanel.stopButton.title  = button.stop
      controlPanel.stopButton.active = 'YES'
  end
 
  if(apache.status == 'stopped' and mysql.status == 'stopped') then
      controlPanel.startButton.title  = button.start
      controlPanel.startButton.active = 'YES'

      controlPanel.stopButton.title  = button.stopped
      controlPanel.stopButton.active = 'NO'
  end
end

-- controlPanel.headerBox = iup.hbox
-- {
--   controlPanel.langButton,
--   controlPanel.siteButton
-- }

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
controlPanel.box = iup.vbox{iup.fill{}, controlPanel.langButton, controlPanel.buttonBox, controlPanel.output, margin = '10x10'}

controlPanel.dialog = iup.dialog
{
    controlPanel.box, 
    title = dialogTitle.controlPanel,
    --tray = "YES", 
    --traytip = "ZenTao Control Panel",
    --trayimage = image, 
    size='300x200'
}
controlPanel.dialog:showxy(iup.RIGHT, iup.RIGHT)

controlPanel.versionInfo()
controlPanel.initValues()
controlPanel.setButtonStatus()

iup:MainLoop()

