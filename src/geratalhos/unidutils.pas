unit unidUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure ExibirMensagemErro(const Mensagem: String);

implementation

uses Controls, Dialogs;

procedure ExibirMensagemErro(const Mensagem: String);
begin
  with TTaskDialog.Create(nil) do
    try
      Title := Mensagem;
      Caption := 'Erro';
      CommonButtons := [];
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'OK';
        ModalResult := mrOK;
      end;
      MainIcon := tdiError;
      Execute;
    finally
      Free;
    end
end;

end.

