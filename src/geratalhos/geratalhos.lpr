program geratalhos;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, formPrincipal, unidOL, unidutils, unidtemas, unidZip,
  unidPrisma, unidConfig, unidVariaveis, unidExcecoes, unidExcecoesLista;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Gerador de Atalhos';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJanelaPrincipal, JanelaPrincipal);
  Application.Run;
end.

