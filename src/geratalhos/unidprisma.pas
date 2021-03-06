unit unidPrisma;

{$mode objfpc}{$H+}

interface

uses
  Classes, IniFiles, SysUtils, unidOL, unidTemas;

type
  TAtalhoPrisma = class(TObject)
  private
    Arquivo: String;
    FArquivoIni: TMemIniFile;
    FID: Cardinal;
    FMaquinas: TListaSimplesOrgaosLocais;
    FModeloPrisma: String;
    FTema: TTema;
    function GerarAtalho(Setor: String): Boolean;
    function GetMaquinas: TListaSimplesOrgaosLocais;
    function GetTema: TTema;
    procedure ProcessarMaquinaPrisma(Maquina, Setor: String);
    procedure ProcessarPlanoFundo(Codigo: String);
    procedure ProcessarTema;
    function SalvarArquivo(Codigo: String): Boolean;
    procedure SetTema(Value: TTema);
    procedure SetMaquinas(Value: TListaSimplesOrgaosLocais);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AbrirEmulador;
    procedure Gerar;
    property Maquinas: TListaSimplesOrgaosLocais read GetMaquinas write SetMaquinas;
    property Tema: TTema read GetTema write SetTema;
  end;

implementation

uses
  ActiveX, ComObj, LClIntf, LConvEncoding, ShlObj, unidConfig,
  unidExcecoes, unidExcecoesLista, unidVariaveis, unidZip;

const
  ARQUIVO_NOME = 'prisma.%s.atcf';
  PLANOFUNDO_NOME = 'planofundo.%s.png';
//  LOCAL_ACCUTERM = 'Atwin71\atwin71.exe';

constructor TAtalhoPrisma.Create;
begin
  inherited Create;

  if not DirectoryExists(Variaveis.PastaPrisma) then
    if not CreateDir(Variaveis.PastaPrisma) then
      raise EProgramaErro.Create(excecaoCriarDirPrisma);
  if not DirectoryExists(Variaveis.PastaPlanosFundos) then
    if not CreateDir(Variaveis.PastaPlanosFundos) then
      raise EProgramaErro.Create(excecaoCriarDirPlanoFundo);
  FModeloPrisma := Variaveis.PastaModelos + Variaveis.ArquivoPrisma;
  if not FileExists(FModeloPrisma) then
    raise EProgramaErro.Create(excecaoObterModeloPrisma);
  FMaquinas := nil;
  FArquivoIni := TMemIniFile.Create(FModeloPrisma);
  FArquivoIni.CacheUpdates := true;
  FID := Configuracoes.ProximoID;
end;

destructor TAtalhoPrisma.Destroy;
begin
  if Assigned(FArquivoIni) then
    FArquivoIni.Free;
end;

procedure TAtalhoPrisma.AbrirEmulador;
begin
  OpenDocument(Arquivo);
end;

procedure TAtalhoPrisma.Gerar;
var
  OL: TOrgaoLocal;
begin
  ProcessarTema;
  for OL in FMaquinas do
  begin
    ProcessarPlanoFundo(OL.Codigo);
    ProcessarMaquinaPrisma(OL.MaquinaPrisma, OL.NomeExibicao);
    if SalvarArquivo(OL.Codigo) then
      GerarAtalho(OL.NomeExibicao);
  end;
end;

function TAtalhoPrisma.GerarAtalho(Setor: String): Boolean;
var
  ArquivoNome: WideString;
  Atalho: WideString;

  IObject: IUnknown;
  ISLink: IShellLinkW;
  IPFile: IPersistFile;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLinkW;
  IPFile := IObject as IPersistFile;
  if Setor.StartsWith('APS', true) then
    Setor := Setor.Substring(3);
  Atalho := WideString(Variaveis.PastaAreaTrabalho + 'Prisma ' + Setor + '.lnk');
  ArquivoNome := WideString(Arquivo);
  with ISLink do begin
    SetDescription(PWideChar('Abre o Prisma'));
    SetIconLocation(PWideChar(WideString(ParamStr(0))), 2);
    SetPath(PWideChar(ArquivoNome));
    ArquivoNome := WideString(ExtractFilePath(Arquivo));
    SetWorkingDirectory(PWideChar(ArquivoNome));
  end;
  if FileExists(Atalho) then
    SysUtils.DeleteFile(Atalho);
  Result := IPFile.Save(PWideChar(Atalho), false) <> S_OK;
