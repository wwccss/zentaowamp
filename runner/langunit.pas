unit langunit;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, regexpr;

procedure SetLanguage(langSetting: string = 'zh_cn'; force: Boolean = False);
procedure LoadLang(langSetting: string = 'zh_cn');
function GetLang(key: string; defaultValue: string = ''): string;overload;
function GetLang(section: string; key: string; defaultValue: string): string;overload;

const
    LANG_DIR = 'languages';

var
    lang: TStringList;
    language: string;
    langName: string;

implementation

procedure SetLanguage(langSetting: string = 'zh_cn'; force: Boolean = False);
begin
    if (langSetting <> language) or force then begin
        LoadLang(langSetting);
    end;
end;

procedure LoadLang(langSetting: string = 'zh_cn');
var
    langFile                     : TStringList;
    i                            : integer;
    line, section                : string;
    sectionRegex, nameValueRegex : TRegExpr;
begin
    language := langSetting;
    if not Assigned(lang) then begin
        lang := TStringList.Create;
        lang.Sorted := True;
        lang.Duplicates := dupIgnore;
    end; 

    langFile := TStringList.Create;
    try
        langFile.LoadFromFile(LANG_DIR + '/' + language + '.ini');
        if langFile.Count > 0 then begin
            lang.Clear;
            sectionRegex              := TRegExpr.Create;
            sectionRegex.Expression   := '\[(.+)\]';
            nameValueRegex            := TRegExpr.Create;
            nameValueRegex.Expression := '(\w+)\s*=\s*(.*)';
            section                   := '';
            for i := 0 to (langFile.Count - 1) do
            begin
                line := Trim(langFile[i]);

                if Pos(';', line) = 1 then continue;

                if sectionRegex.Exec(line) then begin
                    section := sectionRegex.Match[1];
                end else if nameValueRegex.Exec(line) then begin
                    lang.Values[section + '/' + nameValueRegex.Match[1]] := nameValueRegex.Match[2];
                end;
            end;
            sectionRegex.Free;
            nameValueRegex.Free;
        end;
        
    finally
    langFile.Free;
    end;
    
    langName := GetLang('lang/name', langSetting);
end;

function GetLang(key: string; defaultValue: string = ''): string;overload;
begin
    Result := lang.Values[key];
    if Result = '' then Result := defaultValue;
end;

function GetLang(section: string; key: string; defaultValue: string): string;overload;
begin
    Result := lang.Values[section + '/' + key];
    if Result = '' then Result := defaultValue;
end;

end.

