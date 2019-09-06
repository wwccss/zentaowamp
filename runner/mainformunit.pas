unit mainformunit;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
    StdCtrls,
    LCLIntf, ExtCtrls,
    langunit,
    Clipbrd,
    zentaounit, process, ServiceManager, ConfigPortDialogUnit, AuthConfigDialogUnit;

type

    { TMainForm }

    TMainForm = class(TForm)
      ButtonStartXXD: TButton;
      copyAuthPassword: TLabel;
      apacheAuthToggle: TCheckBox;
        ButtonRun                : TButton;
        ButtonVisit              : TButton;
        ButtonStop               : TButton;
        ButtonZtOffical          : TButton;
        FlowPanel1: TFlowPanel;
        apacheAuthLabel: TLabel;
        apacheAuthChangeBtn: TLabel;
        MainMenu                 : TMainMenu;
        MemoMessager             : TMemo;
        MenuItem1                : TMenuItem;
        MenuItem2                : TMenuItem;
        MenuItemAll3Log: TMenuItem;
        MenuItemProductProLog: TMenuItem;
        MenuItemApacheLog: TMenuItem;
        MenuItemMysqlLog: TMenuItem;
        MenuItemPhpLog: TMenuItem;
        MenuItemProductLog: TMenuItem;
        MenuItemLog: TMenuItem;
        MenuItemPassword: TMenuItem;
        MenuItemConfirmMysqlPassword: TMenuItem;
        MenuItemChangeAuthAccount: TMenuItem;
        MenuItemEn: TMenuItem;
        MenuItemZhtw: TMenuItem;
        MenuItemZhcn: TMenuItem;
        MenuItemLang: TMenuItem;
        MenuItemXampp            : TMenuItem;
        MenuItemService          : TMenuItem;
        MenuItemOfficialSite     : TMenuItem;
        MenuItemOfficialHelp     : TMenuItem;
        MenuItemFlowChart        : TMenuItem;
        MenuItem16               : TMenuItem;
        MenuItemFaq              : TMenuItem;
        MenuItemForum            : TMenuItem;
        MenuItemRunCommands      : TMenuItem;
        MenuItemTool             : TMenuItem;
        MenuItemViewService      : TMenuItem;
        MenuItemUninstallService : TMenuItem;
        MenuItemHelp             : TMenuItem;
        MenuItemExit             : TMenuItem;
        MenuItemInitBat          : TMenuItem;
        MenuItemDatabase         : TMenuItem;
        MenuItemBackup           : TMenuItem;
        Timer1: TTimer;
        TrayIcon1                : TTrayIcon;
        procedure apacheAuthChangeBtnClick(Sender: TObject);
        procedure apacheAuthToggleChange(Sender: TObject);
        procedure ButtonRunClick(Sender: TObject);
        procedure ButtonStartXXDClick(Sender: TObject);
        procedure ButtonStopClick(Sender: TObject);
        procedure ButtonVisitClick(Sender: TObject);
        procedure ButtonZtOfficalClick(Sender: TObject);
        procedure ChangeLangMenuItemClick(Sender: TObject);
        procedure copyAuthPasswordClick(Sender: TObject);
        procedure copyAuthPasswordMouseLeave(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure FormWindowStateChange(Sender: TObject);
        procedure MenuItem10Click(Sender: TObject);
        procedure MenuItem2Click(Sender: TObject);
        procedure MenuItemAll3LogClick(Sender: TObject);
        procedure MenuItemApacheLogClick(Sender: TObject);
        procedure MenuItemChangeAuthAccountClick(Sender: TObject);
        procedure MenuItemConfirmMysqlPasswordClick(Sender: TObject);
        procedure MenuItemMysqlLogClick(Sender: TObject);
        procedure MenuItemOfficialHelpClick(Sender: TObject);
        procedure MenuItemFlowChartClick(Sender: TObject);
        procedure MenuItemFaqClick(Sender: TObject);
        procedure MenuItemForumClick(Sender: TObject);
        procedure MenuItemPhpLogClick(Sender: TObject);
        procedure MenuItemProductLogClick(Sender: TObject);
        procedure MenuItemProductProLogClick(Sender: TObject);
        procedure MenuItemViewServiceClick(Sender: TObject);
        procedure MenuItemUninstallServiceClick(Sender: TObject);
        procedure MenuItemExitClick(Sender: TObject);
        procedure MenuItemInitBatClick(Sender: TObject);
        procedure MenuItemDatabaseClick(Sender: TObject);
        procedure MenuItemBackupClick(Sender: TObject);
        procedure MenuItemRunCommandsClick(Sender: TObject);
        procedure MenuItemXamppClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure TrayIcon1Click(Sender: TObject);
    private
        { private declarations }
    public
        procedure DisplayMessage(Message: string);
        procedure ChangeLanguage(langSetting: string);
        procedure updateAuthStatus();
        procedure updateXxdStatus();
    end;

var
    MainForm: TMainForm;
    FirstShow: boolean;

implementation

{$R *.lfm}

procedure TMainForm.MenuItemExitClick(Sender: TObject);
begin
    Close;
end;

procedure TMainForm.MenuItemInitBatClick(Sender: TObject);
begin
    if product.InitBat = '' then Exit;

    if InitBat then begin
        if mrYes = QuestionDlg (GetLang('UI/confirmation', '确认'), GetLang('message/initBatSuccessfully', '成功生成批处理文件，是否到%s目录下查看？'), mtCustom, [mrYes, GetLang('UI/yes', '是'), mrNo, GetLang('UI/no', '否'), 'IsDefault'], '') then begin
            ExcuteCommand('explorer ' + product.BinPath, False, False);
        end;
    end else begin
        ShowMessage(GetLang('message/runFailed', '执行失败。'));
    end;
end;

procedure TMainForm.MenuItemDatabaseClick(Sender: TObject);
begin
    if (apache.Status = 'running') and (mysql.Status = 'running') then begin
        OpenUrl('http://' + HOST + ':' + IntToStr(apache.port) + '/adminer');
    end else begin
        ShowMessage(GetLang('message/stopSuccessfully', '服务已经停止，点击“启动”按钮来启动服务。'));
    end;
end;

procedure TMainForm.MenuItemBackupClick(Sender: TObject);
var
    deskDir: string;
begin
    if product.BackupFile = '' then begin
        ShowMessage(GetLang('message/nobackupfile', '备份功能此版本不可用'));
        Exit;
    end;

    if (apache.Status = 'running') and (mysql.Status = 'running') then begin
        deskDir := BackupZentao();
        if deskDir <> '' then begin
            if mrYes = QuestionDlg (GetLang('UI/confirmation', '确认'), GetLang('message/backupCompleteTip', '成功备份到%s目录, 是否进入该目录查看？'), mtCustom, [mrYes, GetLang('UI/yes', '是'), mrNo, GetLang('UI/no', '否'), 'IsDefault'], '') then begin
                ExcuteCommand('explorer ' + deskDir, False, False);
            end;
        end else begin
            ShowMessage(GetLang('message/backupFailed', '备份失败，详情参见面板输出信息。'));
        end;
    end else Begin
        ShowMessage(GetLang('message/backupWithServerNotRunning', '备份失败，因为服务没有运行，请启动服务后进行备份。'));
    end;
end;

procedure TMainForm.MenuItemRunCommandsClick(Sender: TObject);
var
    userString  : string;
    outputLines : TStringList;
    i           : integer;
begin
    if InputQuery(GetLang('message/runCommands', '执行命令'), GetLang('message/inputCommandTip', '请输入要执行的命令(不支持IO重定向)，例如：cmd.exe /c "echo Hello world!"'), userString) then begin
        PrintLn;
        PrintLn('> ' + GetLang('message/startRunCommands', '开始执行命令：'));
        outputLines := ExcuteCommand(userString, true, false);
        for i := 0 to (outputLines.Count - 1) do
        begin
            PrintLn(outputLines[i]);
        end;
        outputLines.Free;
        PrintLn('* ' + GetLang('message/commandComplete', '命令执行完毕。'));
    end;
end;

procedure TMainForm.MenuItemXamppClick(Sender: TObject);
begin
    OpenUrl('http://www.apachefriends.org/en/xampp.html');
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
    updateXxdStatus();
end;

procedure TMainForm.TrayIcon1Click(Sender: TObject);
begin
    if WindowState = wsMinimized then begin
        Show;
        WindowState   := wsNormal;
        ShowInTaskBar := stAlways;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    FirstShow := True;
    LoadConfig();
    Icon.LoadFromFile(os.IconFile);
    TrayIcon1.Icon.LoadFromFile(os.IconFile);
    if userconfig.singleLanguage then begin
        MenuItemLang.Visible := false;
    end;
    SetLanguage(userconfig.Language, false, os.RunnerLocation);

    PrintLn(GetProductTitle() + Format(GetLang('message/zentaoControl', '控制面板 %s'), [GetBuildVersion]));

    if not CheckApplicationPath(Application.Location) then begin
        ShowMessage(GetLang('message/wrongAppLocationPath', '无法安装启动服务，因为当前程序所在路径包含中文等特殊字符。程序所在路径必须仅包含数字、大小写字母或下划线，请修改路径后重试。'));
        Application.Terminate;
        Exit;
    end;

    if not CheckVC then begin
        if mrYes = QuestionDlg (GetLang('UI/confirmation', '确认'), GetLang('UI/isInstallVC', '检查到没有安装VC++运行环境，将无法继续使用。是否立即安装？'), mtCustom, [mrYes, GetLang('UI/yes', '是'), mrNo, GetLang('UI/no', '否'), 'IsDefault'], '') then begin
            InstallVC;
            if not CheckVC then begin
                if mrYes = QuestionDlg (GetLang('UI/confirmation', '确认'), GetLang('message/VCInstallFailConfigSkip', 'VC++运行环境安装失败，是否忽略VC++环境检查并继续运行？继续运行程序有可能会自动退出。'), mtCustom, [mrYes, GetLang('UI/yes', '是'), mrNo, GetLang('UI/no', '否'), 'IsDefault'], '') then begin
                    userconfig.TrySkipCheckVC := true;
                end else begin
                    ShowMessage(GetLang('message/VCInstallFail', 'VC++运行环境安装失败。'));
                    Application.Terminate;
                    Exit;
                end;
            end;
        end else begin
            if mrYes = QuestionDlg (GetLang('UI/confirmation', '确认'), GetLang('message/VCInstallFailConfigSkip', 'VC++运行环境安装失败，是否忽略VC++环境检查并继续运行？继续运行程序有可能会自动退出。'), mtCustom, [mrYes, GetLang('UI/yes', '是'), mrNo, GetLang('UI/no', '否'), 'IsDefault'], '') then begin
                userconfig.TrySkipCheckVC := true;
            end else begin
                Application.Terminate;
                Exit;
            end;
        end;
    end;

    InitZentao();

    MenuItemInitBat.Enabled   := product.InitBat <> '';
    MenuItemBackup.Enabled    := product.BackupFile <> '';

    if debugMode > 0 then begin
        MenuItemRunCommands.Visible := True;
    end;

    if (apache.Status = 'running') and (mysql.Status = 'running') then begin
        ButtonVisit.Enabled := True;
        ButtonStop.Enabled  := True;
        ButtonStop.Caption  := GetLang('UI/stop', '停止');
        ButtonRun.Enabled   := False;
        ButtonRun.Caption   := GetLang('UI/running', '正在运行');
        updateAuthStatus();
    end;

    ButtonStartXXD.Visible := xxd.enabled;
    ButtonStartXXD.Enabled := xxd.enabled;

    if xxd.enabled then begin
        Timer1.Enabled := true;
    end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
    if FirstShow then begin
        FirstShow := False;
        ChangeLanguage(userconfig.Language);
    end;
end;

procedure TMainForm.FormWindowStateChange(Sender: TObject);
begin
    if WindowState = wsMinimized then begin
        ShowInTaskBar := stNever;
        TrayIcon1.Visible := True;
    end else begin
        ShowInTaskBar := stDefault;
        TrayIcon1.Visible := False;
    end;
end;

procedure TMainForm.MenuItem10Click(Sender: TObject);
begin
    CheckProductVersion;
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
    ConfigPortDialog.ShowModal();
end;

procedure TMainForm.MenuItemAll3LogClick(Sender: TObject);
begin
    if product.id = 'all' then begin
        ExcuteCommand('explorer ' + productRanzhi.logPath, False, False);
    end else begin
        ExcuteCommand('explorer ' + product.EpLogPath, False, False);
    end;
end;

procedure TMainForm.MenuItemApacheLogClick(Sender: TObject);
begin
    ExcuteCommand('explorer ' + apache.logPath, False, False);
end;

procedure TMainForm.MenuItemChangeAuthAccountClick(Sender: TObject);
begin
    AuthConfigDialogForm.ShowModal();
end;

procedure TMainForm.MenuItemConfirmMysqlPasswordClick(Sender: TObject);
begin
    ConfirmMySqlPassword;
end;

procedure TMainForm.MenuItemMysqlLogClick(Sender: TObject);
begin
    ExcuteCommand('explorer ' + mysql.logPath, False, False);
end;

procedure TMainForm.MenuItemOfficialHelpClick(Sender: TObject);
begin
    OpenUrl(GetProductLink('helpdocument', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.MenuItemFlowChartClick(Sender: TObject);
begin
    OpenUrl(GetProductLink('flowchart', 'http://www.zentao.net/book/zentaopmshelp/165.html'));
end;

procedure TMainForm.MenuItemFaqClick(Sender: TObject);
begin
    OpenUrl(GetProductLink('feedback', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.MenuItemForumClick(Sender: TObject);
begin
    OpenUrl(GetProductLink('forum', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.MenuItemPhpLogClick(Sender: TObject);
begin
    ExcuteCommand('explorer ' + php.logPath, False, False);
end;

procedure TMainForm.MenuItemProductLogClick(Sender: TObject);
begin
    if product.id = 'all' then begin
        ExcuteCommand('explorer ' + productZentao.logPath, False, False);
    end else begin
        ExcuteCommand('explorer ' + product.logPath, False, False);
    end;
end;

procedure TMainForm.MenuItemProductProLogClick(Sender: TObject);
begin
    if product.id = 'all' then begin
        ExcuteCommand('explorer ' + productChanzhi.logPath, False, False);
    end else begin
        ExcuteCommand('explorer ' + product.proLogPath, False, False);
    end;
end;

procedure TMainForm.MenuItemViewServiceClick(Sender: TObject);
begin
    ExcuteShell('start services.msc', True);
end;

procedure TMainForm.MenuItemUninstallServiceClick(Sender: TObject);
begin
    Cursor := crHourGlass;
    ButtonRun.Enabled   := false;
    updateAuthStatus();
    PrintLn;
    UninstallService();
    Cursor := crDefault;
    ButtonVisit.Enabled := False;
    ButtonStop.Enabled  := False;
    ButtonStop.Caption  := GetLang('UI/stopped', '已停止');
    ButtonRun.Enabled   := True;
    ButtonRun.Caption   := Format(GetLang('UI/startProduct', '启动'), [GetProductTitle]);
    ButtonStartXXD.Caption := GetLang('UI/startXXD', '启动XXD');
    ButtonStartXXD.Enabled := xxd.enabled;
end;

procedure TMainForm.ButtonStopClick(Sender: TObject);
begin
    Cursor := crHourGlass;
    ButtonStop.Enabled := False;
    ButtonStop.Caption := GetLang('UI/stopping', '正在停止');
    if StopZentao then begin
        ButtonVisit.Enabled := False;
        ButtonStop.Enabled  := False;
        ButtonStop.Caption  := GetLang('UI/stopped', '已停止');
        ButtonRun.Enabled   := True;
        ButtonRun.Caption   := Format(GetLang('UI/startProduct', '启动'), [GetProductTitle]);
    end else begin
        ButtonVisit.Enabled := True;
        ButtonStop.Enabled  := True;
        ButtonStop.Caption  := GetLang('UI/stop', '停止');
        ButtonRun.Enabled   := False;
        ButtonRun.Caption   := GetLang('UI/running', '正在运行');
    end;
    Cursor := crDefault;
end;

procedure TMainForm.ButtonRunClick(Sender: TObject);
begin
    Cursor := crHourGlass;
    ButtonRun.Enabled := False;
    ButtonRun.Caption := GetLang('UI/starting', '正在启动');
    if StartZentao then begin
        ButtonVisit.Enabled := True;
        ButtonStop.Enabled  := True;
        ButtonStop.Caption  := GetLang('UI/stop', '停止');
        ButtonRun.Enabled   := False;
        ButtonRun.Caption   := GetLang('UI/running', '正在运行');
    end else begin
        ButtonVisit.Enabled := False;
        ButtonStop.Enabled  := False;
        ButtonStop.Caption  := GetLang('UI/stopped', '已停止');
        ButtonRun.Enabled   := True;
        ButtonRun.Caption   := Format(GetLang('UI/startProduct', '启动'), [GetProductTitle]);
    end;
    Cursor := crDefault;
end;

procedure TMainForm.ButtonStartXXDClick(Sender: TObject);
begin
    if xxd.enabled and ButtonStartXXD.Enabled then begin
        if (xxd.status = 'stopped') or (xxd.status = 'failed') then begin
            ButtonStartXXD.Enabled := false;
            ButtonStartXXD.Caption := GetLang('UI/startingXXD', 'XXD...');

            if startXXD() then begin
                ButtonStartXXD.Caption := GetLang('UI/stopXXD', '停止XXD');
            end else begin
                ButtonStartXXD.Caption := GetLang('UI/startXXD', '启动XXD');
            end;
            ButtonStartXXD.Enabled := true;
        end else if xxd.status = 'running' then begin
            ButtonStartXXD.Enabled := false;
            ButtonStartXXD.Caption := GetLang('UI/stopingXXD', 'XXD...');
            if stopXXD() then begin
                ButtonStartXXD.Caption := GetLang('UI/startXXD', '启动XXD');
            end else begin
                ButtonStartXXD.Caption := GetLang('UI/stopXXD', '停止XXD');
            end;
            ButtonStartXXD.Enabled := true;
        end;
    end;
end;

procedure TMainForm.apacheAuthToggleChange(Sender: TObject);
begin
    userconfig.EnableApacheAuth := apacheAuthToggle.Checked;
    SaveConfig();
    resetAuthConfig;
end;

procedure TMainForm.apacheAuthChangeBtnClick(Sender: TObject);
begin
    AuthConfigDialogForm.ShowModal();
end;

procedure TMainForm.ButtonVisitClick(Sender: TObject);
var
    url : String;
begin
    url := 'http://';
    // if userconfig.EnableApacheAuth then begin
    //     url := url + userconfig.apacheAuthAccount + ':' + userconfig.apacheAuthPassword + '@';
    // end;
    url := url + HOST + ':' + IntToStr(apache.port) + '/' + config.Get('product/main', '');
    ConsoleLn(LineEnding + 'OpenUrl> ' + url + LineEnding);
    OpenUrl(url);
end;

procedure TMainForm.ButtonZtOfficalClick(Sender: TObject);
begin
    OpenUrl(GetProductLink('official', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.ChangeLangMenuItemClick(Sender: TObject);
var
    menuItem: TMenuItem;
begin
    menuItem := Sender as TMenuItem;
    ChangeLanguage(menuItem.Hint);
    // ShowMessage(GetLang('message/applyLangTip', '重启程序来应用所有语言更改。'));
end;

procedure TMainForm.copyAuthPasswordClick(Sender: TObject);
begin
  Clipboard.AsText := userconfig.ApacheAuthPassword;
  copyAuthPassword.Caption := GetLang('ui/copied', '已复制');
end;

procedure TMainForm.copyAuthPasswordMouseLeave(Sender: TObject);
begin
  copyAuthPassword.Caption := GetLang('ui/copyPassword', '复制密码');
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
    if not ButtonRun.Enabled or xxd.status = 'running' then begin
        ShowMessage(GetLang('message/exitAppTip', '退出后服务会在后台继续运行，要停止服务请重新打开此程序进行操作。'));
    end;
    ExitZentao;
end;

{ Display message }
procedure TMainForm.DisplayMessage(Message: string);
begin
   MemoMessager.Lines.Text := MemoMessager.Lines.Text + Message;
   MemoMessager.SelStart   := Length(MemoMessager.Lines.Text);
end;

procedure TMainForm.ChangeLanguage(langSetting: string);
var
    productName: String;
begin
    SetLanguage(langSetting);
    userconfig.Language := langSetting;
    SaveConfig();

    productName := GetProductTitle;
    Caption := Format(GetLang('ui/titleFormat', '%s集成运行环境 %s'), [productName, GetBuildVersion()]);
    TrayIcon1.Hint := Caption;

    MenuItemService.Caption          := GetLang('menu/service', '服务');
    MenuItem2.Caption                := GetLang('menu/configPort', '配置端口');
    MenuItemViewService.Caption      := GetLang('menu/viewService', '查看服务');
    MenuItemUninstallService.Caption := GetLang('menu/uninstallService', '卸载服务');
    MenuItemPassword.Caption         := GetLang('menu/password', '密码');
    MenuItemTool.Caption             := GetLang('menu/tool', '工具');
    MenuItemInitBat.Caption          := GetLang('menu/initBat', '生成脚本');
    MenuItemDatabase.Caption         := GetLang('menu/database', '数 据 库');
    MenuItemBackup.Caption           := GetLang('menu/backup', '备份') + productName;
    MenuItemLang.Caption             := GetLang('menu/lang', '语言');
    MenuItemZhcn.Caption             := GetLang('menu/zhcn', '中文简体');
    MenuItemZhtw.Caption             := GetLang('menu/zhtw', '中文繁体');
    MenuItemEn.Caption               := GetLang('menu/en', 'English');
    MenuItemHelp.Caption             := GetLang('menu/help', '帮助');
    MenuItemOfficialSite.Visible     := GetProductLink('official', '') <> 'false';
    MenuItemOfficialSite.Caption     := GetLang('menu/officialSite', '官方网站');
    MenuItemOfficialHelp.Visible     := GetProductLink('helpdocument', '') <> 'false';
    MenuItemOfficialHelp.Caption     := GetLang('menu/officialHelp', '帮助文档');
    MenuItemFlowChart.Caption        := GetLang('menu/flowChart', '流 程 图');
    MenuItemFlowChart.Visible        := (product.ID = 'zentao') or (GetProductLink('flowchart', '') <> 'false');
    MenuItemFaq.Visible              := GetProductLink('feedback', '') <> 'false';
    MenuItemFaq.Caption              := GetLang('menu/faq', '常见问题');
    MenuItemForum.Visible            := GetProductLink('forum', '') <> 'false';
    MenuItemForum.Caption            := GetLang('menu/forum', '官方论坛');
    MenuItemExit.Caption             := GetLang('menu/exit', '退出');
    MenuItemRunCommands.Caption      := GetLang('menu/runCommands', '执行命令');
    MenuItemConfirmMysqlPassword.Caption := GetLang('message/changeMySqlPassword', '数据库密码');
    MenuItemChangeAuthAccount.Caption    := GetLang('message/changeAuthAccount', 'Apache 访问密码');

    if product.id = 'all' then begin
        MenuItemProductLog.Caption        := Format(GetLang('menu/productLog', '%s日志'), [productZentao.title]);
        MenuItemProductProLog.Caption     := Format(GetLang('menu/productLog', '%s日志'), [productChanzhi.title]);
        MenuItemAll3Log.Caption           := Format(GetLang('menu/productLog', '%s日志'), [productRanzhi.title]);
        MenuItemProductProLog.Visible     := True;
        MenuItemAll3Log.Visible           := True;
    end else begin
        MenuItemProductLog.Caption           := Format(GetLang('menu/productLog', '%s日志'), [GetProductTitle('n')]);
        if product.Pro <> '' then begin
            MenuItemProductProLog.Visible := True;
            MenuItemProductProLog.Caption := Format(GetLang('menu/productLog', '%s日志'), [GetProductTitle('pro')]);
        end else begin
            MenuItemProductProLog.Visible := False;
        end;
        if product.enterprise <> '' then begin
            MenuItemAll3Log.Visible := True;
            MenuItemAll3Log.Caption := Format(GetLang('menu/productLog', '%s日志'), [GetProductTitle('ep')]);
        end else begin
            MenuItemAll3Log.Visible := False;
        end;
    end;

    MenuItemMysqlLog.Caption          := GetLang('menu/mysqlLog', 'Mysql 日志');
    MenuItemPhpLog.Caption            := GetLang('menu/phpLog', 'PHP 日志');
    MenuItemApacheLog.Caption         := GetLang('menu/apacheLog', 'Apache 日志');
    MenuItemLog.Caption               := GetLang('menu/log', '日志');

    ButtonVisit.Caption          := Format(GetLang('UI/visitProduct', '访问%s'), [productName]);
    ButtonZtOffical.Caption      := Format(GetLang('UI/productOfficial', '%s官网'), [productName]);
    if ButtonStop.Enabled then begin
        ButtonStop.Caption := GetLang('UI/stop', ButtonStop.Caption);
    end else begin
        ButtonStop.Caption := GetLang('UI/stopped', ButtonStop.Caption);
    end;

    if ButtonRun.Enabled then begin
        ButtonRun.Caption := Format(GetLang('UI/startProduct', '启动'), [GetProductTitle]);
    end else begin
        ButtonRun.Caption := GetLang('UI/running', ButtonRun.Caption);
    end;

    updateXxdStatus();

    apacheAuthToggle.Caption := GetLang('ui/enableApacheAuth', '启用 Apache 用户访问验证');
    apacheAuthLabel.Caption := Format(GetLang('ui/apacheInfoLabel', '用户名:%s 密码:%s'), [userconfig.ApacheAuthAccount, userconfig.apacheAuthPassword]);
    apacheAuthChangeBtn.Caption := GetLang('ui/change', '修改');
    copyAuthPassword.Caption := GetLang('ui/copyPassword', '复制密码');

    MenuItemZhcn.Checked := False;
    MenuItemEn.Checked   := False;
    MenuItemZhtw.Checked := False;
    if language = MenuItemZhcn.Hint then MenuItemZhcn.Checked := True;
    if language = MenuItemEn.Hint then MenuItemEn.Checked := True;
    if language = MenuItemZhtw.Hint then MenuItemZhtw.Checked := True;

    // PrintLn('更改语言：' + langSetting);
end;

procedure TMainForm.updateAuthStatus();
begin
    apacheAuthToggle.Checked := userconfig.EnableApacheAuth;
    apacheAuthLabel.Caption := Format(GetLang('ui/apacheInfoLabel', '用户名:%s 密码:%s'), [userconfig.ApacheAuthAccount, userconfig.apacheAuthPassword]);
    if userConfig.EnableApacheAuth then begin
        apacheAuthLabel.Font.Color := clMaroon;
    end else begin
        apacheAuthLabel.Font.Color := clGray;
    end;
    apacheAuthChangeBtn.Enabled := userconfig.EnableApacheAuth;
end;

procedure TMainForm.updateXxdStatus();
begin
    if xxd.enabled then begin
        if isXxdRunning() then begin
            ButtonStartXXD.Caption := GetLang('UI/stopXXD', '停止XXD');
        end else begin
            ButtonStartXXD.Caption := GetLang('UI/startXXD', '启动XXD');
        end;
    end;
end;

end.
