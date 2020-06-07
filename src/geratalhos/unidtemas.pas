unit unidTemas;

{$mode objfpc}{$H+}

interface

uses
  Classes, Graphics, SysUtils, FGL;

type
  TTema = class(TObject)
  private
    FArquivo: String;
    FAtributoE4: String;
    FCorFundo: String;
    FCorBlink: String;
    FCorBordaSelecao: String;
    FCorReverso: String;
    FDemonstracao: TPortableNetworkGraphic;
    FFonteCor: String;
    FFonteCorBlink: String;
    FFonteCorReverso: String;
    FFonteEscala: String;
    FFonteNegrito: String;
    FFonteNome: String;
    FFonteTamanho: String;
    FImagemFundo: Boolean;
    FImagemTransparencia: String;
    FImagemArquivo: String;
    FNome: String;
    FMascara: String;
    function GetArquivo: String;
    function GetAtributoE4: String;
    function GetCorFundo: String;
    function GetCorReverso: String;
    function GetCorBlink: String;
    function GetCorBordaSelecao: String;
    function GetDemonstracao: TPortableNetworkGraphic;
    function GetFonteCor: String;
    function GetFonteCorBlink: String;
    function GetFonteCorReverso: String;
    function GetFonteEscala: String;
    function GetFonteNegrito: String;
    function GetFonteNome: String;
    function GetFonteTamanho: String;
    function GetImagemFundo: Boolean;
    function GetImagemTransparencia: String;
    function GetImagemArquivo: String;
    function GetNome: String;
    function GetMascara: String;
  public
    constructor Create(AArquivo: String);
    destructor Destroy; override;
    function Carregar: Boolean;
    property Arquivo: String read GetArquivo;
    property AtributoE4: String read GetAtributoE4;
    property CorFundo: String read GetCorFundo;
    property CorBlink: String read GetCorBlink;
    property CorBordaSelecao: String read GetCorBordaSelecao;
    property CorReverso: String read GetCorReverso;
    property Demonstracao: TPortableNetworkGraphic read GetDemonstracao;
    property FonteCor: String read GetFonteCor;
    property FonteCorBlink: String read GetFonteCorBlink;
    property FonteCorReverso: String read GetFonteCorReverso;
    property FonteEscala: String read GetFonteEscala;
    property FonteNegrito: String read GetFonteNegrito;
    property FonteNome: String read GetFonteNome;
    property FonteTamanho: String read GetFonteTamanho;
    property ImagemFundo: Boolean read GetImagemFundo;
    property ImagemTransparencia: String read GetImagemTransparencia;
    property ImagemArquivo: String read GetImagemArquivo;
    property Nome: String read GetNome;
    property Mascara: String read GetMascara;
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

uses Dialogs, IniFiles, unidVariaveis, unidZip;

constructor TTema.Create(AArquivo: String);
begin
  inherited Create;

  FArquivo := AArquivo;
  FDemonstracao := TPortableNetworkGraphic.Create;
end;

destructor TTema.Destroy;
begin
  if Assigned(FDemonstracao) then
    FDemonstracao.Free;
end;

function TTema.Carregar: Boolean;
var
  StringStream: TStringStream;
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
        StringStream := TStringStream.Create(Texto);
        IniFile := TIniFile.Create(StringStream);
        StringStream.Free;
        FAtributoE4 := IniFile.ReadString('CONTEUDO', 'AtributoE4', '');
        FNome := IniFile.ReadString('INFO', 'Nome', '');
        FCorFundo := IniFile.ReadString('CONTEUDO', 'CorFundo', '');
        FCorBlink := IniFile.ReadString('CONTEUDO', 'CorBlink', '');
        FCorBordaSelecao := IniFile.ReadString('CONTEUDO', 'CorBordaSelecao', '');
        FCorReverso := IniFile.ReadString('CONTEUDO', 'CorReverso', '');
        FFonteCor := IniFile.ReadString('CONTEUDO', 'CorFonte', '');
        FFonteCorBlink := IniFile.ReadString('CONTEUDO', 'CorFonteBlink', '');
        FFonteCorReverso := IniFile.ReadString('CONTEUDO', 'CorFonteReverso', '');
        FFonteEscala := IniFile.ReadString('CONTEUDO', 'EscalaFonte', '');
        FFonteNegrito := IniFile.ReadString('CONTEUDO', 'FonteNegrito', 'False');
        FFonteNome := IniFile.ReadString('CONTEUDO', 'NomeFonte', '');
        FFonteTamanho := IniFile.ReadString('CONTEUDO', 'Tamanho', '');
        FImagemFundo := IniFile.ReadBool('CONTEUDO', 'ImagemFundo', false);
        FImagemTransparencia := IniFile.ReadString('CONTEUDO', 'ImagemTransparencia', '');
        FImagemArquivo := IniFile.ReadString('CONTEUDO', 'ImagemArquivo', '');
        FMascara := IniFile.ReadString('CONTEUDO', 'Mascara', '');
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

function TTema.GetAtributoE4: String;
begin
  Result := FAtributoE4;
end;

function TTema.GetCorFundo: String;
begin
  Result := FCorFundo;
end;

function TTema.GetCorBlink: String;
begin
  Result := FCorBlink;
end;

function TTema.GetCorBordaSelecao: String;
begin
  Result := FCorBordaSelecao;
end;

function TTema.GetCorReverso: String;
begin
  Result := FCorReverso;
end;

function TTema.GetDemonstracao: TPortableNetworkGraphic;
begin
  Result := FDemonstracao;
end;

function TTema.GetFonteCor: String;
begin
  Result := FFonteCor;
end;

function TTema.GetFonteCorBlink: String;
begin
  Result := FFonteCorBlink;
end;

function TTema.GetFonteCorReverso: String;
begin
  Result := FFonteCorReverso;
end;

function TTema.GetFonteEscala: String;
begin
  Result := FFonteEscala;
end;

function TTema.GetFonteNegrito: String;
begin
  Result := FFonteNegrito;
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

function TTema.GetMascara: String;
begin
  Result := FMascara;
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
      NovoTema := TTema.Create(FPasta + Tema);
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
