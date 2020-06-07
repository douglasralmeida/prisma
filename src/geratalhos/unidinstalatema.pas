unit unidInstalaTema;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure InstalarTema(const ArquivoTema: String);

implementation

uses FileUtil, unidExcecoes, unidExcecoesLista, unidVariaveis, unidTemas,
     unidUtils;

function ObterPastaTemasUsuario: String;
begin
  Result := Variaveis.PastaTemasPessoais;
  if not DirectoryExists(Result) then
    if not CreateDir(Result) then
    begin
      Result := '';
      raise EProgramaErro.Create(excecaoCriarDirTemasPess);
    end;
end;

function ObterNomeTema(Arquivo: String): String;
begin
  with TTema.Create(Arquivo) do
    try
      if Carregar then
        Result := Nome
      else
        Result := '';
    finally
      Free;
    end;
end;

procedure InstalarTema(const ArquivoTema: String);
const
  PERGUNTA = 'Você deseja adicionar o tema selecionado à coleção de temas do Prisma?';
  RESPOSTAS: array[0..1] of string = ('Sim, adicionar à coleção.', 'Não, não adicionar à coleção.');
var
  PastaDestino: String;
  ArquivoDestino: String;
  ArquivoTemas: TStringList;
  NomeNovoTema: String;
  EncontrouIgual: Boolean;
  TemaExistente: String;
begin
  //Gera as variáveis necessárias e cria as pastas de configuração
  Variaveis := TVariaveis.Create;
  PrepararPastaConfig;

  //Checa parâmetros e existência do arquivo de tema
  if ArquivoTema.Length = 0 then
    raise EProgramaErro.Create(excecaoParametrosIncorretos);
  if not FileExists(ArquivoTema) then
    raise EProgramaErro.Create(excecaoArquivoNaoExiste);

  //Confirma com o usuário o desejo de instalação do tema
  if ExibirPergunta(PERGUNTA, RESPOSTAS, 1) = 0 then
  begin
    //Verifica o nome do tema
    NomeNovoTema := ObterNomeTema(ArquivoTema);
    if NomeNovoTema.Length = 0 then
      raise EProgramaErro.Create(excecaoTemaFormatoInvalido);

    //Checa a pasta de instalação de temas
    PastaDestino := ObterPastaTemasUsuario;
    if PastaDestino = '' then
      Exit;
    ArquivoDestino := PastaDestino + ExtractFileName(ArquivoTema);

    //TODO: Instalar fontes na pasta de Fontes do Windows

    //Copia o arquivo de tema para a pasta de temas
    if not CopyFile(ArquivoTema, ArquivoDestino) then
      raise EProgramaErro.Create(excecaoInstalarTema);

    //Registra o tema na coleção de temas do usuário
    ArquivoDestino := PastaDestino + Variaveis.ArquivoDescricao;
    ArquivoTemas := TStringList.Create;
    try
      if FileExists(ArquivoDestino) then
        ArquivoTemas.LoadFromFile(ArquivoDestino);
      EncontrouIgual := false;
      for TemaExistente in ArquivoTemas do
        if TemaExistente = ExtractFileName(ArquivoTema) then
          EncontrouIgual := true;
      if not EncontrouIgual then
        ArquivoTemas.Add(ExtractFileName(ArquivoTema));
      ArquivoTemas.SaveToFile(ArquivoDestino);
    finally
      ArquivoTemas.Free;
    end;
    Variaveis.Free;
  end;
end;

end.

