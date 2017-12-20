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
    StdCtrls,
    controls,
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
    TIntegerArray = Array of Integer;

    OsEnvironment = record
        Exe            : string;
        Drive          : string;
        Location       : string;
        ConfigFile     : string;
        UserConfigFile : string;
        IsInXAMPP      : boolean;
        RunnerLocation : string;
        Architecture   : string;
    end;

    PhpConfig = record
        Version       : string;
        Exe           : string;
        ConfigFile    : string;
        ConfigFileTpl : string;
        logPath       : string;
    end;

    ApacheConfig = record
        Version       : string;
        Exe           : string;
        htpasswd      : string;
        authFile      : string;
        ConfigFile    : string;
        ServiceName   : string;
        Status        : string;
        Port          : integer;
        // SuggestPort   : integer;
        ConfigFileTpl : string;
        AccessFileDir : string;
        AdminerPath   : String;
        htdocsPath    : String;
        logPath       : String;
    end;

    MysqlConfig = record
        Version           : string;
        Exe               : string;
        mysqlExe          : String;
        ConfigFile        : string;
        ConfigFileTpl     : string;
        // MyConfig          : string;
        StoryConfig       : string;
        TaskConfig        : string;
        TestConfig        : string;
        ProConfig         : string;
        ServiceName       : string;
        Status            : string;
        Port              : integer;
        logPath           : string;
        // SuggestPort       : integer;
    end;

    ProductSystemConfig = record
        Version        : string;
        ConfigFile     : string;
        MyConfig       : string;
        VersionFile    : string;
        UpdaterUrl     : string;
        InitBat        : string;
        BinPath        : string;
        Path           : String;
        ProPath        : String;
        BackupFile     : string;
        ID             : string;
        Title          : string;
        Pro            : string;
        ProVersion     : string;
        ProMyConfig    : string;
        ProConfigFile  : string;
        ProVersionFile : string;
        logPath        : string;
        proLogPath     : string;
    end;

    UserConfiguration = record
        LastRunTime    : TDateTime;
        ApachePort     : Integer;
        MysqlPort      : Integer;
        Language       : string;
        AutoChangePort : boolean;
        EnableApacheAuth: boolean;
        ApacheAuthAccount: string;
        ApacheAuthPassword: string;
        forceX86       : Boolean;
    end;

function GetVersion(soft: string; display: Boolean = False): string;
function ExcuteCommand(commands: string; waitOnExit: boolean = False; hideWindow: boolean = True): TStringList;
function CommondResultHas(outputlines: TStringList; theValue: string): boolean;
function ExcuteShell(commands: string; waitOnExit: boolean = False): TStringList;
procedure PrintLn(message: string = '');overload;
procedure PrintLn(Const message : String; const args : Array of const);overload;
procedure Print(message: string = '');overload;
procedure Print(Const message : String; const args : Array of const);overload;
procedure ConsoleLn(textOrName: string = ''; text: string = '`');
procedure Console(textOrName: string = ''; text: string = '`'; newLine: boolean = False);
function CheckApplicationPath(path: String): boolean;
procedure InitZentao();
function BackupZentao(): string;
function StartZentao(): boolean;
function StopZentao(): boolean;
function GetBuildVersion(formatStr: string = 'auto'): string;
function LoadConfig(): boolean;
function SaveConfig(destroy: boolean = False): boolean;
procedure ExitZentao();
function FixPort(serviceName: string; forceChange: boolean = False): integer;
function CheckPort(port: integer): boolean;
function InstallService(serviceName: string): boolean;
function UninstallService(serviceName: string): boolean;overload;
function UninstallService(): boolean;overload;
function GetServiceStatus(serviceName: string): string;
function checkSevicePath(serviceName: String): Boolean;
function ProcessIsRunning(process: string): boolean;
function RestartService(serviceName: string; force: boolean = False; retry: boolean = False): boolean;
function StopService(serviceName: string; cleanup: boolean = False): boolean;
procedure KillProcess(process: string);
function BooleanStr(bool:boolean; trueText: string = 'true'; falseText: string = 'false'): string;
function GetConfigPort(serviceName: string): Integer;
function SetConfigPort(serviceName: string): boolean;
function UpdateConfigPort(serviceName: string; configFile: string): boolean;
function GetProductVersion(versionFile: string = ''): string;
function CheckProductVersion(): string;
function HttpGet(url: string): string;
function GetLocalIP(): string;
function InitBat(): boolean;
function FixConfigPath(): boolean;
function FixConfigFile(src: string; dest: string): boolean;
function CheckVC(): boolean;
procedure InstallVC();
function StrReplace(source: string; find: string; forReplace: string): string;
function formatDir(source: string): string;
function GenRandomStr(len: integer): String;
function addApacheUser(account: String; password: String): Boolean;
procedure ResetAuthConfig();
function GetOsArch(): String;
function GetProductTitle(): String;
function GetProductLink(linkName: String; defaultLink: String): String;
function ChangeMySqlPassword(password: string): boolean;
function UpdateMySqlPassword(configFile: string; password: string): boolean;
function CheckMySqlPassword(): boolean;
function ConfirmMySqlPassword(): boolean;

