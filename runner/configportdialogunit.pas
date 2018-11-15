unit ConfigPortDialogUnit;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ComCtrls, ZentaoUnit, langunit;

type

    { TConfigPortDialog }

    TConfigPortDialog = class(TForm)
        Button1   : TButton;
        CheckBox1 : TCheckBox;
        Edit1     : TEdit;
        Edit2     : TEdit;
        Label1    : TLabel;
        Label2    : TLabel;
        UpDown1   : TUpDown;
        UpDown2   : TUpDown;
        procedure Button1Click(Sender: TObject);
        procedure Edit1Change(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        { private declarations }
    public
        { public declarations }
    end;

var
    ConfigPortDialog: TConfigPortDialog;

implementation

{$R *.lfm}

{ TConfigPortDialog }

procedure TConfigPortDialog.Button1Click(Sender: TObject);
begin
    userConfig.ApachePort := StrToInt(Edit1.Text);
    userConfig.MysqlPort  := StrToInt(Edit2.Text);
    mysql.port            := userConfig.MysqlPort;
    apache.port           := userConfig.apachePort;
    userConfig.AutoChangePort := CheckBox1.Checked;
    SaveConfig();
    // FixConfigPath();
    Close;
end;

procedure TConfigPortDialog.Edit1Change(Sender: TObject);
begin

end;

procedure TConfigPortDialog.FormShow(Sender: TObject);
begin
    Edit1.Text        := IntToStr(userConfig.ApachePort);
    Edit2.Text        := IntToStr(userConfig.MysqlPort);
    CheckBox1.Checked := userConfig.AutoChangePort;

    Caption           := GetLang('menu/configPort', '配置端口');
    Label1.Caption    := 'apache ' + GetLang('ui/port', '端口');
    Label2.Caption    := 'mysql ' + GetLang('ui/port', '端口');
    Button1.Caption   := GetLang('ui/confirm', '确定');
    CheckBox1.Caption := GetLang('ui/autoChangePort', '自动更改端口号');
end;

end.

