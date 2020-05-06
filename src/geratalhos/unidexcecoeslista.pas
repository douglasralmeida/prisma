unit unidExcecoesLista;

{$mode objfpc}{$H+}

interface

uses
  unidExcecoes;

const
  excecaoCriarDirConfig: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações padrão do Gerador de Atalhos. Impossível criar a pasta de configurações.';
    AjudaID: 101);

  excecaoCopiarModeloConfig: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações padrão do Gerador de Atalhos. Impossível copiar configurações padrão.';
    AjudaID: 102);

implementation

end.

