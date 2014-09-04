unit zentaounit;

{$mode objfpc}{$H+}

interface

uses
    Classes,
    {$ifdef WINDOWS}
    Windows,
    {$endif}
    Forms,
    Dialogs,
    Process,
    jsonconf,
    regexpr,
    Sockets,
    fphttpclient,
    fpjson,
    jsonparser,
    langunit,
    inifileunit,
    SysUtils;

type
    OsEnvironment = record
        Exe      : string;
        Drive    : string;
        Location : string;
    end;

    PhpConfig = record
        Version    : string;
        Exe        : string;
        ConfigFile : string;
    end;

    ApacheConfig = record
        Version     : string;
        Exe         : string;
        ConfigFile  : string;
        ServiceName : string;
        Status      : string;
        Port        : integer;
        SuggestPort : integer;
    end;

    MysqlConfig = record
        Version           : string;
        Exe               : string;
        ConfigFile        : string;
        OldConfigFile     : string;
        MyConfig          : string;
        StoryConfig       : string;
        TaskConfig        : string;
        TestConfig        : string;
        ProConfig         : string;
        PhpmyadminConfig  : string;
        ServiceName       : string;
        Status            : string;
        Port              : integer;
        SuggestPort       : integer;
    end;

    PhpmyadminConfig = record
        Readme  : string;
        Version : string;
    end;

    ProductSystemConfig = record
        Version     : string;
        ConfigFile  : string;
        VersionFile : string;
        UpdaterUrl  : string;
        InitBat     : string;
        BinPath     : string;
        BackupFile  : string;
        ID          : string;
        Title       : string;
    end;

function GetVersion(soft: string; display: Boolean = False): string;
function ExcuteCommand(commands: string; waitOnExit: boolean = False; hideWindow: boolean = True): TStringList;
function ExcuteShell(commands: string; waitOnExit: boolean = False): TStringList;
procedure PrintLn(message: string = '');overload;
procedure PrintLn(Const message : String; const args : Array of const);overload;
procedure Print(message: string = '');overload;
procedure Print(Const message : String; const args : Array of const);overload;
procedure ConsoleLn(textOrName: string = ''; text: string = '`');
procedure Console(textOrName: string = ''; text: string = '`'; newLine: boolean = False);
procedure InitZentao();
function BackupZentao(): string;
function StartZentao(): boolean;
function StopZentao(): boolean;
function GetBuildVersion(formatStr: string = '%d.%d.%d'): string;
function LoadConfig(): boolean;
function SaveConfig(destroy: boolean = False): boolean;
procedure ExitZentao();
function FixPort(serviceName: string; forceChange: boolean = False): integer;
function CheckPort(port: integer): boolean;
function InstallService(serviceName: string): boolean;
function UninstallService(serviceName: string): boolean;overload;
function UninstallService(): boolean;overload;
function GetServiceStatus(serviceName: string): string;
function ProcessIsRunning(process: string): boolean;
function RestartService(serviceName: string; force: boolean = False; retry: boolean = False): boolean;
function StopService(serviceName: string; cleanup: boolean = False): boolean;
procedure KillProcess(process: string);
function BooleanStr(bool:boolean; trueText: string = 'true'; falseText: string = 'false'): string;
function GetConfigPort(serviceName: string): Integer;
function SetConfigPort(serviceName: string): boolean;
function UpdateConfigPort(serviceName: string; configFile: string): boolean;
function GetProductVersion(): string;
function CheckProductVersion(): string;
function HttpGet(url: string): string;
function GetLocalIP(): string;
function InitBat(): boolean;
function FixConfigPath(): boolean;
function CheckVC2008(): boolean;
procedure InstallVC2008();

const
    ONE_DAY_MILLION_SECONDS = 24 * 60 * 60 * 1000;
    ONE_DAY_SECONDS         = 24 * 60 * 60;
    CONFIG_USER_FILE        = 'config.user.json';
    CONFIG_FILE             = 'config.ini';
    DEBUG_MODE              = 0;
    READ_BYTES              = 2048;

    MAX_PORT          = 65535;
    HOST              = '127.0.0.1';
    VC_REDIST_2005    = 'vcredist_x86_sp1.exe';
    VC_REDIST_2008    = 'vcredist_x86.exe';
    VC_DETECTOR       = 'vc2008_detector.bat';
    VERSION           = '1.2';
    INIT_SUCCESSCODE  = '0';