const
    ONE_DAY_MILLION_SECONDS = 24 * 60 * 60 * 1000;
    ONE_DAY_SECONDS         = 24 * 60 * 60;
    CONFIG_USER_FILE        = 'config.user.json';
    CONFIG_FILE             = 'config.ini';
    APP_DIR                 = 'runner';
    DEBUG_MODE_DEFAULT      = 0;
    READ_BYTES              = 2048;

    FORCE_X86         = False;
    MAX_PORT          = 65535;
    HOST              = '127.0.0.1';
    VC_REDIST         = 'vc_redist.%s.exe';
    VC_DETECTOR       = 'vc_detector_%s.bat'; 
    OS_CHECK_BAT      = 'check_os.bat';
    VERSION_MAJOR     = 2;
    VERSION_MINOR     = 0;
    VERSION_PACTH     = 8;
    INIT_SUCCESSCODE  = '0';
    MYSQL_USER        = 'zentao';
    MYSQL_USER_ROOT   = 'root';
    CONFIG_DB_USER    = '$config->db->user';
    CONFIG_DB_PASS    = '$config->db->password';
    CONFIG_DB_PORT    = '$config->db->port';
    RANDOM_STR_SET    = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

var
    // debug_mode : integer;
    os             : OsEnvironment;
    php            : PhpConfig;
    apache         : ApacheConfig;
    mysql          : MysqlConfig;
    product        : ProductSystemConfig;
    productChanzhi : ProductSystemConfig;
    productRanzhi  : ProductSystemConfig;
    productZentao  : ProductSystemConfig;
    userConfig     : UserConfiguration;
    isFirstRun     : boolean;
    config         : TIniFile;
    userConfigFile : TJSONConfig;
    debugMode      : integer;

implementation

uses mainformunit;


function GenRandomStr(len: integer): String;
var
    i: integer;
begin
    Result := '';
    For i := 0 to len do
    begin
        Result := Result + RANDOM_STR_SET[Random(Length(RANDOM_STR_SET))];
    end;
end;

function CheckVC(): boolean;
var
    outputLines : TStringList;
    i           : integer;
begin
    Result := False;
    outputLines := ExcuteCommand(os.RunnerLocation + format(VC_DETECTOR, [os.Architecture]));
    for i := 0 to (outputLines.Count - 1) do
    begin
        if Pos('INSTALLED', outputLines[i]) > 0 then begin
            Result := True;
            BREAK;
        end;
    end;
end;

function GetOsArch(): String;
var
    outputLines : TStringList;
    i           : integer;
begin
    Result := 'x86';
    if (not userConfig.forceX86) and (VERSION_MAJOR > 1) then begin
        outputLines := ExcuteShell(os.RunnerLocation + OS_CHECK_BAT);
        for i := 0 to (outputLines.Count - 1) do
        begin
            if Pos('64', outputLines[i]) > 0 then begin
                Result := 'x64';
                BREAK;
            end;
        end;
    end;
end;

function GetProductTitle(): String;
begin
    Result := config.Get('product/title_' + userconfig.Language, GetLang('product/' + product.id, product.Title));
end;

function GetProductLink(linkName: String; defaultLink: String): String;
var
    linkUrl: String;
begin
    linkUrl := config.Get('product/' + linkName + '_' + userconfig.Language, '');
    if linkUrl = '' then begin
        linkUrl := config.Get('product/' + linkName, defaultLink);
    end;
    Result := linkUrl;
end;

function CommondResultHas(outputlines: TStringList; theValue: string): boolean;
var
    i : integer;
begin
    Result := False;
    for i := 0 to (outputlines.Count - 1) do
    begin
        if Pos(theValue, outputlines[i]) > 0 then begin
            Result := True;
            BREAK;
        end;
    end;
end;

procedure InstallVC();
begin
    ExcuteCommand(os.RunnerLocation + format(VC_REDIST, [os.Architecture]), False, False);
end;

function addApacheUser(account: String; password: String): Boolean;
var
    emptyLines: TStringList;
begin
    emptyLines := TStringList.Create;
    emptyLines.SaveToFile(apache.authFile);
    emptyLines.Free;
    ExcuteCommand(apache.htpasswd + ' -b ' + apache.authFile + ' ' + account + ' ' + password);
end;

procedure resetAuthConfig();
var
    emptyLines: TStringList;
