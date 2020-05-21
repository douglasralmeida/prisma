program geratalhos;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, SysUtils,
  Forms, lazcontrols, formPrincipal, unidOL, unidUtils, unidTemas, unidZip,
  unidPrisma, unidConfig, unidVariaveis, unidExcecoes, unidExcecoesLista, unidInstalaTema;

{$R *.res}
{$R maisrecursos.rc}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Gerador de Atalhos';
  Application.Scaled:=True;
  Application.Initialize;
  if (ParamCount > 1) and (UpperCase(ParamStr(1)) = '/IT') then
  begin
    try
      InstalarTema(ParamStr(2))
    except
      on E: Exception do
        ExibirMensagemErro(E.Message, E.HelpContext);
    end;
  end
  else
  begin
    Application.CreateForm(TJanelaPrincipal, JanelaPrincipal);
    Application.Run;
  end;
end.

