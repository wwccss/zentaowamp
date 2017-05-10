unit authconfigdialogunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ZentaoUnit, langunit;

type

  { TAuthConfigDialogForm }

  TAuthConfigDialogForm = class(TForm)
    AccountLabel: TLabel;
    authAccountInput: TEdit;
    authPasswordInput: TEdit;
    ConfirmButton: TButton;
    PasswordLabel: TLabel;
    procedure ConfirmButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AuthConfigDialogForm: TAuthConfigDialogForm;

implementation

{$R *.lfm}

{ TAuthConfigDialogForm }

procedure TAuthConfigDialogForm.FormCreate(Sender: TObject);
begin
   authAccountInput.Text := userconfig.ApacheAuthAccount;
   authPasswordInput.Text := userconfig.ApacheAuthPassword;
end;

procedure TAuthConfigDialogForm.FormShow(Sender: TObject);
begin
     Caption := GetLang('menu/configAuthAcount', '配置访问验证账号');
     AccountLabel.Caption := GetLang('ui/account', '用户名');
     PasswordLabel.Caption := GetLang('ui/password', '密码');
     ConfirmButton.Caption := GetLang('ui/confirm', '确定');
end;

procedure TAuthConfigDialogForm.ConfirmButtonClick(Sender: TObject);
begin
   if (authAccountInput.Text = '') or (authPasswordInput.Text = '') then begin
       ShowMessage(GetLang('message/accountAndPasswordRequired', '用户名或密码不能为空。'));
   end else begin
       userconfig.ApacheAuthAccount := authAccountInput.Text;
       userconfig.ApacheAuthPassword := authPasswordInput.Text;
       SaveConfig();
       resetAuthConfig;
       Close();
   end;
end;

end.

