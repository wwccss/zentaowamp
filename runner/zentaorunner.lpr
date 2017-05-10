program zentaorunner;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}{$IFDEF UseCThreads}
    cthreads,
    {$ENDIF}{$ENDIF}
    Interfaces, // this includes the LCL widgetset
    Forms, mainformunit, zentaounit, langunit, inifileunit,
    ConfigPortDialogUnit, authconfigdialogunit;

{$R *.res}

begin
    RequireDerivedFormResource := True;
    Application.Initialize;
    Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TConfigPortDialog, ConfigPortDialog);
    Application.CreateForm(TAuthConfigDialogForm, AuthConfigDialogForm);
    Application.Run;
end.

