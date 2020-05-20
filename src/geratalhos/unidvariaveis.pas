unit unidVariaveis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TVariaveis = class(TObject)
  private
    FArquivoConfig: String;
    FArquivoPrisma: String;
    FArquivoDescricao: String;
    FModeloConfig: String;
    FPastaApp: String;
    FPastaAreaTrabalho: String;
    FPastaArqProgx86: String;
    FPastaConfig: String;
    FPastaDados: String;
    FPastaModelos: String;
    FPastaPlanosFundo: String;
    FPastaPrisma: String;
    FPastaTemas: String;
    function GetArquivoConfig: String;
    function GetArquivoPrisma: String;
    function GetArquivoDescricao: String;
    function GetModeloConfig: String;
    function GetPastaApp: String;
    function GetPastaAreaTrabalho: String;
    function GetPastaArqProgx86: String;
    function GetPastaConfig: String;
    function GetPastaDados: String;
    function GetPastaModelos: String;
    function GetPastaPlanosFundo: String;
    function GetPastaPrisma: String;
    function GetPastaTemas: String;
  public
    constructor Create;
    function GetGrupoNome: String;
    function GetAppNome: String;
    property ArquivoConfig: String read GetArquivoConfig;
    property ArquivoDescricao: String read GetArquivoDescricao;
    property ArquivoPrisma: String read GetArquivoPrisma;
    property ModeloConfig: String read GetModeloConfig;
    property PastaApp: String read GetPastaApp;
    property PastaAreaTrabalho: String read GetPastaAreaTrabalho;
    property PastaArqProgx86: String read GetPastaArqProgx86;
    property PastaConfig: String read GetPastaConfig;
    property PastaDados: String read GetPastaDados;
    property PastaModelos: String read GetPastaModelos;
    property PastaPlanosFundos: String read GetPastaPlanosFundo;
    property PastaPrisma: String read GetPastaPrisma;
    property PastaTemas: String read GetPastaTemas;
  end;

var
  Variaveis: TVariaveis;

implementation

uses Forms, ShlObj;

const
  APP_NOME = 'Gerador de Atalhos do Prisma';
  GRUPO_NOME = 'Aplicações do INSS';

constructor TVariaveis.Create;
var
  Pasta: Array[0..MaxPathLen] of Char;
begin
  inherited;

  Pasta := '';
  FArquivoConfig := 'CONFIG.INI';
  FArquivoDescricao := 'DESC.INFO';
  FArquivoPrisma := 'PRISMA.PRM';
  FModeloConfig := 'CONFIG.PRC';
  FPastaApp := ExtractFilePath(Application.ExeName);
  SHGetSpecialFolderPath(0, Pasta, CSIDL_LOCAL_APPDATA, false);
  FPastaConfig := Pasta + '\' + GetGrupoNome + '\' + GetAppNome + '\';
  SHGetSpecialFolderPath(0, Pasta, CSIDL_DESKTOP, false);
  FPastaAreaTrabalho := Pasta + '\';
  SHGetSpecialFolderPath(0, Pasta, CSIDL_PROGRAM_FILESX86, false);
  FPastaArqProgx86 := Pasta + '\';
  FPastaDados := FPastaApp + 'dados\';
  FPastaModelos := FPastaApp + 'modelos\';
  FPastaPrisma := FPastaConfig + 'maquinas\';
  FPastaPlanosFundo := FPastaConfig + '\planosfundo\';
  FPastaTemas := FPastaApp + 'temas\';
end;

function TVariaveis.GetGrupoNome: String;
begin
  Result := GRUPO_NOME;
end;

function TVariaveis.GetAppNome: String;
begin
  Result := APP_NOME;
end;

function TVariaveis.GetArquivoConfig: String;
begin
  Result := FArquivoConfig;
end;

function TVariaveis.GetArquivoDescricao: String;
begin
  Result := FArquivoDescricao;
end;

function TVariaveis.GetArquivoPrisma: String;
begin
  Result := FArquivoPrisma;
end;

function TVariaveis.GetModeloConfig: String;
begin
  Result := FModeloConfig;
end;

function TVariaveis.GetPastaApp: String;
begin
  Result := FPastaApp;
end;

function TVariaveis.GetPastaAreaTrabalho: String;
begin
  Result := FPastaAreaTrabalho;
end;

function TVariaveis.GetPastaArqProgx86: String;
begin
  Result := FPastaArqProgx86;
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

function TVariaveis.GetPastaPlanosFundo: String;
begin
  Result := FPastaPlanosFundo;
end;

function TVariaveis.GetPastaPrisma: String;
begin
  Result := FPastaPrisma;
end;

function TVariaveis.GetPastaTemas: String;
begin
  Result := FPastaTemas;
end;

end.

