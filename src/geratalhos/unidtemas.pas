unit unidTemas;

{$mode objfpc}{$H+}

interface

uses
  Classes, Graphics, SysUtils, FGL;

type
  TTema = class(TObject)
  private
    FArquivo: String;
    FCorFundo: String;
    FDemonstracao: TPortableNetworkGraphic;
    FFonteCor: String;
    FFonteEscala: String;
    FFonteNome: String;
    FFonteTamanho: String;
    FImagemFundo: Boolean;
    FImagemTransparencia: String;
    FImagemArquivo: String;
    FNome: String;
    function GetArquivo: String;
    function GetCorFundo: String;
    function GetDemonstracao: TPortableNetworkGraphic;
    function GetFonteCor: String;
    function GetFonteEscala: String;
    function GetFonteNome: String;
    function GetFonteTamanho: String;
    function GetImagemFundo: Boolean;
    function GetImagemTransparencia: String;
    function GetImagemArquivo: String;
    function GetNome: String;
  public
    constructor Create(AArquivo: String; ANome: String);
    destructor Destroy; override;
    function Carregar: Boolean;
    property Arquivo: String read GetArquivo;
    property CorFundo: String read GetCorFundo;
    property Demonstracao: TPortableNetworkGraphic read GetDemonstracao;
    property FonteCor: String read GetFonteCor;
    property FonteEscala: String read GetFonteEscala;
    property FonteNome: String read GetFonteNome;
    property FonteTamanho: String read GetFonteTamanho;
    property ImagemFundo: Boolean read GetImagemFundo;
    property ImagemTransparencia: String read GetImagemTransparencia;
    property ImagemArquivo: String read GetImagemArquivo;
    property Nome: String read GetNome;
  end;

  TListaTemas = specialize TFPGObjectList<TTema>;

  TTemas = class(TObject)
  private
    FLista: TListaTemas;
    FNome: String;
    FPasta: String;
    function GetNome: String;
    function GetQuantidade: Integer;
  public
    constructor Create(ANome: String);
    destructor Destroy; override;
    function Carregar(Pasta: String): Boolean;
    property Lista: TListaTemas read FLista;
    property Nome: String read FNome;
    property Quantidade: Integer read GetQuantidade;
  end;

implementation

uses Dialogs, IniFiles, unidVariaveis, unidUtils, unidZip;

constructor TTema.Create(AArquivo: String; ANome: String);
begin
  inherited Create;

  FArquivo := AArquivo;
  FDemonstracao := TPortableNetworkGraphic.Create;
  FNome := ANome;
end;

destructor TTema.Destroy;
begin
  if Assigned(FDemonstracao) then
    FDemonstracao.Free;
end;

function TTema.Carregar: Boolean;
var
  IniFile: TIniFile;
  ZipFile: TZipFile;
  Texto: String;
  ImgFundo: TMemoryStream;
begin
  Result := false;
  if not FileExists(FArquivo) then
    Exit(false);
  ZipFile := TZipFile.Create;
  try
    if ZipFile.Open(FArquivo) then
    begin
      Texto := ZipFile.ExtractFileToString('themedata.ini');
      ImgFundo := ZipFile.ExtractFile('exemplo.png');
      ZipFile.Close;
      if Assigned(ImgFundo) then
      begin
        FDemonstracao.LoadFromStream(ImgFundo);
      end;
      if Texto.Length > 0 then
      begin
        IniFile := TIniFile.Create(TStringStream.Create(Texto));
        FNome := IniFile.ReadString('INFO', 'Nome', '');
        FCorFundo := IniFile.ReadString('CONTEUDO', 'CorFundo', '');
        FFonteCor := IniFile.ReadString('CONTEUDO', 'CorFonte', '');
        FFonteEscala := IniFile.ReadString('CONTEUDO', 'EscalaFonte', '');
        FFonteNome := IniFile.ReadString('CONTEUDO', 'NomeFonte', '');
        FFonteTamanho := IniFile.ReadString('CONTEUDO', 'Tamanho', '');
        FImagemFundo := IniFile.ReadBool('CONTEUDO', 'ImagemFundo', false);
        FImagemTransparencia := IniFile.ReadString('CONTEUDO', 'ImagemTransparencia', '');
        FImagemArquivo := IniFile.ReadString('CONTEUDO', 'ImagemArquivo', '');
        Result := true;
      end;
    end;
  finally
    if Assigned(IniFile) then
      IniFile.Free;
    if Assigned(ImgFundo) then
      ImgFundo.Free;
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

function TTema.GetDemonstracao: TPortableNetworkGraphic;
begin
  Result := FDemonstracao;
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

function TTema.GetImagemFundo: Boolean;
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

constructor TTemas.Create(ANome: String);
begin
  inherited Create;

  FLista := TListaTemas.Create;
  FNome := ANome;
end;

destructor TTemas.Destroy;
begin
  if Assigned(FLista) then
    FLista.Free;

  inherited;
end;

function TTemas.Carregar(Pasta: String): Boolean;
var
  ArquivoTemas: TStringList;
  NomeArquivoTemas: String;
  NovoTema: TTema;
  DadosTema: TTupla;
  Tema: String;
begin
  FPasta := Pasta;
  NomeArquivoTemas := Pasta + Variaveis.ArquivoDescricao;
  if not FileExists(NomeArquivoTemas) then
    Exit(False);
  ArquivoTemas := TStringList.Create;
  try
    ArquivoTemas.LoadFromFile(NomeArquivoTemas);
    for Tema in ArquivoTemas do
    begin
      DadosTema := SepararTexto(Tema, ',');
      NovoTema := TTema.Create(FPasta + DadosTema.Texto2, DadosTema.Texto1);
      if NovoTema.Carregar then
        FLista.Add(NovoTema)
      else
        NovoTema.Free;
    end;
    Result := true;
  finally
    ArquivoTemas.Free;
  end;
end;

function TTemas.GetNome: String;
begin
  Result := FNome;
end;

function TTemas.GetQuantidade: Integer;
begin
  Result := FLista.Count;
end;

end.

