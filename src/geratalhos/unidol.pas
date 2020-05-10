unit unidOL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FGL;

type
  TOrgaoLocal = class(TObject)
  private
    FCodigo: String;
    FMaquinaPrisma: String;
    FNomeExibicao: String;
    FNomeInterno: String;
    function GetCodigo: String;
    function GetNomeExibicao: String;
    function GetNomeInterno: String;
    function GetMaquinaPrisma: String;
    procedure SetCodigo(Value: String);
    procedure SetMaquinaPrisma(Value: String);
    procedure SetNomeExibicao(Value: String);
    procedure SetNomeInterno(Value: String);
  public
     property Codigo: String read GetCodigo write SetCodigo;
     property MaquinaPrisma: String read GetMaquinaPrisma write SetMaquinaPrisma;
     property NomeExibicao: String read GetNomeExibicao write SetNomeExibicao;
     property NomeInterno: String read GetNomeInterno write SetNomeInterno;
  end;

  TListaOrgaosLocais = specialize TFPGObjectList<TOrgaoLocal>;

  TOrgaosLocais = class(TObject)
  private
    FArquivo: String;
    FNome: String;
    FLista: TListaOrgaosLocais;
    function GetArquivo: String;
    function GetNome: String;
  public
    constructor Create(AArquivo: String; ANome: String);
    destructor Destroy; override;
    function Carregar: Boolean;
    property Arquivo: String read GetArquivo;
    property Lista: TListaOrgaosLocais read FLista;
    property Nome: String read GetNome;
  end;

implementation

uses CSVDocument;

function TOrgaoLocal.GetCodigo: String;
begin
  Result := FCodigo;
end;

function TOrgaoLocal.GetMaquinaPrisma: String;
begin
  Result := FMaquinaPrisma;
end;

function TOrgaoLocal.GetNomeExibicao: String;
begin
  Result := FNomeExibicao;
end;

function TOrgaoLocal.GetNomeInterno: String;
begin
  Result := FNomeInterno;
end;

procedure TOrgaoLocal.SetCodigo(Value: String);
begin
  if Value <> FCodigo then
    FCodigo := Value;
end;

procedure TOrgaoLocal.SetMaquinaPrisma(Value: String);
begin
  if Value <> FMaquinaPrisma then
    FMaquinaPrisma := Value;
end;

procedure TOrgaoLocal.SetNomeExibicao(Value: String);
begin
  if Value <> FNomeExibicao then
    FNomeExibicao := Value;
end;

procedure TOrgaoLocal.SetNomeInterno(Value: String);
begin
  if Value <> FNomeInterno then
    FNomeInterno := Value;
end;

{ TORGAOSLOCAIS }

constructor TOrgaosLocais.Create(AArquivo: String; ANome: String);
begin
  inherited Create;
  FLista := TListaOrgaosLocais.Create;
  FArquivo := AArquivo;
  FNome := ANome;
end;

destructor TOrgaosLocais.Destroy;
var
  I: Integer;
begin
  if Assigned(FLista) then
    FLista.Free;

  inherited;
end;

function TOrgaosLocais.Carregar: Boolean;
var
  i: Integer;
  DocumentoCSV: TCSVDocument;
  OL: TOrgaoLocal;
begin
  if not FileExists(FArquivo) then
    Exit(false);
  DocumentoCSV := TCSVDocument.Create;
  try
    DocumentoCSV.Delimiter := ';';
    DocumentoCSV.LoadFromFile(FArquivo);
    for i := 0 to DocumentoCSV.RowCount - 1 do
    begin
      OL := TOrgaoLocal.Create();
      OL.MaquinaPrisma := DocumentoCSV.Cells[0, I];
      OL.NomeExibicao := DocumentoCSV.Cells[1, I];
      OL.Codigo := DocumentoCSV.Cells[2, I];
      FLista.Add(OL);
    end;
    Result := True;
  finally
    DocumentoCSV.Free;
  end;
end;

function TOrgaosLocais.GetArquivo: String;
begin
  Result := FArquivo;
end;

function TOrgaosLocais.GetNome: String;
begin
  Result := FNome;
end;

end.
