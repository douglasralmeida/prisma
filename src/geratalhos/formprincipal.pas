unit formPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, ListViewFilterEdit, FGL, unidOL, unidTemas, EditBtn, Menus,
  ActnList;

type
  { TJanelaPrincipal }
  TJanelaPrincipal = class(TForm)
    AcaoOLAdicionar: TAction;
    AcaoOLSelecionarTudo: TAction;
    AcaoOLInverterSelecao: TAction;
    AcaoOLRemover: TAction;
    AcaoOLRemoverTudo: TAction;
    ImagemTema: TImage;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListaImagens16: TImageList;
    ListaAcoes: TActionList;
    BotaoVoltar: TButton;
    BotaoAvancar: TButton;
    BotaoAdicionar: TButton;
    BotaoRemover: TButton;
    BotaoRemoverTudo: TButton;
    Caderno: TNotebook;
    checExecutar: TCheckBox;
    EditFiltro: TListViewFilterEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListaMaquinas: TListView;
    ListaTemas: TListView;
    ListaAdicionadas: TListView;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    MenuListaAdicionadas: TPopupMenu;
    PaginaDois: TPage;
    PaginaSplash: TPage;
    PaginaUm: TPage;
    PainelConteudo: TPanel;
    ListaImagens32: TImageList;
    PainelRodape: TPanel;
    MenuListaOLs: TPopupMenu;
    RotuloCarregando: TLabel;
    procedure AcaoOLAdicionarExecute(Sender: TObject);
    procedure AcaoOLInverterSelecaoExecute(Sender: TObject);
    procedure AcaoOLRemoverExecute(Sender: TObject);
    procedure AcaoOLRemoverTudoExecute(Sender: TObject);
    procedure AcaoOLSelecionarTudoExecute(Sender: TObject);
    procedure BotaoVoltarClick(Sender: TObject);
    procedure BotaoAvancarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListaAdicionadasDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListaAdicionadasDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListaAdicionadasSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListaMaquinasDblClick(Sender: TObject);
    procedure ListaMaquinasDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListaMaquinasDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListaMaquinasSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListaTemasSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    ListaOLs: TOrgaosLocais;
    ListaOLAdicionadas: TListaSimplesOrgaosLocais;
    ProgramaIniciado: Boolean;
    Temas: TTemas;
    function CarregarOLs: Boolean;
    function CarregarTemas: Boolean;
    function CarregarRecursos: Boolean;
  public

  protected

  end;

const
  VersaoBeta = False;

var
  JanelaPrincipal: TJanelaPrincipal;
  TemaSelecionado: TTema;

implementation

uses
  unidConfig, unidPrisma, unidVariaveis, unidUtils;

{$R *.lfm}

const
  ARQUIVO_OLS = 'LISTAOL.CSV';

{ TJanelaPrincipal }

procedure TJanelaPrincipal.AcaoOLAdicionarExecute(Sender: TObject);
var
  OL: TOrgaoLocal;
  Item: TListItem;
  NovoItem: TListItem;
begin
  Item := ListaMaquinas.Selected;
  ListaAdicionadas.BeginUpdate;
  try
    while Item <> nil do
    begin
      OL := TOrgaoLocal(Item.Data);
      if ListaOLAdicionadas.IndexOf(OL) = -1 then
      begin
        ListaOLAdicionadas.Add(OL);
        NovoItem := ListaAdicionadas.Items.Add;
        NovoItem.Caption := OL.NomeExibicao;
        NovoItem.Data := OL;
        NovoItem.ImageIndex := 0;
      end;
      Item := ListaMaquinas.GetNextItem(Item, sdBelow, [lisSelected]);
    end;
  finally
    ListaAdicionadas.EndUpdate;
  end;
end;

procedure TJanelaPrincipal.AcaoOLInverterSelecaoExecute(Sender: TObject);
var
  Lista: TListView;
  Item: TListItem;
begin
  if ListaMaquinas.Focused then
    Lista := ListaMaquinas
  else if ListaAdicionadas.Focused then
    Lista := ListaAdicionadas
  else
    Exit;
  for Item in Lista.Items do
    Item.Selected := not Item.Selected;
end;

procedure TJanelaPrincipal.AcaoOLRemoverExecute(Sender: TObject);
var
  I: Integer;
  Item: TListItem;
