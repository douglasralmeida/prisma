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
    function ExtractFileToDisk(AFileName, ADest: String): Boolean;
    function ExtractFileToString(AFileName: String): String;
    function Open(AFileName: String): Boolean;
    property FileName: String read GetFileName;
  end;

implementation

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


const BUFFER_SIZE = 8192;

function TZipFile.ExtractFile(AFileName: String): TMemoryStream;
var
  buffer: Array[0..BUFFER_SIZE - 1] of Byte;
  buffsize: Cardinal;
  data: TMemoryStream;
  error: LongInt;
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
    data.Size := Int64(info.uncompressed_size);
//    if data.Size < BUFFER_SIZE then
//      buffsize := Cardinal(data.Size)
//    else
      buffsize := BUFFER_SIZE;
    data.Position := 0;
    repeat
      error := unzReadCurrentFile(FFile, @buffer, buffsize);
      if error < 0 then
      begin
        data.Free;
        Exit(nil);
      end;
      if error > 0 then
        data.Write(buffer, error);
    until (error = 0);
    data.Position := 0;
    Result := data;
  finally
    unzCloseCurrentFile(FFile);
  end;
end;

function TZipFile.ExtractFileToDisk(AFileName, ADest: String): boolean;
var
  stream: TMemoryStream;
  teste: string;
begin
  stream := ExtractFile(AFileName);
  if stream = nil then
    Exit(false);
  try
    stream.SaveToFile(ADest);
    Result := FileExists(ADest);
  finally
    stream.Free;
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

