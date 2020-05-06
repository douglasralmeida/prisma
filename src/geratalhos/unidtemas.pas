unit unidtemas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FGL;

type
  TTema = class(TObject)
  private
    FArquivo: String;
    FCorFundo: String;
    FFonteCor: String;
    FFonteEscala: String;
    FFonteNome: String;
    FFonteTamanho: String;
    FImagemFundo: String;
    FImagemTransparencia: String;
    FImagemArquivo: String;
    FNome: String;
    function GetArquivo: String;
    function GetCorFundo: String;
    function GetFonteCor: String;
    function GetFonteEscala: String;
    function GetFonteNome: String;
    function GetFonteTamanho: String;
    function GetImagemFundo: String;
    function GetImagemTransparencia: String;
    function GetImagemArquivo: String;
    function GetNome: String;
  public
    constructor Create(AArquivo: String; ANome: String);
    function Carregar: Boolean;
    property Arquivo: String read GetArquivo;
    property CorFundo: String read GetCorFundo;
    property FonteCor: String read GetFonteCor;
    property FonteEscala: String read GetFonteEscala;
    property FonteNome: String read GetFonteNome;
    property FonteTamanho: String read GetFonteTamanho;
    property ImagemFundo: String read GetImagemFundo;
    property ImagemTransparencia: String read GetImagemTransparencia;
    property ImagemArquivo: String read GetImagemArquivo;
    property Nome: String read GetNome;
  end;

  TListaTemas = specialize TFPGObjectList<TTema>;

  TTemas = class(TObject)
  private
    FLista: TListaTemas;
    FPasta: String;
  public
    constructor Create;
    destructor Destroy; override;
    function Carregar: Boolean;
    property Lista: TListaTemas read FLista;
  end;

implementation

//uses ZipFile;

uses Dialogs, IniFiles, unidVariaveis, unidZip;

constructor TTema.Create(AArquivo: String; ANome: String);
begin
  inherited Create;

  FArquivo := AArquivo;
  FNome := ANome;
end;

function TTema.Carregar: Boolean;
var
  IniFile: TIniFile;
  ZipFile: TZipFile;
  Texto: String;
begin
  Result := false;
  if not FileExists(FArquivo) then
    Exit(false);
  ZipFile := TZipFile.Create;
  try
    if ZipFile.Open(FArquivo) then
    begin
      Texto := ZipFile.ExtractFileToString('themedata.ini');
      ZipFile.Close;
      if Texto.Length > 0 then
      begin
        IniFile := TIniFile.Create(TStringStream.Create(Texto));
        FCorFundo := IniFile.ReadString('CONTEUDO', 'CorFundo', '');
        FFonteCor := IniFile.ReadString('CONTEUDO', 'CorFonte', '');
        FFonteEscala := IniFile.ReadString('CONTEUDO', 'EscalaFonte', '');
        FFonteNome := IniFile.ReadString('CONTEUDO', 'NomeFonte', '');
        FFonteTamanho := IniFile.ReadString('CONTEUDO', 'Tamanho', '');
        FImagemFundo := IniFile.ReadString('CONTEUDO', 'ImagemFundo', '');
        FImagemTransparencia := IniFile.ReadString('CONTEUDO', 'ImagemTransparencia', '');
        FImagemArquivo := IniFile.ReadString('CONTEUDO', 'ImagemArquivo', '');
        Result := true;
      end;
    end;
  finally
    if Assigned(IniFile) then
      IniFile.Free;
    ZipFile.Free;
  end;
end;

function TTema.GetArquivo: String;
begin
  Result := FArquivo;
end;

function TTema.GetCorFundo: String;
begin
  Result := FCorFundo;
end;

function TTema.GetFonteCor: String;
begin
  Result := FFonteCor;
end;

function TTema.GetFonteEscala: String;
begin
  Result := FFonteEscala;
end;

function TTema.GetFonteNome: String;
begin
  Result := FFonteNome;
end;

function TTema.GetFonteTamanho: String;
begin
  Result := FFonteTamanho;
end;

function TTema.GetImagemFundo: String;
begin
  Result := FImagemFundo;
end;

function TTema.GetImagemTransparencia: String;
begin
  Result := FImagemTransparencia;
end;

function TTema.GetImagemArquivo: String;
begin
  Result := FImagemArquivo;
end;

function TTema.GetNome: String;
begin
  Result := FNome;
end;

{ TTemas }

constructor TTemas.Create;
begin
  inherited;

  FLista := TListaTemas.Create;
  FPasta := Variaveis.PastaTemas;
end;

destructor TTemas.Destroy;
begin
  if Assigned(FLista) then
    FLista.Free;

  inherited;
end;

function TTemas.Carregar: Boolean;
var
  Arquivo: String;
  ArquivoTemas: TStringList;
  Nome: String;
  NovoTema: TTema;
  Tema: String;
  NomeArquivoTemas: String;
begin
  NomeArquivoTemas := FPasta + Variaveis.ArquivoDescricao;
  if not FileExists(NomeArquivoTemas) then
    Exit(False);
  ArquivoTemas := TStringList.Create;
  try
    ArquivoTemas.LoadFromFile(NomeArquivoTemas);
    for Tema in ArquivoTemas do
    begin
      Nome := LeftStr(Tema, Pos(',', Tema) - 1);
      Arquivo := RightStr(Tema, Tema.Length - Pos(',', Tema));
      NovoTema := TTema.Create(FPasta + Arquivo, Nome);
      if NovoTema.Carregar then
        FLista.Add(NovoTema);
    end;
    Result := true;
  finally
    ArquivoTemas.Free;
  end;
end;

end.

