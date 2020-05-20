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

  excecaoCriarDirPrisma: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações de acesso a máquina Prisma. Impossível criar a pasta de configurações de acesso.';
    AjudaID: 110);

  excecaoObterModeloPrisma: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações de acesso a máquina Prisma. Impossível obter o arquivo modelo das configurações de acesso.';
    AjudaID: 111);

  excecaoCriarDirPlanoFundo: TExcecaoDados = (
    Mensagem: 'Não foi possível gerar as configurações de acesso a máquina Prisma. Impossível criar a pasta de imagens de plano de fundo.';
    AjudaID: 112);


implementation

end.

