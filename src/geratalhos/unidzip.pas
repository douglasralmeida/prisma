unit unidZip;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unzip, ZipUtils;

type
  TZipFile = class(TObject)
  private
    FFile: unzFile;
    FOpened: Boolean;
    FFileName: String;
    function GetFileName: String;
  public
    constructor Create;
    function Close: Boolean;
    function ExtractFile(AFileName: String): TMemoryStream;
    function ExtractFileToString(AFileName: String): String;
    function Open(AFileName: String): Boolean;
    property FileName: String read GetFileName;
  end;

implementation

const
  BUFFER_SIZE = 8192;

{ TZipFile }
constructor TZipFile.Create;
begin
  inherited;

  FFile := nil;
  FOpened := false;
  FFileName := '';
end;

function TZipFile.Close: Boolean;
begin
  if FOpened then
    Result := unzClose(FFile) = UNZ_OK
  else
    Result := true;
end;

function TZipFile.ExtractFile(AFileName: String): TMemoryStream;
var
  data: TMemoryStream;
  info: unz_file_info;
begin
  if unzLocateFile(FFile, PChar(AFileName), 2) <> UNZ_OK then
    Exit(nil);
  if unzGetCurrentFileInfo(FFile, @info, nil, 0, nil, 0, nil, 0) <> UNZ_OK then
    Exit(nil);
  if unzOpenCurrentFile(FFile) <> UNZ_OK then
    Exit(nil);
  try
    data := TMemoryStream.Create;
    data.Size := info.uncompressed_size;
    if unzReadCurrentFile(FFile, data.Memory, data.Size) < 0 then
    begin
      data.Free;
      Result := nil;
    end;
    Result := data;
  finally
    unzCloseCurrentFile(FFile);
  end;
end;

function TZipFile.ExtractFileToString(AFileName: String): String;
var
  stream: TMemoryStream;
begin
  stream := ExtractFile(AFileName);
  if stream = nil then
    Exit('');
  try
    SetString(Result, PChar(stream.Memory), stream.Size);
  finally
    stream.Free;
  end;
end;

function TZipFile.GetFileName: String;
begin
  Result := FFileName;
end;

function TZipFile.Open(AFileName: String): Boolean;
begin
  FFile := unzOpen(PChar(AFileName));
  if FFile <> nil then
  begin
    FOpened := true;
    FFileName := AFileName;
  end
  else
  begin
    FOpened := false;
    FFileName := '';
  end;
  Result := FOpened;
end;


end.