var
    os         : OsEnvironment;
    php        : PhpConfig;
    apache     : ApacheConfig;
    mysql      : MysqlConfig;
    phpmyadmin : PhpmyadminConfig;
    product    : ProductSystemConfig;
    userConfig : TJSONConfig;
    isFirstRun : boolean;
    config     : TIniFile;

implementation

uses mainformunit;

function CheckVC2008(): boolean;
var
    outputLines : TStringList;
    i           : integer;
begin
    Result := False;
    outputLines := ExcuteCommand(VC_DETECTOR);
    for i := 0 to (outputLines.Count - 1) do
    begin
        if Pos('INSTALLED', outputLines[i]) > 0 then begin
            Result := True;
            BREAK;
        end;
    end;
end;

procedure InstallVC2008();
begin
    ExcuteCommand(VC_REDIST_2008, False, False);
end;

{ Fix config path }
function FixConfigPath(): boolean;
var
    fileLines   : TStringList;
    regex       : TRegExpr;
    i           : integer;
begin
    fileLines := TStringList.Create;
    regex := TRegExpr.Create;
    regex.Expression := '(\w*\s*=\s*"?\.?;?)(\w:)(\/xampp\/.*)';

    // fix mysql config path
    // backup config file
    // try
    //     ExcuteCommand('copy ' + mysql.OldConfigFile + ' ' + mysql.ConfigFile).Free;
    // finally
    // end;
    fileLines.LoadFromFile(mysql.ConfigFile);

    for i := 0 to (fileLines.Count - 1) do
    begin
        if regex.Exec(fileLines[i]) then begin
            fileLines[i] := regex.Match[1] + os.Drive + regex.Match[3];
        end;
    end;
    fileLines.SaveToFile(mysql.ConfigFile);

    // fix php config path
    fileLines.LoadFromFile(php.ConfigFile);
    for i := 0 to (fileLines.Count - 1) do
    begin
        if regex.Exec(fileLines[i]) then begin
            fileLines[i] := regex.Match[1] + os.Drive + regex.Match[3];
        end;
    end;
    fileLines.SaveToFile(php.ConfigFile);

    regex.Free;
    fileLines.Free;
end;

{ Get local IP address }
function GetLocalIP(): string;
var
    outputLines : TStringList;
    regex       : TRegExpr;
    i           : integer;
begin
    Result := HOST;
    outputLines := ExcuteCommand('ipconfig');
    if outputLines.Count > 0 then begin
        regex := TRegExpr.Create;
        regex.Expression := '.*: (\d+\.\d+\.\d+\.\d+)';
        for i := 0 to (outputLines.Count - 1) do
        begin
            if regex.Exec(outputLines[i]) then begin
                Result := regex.Match[1];
                BREAK;
            end;
        end;
        regex.Free;
    end;
    outputLines.Free;
    ConsoleLn('> GetLocalIP: ' + Result);
end;

{ Init bat srcipts }
function InitBat(): boolean;
var
    outputLines : TStringList;
    regex       : TRegExpr;
    i           : integer;
begin
    Result := False;
    if product.InitBat = '' then Exit;

    ExcuteCommand(product.InitBat + ' ' + php.Exe + ' http://' + GetLocalIP + ':' + IntToStr(apache.Port)).Free;
    outputLines := ExcuteShell('echo %ERRORLEVEL%');
    if outputLines.Count > 0 then begin
        if outputLines[0] = INIT_SUCCESSCODE then begin
            Result := True;
        end;
    end;
    ConsoleLn('> InitBat: ' + BooleanStr(Result));
end;

{ Check product version }
function CheckProductVersion(): string;
var
    response: string;
begin
    PrintLn(product.UpdaterUrl);
    response := HttpGet(product.UpdaterUrl);
    if response <> 'NULL' then begin
        
    end else begin
        Result := 'failed';
    end;
end;

