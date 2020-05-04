unit formPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, ListViewFilterEdit, FGL, unidOL, unidTemas, EditBtn;

type

  { TGrupoOrgaosLocais }
  TGrupoOrgaosLocais = specialize TFPGObjectList<TOrgaosLocais>;

  { TJanelaPrincipal }
  TJanelaPrincipal = class(TForm)
    BotaoGerar: TButton;
    BotaoMudar: TButton;
    ComboOLs: TComboBox;
    EditFiltro: TListViewFilterEdit;
    Image1: TImage;
    ListaImagens: TImageList;
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
    PastaApp: String;
    GruposOLs: TGrupoOrgaosLocais;
    Temas: TTemas;
    function CarregarGrupos: Boolean;
    function CarregarOLs: Boolean;
    function CarregarTemas: Boolean;
  public

  protected

  end;

const
  DESC_ARQUIVO = 'DESC.TXT';
  PASTA_DADOS = 'dados\';
  PASTA_TEMAS = 'temas\';

var
  JanelaPrincipal: TJanelaPrincipal;
  TemaSelecionado: TTema;
  MaqinaPrismaSelecionada: string;

implementation

uses
  UxTheme, unidUtils;

{$R *.lfm}

{ TJanelaPrincipal }

procedure TJanelaPrincipal.BotaoGerarClick(Sender: TObject);
begin
  if ListaTemas.ItemIndex < 0 then
  begin
    ExibirMensagemErro('Selecione um tema da lista antes de gerar.');
    Exit;
  end;
  TemaSelecionado := Temas.Lista[ListaTemas.ItemIndex];
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
  OL: TOrgaoLocal;
begin
  if ComboOLs.ItemIndex > - 1 then
  begin
    EditFiltro.Items.Clear;
    EditFiltro.BeginUpdateBounds;
    for OL in GruposOLs[ComboOLs.ItemIndex].Lista do
      AdicionarFiltro(EditFiltro.Items, [OL.NomeExibicao, OL.Codigo]);
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
    MaqinaPrismaSelecionada := ListaMaquinas.Selected.SubItems[0];

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
var
  Dados: TStringList;
  Nome: String;
  Arquivo: String;
  Grupo: String;
begin
  Dados := TStringList.Create;
  try
    Dados.LoadFromFile(PastaApp + PASTA_DADOS + DESC_ARQUIVO);
    for Grupo in Dados do
    begin
      Nome := LeftStr(Grupo, Pos(',', Grupo) - 1);
      Arquivo := RightStr(Grupo, Grupo.Length - Pos(',', Grupo));
      GruposOLs.Add(TOrgaosLocais.Create(PastaApp + PASTA_DADOS + Arquivo, Nome));
      ComboOLs.Items.Add(Nome);
    end;
    Result := true;
  finally
    Dados.Free;
  end;
end;

function TJanelaPrincipal.CarregarOLs: Boolean;
var
  Resultado: Boolean;
  Grupo: TOrgaosLocais;
begin
  Resultado := false;
  for Grupo in GruposOLs do
    Resultado := Grupo.Carregar or Resultado;
  Result := Resultado;
end;

function TJanelaPrincipal.CarregarTemas: Boolean;
var
  Item: TListItem;
  Tema: TTema;
begin
  Temas := TTemas.Create(PastaApp + PASTA_TEMAS);
  Result := Temas.Carregar;
  if Result then
    for Tema in Temas.Lista do
    begin
      Item := ListaTemas.Items.Add;
      Item.Caption := Tema.Nome;
    end;
end;

procedure TJanelaPrincipal.FormCreate(Sender: TObject);
begin
  Caderno.PageIndex := 0;
  GruposOLs := TGrupoOrgaosLocais.Create;
end;

procedure TJanelaPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(GruposOLs) then
    GruposOLs.Free;
  if Assigned(Temas) then
    Temas.Free;
end;

procedure TJanelaPrincipal.FormShow(Sender: TObject);
begin
  PastaApp := ExtractFilePath(Application.ExeName);
  if not CarregarGrupos then
    Exit;
  if not CarregarOLs then
    Exit;
  if not CarregarTemas then
    Exit;
  if ComboOLs.CanFocus then
     ComboOLs.SetFocus;
end;

end.

