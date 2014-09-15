unit ConfigPortDialogUnit;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ComCtrls, ZentaoUnit, langunit;

type

    { TConfigPortDialog }

    TConfigPortDialog = class(TForm)
        Button1: TButton;
        Edit1: TEdit;
        Edit2: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        UpDown1: TUpDown;
        UpDown2: TUpDown;
        procedure Button1Click(Sender: TObject);
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
    apache.Port := StrToInt(Edit1.Text);
    mysql.Port  := StrToInt(Edit2.Text);
    SaveConfig();
    Close;
end;

procedure TConfigPortDialog.FormShow(Sender: TObject);
begin
    Edit1.Text := IntToStr(apache.Port);
    Edit2.Text := IntToStr(mysql.Port);

    Caption := GetLang('menu/configPort', '配置默认服务');
    Label1.Caption := 'apache ' + GetLang('ui/port', '端口');
    Label2.Caption := 'mysql ' + GetLang('ui/port', '端口');
    Button1.Caption := GetLang('ui/confirm', '确定');
end;

end.