{ Kill process }
procedure KillProcess(process: string);
begin
    // todo some error in windows 8.1
    ConsoleLn('KillProcess');
    ExcuteCommand('tskill ' + process, True);
end;

{ Judge a process is running or not }
function ProcessIsRunning(process: string): boolean;
var
    output  : TStringList;
    text    : string;
    i       : integer;
begin
    Result := False;
    ConsoleLn('ProcessIsRunning');
    output := ExcuteCommand('tasklist');
    process := LowerCase(process);
    for i := 0 to (output.Count - 1) do
    begin
        text := output[i];
        ConsoleLn(text);

        text := LowerCase(text);
        if Pos(process, text) > 0 then begin
            Result := True;
            BREAK;
        end;
    end;
    output.Free;
end;

{ Start service }
function RestartService(serviceName: string; force: boolean = False; retry: boolean = False): boolean;
var
    serviceStatus  : string;
    OutputLines    : TStringList;
    text           : string;
    port, i        : integer;
begin
    ConsoleLn('> RestartService', serviceName + ':' + BooleanStr(force, 'force ', ''));

    if serviceName = apache.ServiceName then begin
        port := apache.Port;
    end else port := mysql.Port;

    serviceStatus := GetServiceStatus(serviceName);
    if serviceStatus = 'running' then begin
        StopService(ServiceName);
        serviceStatus := GetServiceStatus(serviceName);
    end else if serviceStatus = 'failed' then begin
        // PrintLn('服务' + serviceName + '没有安装。');
        if force then begin
            InstallService(serviceName);
            serviceStatus := GetServiceStatus(serviceName);
        end;
    end;

    if serviceStatus = 'stopped' then begin
        if retry then begin
            PrintLn(GetLang('message/startingServiceAgain', '再次尝试启动服务：%s...'), [serviceName]);
        end else begin
            PrintLn(GetLang('message/startingService', '正在启动服务：%s...'), [serviceName]);
        end;
        port := FixPort(ServiceName, retry);
        ExcuteCommand('net start ' + serviceName).Free;
        Sleep(1000);
        
        serviceStatus := GetServiceStatus(serviceName);
        if serviceStatus = 'running' then begin
            PrintLn(GetLang('message/startedService', '成功启动服务，端口号为：%s'), [IntToStr(port)]);
        end else begin
            Print(GetLang('message/failed', '失败。'));
        end;
    end;

    Result := (serviceStatus = 'running');
    ConsoleLn('  RestartService Result: ' + BooleanStr(Result));
end;

{ Stop service }
function StopService(serviceName: string; cleanup: boolean = False): boolean;
var
    serviceStatus  : string;
begin
    ConsoleLn('> StopService', serviceName + ' ' + ' ' + BooleanStr(cleanup, 'cleanup ', ''));
    Result := True;
    PrintLn(GetLang('message/stoppingService', '正在停止服务：%s...'), [serviceName]);
    serviceStatus := GetServiceStatus(serviceName);
    if serviceStatus = 'failed' then begin
        Print(GetLang('message/serviceNotInstalled', '服务没有安装。'));
    end else if serviceStatus = 'stopped' then begin
        Print(GetLang('message/serviceStopped', '服务已停止。'));
    end else if serviceStatus = 'running' then begin
        ExcuteCommand('net stop ' + serviceName).Free;
        serviceStatus := GetServiceStatus(serviceName);
        if serviceStatus = 'stopped' then begin
            Print(GetLang('message/serviceStopped', '服务已停止。'));
        end else begin
            Result := False;
            PrintLn(GetLang('message/stopServiceFailed', '无法停止服务，当前状态为：%s...'), [serviceStatus]);
        end;
    end else begin
        Result := False;
        Print(GetLang('message/cannotGetServiceStatus', '无法获取服务状态。'));
    end;

    if cleanup and (serviceStatus = 'stopped') then begin
        UninstallService(serviceName);
    end;
    Console(BooleanStr(Result));
end;

{ Install service }
function InstallService(serviceName: string): boolean;
var
    process        : string;
    installCommand : string;
    installResult  : string;
    serviceStatus  : string;
    OutputLines    : TStringList;
    text           : string;
    i        : integer;
