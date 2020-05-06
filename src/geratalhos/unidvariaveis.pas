unit unidVariaveis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TVariaveis = class(TObject)
  private
    FArquivoConfig: String;
    FArquivoDescricao: String;
    FModeloConfig: String;
    FPastaApp: String;
    FPastaConfig: String;
    FPastaDados: String;
    FPastaModelos: String;
    FPastaTemas: String;
    function GetArquivoConfig: String;
    function GetArquivoDescricao: String;
    function GetModeloConfig: String;
    function GetPastaApp: String;
    function GetPastaConfig: String;
    function GetPastaDados: String;
    function GetPastaModelos: String;
    function GetPastaTemas: String;
  public
    constructor Create;
    property ArquivoConfig: String read GetArquivoConfig;
    property ArquivoDescricao: String read GetArquivoDescricao;
    property ModeloConfig: String read GetModeloConfig;
    property PastaApp: String read GetPastaApp;
    property PastaConfig: String read GetPastaConfig;
    property PastaDados: String read GetPastaDados;
    property PastaModelos: String read GetPastaModelos;
    property PastaTemas: String read GetPastaTemas;
  end;

var
  Variaveis: TVariaveis;

implementation

uses Forms, ShlObj;

constructor TVariaveis.Create;
const
  LOCAL_CONFIG = '\Aplicações do INSS\Gerador de Atalhos do Prisma\';
var
  AppData: Array[0..MaxPathLen] of Char;
begin
  inherited;

  AppData := '';
  SHGetSpecialFolderPath(0, AppData, CSIDL_LOCAL_APPDATA, false);
  FArquivoConfig := 'CONFIG.INI';
  FArquivoDescricao := 'DESC.INFO';
  FModeloConfig := 'CONFIG.PRC';
  FPastaApp := ExtractFilePath(Application.ExeName);
  FPastaConfig := AppData + LOCAL_CONFIG;
  FPastaDados := FPastaApp + 'dados\';
  FPastaModelos := FPastaApp + 'modelos\';
  FPastaTemas := FPastaApp + 'temas\';
end;

function TVariaveis.GetArquivoConfig: String;
begin
  Result := FArquivoConfig;
end;

function TVariaveis.GetArquivoDescricao: String;
begin
  Result := FArquivoDescricao;
end;

function TVariaveis.GetModeloConfig: String;
begin
  Result := FModeloConfig;
end;

function TVariaveis.GetPastaApp: String;
begin
  Result := FPastaApp;
end;

function TVariaveis.GetPastaConfig: String;
begin
  Result := FPastaConfig;
end;

function TVariaveis.GetPastaDados: String;
begin
  Result := FPastaDados;
end;

function TVariaveis.GetPastaModelos: String;
begin
  Result := FPastaModelos;
end;

function TVariaveis.GetPastaTemas: String;
begin
  Result := FPastaTemas;
end;


end.

