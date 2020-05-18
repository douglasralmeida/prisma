﻿; Script para o instalador do Cliente do Prisma x64

#define MyAppName "Prisma"
#define MyAppVersion "1.0"
#define MyAppPublisher "Instituto Nacional do Seguro Social"
#define MyAppURL "https://github.com/douglasralmeida/prisma"

[Setup]

AppId={{E0A55BDA-4DED-4D7A-80F1-AE76E5CC3723}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AllowNoIcons=yes
ArchitecturesInstallIn64BitMode=x64
ChangesAssociations=True
ChangesEnvironment=true
Compression=lzma
DefaultDirName={pf}\Aplicativos do INSS\Prisma
DefaultGroupName=Aplicativos do INSS\Prisma
DisableDirPage=yes
DisableReadyPage=yes
DisableWelcomePage=no
MinVersion=0,6.1
OutputBaseFilename=prismainstala.x64
OutputDir=..\dist
SetupIconFile=..\res\setup.icone.ico
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName=Prisma
UninstallDisplayIcon={uninstallexe}
UninstallDisplaySize=50000000
VersionInfoVersion=1.0.0
VersionInfoProductVersion=1.0
WizardImageFile=..\res\setup.grande.bmp
WizardSmallImageFile=..\res\setup.pequeno.bmp
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[LangOptions]
DialogFontName=Segoe UI
DialogFontSize=9
WelcomeFontName=Segoe UI
WelcomeFontSize=12
TitleFontName=Segoe UI
TitleFontSize=29
CopyrightFontName=Segoe UI
CopyrightFontSize=9

[Components]
Name: "accuterm"; Description: "Emulador Accuterm 7.3"; ExtraDiskSpaceRequired: 1024; Types: compact custom full; Flags: fixed
Name: "geratalhos"; Description: "Gerador de Atalhos do Prisma"; Types: compact custom full; Flags: fixed

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\accuterm\setup.ini"; DestDir: "{app}\emulador"; Flags: ignoreversion; Components: accuterm;
Source: "..\accuterm\atwin71.ini"; DestDir: "{app}\emulador\accextra"; Flags: ignoreversion; Components: accuterm;
Source: "..\accuterm\menu71.ini"; DestDir: "{app}\emulador\accextra"; Flags: ignoreversion; Components: accuterm;
Source: "..\bin\atwin71.msi"; DestDir: "{app}\emulador"; Flags: ignoreversion; AfterInstall: InstalarAccuterm(); Components: accuterm;
Source: "..\bin\geratalhos64.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: geratalhos;
Source: "..\bin\listaol.csv"; DestDir: "{app}"; Flags: ignoreversion; Components: geratalhos;
Source: "..\bin\modelos\*"; DestDir: "{app}\modelos"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: geratalhos;
Source: "..\bin\temas\*"; DestDir: "{app}\temas"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: geratalhos;
Source: "..\fontes\FiraCode-Bold.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Light.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code Light"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Medium.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code Medium"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Regular.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Retina.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code Retina"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-SemiBold.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code SemiBold"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;

[Icons]
Name: "{group}\Gerador de Atalhos do Prisma"; Filename: "{app}\geratalhos.exe"; WorkingDir: "{app}"; Comment: "Crie atalhos do Prisma na área de trabalho.";

[Run]
Filename: "{app}\geratalhos.exe"; Description: "Executar o Gerador de Atalhos do Primsa imediatamente."; Flags: nowait postinstall skipifsilent

[Code]
function DirEstaVazio(DirNome: String): Boolean;
var
  FindRec: TFindRec;
  Contador: Integer;
begin
  Result := False;
  if FindFirst(DirNome + '\*', FindRec) then
  begin
    try
      repeat
        if (FindRec.Name <> '.') and (FindRec.Name <> '..') then
        begin
          Contador := 1;
          break;
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
      if Contador = 0 then
        Result := True;
    end;
  end;
end;

procedure InstalarAccuterm();
var
  TextoStatus: string;
  Resultado: Integer;
  Config, Caminho, Parametros: string;
begin
  Caminho := ExpandConstant('{app}\emulador\atwin71.msi');
  Config := ExpandConstant('"{app}\emulador\setup.ini"');
  Parametros := '/q /i "' + Caminho + '" ALLUSERS="1" LICENSEACCEPTED="YES" SETUPINI=' + Config;
  TextoStatus := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption:='Instalando e configurando o emulador Accuterm 7.3. Aguarde...';
  WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    if not Exec('msiexec', Parametros, '', SW_SHOW, ewWaitUntilTerminated, Resultado) then
      MsgBox('Ocorreu um erro ao instalar o Accuterm 7.3. O Prisma não irá funcionar.', mbError, MB_OK);
  finally
    WizardForm.StatusLabel.Caption := TextoStatus;
    WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Diretorio: String;
begin
  if CurUninstallStep = usUninstall then
  begin
    { Apaga do diretório Aplicações INSS se estiver vazio }

    Diretorio := ExpandConstant('{pf}\Aplicativos do INSS');
    if DirEstaVazio(Diretorio) then
      DelTree(Diretorio, True, True, True);

    { Apaga o diretório UserAppData }
    Diretorio := ExpandConstant('{userappdata}\Aplicações do INSS\Gerador de Atalhos do Prisma');
    DelTree(Diretorio, True, True, True);
    Diretorio := ExpandConstant('{userappdata}\Aplicações do INSS');
    if DirEstaVazio(Diretorio) then
      DelTree(Diretorio, True, True, True);
  end;
end;