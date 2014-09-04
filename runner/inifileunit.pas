unit inifileunit;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, regexpr;

type
    TIniFile = class

    public
        List: TStringList;
        FileName: string;

        constructor Create(filePath: string = '');
        destructor Destroy;
        procedure Free();

        function Load(filePath: string = ''): Boolean;
        function Get(key: string; defaultValue: string = ''): string; overload;
        function Get(section: string; key: string; defaultValue: string): string; overload;

    end;

implementation

constructor TIniFile.Create(filePath: string = '');
begin
    List            := TStringList.Create;
    List.Sorted     := True;
    List.Duplicates := dupIgnore;

    if filePath <> '' then Load(filePath);
end;

destructor TIniFile.Destroy;
begin
    List.Free;
    Inherited Destroy;
end;

procedure TIniFile.Free();
begin
    if Self <> Nil then Destroy;
end;

function TIniFile.Load(filePath: string = ''): Boolean;
var
    fileLines                    : TStringList;
    sectionRegex, nameValueRegex : TRegExpr;
    i                            : integer;
    line, section                : string;
begin
    if filePath <> '' then FileName := filePath;

    Result := False;
    fileLines := TStringList.Create;
    try
        fileLines.LoadFromFile(filePath);
        if fileLines.Count > 0 then begin
            List.Clear;
            sectionRegex              := TRegExpr.Create;
            sectionRegex.Expression   := '\[(.+)\]';
            nameValueRegex            := TRegExpr.Create;
            nameValueRegex.Expression := '(\w+)\s*=\s*(.*)';
            section                   := '';

            for i := 0 to (fileLines.Count - 1) do
            begin
                line := Trim(fileLines[i]);

                if (Pos(';', line) = 1) or (Pos('#', line) = 1) then continue;

                if sectionRegex.Exec(line) then begin
                    section := sectionRegex.Match[1];
                end else if nameValueRegex.Exec(line) then begin
                    List.Values[section + '/' + nameValueRegex.Match[1]] := nameValueRegex.Match[2];
                end;
            end;

            sectionRegex.Free;
            nameValueRegex.Free;

            Result := True;
        end;
    except 
        
    end;
    fileLines.Free;
end;

function TIniFile.Get(key: string; defaultValue: string = ''): string; overload;
begin
    Result := List.Values[key];
    if Result = '' then Result := defaultValue;
end;

function TIniFile.Get(section: string; key: string; defaultValue: string): string; overload;
begin
    Result := List.Values[section + '/' + key];
    if Result = '' then Result := defaultValue;
end;

end.