end;

function TAtalhoPrisma.GetMaquinas: TListaSimplesOrgaosLocais;
begin
  Result := FMaquinas;
end;

function TAtalhoPrisma.GetTema: TTema;
begin
  Result := FTema;
end;

procedure TAtalhoPrisma.ProcessarMaquinaPrisma(Maquina, Setor: String);
begin
  FArquivoIni.WriteString('Accuterm', 'HostName', Maquina);
  FArquivoIni.WriteString('Accuterm', 'SessionTitle', Setor);
end;

procedure TAtalhoPrisma.ProcessarPlanoFundo(Codigo: String);
var
  ArquivoImagemFundo: String;
  ZipFile: TZipFile;
begin
  ArquivoImagemFundo := Variaveis.PastaPlanosFundos + Format(PLANOFUNDO_NOME, [Codigo]);
  FArquivoIni.WriteString('Accuterm', 'BackgroundTransparency', FTema.ImagemTransparencia);
  if FArquivoIni.ValueExists('Accuterm', 'BackgroundPictureFile') then
    FArquivoIni.DeleteKey('Accuterm', 'BackgroundPictureFile');
  if FTema.ImagemFundo then
  begin
    FArquivoIni.WriteString('Accuterm', 'BackgroundPictureFile', ArquivoImagemFundo);
    ZipFile := TZipFile.Create;
    try
      if ZipFile.Open(FTema.Arquivo) then
      begin
        ZipFile.ExtractFileToDisk('planofundo.png', ArquivoImagemFundo);
        ZipFile.Close;
      end;
    finally
      ZipFile.Free;
    end;
  end;
end;

procedure TAtalhoPrisma.ProcessarTema;
begin
  FArquivoIni.WriteString('Accuterm', 'FontName', FTema.FonteNome);
  FArquivoIni.WriteString('Accuterm', 'FontSize', FTema.FonteTamanho);
  FArquivoIni.WriteString('Accuterm', 'ScaleFont', FTema.FonteEscala);
  FArquivoIni.WriteString('Accuterm', 'AttributeMask', FTema.Mascara);
  FArquivoIni.WriteString('Accuterm', 'BoldFont', FTema.FonteNegrito);

  FArquivoIni.WriteString('Palette', 'Color0', FTema.CorFundo);
  FArquivoIni.WriteString('Palette', 'Color1', FTema.FonteCor);
  FArquivoIni.WriteString('Palette', 'Color2', FTema.CorReverso);
  FArquivoIni.WriteString('Palette', 'Color3', FTema.FonteCorReverso);
  FArquivoIni.WriteString('Palette', 'Color4', FTema.CorBlink);
  FArquivoIni.WriteString('Palette', 'Color5', FTema.FonteCorBlink);
  FArquivoIni.WriteString('Palette', 'Color16', FTema.CorBordaSelecao);
  FArquivoIni.WriteString('Palette', 'Color17', FTema.CorBordaSelecao);

  FArquivoIni.WriteString('Attribute', 'E4', FTema.AtributoE4);
end;

function TAtalhoPrisma.SalvarArquivo(Codigo: String): Boolean;
var
  NovoArquivo: TStringList;
  TextoConvertido: String;
begin
  Arquivo := Variaveis.PastaPrisma + Format(ARQUIVO_NOME, [Codigo]);
  NovoArquivo := TStringList.Create;
  try
    FArquivoIni.GetStrings(NovoArquivo);
    TextoConvertido := ConvertEncoding(NovoArquivo.Text, EncodingUTF8, EncodingAnsi);
    NovoArquivo.Text := TextoConvertido;
    if FileExists(Arquivo) then
      DeleteFile(Arquivo);
    NovoArquivo.SaveToFile(Arquivo);
    Result := FileExists(Arquivo);
  finally
    NovoArquivo.Free;
  end;
end;

procedure TAtalhoPrisma.SetMaquinas(Value: TListaSimplesOrgaosLocais);
begin
  FMaquinas := Value;
end;

procedure TAtalhoPrisma.SetTema(Value: TTema);
begin
  FTema := Value;
end;

end.

