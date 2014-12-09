unit mainformunit;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
    StdCtrls,
    LCLIntf, ExtCtrls,
    langunit,
    zentaounit, process, ServiceManager, ConfigPortDialogUnit;

type

    { TMainForm }

    TMainForm = class(TForm)
        ButtonRun                : TButton;
        ButtonVisit              : TButton;
        ButtonStop               : TButton;
        ButtonZtOffical          : TButton;
        MainMenu                 : TMainMenu;
        MemoMessager             : TMemo;
        MenuItem1                : TMenuItem;
        MenuItem2                : TMenuItem;
        MenuItemXampp            : TMenuItem;
        MenuItemService          : TMenuItem;
        MenuItemZhcn             : TMenuItem;
        MenuItem11               : TMenuItem;
        MenuItemLang             : TMenuItem;
        MenuItemOfficialSite     : TMenuItem;
        MenuItemOfficialHelp     : TMenuItem;
        MenuItemFlowChart        : TMenuItem;
        MenuItem16               : TMenuItem;
        MenuItemFaq              : TMenuItem;
        MenuItemForum            : TMenuItem;
        MenuItemEn               : TMenuItem;
        MenuItemZhtw             : TMenuItem;
        MenuItemRunCommands      : TMenuItem;
        MenuItemMore             : TMenuItem;
        MenuItemViewService      : TMenuItem;
        MenuItemUninstallService : TMenuItem;
        MenuItemHelp             : TMenuItem;
        MenuItemExit             : TMenuItem;
        MenuItemInitBat          : TMenuItem;
        MenuItemDatabase         : TMenuItem;
        MenuItemBackup           : TMenuItem;
        TrayIcon1                : TTrayIcon;
        procedure ButtonRunClick(Sender: TObject);
        procedure ButtonStopClick(Sender: TObject);
        procedure ButtonVisitClick(Sender: TObject);
        procedure ButtonZtOfficalClick(Sender: TObject);
        procedure ChangeLangMenuItemClick(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure FormWindowStateChange(Sender: TObject);
        procedure MenuItem10Click(Sender: TObject);
        procedure MenuItem2Click(Sender: TObject);
        procedure MenuItemOfficialHelpClick(Sender: TObject);
        procedure MenuItemFlowChartClick(Sender: TObject);
        procedure MenuItemFaqClick(Sender: TObject);
        procedure MenuItemForumClick(Sender: TObject);
        procedure MenuItemViewServiceClick(Sender: TObject);
        procedure MenuItemUninstallServiceClick(Sender: TObject);
        procedure MenuItemExitClick(Sender: TObject);
        procedure MenuItemInitBatClick(Sender: TObject);
        procedure MenuItemDatabaseClick(Sender: TObject);
        procedure MenuItemBackupClick(Sender: TObject);
        procedure MenuItemRunCommandsClick(Sender: TObject);
        procedure MenuItemXamppClick(Sender: TObject);
        procedure TrayIcon1Click(Sender: TObject);
    private
        { private declarations }
    public
        procedure DisplayMessage(Message: string);
        procedure ChangeLanguage(langSetting: string);
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
        if mrYes = MessageDlg(Format(GetLang('message/initBatSuccessfully', '成功生成批处理文件，是否到%s目录下查看？'), [product.BinPath]), mtConfirmation, [mbYes, mbNo], 0) then begin
            ExcuteCommand('explorer ' + product.BinPath, False, False);
        end;
    end else begin
        ShowMessage(GetLang('message/runFailed', '执行失败。'));
    end;
end;

procedure TMainForm.MenuItemDatabaseClick(Sender: TObject);
begin
    if (apache.Status = 'running') and (mysql.Status = 'running') then begin
        OpenUrl('http://' + HOST + ':' + IntToStr(apache.port) + '/phpmyadmin');
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

    if mysql.Status <> 'running' then begin
        ShowMessage(GetLang('message/mysqlNotRunning', '未启动mysql，只备份文件数据。'));
    end;

    deskDir := BackupZentao();
    if mrYes = MessageDlg(Format(GetLang('message/backupCompleteTip', '成功备份到%s目录, 是否进入该目录查看？'), [deskDir]), mtConfirmation, [mbYes, mbNo], 0) then begin
        ExcuteCommand('explorer ' + deskDir, False, False);
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
        outputLines := ExcuteCommand(userString);
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
    SetLanguage('zh_cn', false, os.RunnerLocation);

    PrintLn(product.Title + Format(GetLang('message/zentaoControl', '控制面板 %s'), [GetBuildVersion]));

    // if Pos(':\xampp\', LowerCase(Application.ExeName)) <> 2 then begin
    //     ShowMessage(GetLang('UI/wrongPath', '请将一键安装包解压到根目录, 例如：D:\xampp'));
    //     Close;
    // end;

    if not CheckVC2008 then begin
        if mrYes = MessageDlg(GetLang('UI/isInstallVC', '检查到没有安装VC2008运行环境，将无法正常使用所有功能。是否立即安装？'), mtConfirmation, [mbYes, mbNo], 0) then begin
        InstallVC2008;
        end;
    end;

    InitZentao();

    MenuItemInitBat.Enabled   := product.InitBat <> '';
    MenuItemBackup.Enabled    := product.BackupFile <> '';
    MenuItemFlowChart.Visible := product.ID = 'zentao';

    if DEBUG_MODE > 0 then begin
        MenuItemRunCommands.Visible := True;
    end;

    if (apache.Status = 'running') and (mysql.Status = 'running') then begin
        ButtonVisit.Enabled := True;
        ButtonStop.Enabled  := True;
        ButtonStop.Caption  := GetLang('UI/stop', '停止');
        ButtonRun.Enabled   := False;
        ButtonRun.Caption   := GetLang('UI/running', '正在运行');
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

procedure TMainForm.MenuItemOfficialHelpClick(Sender: TObject);
begin
    OpenUrl(config.Get('product/helpdocument', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.MenuItemFlowChartClick(Sender: TObject);
begin
    OpenUrl('http://www.zentao.net/book/zentaopmshelp/165.html');
end;

procedure TMainForm.MenuItemFaqClick(Sender: TObject);
begin
    OpenUrl(config.Get('product/feedback', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.MenuItemForumClick(Sender: TObject);
begin
    OpenUrl(config.Get('product/forum', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.MenuItemViewServiceClick(Sender: TObject);
begin
    ExcuteShell('start services.msc', True);
end;

procedure TMainForm.MenuItemUninstallServiceClick(Sender: TObject);
begin
    Cursor := crHourGlass;
    PrintLn;
    UninstallService();
    Cursor := crDefault;
    ButtonVisit.Enabled := False;
    ButtonStop.Enabled  := False;
    ButtonStop.Caption  := GetLang('UI/stopped', '已停止');
    ButtonRun.Enabled   := True;
    ButtonRun.Caption   := GetLang('UI/startZentao', '启动') + product.Title;
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
        ButtonRun.Caption   := GetLang('UI/startZentao', '启动') + product.Title;
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
        ButtonRun.Caption   := GetLang('UI/startZentao', '启动') + product.Title;
    end;
    Cursor := crDefault;
end;

procedure TMainForm.ButtonVisitClick(Sender: TObject);
begin
    OpenUrl('http://' + HOST + ':' + IntToStr(apache.port) + '/' + config.Get('product/main', ''));
end;

procedure TMainForm.ButtonZtOfficalClick(Sender: TObject);
begin
    OpenUrl(config.Get('product/official', 'http://www.cnezsoft.com/'));
end;

procedure TMainForm.ChangeLangMenuItemClick(Sender: TObject);
var
    menuItem: TMenuItem;
begin
    menuItem := Sender as TMenuItem;
    ChangeLanguage(menuItem.Hint);
    ShowMessage(GetLang('message/applyLangTip', '重启程序来应用所有语言更改。'));
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
    ExitZentao;
    if not ButtonRun.Enabled then begin
        ShowMessage(GetLang('message/exitAppTip', '退出后服务会在后台继续运行，要停止服务请重新打开此程序进行操作。'));
    end;
end;

{ Display message }
procedure TMainForm.DisplayMessage(Message: string);
begin
   MemoMessager.Lines.Text := MemoMessager.Lines.Text + Message;
   MemoMessager.SelStart   := Length(MemoMessager.Lines.Text);
end;

procedure TMainForm.ChangeLanguage(langSetting: string);
begin
    SetLanguage(langSetting);

    Caption := product.Title + GetLang('ui/title', '集成运行环境') + ' ' + GetBuildVersion;

    MenuItemService.Caption          := GetLang('menu/service', '服务');
    MenuItem2.Caption                := GetLang('menu/configPort', '配置默认端口');
    MenuItemViewService.Caption      := GetLang('menu/viewService', '查看服务');
    MenuItemUninstallService.Caption := GetLang('menu/uninstallService', '卸载服务');
    MenuItemMore.Caption             := GetLang('menu/more', '更多');
    MenuItemInitBat.Caption          := GetLang('menu/initBat', '生成脚本');
    MenuItemDatabase.Caption         := GetLang('menu/database', '数 据 库');
    MenuItemBackup.Caption           := GetLang('menu/backup', '备份') + product.Title;
    MenuItemLang.Caption             := GetLang('menu/lang', '语言');
    MenuItemZhcn.Caption             := GetLang('menu/zhcn', '中文简体');
    MenuItemZhtw.Caption             := GetLang('menu/zhtw', '中文繁体');
    MenuItemEn.Caption               := GetLang('menu/en', 'English');
    MenuItemHelp.Caption             := GetLang('menu/help', '帮助');
    MenuItemOfficialSite.Caption     := product.Title + GetLang('menu/officialSite', '官网');
    MenuItemOfficialHelp.Caption     := GetLang('menu/officialHelp', '帮助文档');
    MenuItemFlowChart.Caption        := GetLang('menu/flowChart', '流 程 图');
    MenuItemFaq.Caption              := GetLang('menu/faq', '常见问题');
    MenuItemForum.Caption            := GetLang('menu/forum', '官方论坛');
    MenuItemExit.Caption             := GetLang('menu/exit', '退出');
    MenuItemRunCommands.Caption      := GetLang('menu/runCommands', '执行命令');

    ButtonVisit.Caption     := GetLang('UI/visitZentao', '访问') + product.Title;
    ButtonZtOffical.Caption :=  product.Title + GetLang('UI/zentaoOfficial', '官网');
    if ButtonStop.Enabled then begin
        ButtonStop.Caption := GetLang('UI/stop', ButtonStop.Caption);
    end else begin
        ButtonStop.Caption := GetLang('UI/stopped', ButtonStop.Caption);
    end;

    if ButtonRun.Enabled then begin
        ButtonRun.Caption := GetLang('UI/startZentao', ButtonRun.Caption);
    end else begin
        ButtonRun.Caption := GetLang('UI/runing', ButtonRun.Caption);
    end;
    
    MenuItemZhcn.Checked := False;
    MenuItemEn.Checked   := False;
    MenuItemZhtw.Checked := False;
    if language = MenuItemZhcn.Hint then MenuItemZhcn.Checked := True;
    if language = MenuItemEn.Hint then MenuItemEn.Checked := True;
    if language = MenuItemZhtw.Hint then MenuItemZhtw.Checked := True;

    // PrintLn('更改语言：' + langSetting);
end;

end.

