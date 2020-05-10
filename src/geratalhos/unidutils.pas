unit unidUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure ExibirMensagemErro(const Mensagem: String; const AjudaID: Integer=0);
procedure ExibirMensagemInfo(const Mensagem: String; const Desc: String);

implementation

uses Controls, Dialogs;

procedure ExibirMensagemErro(const Mensagem: String; const AjudaID: Integer=0);
begin
  with TTaskDialog.Create(nil) do
    try
      Title := Mensagem;
      Caption := 'Erro';
      CommonButtons := [];
      Flags := Flags + [tfEnableHyperlinks, tfPositionRelativeToWindow];
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'OK';
        ModalResult := mrOK;
      end;
      MainIcon := tdiError;
      if AjudaID > 0 then
      begin
        FooterIcon := tdiInformation;
        FooterText := 'Para obter ajuda sobre este erro, <A HREF="executablestring">clique aqui</A>.';
      end;
      Execute;
    finally
      Free;
    end
end;

procedure ExibirMensagemInfo(const Mensagem: String; const Desc: String);
begin
  with TTaskDialog.Create(nil) do
    try
      Title := Mensagem;
      Caption := 'Informação';
      CommonButtons := [];
      ExpandedText := Desc;
      ExpandButtonCaption := 'Saiba mais sobre isso';
      Flags := Flags + [tfEnableHyperlinks, tfPositionRelativeToWindow];
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'OK';
        ModalResult := mrOK;
      end;
      MainIcon := tdiInformation;
      Execute;
    finally
      Free;
    end
end;

end.

