unit unidConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, IniFiles, SysUtils;

type
  TConfiguracoes = class(TObject)
  private
    FArquivoConf: String;
    FArquivoIni: TIniFile;
    function GetProximoID: LongWord;
    function GetExibirMsgBeta: Boolean;
    procedure SetExibirMsgBeta(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property ExibirMsgBeta: Boolean read GetExibirMsgBeta write SetExibirMsgBeta;
    property ProximoID: Cardinal read GetProximoID;
  end;

var
  Configuracoes: TConfiguracoes;

implementation

uses
  FileUtil, unidExcecoes, unidExcecoesLista, unidVariaveis;

constructor TConfiguracoes.Create;
begin
  inherited;

  if not DirectoryExists(Variaveis.PastaConfig) then
    if not CreateDir(Variaveis.PastaConfig) then
      raise EProgramaErro.Create(excecaoCriarDirConfig);
  FArquivoConf := Variaveis.PastaConfig + Variaveis.ArquivoConfig;
  if not FileExists(FArquivoConf) then
    if not CopyFile(Variaveis.PastaModelos + Variaveis.ModeloConfig, FArquivoConf, true) then
      raise EProgramaErro.Create(excecaoCopiarModeloConfig);
  FArquivoIni := TIniFile.Create(FArquivoConf);
end;

destructor TConfiguracoes.Destroy;
begin
  if Assigned(FArquivoIni) then
    FArquivoIni.Free;

  inherited;
end;

function TConfiguracoes.GetExibirMsgBeta: Boolean;
var
  resultado: Boolean;
  valor: String;
begin
  valor := FArquivoIni.ReadString('DADOS', 'MensagemVersaoBeta', 'True');
  try
    resultado := StrToBool(valor);
  except
    resultado := true;
  end;
  Result := resultado;
end;

function TConfiguracoes.GetProximoID: Cardinal;
var
  resultado: Cardinal;
  valor: String;
begin
  valor := FArquivoIni.ReadString('DADOS', 'ProximoID', '1');
  try
    resultado := StrToDWord(valor);
  except
    resultado := 1;
  end;
  Result := resultado;
  if resultado = High(Cardinal) then
    resultado := 1
  else
    resultado := resultado + 1;
  FArquivoIni.WriteString('DADOS', 'ProximoID', Format('%u', [resultado]));
  FArquivoIni.UpdateFile;
end;

procedure TConfiguracoes.SetExibirMsgBeta(Value: Boolean);
begin
  FArquivoIni.WriteBool('DADOS', 'MensagemVersaoBeta', Value);
  FArquivoIni.UpdateFile;
end;

end.
