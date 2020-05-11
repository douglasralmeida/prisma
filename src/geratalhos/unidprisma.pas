unit unidPrisma;

{$mode objfpc}{$H+}

interface

uses
  Classes, IniFiles, SysUtils, unidTemas;

type
  TAtalhoPrisma = class(TObject)
  private
    FArquivoIni: TMemIniFile;
    FArquivoNome: String;
    FID: Cardinal;
    FNomeMaquinaPrisma: String;
    FNomeSetor: String;
    FModeloPrisma: String;
    FTema: TTema;
    function GerarAtalho: Boolean;
    function GetNomeMaquinaPrisma: String;
    function GetTema: TTema;
    procedure ProcessarMaquinaPrisma;
    procedure ProcessarPlanoFundo;
    procedure ProcessarTema;
    procedure SalvarArquivo;
    procedure SetNomeMaquinaPrisma(Value: String);
    procedure SetTema(Value: TTema);
  public
    constructor Create(ASetor: String);
    destructor Destroy; override;
    procedure Gerar;
    property NomeMaquinaPrisma: String read GetNomeMaquinaPrisma write SetNomeMaquinaPrisma;
    property Tema: TTema read GetTema write SetTema;
  end;

implementation

uses
  ActiveX, ComObj, LConvEncoding, ShlObj, unidConfig, unidExcecoes, unidExcecoesLista,
  unidVariaveis;

const
  ARQUIVO_NOME = 'prisma%u.atcf';
  PLANOFUNDO_NOME = 'planofundo%u.jpg';

constructor TAtalhoPrisma.Create(ASetor: String);
begin
  inherited Create;

  if not DirectoryExists(Variaveis.PastaPrisma) then
    if not CreateDir(Variaveis.PastaPrisma) then
      raise EProgramaErro.Create(excecaoCriarDirPrisma);
  FModeloPrisma := Variaveis.PastaModelos + Variaveis.ArquivoPrisma;
  if not FileExists(FModeloPrisma) then
    raise EProgramaErro.Create(excecaoObterModeloPrisma);
  FNomeSetor := ASetor;
  FArquivoIni := TMemIniFile.Create(FModeloPrisma);
  FArquivoIni.CacheUpdates := true;
  FID := Configuracoes.ProximoID;
end;

destructor TAtalhoPrisma.Destroy;
begin
  if Assigned(FArquivoIni) then
    FArquivoIni.Free;
end;

procedure TAtalhoPrisma.Gerar;
begin
  ProcessarMaquinaPrisma;
  ProcessarTema;
  ProcessarPlanoFundo;
  SalvarArquivo;
  GerarAtalho;
end;

function TAtalhoPrisma.GerarAtalho: Boolean;
var
  ArquivoNome: WideString;
  Atalho: WideString;
  CaminhoAccuterm: WideString;

  IObject: IUnknown;
  ISLink: IShellLinkW;
  IPFile: IPersistFile;
  Setor: String;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLinkW;
  IPFile := IObject as IPersistFile;
  if FNomeSetor.StartsWith('APS', true) then
    Setor := FNomeSetor.Substring(3)
  else
    Setor := FNomeSetor;
  Atalho := WideString(Variaveis.PastaAreaTrabalho + 'Prisma ' + Setor + '.lnk');
  ArquivoNome := WideString(FArquivoNome);
  CaminhoAccuterm := WideString(Variaveis.PastaArqProgx86) + 'Atwin71\atwin71.exe';
  with ISLink do begin
    SetIconLocation(PWideChar(CaminhoAccuterm), 0);
    SetPath(PWideChar(ArquivoNome));
    ArquivoNome := WideString(ExtractFilePath(FArquivoNome));
    SetWorkingDirectory(PWideChar(ArquivoNome));
  end;
  if FileExists(Atalho) then
    DeleteFile(Atalho);
  Result := IPFile.Save(PWideChar(Atalho), false) <> S_OK;
end;

function TAtalhoPrisma.GetNomeMaquinaPrisma: String;
begin
  Result := FNomeMaquinaPrisma;
end;

function TAtalhoPrisma.GetTema: TTema;
begin
  Result := FTema;
end;

procedure TAtalhoPrisma.ProcessarMaquinaPrisma;
begin
  FArquivoIni.WriteString('Accuterm', 'HostName', FNomeMaquinaPrisma);
  FArquivoIni.WriteString('Accuterm', 'SessionTitle', FNomeSetor);
end;

procedure TAtalhoPrisma.ProcessarPlanoFundo;
var
  ArquivoImagemFundo: String;
begin
  ArquivoImagemFundo := Variaveis.PastaPlanosFundos + Format(PLANOFUNDO_NOME, [FID]);
  FArquivoIni.WriteString('Accuterm', 'BackgroundTransparency', FTema.ImagemTransparencia);
  FArquivoIni.WriteString('Accuterm', 'BackgroundPictureMode', FTema.ImagemFundo);
  FArquivoIni.WriteString('Accuterm', 'BackgroundPictureFile', ArquivoImagemFundo);
end;

procedure TAtalhoPrisma.ProcessarTema;
begin
  FArquivoIni.WriteString('Accuterm', 'FontName', FTema.FonteNome);
  FArquivoIni.WriteString('Accuterm', 'FontSize', FTema.FonteTamanho);
  FArquivoIni.WriteString('Accuterm', 'ScaleFont', FTema.FonteEscala);
  FArquivoIni.WriteString('Palette', 'Color0', FTema.CorFundo);
  FArquivoIni.WriteString('Palette', 'Color1', FTema.FonteCor);
end;

procedure TAtalhoPrisma.SalvarArquivo;
var
  NovoArquivo: TStringList;
  TextoConvertido: String;
begin
  FArquivoNome := Variaveis.PastaPrisma + Format(ARQUIVO_NOME, [FID]);
  NovoArquivo := TStringList.Create;
  try
    FArquivoIni.GetStrings(NovoArquivo);
    TextoConvertido := ConvertEncoding(NovoArquivo.Text, EncodingUTF8, EncodingAnsi);
    NovoArquivo.Text := TextoConvertido;
    NovoArquivo.SaveToFile(FArquivoNome);
  finally
    NovoArquivo.Free;
  end;
end;

procedure TAtalhoPrisma.SetNomeMaquinaPrisma(Value: String);
begin
  if Value <> FNomeMaquinaPrisma then
    FNomeMaquinaPrisma := Value;
end;

procedure TAtalhoPrisma.SetTema(Value: TTema);
begin
  FTema := Value;
end;

end.