begin
    ConsoleLn('> InstallService', serviceName);

    if serviceName = apache.ServiceName then
    begin
        process        := 'httpd';
        installCommand := os.Drive + '\xampp\apache\bin\httpd.exe -k install -n ' + apache.serviceName;
    end
    else if serviceName = mysql.ServiceName then
    begin
        process        := 'mysqld';
        installCommand := os.Drive + '\xampp\mysql\bin\mysqld.exe --install ' + mysql.serviceName;
    end;

    PrintLn(GetLang('message/installingSerivce', '正在安装服务：%s...'), [serviceName]);

    // if ProcessIsRunning(process) then KillProcess(process);

    serviceStatus := GetServiceStatus(serviceName);
    if serviceStatus = 'failed' then begin
        Result := False;

        OutputLines := ExcuteCommand(installCommand);
        if OutputLines.Count > 0 then begin
            installResult := 'failed';
            for i := 0 to (OutputLines.Count - 1) do begin
                text := OutputLines[i];
                if Pos('sxstrace', text) > 0 then begin
                    installResult := 'withoutVC';
                    BREAK;
                end else if Pos('installed', text) > 0 then begin
                    installResult := 'installed';
                    BREAK;
                end;
            end;
        end else begin
            installResult := 'failed';
        end;
        OutputLines.Free;

        if installResult = 'failed' then begin
            serviceStatus := GetServiceStatus(serviceName);
            if serviceStatus <> 'failed' then installResult := 'installed';
        end;

        if installResult = 'failed' then begin
            Print(GetLang('message/installFailed', '安装失败。'));
        end else if installResult = 'installed' then begin
            Result := True;
            Print(GetLang('message/installSuccess', '成功安装服务。'));
        end else if (installResult = 'withoutVC') and (serviceName = apache.ServiceName) then begin
            Print(GetLang('message/needVC', '检测当前系统缺少VC运行环境，请先安装VC运行环境。'));
        end;
    end else begin
        print(GetLang('message/serviceExistTip', '服务已存在。如果需要重新安装，请先卸载。'));
    end;
    ConsoleLn('  InstallService Result: ' + BooleanStr(Result));
end;

{ Uninstall service }
function UninstallService(serviceName: string): boolean; overload;
var
    serviceStatus  : string;
begin
    // stop service
    StopService(serviceName);

    Result := False;
    PrintLn(GetLang('message/uninstallingService', '正在卸载服务：%s...'), [serviceName]);
    serviceStatus := GetServiceStatus(serviceStatus);
    if serviceStatus <> 'failed' then begin
        ExcuteCommand('sc delete ' + serviceName).Free;
        serviceStatus := GetServiceStatus(serviceStatus);
    end;
    if serviceStatus = 'failed' then begin
        Print(GetLang('message/uninstallSuccess', '成功卸载。'));
        Result := True;
    end else begin
        Print(GetLang('message/uninstallFailed', '无法卸载服务，请重试。'));
    end;
end;

function UninstallService(): boolean; overload;
begin
    Result := UninstallService(apache.ServiceName);
    if not Result then Result := UninstallService(apache.ServiceName);
    Result := UninstallService(mysql.ServiceName);
    if not Result then Result := UninstallService(mysql.ServiceName);
end;

{ Get service status }
function GetServiceStatus(serviceName: string): string;
var
    OutputLines    : TStringList;
    i              : integer;
    text           : string;
begin
    Result := 'unknown';
    OutputLines := ExcuteCommand('sc query ' + serviceName);
    if OutputLines.Count > 0 then begin
        for i := 0 to (OutputLines.Count - 1) do
        begin
            text := OutputLines[i];
            if Pos('RUNNING', text) > 0 then begin
                Result := 'running';
                BREAK;
            end else if Pos('STOPPED', text) > 0 then begin
                Result := 'stopped';
                BREAK;
            end else if Pos('1060', text) > 0 then begin
                Result := 'failed';
                BREAK;
            end else if Pos('PENDING', text) > 0 then begin
                Sleep(100);
                Result := GetServiceStatus(serviceName);
                Exit;
            end;
        end;
    end;
    OutputLines.Free;

    if serviceName = apache.ServiceName then begin
        apache.Status := Result;
    end else begin
        mysql.Status := Result;
    end;

    ConsoleLn('> GetServiceStatus:' + serviceName, Result);