begin
  if ListaAdicionadas.SelCount > 0 then
  begin
    ListaAdicionadas.BeginUpdate;
    try
      I := ListaAdicionadas.Items.Count - 1;
      repeat
        Item := ListaAdicionadas.Items[I];
        if Item.Selected then
        begin
          ListaOLAdicionadas.Delete(I);
          ListaAdicionadas.Items.Delete(I);
        end;
        Dec(I);
      until I = -1;
    finally
      ListaAdicionadas.EndUpdate;
    end;
    ListaAdicionadasSelectItem(Sender, nil, false);
  end;
end;

procedure TJanelaPrincipal.AcaoOLRemoverTudoExecute(Sender: TObject);
begin
  ListaAdicionadas.BeginUpdate;
  try
    ListaOLAdicionadas.Clear;
    ListaAdicionadas.Clear;
  finally
    ListaAdicionadas.EndUpdate;
  end;
  ListaAdicionadasSelectItem(Sender, nil, false);
end;

procedure TJanelaPrincipal.AcaoOLSelecionarTudoExecute(Sender: TObject);
var
  Lista: TListView;
begin
  if ListaMaquinas.Focused then
    Lista := ListaMaquinas
  else if ListaAdicionadas.Focused then
    Lista := ListaAdicionadas
  else
    Exit;
  Lista.SelectAll;
end;

procedure TJanelaPrincipal.BotaoAvancarClick(Sender: TObject);
var
  AtalhoPrisma: TAtalhoPrisma;
begin
  if Caderno.PageIndex = 0 then
  begin
    if ListaAdicionadas.Items.Count = 0 then
    begin
      ExibirMensagemErro('Adicione, pelo menos, uma APS na lista antes de avançar.');
      Exit;
    end;
    BotaoVoltar.Enabled := true;
    BotaoAvancar.Caption := '&Gerar';
    Caderno.PageIndex := 1;
    if ListaTemas.CanFocus then
       ListaTemas.SetFocus;
  end
  else
  begin
    if ListaTemas.ItemIndex < 0 then
    begin
      ExibirMensagemErro('Selecione um tema da lista antes de gerar.');
      Exit;
    end;
    TemaSelecionado := Temas.Lista[ListaTemas.ItemIndex];
    AtalhoPrisma := TAtalhoPrisma.Create;
    try
      AtalhoPrisma.Maquinas := ListaOLAdicionadas;
      AtalhoPrisma.Tema := TemaSelecionado;
    except
      on E: Exception do
      begin
        ExibirMensagemErro(E.Message, E.HelpContext);
        AtalhoPrisma.Free;
        Exit;
      end;
    end;
    try
      AtalhoPrisma.Gerar;
      if checExecutar.Checked then
        AtalhoPrisma.AbrirEmulador;
    finally
      AtalhoPrisma.Free;
    end;
    Close;
  end;
end;

procedure TJanelaPrincipal.BotaoVoltarClick(Sender: TObject);
begin
  BotaoVoltar.Enabled := false;
  BotaoAvancar.Caption := '&Avançar';
  Caderno.PageIndex := 0;
  if EditFiltro.CanFocus then
     EditFiltro.SetFocus;
end;

function TJanelaPrincipal.CarregarOLs: Boolean;

  procedure AdicionarFiltro(Lista: TListViewDataList; Rotulos: Array of String; Valor: TOrgaoLocal);
  var
    Dado: TListViewDataItem;
  begin
    SetLength(Dado.StringArray, 3);
    Dado.StringArray[0] := Rotulos[0];
    Dado.StringArray[1] := Rotulos[1];
    Dado.StringArray[2] := Rotulos[2];
    Dado.Data := Valor;
    Dado.ImageIndex := 0;
    Lista.Add(Dado);
  end;

var
  OL: TOrgaoLocal;
begin
  Result := false;
  ListaOLs := TOrgaosLocais.Create(ARQUIVO_OLS, 'Todos os OLs');
  ListaOLAdicionadas := TListaSimplesOrgaosLocais.Create;
  Result := ListaOLs.Carregar;
  if Result then
    for OL in ListaOLs do
      if OL.MaquinaPrisma <> 'NAOCADASTRADO' then
        AdicionarFiltro(EditFiltro.Items, [OL.NomeExibicao, OL.Codigo, OL.MaquinaPrisma], OL);
  EditFiltro.InvalidateFilter;
