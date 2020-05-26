unit unidConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, IniFiles, SysUtils;

type

  { TConfiguracoes }

  TConfiguracoes = class(TObject)
  private
    FArquivoConf: String;
    FArquivoIni: TIniFile;
    function GetPosicaoX: Integer;
    function GetPosicaoY: Integer;
    function GetProximoID: LongWord;
    function GetExibirMsgBeta: Boolean;
    procedure SetExibirMsgBeta(Value: Boolean);
    procedure SetPosicaoX(Value: Integer);
    procedure SetPosicaoY(Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    property ExibirMsgBeta: Boolean read GetExibirMsgBeta write SetExibirMsgBeta;
    property PosicaoX: Integer read GetPosicaoX write SetPosicaoX;
    property PosicaoY: Integer read GetPosicaoY write SetPosicaoY;
    property ProximoID: Cardinal read GetProximoID;
  end;

var
  Configuracoes: TConfiguracoes;

implementation

uses
  FileUtil, unidExcecoes, unidExcecoesLista, unidVariaveis, unidUtils;

constructor TConfiguracoes.Create;
begin
  inherited;

  PrepararPastaConfig;
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

function TConfiguracoes.GetPosicaoX: Integer;
var
  resultado: Integer;
  valor: String;
begin
  valor := FArquivoIni.ReadString('JANELA', 'PosicaoX', '-1');
  try
    resultado := StrToInt(valor);
  except
    resultado := -1;
  end;
  Result := resultado;
end;

function TConfiguracoes.GetPosicaoY: Integer;
var
  resultado: Integer;
  valor: String;
begin
  valor := FArquivoIni.ReadString('JANELA', 'PosicaoY', '-1');
  try
    resultado := StrToInt(valor);
  except
    resultado := -1;
  end;
  Result := resultado;
end;

function TConfiguracoes.GetProximoID: LongWord;
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

procedure TConfiguracoes.SetPosicaoX(Value: Integer);
begin
  FArquivoIni.WriteInteger('JANELA', 'PosicaoX', Value);
  FArquivoIni.UpdateFile;
end;

procedure TConfiguracoes.SetPosicaoY(Value: Integer);
begin
  FArquivoIni.WriteInteger('JANELA', 'PosicaoY', Value);
  FArquivoIni.UpdateFile;
end;

end.