end;

{ Check port avaliable }
function CheckPort(port: integer): boolean;
var
    sock    : Longint;
    address : TInetSockAddr;
    sIn,sOut : Text;
begin
    sock := fpSocket(AF_INET, SOCK_STREAM, 0);
    if sock < 0 then ConsoleLn('Client socket error!');
    address.sin_family := AF_INET;
    address.sin_port:= port shl 8;
    address.sin_addr.s_addr := ((1 shl 24) or 127);
    Result := (Not Connect(sock, address, sIn, sOut));
    ConsoleLn('> CheckPort:' + IntToStr(port), BooleanStr(Result));
end;

{ Fix port for apache and mysql}
function FixPort(serviceName: string; forceChange: boolean = False): integer;
var
    address: TInetSockAddr;
    sIn,sOut : Text;
    oldPort: Integer;
begin
    if serviceName = apache.ServiceName then begin
        // fix apache port
        if forceChange or (not CheckPort(apache.Port)) then
        begin
            oldPort := apache.Port;
            apache.Port := 80;
            if oldPort = 80 then apache.Port := apache.Port + 1;

            while (apache.Port = oldPort) or (not CheckPort(apache.Port)) do
            begin
                apache.Port := apache.Port + 1;
            end;

            userconfig.SetValue('apache/port', apache.port);

            Print(GetLang('message/portChanged', '已更换端口...'));
        end
        else
        begin
            // Print('apache端口号为：'+ IntToStr(apache.Port));
        end;
        Result := apache.Port;
        SetConfigPort(apache.ServiceName);
    end else begin
        // fix mysql port
        if forceChange or (not CheckPort(mysql.Port)) then
        begin
            oldPort := mysql.Port;
            mysql.Port := 3307;
            if oldPort = 3306 then mysql.Port := mysql.Port + 1;

            while (mysql.Port <> oldPort) and (mysql.Port < MAX_PORT) and (not CheckPort(mysql.Port)) do
            begin
                mysql.Port := mysql.Port + 1;
            end;

            userconfig.SetValue('mysql/port', mysql.port);

            Print(GetLang('message/portChanged', '已更换端口...'));
        end
        else
        begin
            // Print('mysql端口号为：'+ IntToStr(mysql.Port));
        end;
        Result := mysql.Port;
        SetConfigPort(mysql.ServiceName);
    end;
end;

{ Excute command with shell-cmd.exe }
function ExcuteShell(commands: string; waitOnExit: boolean = False): TStringList;
begin
    Result := ExcuteCommand('cmd.exe /c "' + commands + '"');
end;

{ Excute commond line and return output as string }
function ExcuteCommand(commands: string; waitOnExit: boolean = False; hideWindow: boolean = True): TStringList;
var
    MemStream: TMemoryStream;
    NumBytes: LongInt;
    BytesRead: LongInt;
begin
    
    ConsoleLn('> Excute Commands', commands + ' (wait? ' + BooleanStr(waitOnExit) + ')');
    with TProcess.Create(nil) do
    begin
        if hideWindow then ShowWindow := swoHIDE;
        CurrentDirectory := os.Location;
        Options := Options + [poUsePipes];
        if waitOnExit then Options := Options + [poWaitOnExit];
        CommandLine := commands;

        MemStream := TMemoryStream.Create;
        BytesRead := 0;
        Execute;
        while True do
        begin
          // make sure we have room
          MemStream.SetSize(BytesRead + READ_BYTES);
       
          // try reading it
          NumBytes := Output.Read((MemStream.Memory + BytesRead)^, READ_BYTES);
          if NumBytes > 0 // All read() calls will block, except the final one.
          then
          begin
            Inc(BytesRead, NumBytes);
          end
          else BREAK; // Program has finished execution.
        end;
        if BytesRead > 0 then ConsoleLn;
        MemStream.SetSize(BytesRead);

        Result := TStringList.Create;
        Result.LoadFromStream(MemStream);

        if DEBUG_MODE > 1 then begin
            for BytesRead := 0 to (Result.Count - 1) do
            begin
                ConsoleLn(' - ' + Result[BytesRead]);
            end;
        end;

        MemStream.Free;
        Free;
    end;