begin
    emptyLines := TStringList.Create;
    emptyLines.SaveToFile(apache.authFile);
    emptyLines.Free;

    if userconfig.EnableApacheAuth then begin
        ExcuteCommand(apache.htpasswd + ' -b ' + apache.authFile + ' ' + userconfig.ApacheAuthAccount + ' ' + userconfig.ApacheAuthPassword);
    end;

    FixConfigFile(apache.AccessFileDir + 'adminer.ztaccess', apache.AdminerPath + '.ztaccess');
    FixConfigFile(apache.AccessFileDir + 'htdocs.ztaccess', apache.htdocsPath + '.ztaccess');

    if product.id = 'all' then begin
        FixConfigFile(apache.AccessFileDir + productZentao.id + '.ztaccess', productZentao.path + 'www/.ztaccess');
        FixConfigFile(apache.AccessFileDir + productRanzhi.id + '.ztaccess', productRanzhi.path + 'www/.ztaccess');
        FixConfigFile(apache.AccessFileDir + productChanzhi.id + '.ztaccess', productChanzhi.path + 'www/.ztaccess');
    end else begin
        FixConfigFile(apache.AccessFileDir + 'default.ztaccess', product.path + 'www/.ztaccess');
        if product.ProPath <> '' then begin
            FixConfigFile(apache.AccessFileDir + 'pro.ztaccess', product.ProPath + 'www/.ztaccess');
        end;
    end;

    MainForm.updateAuthStatus;
end;

{ Generage config file from template }
function FixConfigFile(src: string; dest: string): boolean;
var
    fileLines   : TStringList;
    i           : integer;
    line        : string;
    osLocation  : string;
    authConfig  : String;
begin
    src  := formatDir(src);
    dest := formatDir(dest);
    ConsoleLn(LineEnding + '> FixConfigFile');
    ConsoleLn('    src: ' + src);
    ConsoleLn('    dest:' + dest);

    authConfig := 'Require all granted';
    if userconfig.EnableApacheAuth then begin
        authConfig := 'AuthName "' + product.id + ' runner authentication required"'
            + LineEnding + 'AuthType Basic'
            + LineEnding + 'AuthUserFile "' + formatDir(apache.authFile) + '"'
            + LineEnding + 'Require valid-user';
    end;

    osLocation := formatDir(os.Location);
    fileLines := TStringList.Create;
    fileLines.LoadFromFile(src);
    for i := 0 to (fileLines.Count - 1) do
    begin
        line := StrReplace(fileLines[i], '%APP_LOCATION%', osLocation);
        line := StrReplace(line, '%APACHE_PORT%', inttostr(apache.Port));
        line := StrReplace(line, '%MYSQL_PORT%', inttostr(mysql.Port));
        line := StrReplace(line, '%PRODUCT_ID%', product.id);
        line := StrReplace(line, '%AUTH_CONFIG%', authConfig);
        fileLines[i] := line;
    end;
    fileLines.SaveToFile(dest);
    fileLines.Free;
    ConsoleLn('    saved! |<');
    Result := true;
end;

{ Fix config path }
function FixConfigPath(): boolean;
begin
    FixConfigFile(mysql.ConfigFileTpl, mysql.ConfigFile);
    FixConfigFile(php.ConfigFileTpl, php.ConfigFile);
    FixConfigFile(apache.ConfigFileTpl, apache.ConfigFile);

    if product.id = 'all' then begin
        UpdateConfigPort(mysql.ServiceName, productRanzhi.MyConfig);
        UpdateConfigPort(mysql.ServiceName, productZentao.MyConfig);
        UpdateConfigPort(mysql.ServiceName, productChanzhi.MyConfig);
    end else begin
        UpdateConfigPort(mysql.ServiceName, product.MyConfig);
        if product.pro <> '' then begin
            UpdateConfigPort(mysql.ServiceName, product.ProMyConfig);
        end;
    end;

    Result := true;
end;

function CheckApplicationPath(path: String): boolean;
var
    regex: TRegExpr;
begin
    regex := TRegExpr.Create;
    regex.Expression := '^[a-zA-Z\d_\\\/:]*$';
    Result := regex.Exec(path);
    regex.Free;
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

    ExcuteCommand(product.InitBat + ' ' + php.Exe + ' http://' + GetLocalIP + ':' + IntToStr(apache.Port) + '/' + product.id + '/').Free;
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
        Sleep(3000);
        serviceStatus := GetServiceStatus(serviceName);
    end else if serviceStatus = 'failed' then begin
        // PrintLn('服务' + serviceName + '没有安装。');
        if force then begin
            InstallService(serviceName);
            Sleep(3000);
            serviceStatus := GetServiceStatus(serviceName);
        end;
    end;

    if not checkSevicePath(ServiceName) then begin
        PrintLn(GetLang('message/wrongService', '服务安装路径不正确。'));
        if mrYes = MessageDlg(GetLang('message/wrongServiceTip', '服务安装路径不正确。是否重新安装？'), mtConfirmation, [mbYes, mbNo], 0) then begin
            UninstallService(serviceName);
            Sleep(3000);
            InstallService(serviceName);
            Sleep(3000);
            serviceStatus := GetServiceStatus(serviceName);
        end else begin
            Result := false;
            Exit;
        end;
    end;

    if serviceStatus = 'stopped' then begin
        if retry then begin
            PrintLn(GetLang('message/startingServiceAgain', '再次尝试启动服务：%s(P%s)...'), [serviceName, port]);
        end else begin
            PrintLn(GetLang('message/startingService', '正在启动服务：%s(P%s)...'), [serviceName, port]);
        end;
        port := FixPort(ServiceName, retry);
        ExcuteCommand('net start ' + serviceName).Free;
        Sleep(3000);
        
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
        installCommand := os.Location + 'apache\bin\httpd.exe -k install -n ' + apache.serviceName;
    end
    else if serviceName = mysql.ServiceName then
    begin
        process        := 'mysqld';
        installCommand := os.Location + 'mysql\bin\mysqld.exe --install ' + mysql.serviceName + ' --defaults-file="' + mysql.configfile + '"';
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

