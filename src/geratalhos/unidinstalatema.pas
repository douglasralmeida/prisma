unit unidInstalaTema;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure InstalarTema(const ArquivoTema: String);

implementation

uses FileUtil, unidExcecoes, unidExcecoesLista, unidVariaveis, unidUtils;

function ObterPastaTemasUsuario: String;
begin
  Result := Variaveis.PastaTemasPessoais;
  if not DirectoryExists(Result) then
    if not CreateDir(Result) then
    begin
      Result := '';
      Variaveis.Free;
      raise EProgramaErro.Create(excecaoCriarDirTemasPess);
    end;
  Variaveis.Free;
end;

procedure InstalarTema(const ArquivoTema: String);
const
  PERGUNTA = 'Você deseja adicionar o tema selecionado à coleção de temas do Prisma?';
  RESPOSTAS: array[0..1] of string = ('Sim, adicionar à coleção.', 'Não, não adicionar à coleção.');
var
  ArquivoDestino: String;
begin
  Variaveis := TVariaveis.Create;
  PrepararPastaConfig;
  if ArquivoTema.Length = 0 then
    raise EProgramaErro.Create(excecaoParametrosIncorretos);
  if not FileExists(ArquivoTema) then
    raise EProgramaErro.Create(excecaoArquivoNaoExiste);
  if ExibirPergunta(PERGUNTA, RESPOSTAS, 1) = 0 then
  begin
    ArquivoDestino := ObterPastaTemasUsuario;
    if ArquivoDestino = '' then
      Exit;
    ArquivoDestino := ArquivoDestino + ExtractFileName(ArquivoTema);
    if not CopyFile(ArquivoTema, ArquivoDestino) then
      raise EProgramaErro.Create(excecaoInstalarTema);
  end;
end;

end.