end;

{ Get software version and print it }
function GetVersion(soft: string; display: Boolean = False): string;
var
    command : string;
    i       : integer;
    text    : string;
    output  : TStringList;
begin
    Result := userconfig.GetValue(soft + '/version', '');
    if Result = '' then
    begin
        if soft = 'php' then
        begin
            command := php.Exe + ' --version';
        end
        else if soft = 'mysql' then
        begin
            command := mysql.Exe + ' --version';
        end
        else if soft = 'apache' then
        begin
            command := apache.Exe + ' -v';
        end;
        
        if soft = 'phpmyadmin' then
        begin
            output := TStringList.Create;
            output.LoadFromFile(phpmyadmin.Readme);
            for i := 0 to (output.Count - 1) do
            begin
                text := output[i];
                if (text <> '') and (Pos('version ', LowerCase(text)) = 1) then
                begin
                    Result := text;
                    break;
                end;
            end;
            output.Free;
        end
        else
        begin
            output := ExcuteCommand(command, True);
            Result := output[0];
            output.Free;
        end;

        userconfig.SetValue(soft + '/version', Result)
    end;

    if display then
    begin
        PrintLn(GetLang('message/version', '%s版本：%s'), [soft, Result]);
    end;
end;

{ Initialize all before ready }
procedure InitZentao();
begin
    isFirstRun := True;

    // os
    os.Exe                 := Application.ExeName;
    os.Location            := Application.Location;
    os.Drive               := Copy(os.Location, 0, 2);
    
    // php
    php.Exe                := os.Drive + '\xampp\php\php.exe';
    php.ConfigFile         := os.Drive + '\xampp\php\php.ini';
    php.Version            := GetVersion('php', True);

    // apache
    apache.Exe             := os.Drive + '\xampp\apache\bin\httpd.exe';
    apache.ConfigFile      := os.Drive + '\xampp\apache\conf\httpd.conf';
    apache.ServiceName     := 'apachezt';
    apache.Status          := GetServiceStatus(apache.ServiceName);
    apache.Port            := GetConfigPort(apache.ServiceName);
    apache.SuggestPort     := userconfig.GetValue('apache/suggestPort', 88);
    apache.Version         := GetVersion('apache', True);

    // mysql
    mysql.Exe              := os.Drive + '\xampp\mysql\bin\mysql.exe';
    mysql.OldConfigFile    := os.Drive + '\xampp\mysql\bin\my.ini';
    mysql.ConfigFile       := os.Drive + '\xampp\mysql\my.ini';
    mysql.MyConfig         := os.Drive + '\xampp\zentao\config\my.php';
    mysql.PhpmyadminConfig := os.Drive + '\xampp\phpmyadmin\config.inc.php';
    mysql.ServiceName      := 'mysqlzt';
    mysql.Status           := GetServiceStatus(mysql.ServiceName);
    mysql.Port             := GetConfigPort(mysql.ServiceName);
    mysql.SuggestPort      := userconfig.GetValue('mysql/suggestPort', 3308);
    mysql.Version          := GetVersion('mysql', True);

    // phpmyadmin
    phpmyadmin.Readme      := os.Drive + '\xampp\phpmyadmin\README';
    phpmyadmin.Version     := GetVersion('phpmyadmin', True);


    // product, like zentao or chanzhi
    product.ID             := config.Get('product/id', 'zentao');
    product.ConfigFile     := os.Drive + '\xampp\' + product.ID + '\' + config.Get('product/config', 'config\config.php');
    product.VersionFile    := os.Drive + '\xampp\' + product.ID + '\VERSION';
    product.Version        := GetProductVersion;
    product.BinPath        := os.Drive + '\xampp\' + product.ID + '\bin\';

    product.InitBat        := config.Get('product/initbat');
    if product.InitBat <> '' then begin
        product.InitBat := os.Drive + '\xampp\' + product.ID + '\' + product.InitBat;
    end;

    product.BackupFile     := config.Get('product/backfile');
    if product.BackupFile <> '' then begin
        product.BackupFile := os.Drive + '\xampp\' + product.ID + '\' + product.BackupFile;
    end;

    product.Title          := config.Get('product/title');

    FixConfigPath;

    PrintLn;
    PrintLn(GetLang('message/currentLocation', '当前目录：%s'), [os.Location]);