{ Check service path }
function checkSevicePath(serviceName: String): Boolean;
var
    OutputLines    : TStringList;
    i              : integer;
    text           : string;
begin
    Result := True;
    ConsoleLn('> checkSevicePath:' + serviceName);
    OutputLines := ExcuteCommand('sc qc ' + serviceName);
    if OutputLines.Count > 0 then begin
        for i := 0 to (OutputLines.Count - 1) do
        begin
            text := OutputLines[i];
            if Pos('BINARY_PATH_NAME', text) > 0 then begin
                if ServiceName = apache.ServiceName then begin
                    Result := Pos(apache.exe, text) > 0;
                    ConsoleLn('apache result: ' + BooleanStr(Result) + ', apache: ' + apache.exe)
                end else if ServiceName = mysql.ServiceName then begin
                    Result := Pos(mysql.exe, text) > 0;
                    ConsoleLn('mysql result: ' + BooleanStr(Result) + ', mysql: ' + mysql.exe)
                end;
                Break;
            end;
        end;
    end;
    ConsoleLn(' - Result: ' + BooleanStr(Result));
    OutputLines.Free;
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
        Result := apache.Port;
        // fix apache port
        if userconfig.AutoChangePort and (forceChange or (not CheckPort(apache.Port))) then
        begin
            oldPort := apache.Port;
            apache.Port := 80;
            if oldPort = 80 then apache.Port := apache.Port + 1;

            while (apache.Port = oldPort) or (not CheckPort(apache.Port)) do
            begin
                apache.Port := apache.Port + 1;
            end;

            userconfig.ApachePort := apache.Port;

            Print(GetLang('message/portChanged', '更换端口...'));
        end
        else
        begin
            Print(GetLang('ui/port', '端口') + ':' + IntToStr(apache.Port) + '...');
        end;
        if Result <> apache.Port then begin
            Result := apache.Port;
            SetConfigPort(apache.serviceName);
        end;
    end else begin
        Result := mysql.Port;
        // fix mysql port
        if userconfig.AutoChangePort and (forceChange or (not CheckPort(mysql.Port))) then
        begin
            oldPort := mysql.Port;
            mysql.Port := 3307;
            if oldPort = 3306 then mysql.Port := mysql.Port + 1;

            while (mysql.Port <> oldPort) and (mysql.Port < MAX_PORT) and (not CheckPort(mysql.Port)) do
            begin
                mysql.Port := mysql.Port + 1;
            end;

            userconfig.MysqlPort := mysql.Port;

            Print(GetLang('message/portChanged', '已更换端口...'));
        end
        else
        begin
            Print(GetLang('ui/port', '端口') + ':' + IntToStr(mysql.Port) + '...');
        end;
        if Result <> mysql.Port then begin
            Result := mysql.Port;
            SetConfigPort(mysql.serviceName);
        end;
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
            if NumBytes > 0 then begin // All read() calls will block, except the final one.
                Inc(BytesRead, NumBytes);
            end
            else BREAK; // Program has finished execution.
        end;

        while True do
        begin
            // make sure we have room
            MemStream.SetSize(BytesRead + READ_BYTES);
            // try reading it
            NumBytes := Stderr.Read((MemStream.Memory + BytesRead)^, READ_BYTES);
            if NumBytes > 0 then begin // All read() calls will block, except the final one.
                Inc(BytesRead, NumBytes);
            end
            else BREAK; // Program has finished execution.
        end;

        if BytesRead > 0 then ConsoleLn;
        MemStream.SetSize(BytesRead);

        Result := TStringList.Create;
        Result.LoadFromStream(MemStream); 

        if debugMode > 1 then begin
            ConsoleLn('   Exit code: ' + inttostr(ExitStatus));
            ConsoleLn('   Output length: ' + inttostr(Result.Count));
            if Result.Count > 0 then begin
                for BytesRead := 0 to (Result.Count - 1) do
                begin
                    ConsoleLn(' - ' + Result[BytesRead]);
                end;
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
    
    output := ExcuteCommand(command, True);
    Result := output[0];
    output.Free;

    if display then
    begin
        PrintLn(GetLang('message/version', '%s版本：%s'), [soft, Result]);
    end;
end;