end;

function TJanelaPrincipal.CarregarRecursos: Boolean;
var
  Icone: TIcon;
begin
  Icone := TIcon.Create;
  try
    Icone.LoadFromResourceID(HInstance, 1002);
    ListaImagens32.AddIcon(Icone);
  finally
    Icone.Free;
  end;
  Result := true;
end;

function TJanelaPrincipal.CarregarTemas: Boolean;
var
  Item: TListItem;
  Tema: TTema;
begin
  Temas := TTemas.Create;
  Result := Temas.Carregar;
  if Result then
    for Tema in Temas.Lista do
    begin
      Item := ListaTemas.Items.Add;
      Item.Caption := Tema.Nome;
      Item.ImageIndex := 0;
    end;
end;

procedure TJanelaPrincipal.FormActivate(Sender: TObject);
const
  MSG_BETA = 'Esta é uma versão de pré-lançamento de um programa de computador que ainda não foi totalmente testado.';
  DESC_BETA = 'Este programa deve ser utilizado para fins de teste e avaliação. Falhas e erros inesperados poderão ocorrer sem que haja uma forma de você contornar.';
begin
  if not ProgramaIniciado then
  begin
    ProgramaIniciado := true;
    Application.ProcessMessages;
    CarregarRecursos;
    Variaveis := TVariaveis.Create;
    try
      Configuracoes := TConfiguracoes.Create;
    except
      on E: Exception do
      begin
        ExibirMensagemErro(E.Message, E.HelpContext);
        Close;
      end;
    end;
    if not CarregarOLs then
    begin
      ExibirMensagemErro('Erro ao carregar o banco de dados de órgãos locais.', 0);
      Close;
    end;
    if not CarregarTemas then
    begin
      ExibirMensagemErro('Erro ao carregar o conjunto de temas disponíveis.', 0);
      Close;
    end;
    if VersaoBeta then
       Sleep(1000);
    if VersaoBeta and Configuracoes.ExibirMsgBeta then
    begin
      Caption := Caption + ' *** VERSÃO DE TESTES ***';
      Configuracoes.ExibirMsgBeta := not ExibirMensagemInfo(MSG_BETA, DESC_BETA, true);
    end;
    Caderno.PageIndex := 0;
    PainelRodape.Show;
    if EditFiltro.CanFocus then
       EditFiltro.SetFocus;
  end;
end;

procedure TJanelaPrincipal.FormCreate(Sender: TObject);
begin
  ProgramaIniciado := false;
  Icon.LoadFromResourceID(HInstance, 1001);
  Caderno.PageIndex := 2;
  RotuloCarregando.Left := Width div 2 - RotuloCarregando.Width div 2;
end;

procedure TJanelaPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(Configuracoes) then
    Configuracoes.Free;
  if Assigned(Variaveis) then
    Variaveis.Free;
  if Assigned(Temas) then
    Temas.Free;
  if Assigned(ListaOLAdicionadas) then
    ListaOLAdicionadas.Free;
  if Assigned(ListaOLs) then
    ListaOLs.Free;
end;

procedure TJanelaPrincipal.ListaAdicionadasDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  AcaoOLAdicionar.Execute;
end;

procedure TJanelaPrincipal.ListaAdicionadasDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListaMaquinas;
end;

procedure TJanelaPrincipal.ListaAdicionadasSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  AcaoOLRemover.Enabled := ListaAdicionadas.SelCount > 0;
end;

procedure TJanelaPrincipal.ListaMaquinasDblClick(Sender: TObject);
begin
  if ListaMaquinas.SelCount > 0 then
    AcaoOLAdicionar.Execute;
end;

procedure TJanelaPrincipal.ListaMaquinasDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  AcaoOLRemover.Execute;
end;

procedure TJanelaPrincipal.ListaMaquinasDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListaAdicionadas;
end;

procedure TJanelaPrincipal.ListaMaquinasSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  AcaoOLAdicionar.Enabled := ListaMaquinas.SelCount > 0;
end;

procedure TJanelaPrincipal.ListaTemasSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  ImagemTema.Picture.Clear;
  if ListaTemas.SelCount > 0 then
  begin

  end;
end;

end.