end;

function GetProductVersion(): string;
var
    fileLines: TStringList;
begin
    fileLines := TStringList.Create;
    fileLines.LoadFromFile(product.VersionFile);
    if fileLines.Count > 0 then begin
        Result := fileLines[0];
    end else begin
        Result := '';
    end;
    fileLines.Free;
end;

{ Get port from config file }
function GetConfigPort(serviceName: string): Integer;
var
    configFile: string;
    matchString: string;
    port: string;
    fileLines: TStringList;
    i: integer;
    regex: TRegExpr;
begin
    ConsoleLn('> GetConfigPort');
    if serviceName = apache.ServiceName then begin
        configFile := apache.configFile;
        Result := userconfig.GetValue('apache/port', 80);
    end else if serviceName = mysql.ServiceName then begin
        configFile := mysql.configFile;
        Result := userconfig.GetValue('mysql/port', 3306);
    end;

    fileLines := TStringList.Create;
    fileLines.LoadFromFile(configFile);

    port := '';
    if fileLines.Count > 0 then begin
        regex := TRegExpr.Create;
        regex.Expression := '(port|Listen)(\s+=?\s*)(\d{1,6})';

        for i := 0 to (fileLines.Count - 1) do
        begin
            if regex.Exec(fileLines[i]) then begin
                port := regex.Match[3];
                BREAK;
            end;
        end;

        regex.Free;
    end;
    fileLines.Free;

    if port <> '' then begin
        Console(' from configfile');
        Result := StrToInt(port);
    end;

    Console(' ' + IntToStr(Result));
end;

{ Set port to config file }
function SetConfigPort(serviceName: string): boolean;
begin
    ConsoleLn('> SetConfigPort', 'serviceName:' + serviceName);
    if serviceName = apache.ServiceName then begin
        Result := UpdateConfigPort(serviceName, apache.ConfigFile);
    end else begin
        UpdateConfigPort(mysql.ServiceName, mysql.myConfig);
        Result := UpdateConfigPort(mysql.ServiceName, mysql.phpmyadminConfig);
        if Result then begin
            Result := UpdateConfigPort(mysql.ServiceName, mysql.configFile);
        end;
    end;
end;

function UpdateConfigPort(serviceName: string; configFile: string): boolean;
var
    oldPort, port: string;
    fileLines: TStringList;
    i, position: integer;
    line, lastWord: string;
    regex: TRegExpr;
begin
    ConsoleLn('> UpdateConfigPort', 'serviceName: ' + ServiceName + ', configFile: ' + ConfigFile);
    if serviceName = apache.ServiceName then begin
        port := IntToStr(apache.Port)
    end else if serviceName = mysql.ServiceName then begin
        port := IntToStr(mysql.Port);
    end;

    Result := False;

    fileLines := TStringList.Create;
    try
        fileLines.LoadFromFile(configFile);

        if fileLines.Count > 0 then begin
            regex := TRegExpr.Create;
            regex.Expression := '(.*port|Listen)(''?\]?\s+=?\s*''?)(\d{1,6})(''?;?)';

            for i := 0 to (fileLines.Count - 1) do
            begin
                line := fileLines[i];
                if regex.Exec(line) then begin
                    lastWord := regex.Match[4];
                    ConsoleLn(' * ' + line + ' > ');
                    fileLines[i] := regex.Replace(line, '$1$2', True) + port + lastWord;
                    Console(fileLines[i]);
                    Result := True;
                end;
            end;
            fileLines.SaveToFile(configFile);
            regex.Free;
        end;
    except
        ConsoleLn('   Can not open file.');
    end;
    fileLines.Free;
end;