{ Initialize all before ready }
procedure InitZentao();
begin
    isFirstRun := True;
    
    // php
    php.Exe                := os.Location + 'php\php.exe';
    php.ConfigFile         := os.Location + 'php\php.ini';
    php.ConfigFileTpl      := os.RunnerLocation + config.Get('php/configfile', 'res\php\php.ini');
    php.logPath            := os.Location + 'php\logs\';

    // apache
    apache.Exe             := os.Location + 'apache\bin\httpd.exe';
    apache.ConfigFile      := os.Location + 'apache\conf\httpd.conf';
    apache.ConfigFileTpl   := os.RunnerLocation + config.Get('apache/configfile', 'res\apache\conf\httpd.conf');
    apache.ServiceName     := 'apachezt';
    apache.Status          := GetServiceStatus(apache.ServiceName);
    apache.Port            := userconfig.ApachePort;
    apache.htpasswd        := os.Location + 'apache\bin\htpasswd.exe';
    apache.authFile        := os.Location + 'apache\auth\.htaccess';
    // apache.SuggestPort     := GetConfigPort(apache.ServiceName);
    apache.AccessFileDir   := os.RunnerLocation + config.Get('apache/AccessFileDir', 'res\ztaccess\');
    apache.AdminerPath     := os.Location + 'adminer\';
    apache.htdocsPath      := os.Location + 'htdocs\';
    apache.logPath         := os.Location + 'apache\logs\';

    // mysql
    mysql.Exe              := os.Location + 'mysql\bin\mysqld.exe';
    mysql.mysqlExe         := os.Location + 'mysql\bin\mysql.exe';
    mysql.ConfigFile       := os.Location + 'mysql\my.ini';
    mysql.ConfigFileTpl    := os.RunnerLocation + config.Get('mysql/configfile', 'res\mysql\my.ini');
    
    mysql.ServiceName      := 'mysqlzt';
    mysql.Status           := GetServiceStatus(mysql.ServiceName);
    mysql.Port             := userconfig.MysqlPort;
    mysql.logPath          := os.Location + 'mysql\';

    // product, like zentao or chanzhi
    product.ID             := config.Get('product/id', 'zentao');
    product.Title          := config.Get('product/title');

    if product.ID <> 'all' then begin
        product.VersionFile    := os.Location + product.ID + '\VERSION';
        product.Version        := GetProductVersion;
        product.path           := os.Location + product.ID + '\';
        product.BinPath        := os.Location + product.ID + '\bin\';
        product.logPath        := os.Location + product.ID + '\tmp\log\';
        product.Pro            := config.Get('product/proversion', '');
        product.ProPath        := '';
        if product.Pro <> '' then begin
            product.ProPath := os.Location + product.Pro + '\';
        end;
        product.MyConfig       := os.Location + product.ID + '\' + config.Get('product/myconfig', 'config\my.php');
        if product.Pro <> '' then begin
            product.ProVersionFile    := os.Location + product.Pro + '\VERSION';
            product.ProMyConfig       := os.Location + product.Pro + '\' + config.Get('product/myconfig', 'config\my.php');
            product.ProVersion        := GetProductVersion(product.ProVersionFile);
            product.proLogPath        := os.Location + product.Pro + '\tmp\log\';
        end;
    end else begin
        product.myconfig := config.Get('product/myconfig', 'config\my.php');

        productChanzhi.id             := 'chanzhi';
        productChanzhi.Title          := config.Get('product/' + productChanzhi.id + 'Title');
        productChanzhi.VersionFile    := os.Location + productChanzhi.ID + '\VERSION';
        productChanzhi.Version        := GetProductVersion(productChanzhi.VersionFile);
        productChanzhi.MyConfig       := os.Location + productChanzhi.ID + '\system\' + product.myconfig;
        productChanzhi.path           := os.Location + productChanzhi.ID + '\';
        productChanzhi.BinPath        := os.Location + productChanzhi.ID + '\bin\';
        productChanzhi.logPath        := os.Location + productChanzhi.ID + '\tmp\log\';

        productZentao.id             := 'zentao';
        productZentao.Title          := config.Get('product/' + productZentao.id + 'Title');
        productZentao.VersionFile    := os.Location + productZentao.ID + '\VERSION';
        productZentao.Version        := GetProductVersion(productZentao.VersionFile);
        productZentao.MyConfig       := os.Location + productZentao.ID + '\' + product.myconfig;
        productZentao.path           := os.Location + productZentao.ID + '\';
        productZentao.BinPath        := os.Location + productZentao.ID + '\bin\';
        productZentao.logPath        := os.Location + productZentao.ID + '\tmp\log\';

        productRanzhi.id             := 'ranzhi';
        productRanzhi.Title          := config.Get('product/' + productRanzhi.id + 'Title');
        productRanzhi.VersionFile    := os.Location + productRanzhi.ID + '\VERSION';
        productRanzhi.Version        := GetProductVersion(productRanzhi.VersionFile);
        productRanzhi.MyConfig       := os.Location + productRanzhi.ID + '\' + product.myconfig;
        productRanzhi.path           := os.Location + productRanzhi.ID + '\';
        productRanzhi.BinPath        := os.Location + productRanzhi.ID + '\bin\';
        productRanzhi.logPath        := os.Location + productRanzhi.ID + '\tmp\log\';
    end;

    product.InitBat        := config.Get('product/initbat');
    if product.InitBat <> '' then begin
        product.InitBat := os.Location + product.ID + '\' + product.InitBat;
    end;

    product.BackupFile     := config.Get('product/backfile');
    if product.BackupFile <> '' then begin
        product.BackupFile := os.Location + product.ID + '\' + product.BackupFile;
    end;

    FixConfigPath;

    php.Version            := GetVersion('php', True);
    apache.Version         := GetVersion('apache', True);
    mysql.Version          := GetVersion('mysql', True);

    if product.ID = 'all' then begin
        PrintLn(GetLang('message/version', '%s版本：%s'), [productZentao.Title, productZentao.Version]);
        PrintLn(GetLang('message/version', '%s版本：%s'), [productRanzhi.Title, productRanzhi.Version]);
        PrintLn(GetLang('message/version', '%s版本：%s'), [productChanzhi.Title, productChanzhi.Version]);
    end else begin
        PrintLn(GetLang('message/version', '%s版本：%s'), [GetProductTitle(), product.Version]);
    end;


    if userConfig.ApacheAuthAccount = '' then begin
        userConfig.ApacheAuthAccount := product.ID;
    end;

    if userConfig.ApacheAuthPassword = '' then begin
        userConfig.ApacheAuthPassword := GenRandomStr(10);
        SaveConfig();
    end;

    resetAuthConfig();

    PrintLn;
    PrintLn(GetLang('message/currentLocation', '当前目录：%s'), [os.Location]);
end;

function GetProductVersion(versionFile: string = ''): string;
var
    fileLines: TStringList;
begin
    fileLines := TStringList.Create;
    if versionFile = '' then versionFile := product.VersionFile;
    fileLines.LoadFromFile(versionFile);
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
        Result := userconfig.ApachePort;
    end else if serviceName = mysql.ServiceName then begin
        configFile := mysql.configFile;
        Result := userconfig.MysqlPort;
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
        FixConfigFile(apache.ConfigFileTpl, apache.ConfigFile); 
    end else begin
        FixConfigFile(php.ConfigFileTpl, php.ConfigFile); 
        FixConfigFile(mysql.ConfigFileTpl, mysql.ConfigFile);

        if product.id = 'all' then begin
            UpdateConfigPort(serviceName, productZentao.MyConfig);
            UpdateConfigPort(serviceName, productChanzhi.MyConfig);
            UpdateConfigPort(serviceName, productRanzhi.MyConfig);
        end else begin
            UpdateConfigPort(serviceName, product.MyConfig);
            if product.pro <> '' then begin
                UpdateConfigPort(serviceName, product.ProMyConfig);
            end;
        end;
    end;
end;

function GetMySqlPassword(): string;
var 
    fileLines: TStringList;
    i, position: integer;
    line: string;
    regex: TRegExpr;
begin
    Result := '';

    fileLines := TStringList.Create;
    try
        if product.id = 'all' then begin
            fileLines.LoadFromFile(productZentao.MyConfig);
        end else begin
            fileLines.LoadFromFile(product.MyConfig);
        end;
        
        if fileLines.Count > 0 then begin
            regex := TRegExpr.Create;
            regex.Expression := '\' + CONFIG_DB_PASS + '\s*=\s*[''"](\w*)[''"];';
            for i := 0 to (fileLines.Count - 1) do
            begin
                line := fileLines[i];
                if regex.Exec(line) then begin
                    Result := regex.Match[1];
                    ConsoleLn('> GetMySqlPassword', 'password:' + Result);
                    BREAK;
                end;
            end;
            regex.Free;
        end;
    except
        ConsoleLn('   Can not open file.');
    end;
    fileLines.Free;
end;

function CheckMySqlPassword(): boolean;
var
    oldPassword: string;
    isBadPassword: boolean;
    userString  : string;
begin
    oldPassword := GetMySqlPassword;
    isBadPassword := (oldPassword = '') or (oldPassword = '123456');
    Result := False;
    userString := GenRandomStr(10);

    if isBadPassword and InputQuery(GetLang('message/changeMySqlPassword', '更改数据库密码'), GetLang('message/changeMySqlPasswordTip', '当前数据库密码太弱，继续使用旧的密码存在安全风险，建议立即修改密码为:'), userString) then begin
        Result := ChangeMySqlPassword(userString);
    end;
end;

function ConfirmMySqlPassword(): boolean;
var
    userString  : string;
begin
    userString := GetMySqlPassword;
    Result := False;
    if InputQuery(GetLang('message/changeMySqlPassword', '更改数据库密码'), GetLang('message/confirmMySqlPasswordTip', '请输入新密码:'), userString) then begin
        Result := ChangeMySqlPassword(userString);
    end;
end;

function ChangeMySqlPassword(password: string): boolean;
var
    oldPassword: String;
    cmdOutput  : TStringList;
begin
    Result := False;
    if (GetServiceStatus(mysql.serviceName) = 'running') then begin
        oldPassword := GetMySqlPassword;
        ConsoleLn('> ChangeMySqlPassword', 'password:' + password + ', oldPassword: ' + oldPassword);
        if oldPassword = password then begin
            ConsoleLn('  Change mySql password faild, because new password is the same as old password.');
        end else begin
            ExcuteCommand(mysql.mysqlExe 
                + ' --user=' + MYSQL_USER_ROOT 
                + ' --password=' + oldPassword 
                + ' --port=' + IntToStr(mysql.port) 
                + ' -e "UPDATE mysql.user SET password=PASSWORD(''' + password + ''')'
                + ' WHERE user=''' + MYSQL_USER_ROOT + ''';"', true);
            ExcuteCommand(mysql.mysqlExe 
                + ' --user=' + MYSQL_USER_ROOT 
                + ' --password=' + oldPassword 
                + ' --port=' + IntToStr(mysql.port) 
                + ' -e "UPDATE mysql.user SET password=PASSWORD(''' + password + ''')'
                + ' WHERE user=''' + MYSQL_USER + ''';"', true);
            ExcuteCommand(mysql.mysqlExe 
                + ' --user=' + MYSQL_USER_ROOT 
                + ' --password=' + oldPassword 
                + ' --port=' + IntToStr(mysql.port) 
                + ' -e "flush privileges;"', true);
            cmdOutput := ExcuteCommand(mysql.mysqlExe 
                + ' --user=' + MYSQL_USER_ROOT 
                + ' --password=' + password 
                + ' --port=' + IntToStr(mysql.port) 
                + ' -e "flush privileges;"', true);
            if (cmdOutput.count > 0) and (pos('error', LowerCase(cmdOutput[0])) > 0) then begin
                ConsoleLn('  Change MySql Password fail');
                ShowMessage(GetLang('message/changeMySqlPasswordFail', '更改数据库密码失败。') + cmdOutput[0]);
            end else begin
                if product.id = 'all' then begin
                    UpdateMySqlPassword(productZentao.MyConfig, password);
                    UpdateMySqlPassword(productRanzhi.MyConfig, password);
                    UpdateMySqlPassword(productChanzhi.MyConfig, password);
                end else begin
                    UpdateMySqlPassword(product.MyConfig, password);
                    if product.pro <> '' then begin
                        UpdateMySqlPassword(product.ProMyConfig, password);
                    end;
                end;
                Result := True;
            end;
        end;
    end else begin
        ConsoleLn('> ChangeMySqlPassword fail, mysql is stop. ', 'password:' + password + ', oldPassword: ' + oldPassword);
        ShowMessage(GetLang('message/changeMySqlPasswordFailBeforeRunMysql', '更改数据库密码失败，MySql 服务器没有运行，请先启动服务再试。'));
    end;
end;

function UpdateMySqlPassword(configFile: string; password: string): boolean;
var 
    fileLines: TStringList;
    i, position: integer;
    line: string;
begin
    ConsoleLn('> UpdateMySqlPassword', 'password:' + password + ', configFile: ' + ConfigFile);
    Result := False;

    fileLines := TStringList.Create;
    try
        fileLines.LoadFromFile(configFile);
        if fileLines.Count > 0 then begin
            for i := 0 to (fileLines.Count - 1) do
            begin
                line := fileLines[i];
                if Pos(CONFIG_DB_PASS, line) > 0 then begin
                    fileLines[i] := CONFIG_DB_PASS + '    = ''' + password + ''';';
                    Result := True;
                    BREAK;
                end;
            end;
            fileLines.SaveToFile(configFile);
        end;
    except
        ConsoleLn('   Can not open file.');
    end;
    fileLines.Free;
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
                if Pos(CONFIG_DB_PORT, line) > 0 then begin
                    fileLines[i] := CONFIG_DB_PORT + '        = ''' + port + ''';';
                    Result := True;
                    BREAK;
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

    FixConfigPath;
    PrintLn(GetLang('message/applyServerConfig', '已应用服务器配置。'));

    Result := RestartService(apache.ServiceName, True);
    if not Result then Result := RestartService(apache.ServiceName, True, True);
    if Result then begin
        Result := RestartService(mysql.ServiceName, True);
        if not Result then Result := RestartService(mysql.ServiceName, True, True);
    end;
    if Result then begin
        PrintLn(Format(GetLang('message/isRunning', '%s正在运行，点击“访问”按钮来使用。'), [GetProductTitle()]));
        PrintLn(Format(GetLang('message/viewInBrowserDirectly', '你也可以直接在浏览器访问：%s'), ['http://' + HOST + ':' + IntToStr(apache.port) + '/' + config.Get('product/main', '')]));
        CheckMySqlPassword;
    end else begin
        PrintLn(GetLang('message/failedAndTry', '启动失败，请稍后重试。'));
    end;
end;

function BackupZentao(): string;
var
    outputLines : TStringList;
    sqlSuccess  : boolean;
    fileSuccess : boolean;
    i           : integer;
begin
    if product.BackupFile = '' then Exit;

    Result := '';
    PrintLn;
    PrintLn(GetLang('message/bakuping', '正在备份......'));
    outputLines := ExcuteCommand(php.Exe + ' "' + product.BackupFile + '"');
    sqlSuccess := CommondResultHas(outputLines, 'Backuping database, successfully saved');
    fileSuccess := CommondResultHas(outputLines, 'Backuping files, successfully saved');

    if sqlSuccess then begin
        Print('Database ' + GetLang('message/bakupSuccess', '备份成功。') + '  ');
    end;
    if fileSuccess then begin
        Print('Files ' + GetLang('message/bakupSuccess', '备份成功。') + '  ');
    end;
    
    if fileSuccess or sqlSuccess then begin
        Result := os.Location + product.ID + '\backup\' + Formatdatetime('yyyymm', Date);
    end;
    
    if not fileSuccess or not sqlSuccess then begin
        PrintLn('Backup failed. Message: ');
        for i := 0 to (outputLines.Count - 1) do
        begin
            PrintLn('- ' + outputLines[i]);
        end;
    end;
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
    LastRunTime: TDateTime;
begin
    // This way we generate a new sequence every time the program is run
    Randomize;

    // os
    os.Exe                                 := Application.ExeName;
    os.Location                            := Application.Location;
    os.RunnerLocation                      := os.Location + APP_DIR + '/';
    os.Architecture                        := GetOsArch;
    // os.Drive                               := Copy(os.Location, 0, 2);//F:\xampp\runner\
    // os.IsInXAMPP                           := (os.Location = (os.Drive + '\xampp\'));

    os.ConfigFile                          := os.RunnerLocation + CONFIG_FILE;
    os.UserConfigFile                      := os.RunnerLocation + CONFIG_USER_FILE;

    { Load system config }
    config := TIniFile.Create(os.ConfigFile);
    debugMode := StrToInt(config.Get('debug/mode', IntToStr(DEBUG_MODE_DEFAULT)));

    Result := False;
    userConfigFile   := TJSONConfig.Create(nil);
    try
        userConfigFile.FileName := os.UserConfigFile;

        userconfig.LastRunTime        := userConfigFile.GetValue('/LastRunTime', 0);
        userconfig.ApachePort         := userConfigFile.GetValue('apache/port', 80);
        userconfig.MysqlPort          := userConfigFile.GetValue('mysql/port', 3306);
        userconfig.Language           := userConfigFile.GetValue('/language', config.Get('common/defaultLang', 'zh_cn'));
        userconfig.AutoChangePort     := userConfigFile.GetValue('/AutoChangePort', False);
        userconfig.EnableApacheAuth   := userConfigFile.GetValue('/EnableApacheAuth', True);
        userconfig.ApacheAuthAccount  := userConfigFile.GetValue('/ApacheAuthAccount', '');
        userconfig.ApacheAuthPassword := userConfigFile.GetValue('/ApacheAuthPassword', '');

        if userconfig.LastRunTime > 0 then
        begin
            isFirstRun := False;
            Result     := True;
        end;
    finally
    end;

    if VERSION_MAJOR = 1 then begin
        userconfig.forceX86 := true;
    end else begin
        userconfig.forceX86 := config.Get('basic/force_x86', '') = 'true';
    end;

    consoleln('OS environment info:');
    consoleln('    os.Architecture  ', os.Architecture);
    consoleln('    os.Exe           ', os.Exe);
    consoleln('    os.Location      ', os.Location);
    consoleln('    os.RunnerLocation', os.RunnerLocation);
end;

{ Load config }
function SaveConfig(destroy: boolean = False): boolean;
begin
    ConsoleLn('SaveConfig: ' + userConfigFile.FileName);
    Result := False;
    try
        userConfigFile.SetValue('/LastRunTime', Now);
        userConfigFile.SetValue('/language', userconfig.Language);
        userConfigFile.SetValue('apache/port', userconfig.ApachePort);
        userConfigFile.SetValue('mysql/port', userconfig.MysqlPort);
        userConfigFile.SetValue('/AutoChangePort', userconfig.AutoChangePort);
        userConfigFile.SetValue('/EnableApacheAuth', userconfig.EnableApacheAuth);
        userConfigFile.SetValue('/ApacheAuthAccount', userconfig.ApacheAuthAccount);
        userConfigFile.SetValue('/ApacheAuthPassword', userconfig.ApacheAuthPassword);

        userConfigFile.Flush;
        Result := True;
    finally
        if destroy then userConfigFile.Free;
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
    if debugMode > 0 then
    begin
        {$ifdef WINDOWS}
        if not IsConsole then
        begin
            AllocConsole;
            IsConsole := True; // in System unit
            SysInitStdIO;      // in System unit
            WriteLn('=== Debug Console [Mode: ' + inttostr(debugMode) + '] ===');
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
function GetBuildVersion(formatStr: string = 'auto'): string;
begin
    if formatStr = '%s' then
    begin
        Result := 'Release';
    end
    else if formatStr = 'auto' then
    begin
        if VERSION_PACTH = 0 then begin
            Result := Format('%d.%d', [VERSION_MAJOR, VERSION_MINOR]);
        end else begin
            Result := Format('%d.%d.%d', [VERSION_MAJOR, VERSION_MINOR, VERSION_PACTH]);
        end;
    end
    else
    begin
        Result := Format(formatStr, [VERSION_MAJOR, VERSION_MINOR, VERSION_PACTH]);
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

function StrReplace(source: string; find: string; forReplace: string): string;
begin
    Result := StringReplace(source, find, forReplace, [rfReplaceAll]);
end;

function formatDir(source: string): string;
begin
    Result := StrReplace(source, '\', '/');
end;

end.

