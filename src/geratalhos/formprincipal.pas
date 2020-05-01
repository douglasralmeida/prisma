unit formPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, ListViewFilterEdit, FGL, unidOL, EditBtn;

type

  { TJanelaPrincipal }

  TJanelaPrincipal = class(TForm)
    BotaoGerar: TButton;
    BotaoMudar: TButton;
    ComboOLs: TComboBox;
    EditFiltro: TListViewFilterEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ListaMaquinas: TListView;
    ListaTemas: TListView;
    Caderno: TNotebook;
    PaginaDois: TPage;
    PaginaUm: TPage;
    SpeedButton1: TSpeedButton;
    procedure BotaoFecharClick(Sender: TObject);
    procedure BotaoMudarClick(Sender: TObject);
    procedure BotaoGerarClick(Sender: TObject);
    procedure ComboOLsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function CarregarGrupos: Boolean;
    function CarregarOLs: Boolean;
  public

  protected

  end;

  TCategorias = specialize TFPGObjectList<TOrgaosLocais>;

const
  PastaDados = 'dados\';

var
  JanelaPrincipal: TJanelaPrincipal;
  PastaApp: String;
  ListaCategorias: TCategorias;

implementation

uses
  UxTheme, unidUtils;

{$R *.lfm}

{ TJanelaPrincipal }

procedure TJanelaPrincipal.BotaoGerarClick(Sender: TObject);
begin
  ExibirMensagemErro('Recurso não implementado.');
end;

procedure TJanelaPrincipal.ComboOLsChange(Sender: TObject);

  procedure AdicionarFiltro(Lista: TListViewDataList; Rotulos: Array of String);
  var
    Dado: TListViewDataItem;
  begin
    Dado.Data := nil;
    SetLength(Dado.StringArray, 2);
    Dado.StringArray[0] := Rotulos[0];
    Dado.StringArray[1] := Rotulos[1];
    Lista.Add(Dado);
  end;

var
  I: Integer;
begin
  if ComboOLs.ItemIndex > - 1 then
  begin
    EditFiltro.Items.Clear;
    EditFiltro.BeginUpdateBounds;
    for I := 0 to ListaCategorias[ComboOLs.ItemIndex].Lista.Count - 1 do
    begin
      AdicionarFiltro(EditFiltro.Items, [
        ListaCategorias[ComboOLs.ItemIndex].Lista[I].NomeExibicao,
        ListaCategorias[ComboOLs.ItemIndex].Lista[I].Codigo
      ]);
    end;
    EditFiltro.EndUpdateBounds;
  end;
  EditFiltro.InvalidateFilter;
end;

procedure TJanelaPrincipal.BotaoMudarClick(Sender: TObject);
begin
  if Caderno.PageIndex = 0 then
  begin
    if ListaMaquinas.ItemIndex < 0 then
    begin
      ExibirMensagemErro('Selecione uma APS da lista antes de avançar.');
      Exit;
    end;

    Caderno.PageIndex := 1;
    BotaoMudar.Caption := '&Voltar';
    BotaoMudar.Default := false;
    BotaoGerar.Caption := '&Gerar';
    BotaoGerar.Enabled := true;
    BotaoGerar.Default := true;
    if ListaTemas.CanFocus then
       ListaTemas.SetFocus;
  end
  else
  begin
    Caderno.PageIndex := 0;
    BotaoMudar.Caption := '&Avançar';
    BotaoMudar.Default := true;
    BotaoGerar.Caption := 'Cancelar';
    BotaoGerar.Enabled := false;
    BotaoGerar.Default := false;
    if ComboOLs.CanFocus then
       ComboOLs.SetFocus;
  end;
end;

procedure TJanelaPrincipal.BotaoFecharClick(Sender: TObject);
begin
  close;
end;

function TJanelaPrincipal.CarregarGrupos: Boolean;
const
  DESCARQUIVO = 'DESC.TXT';
var
  I: Integer;
  Dados: TStringList;
  Categoria: TOrgaosLocais;
  Nome: String;
  Arquivo: String;
begin
  try
    Dados := TStringList.Create;
    Dados.LoadFromFile(PastaApp + PastaDados + DESCARQUIVO);
    for I := 0 to Dados.Count - 1 do
    begin
      Nome := LeftStr(Dados[I], Pos(',', Dados[I]) - 1);
      Arquivo := RightStr(Dados[I], Dados[I].Length - Pos(',', Dados[I]));
      Categoria := TOrgaosLocais.Create(PastaApp + PastaDados + Arquivo, Nome);
      ListaCategorias.Add(Categoria);
      ComboOLs.Items.Add(Nome);
    end;
    Result := true;
  finally
    Dados.Free;
  end;
end;

function TJanelaPrincipal.CarregarOLs: Boolean;
var
  I: Integer;
begin
  try
    for I := 0 to ListaCategorias.Count - 1 do
    begin
      ListaCategorias[I].Carregar;
    end;
    Result := true;
  finally

  end;
end;

procedure TJanelaPrincipal.FormCreate(Sender: TObject);
begin
  Caderno.PageIndex := 0;
  ListaCategorias := TCategorias.Create;
end;

procedure TJanelaPrincipal.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(ListaCategorias) then
  begin
    for I := 0 to ListaCategorias.Count - 1 do
      ListaCategorias[I].Free;
//    ListaCategorias.Free;
  end;
end;

procedure TJanelaPrincipal.FormShow(Sender: TObject);
begin
  PastaApp := ExtractFilePath(Application.ExeName);
  if not CarregarGrupos then
    Exit;
  if not CarregarOLs then
    Exit;
  if ComboOLs.CanFocus then
     ComboOLs.SetFocus;

end;

end.