{ Stop }
function StopZentao(): boolean;
begin
    PrintLn;
    PrintLn(GetLang('message/stoping', '正在停止......'));
    Result := StopService(apache.ServiceName);
    if Result then Result := StopService(mysql.ServiceName);
end;

{ Start }
function StartZentao(): boolean;
begin
    PrintLn;
    PrintLn(GetLang('message/starting', '正在启动......'));

    Result := RestartService(apache.ServiceName, True);
    if not Result then Result := RestartService(apache.ServiceName, True, True);
    if Result then begin
        Result := RestartService(mysql.ServiceName, True);
        if not Result then Result := RestartService(mysql.ServiceName, True, True);
    end;
end;

function BackupZentao(): string;
begin
    if product.BackupFile = '' then Exit;

    PrintLn;
    PrintLn(GetLang('message/bakuping', '正在备份......'));
    ExcuteCommand(php.Exe + ' ' + product.BackupFile);
    Print(GetLang('message/bakupSuccess', '备份成功。'));

    Result := UpperCase(os.Drive) + '\xampp\' + product.ID + '\backup\' + Formatdatetime('yyyymm', Date);
end;

{ Print message on main form }
procedure Print(message: string = '');overload;
begin
    MainForm.DisplayMessage(message);
end;

procedure Print(Const message : String; const args : Array of const);overload;
begin
    Print(Format(message, args));
end;

{ Print message on main form }
procedure PrintLn(message: string = '');overload;
begin
    Print(LineEnding + message);
end;

procedure PrintLn(Const message : String; const args : Array of const);overload;
begin
    PrintLn(Format(message, args));
end;

{ Load config }
function LoadConfig(): boolean;
var
    lastLoginTime: TDateTime;
begin
    { Load system config }
    config := TIniFile.Create(CONFIG_FILE);

    Result := False;
    userconfig   := TJSONConfig.Create(nil);
    try
        userconfig.FileName := CONFIG_USER_FILE;

        lastLoginTime := userconfig.GetValue('/LastRunTime', 0);

        if lastLoginTime > 0 then
        begin
            isFirstRun := False;
            Result     := True;
        end;
    finally
    end;
end;

{ Load config }
function SaveConfig(destroy: boolean = False): boolean;
begin
    ConsoleLn('SaveConfig');
    Result := False;
    try
        userconfig.SetValue('/LastRunTime', Now);
        userconfig.SetValue('/language', language);
        userconfig.Flush;
        Result := True;
    finally
        if destroy then userconfig.Free;
    end;
end;

procedure ExitZentao();
begin
    SaveConfig(True);
    Config.Free;
end;

{ Display debug info into console window. }
procedure Console(textOrName: string = ''; text: string = '`'; newLine: boolean = False);
begin
    if DEBUG_MODE > 0 then
    begin
        {$ifdef WINDOWS}
        if not IsConsole then
        begin
            AllocConsole;
            IsConsole := True; // in System unit
            SysInitStdIO;      // in System unit
            WriteLn('=== Debug Console ===');
        end;
        {$endif}

        if text = '`' then
        begin
            text := textOrName;
        end
        else
        begin
            text := textOrName + ': ' + text;
        end;

        if newLine then text := LineEnding + text;

        write(text);
    end;
end;

procedure ConsoleLn(textOrName: string = ''; text: string = '`');
begin
    Console(textOrName, text, True);
end;

{ Get build version }
function GetBuildVersion(formatStr: string = '%d.%d.%d'): string;
begin
    if formatStr = '%s' then
    begin
        Result := 'Release';
    end
    else
    begin
        Result := Format(formatStr, [1, 2, 2, 0]);
    end;
end;

{ Convert boolean to string }
function BooleanStr(bool:boolean; trueText: string = 'true'; falseText: string = 'false'): string;
begin
    if bool then begin Result := trueText; end
    else Result := falseText;
end;

{ Get content with http client }
function HttpGet(url: string): string;
begin
    ConsoleLn('> HttpGet', url);
    Result := 'NULL';
    With TFPHttpClient.Create(Nil) do
    try
      Result := Get(url);
    finally
      Free;
    end;
    Console('-> ' + Result);
end;

end.

