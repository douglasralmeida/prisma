; Script para o instalador do Cliente do Prisma x86

#include "ambiente.iss"

#define AppName "Prisma"
#define AppOrganization "Aplicativos do INSS"
#define AppVersion "1.0"
#define AppPublisher "Instituto Nacional do Seguro Social"
#define AppURL "https://github.com/douglasralmeida/prisma"

[Setup]

AppId={{E0A55BDA-4DED-4D7A-80F1-AE76E5CC3723}
AppName={#AppName}
AppMutex=AppMutex_GeraAtalhosPrisma1,AppMutex_PrismaPDFConfig1
AppVersion={#AppVersion}
;AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
AllowNoIcons=yes
ArchitecturesAllowed=x86
ChangesAssociations=True
ChangesEnvironment=true
Compression=lzma
DefaultDirName={commonpf}\{#AppOrganization}\{#AppName}
DefaultGroupName={#AppOrganization}\{#AppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableWelcomePage=no
MinVersion=0,6.0
OutputBaseFilename=prismainstala.x86
OutputDir=..\dist
PrivilegesRequired=admin
SetupIconFile=..\res\setup.icone.ico
SetupMutex=InstalacaoPrismax86Mutex1
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName={#AppName} Cliente {#AppVersion}
UninstallDisplayIcon={app}\geratalhos.exe,5
UninstallDisplaySize=75497472
VersionInfoVersion=1.0.0
VersionInfoProductVersion={#AppVersion}
WizardImageFile=..\res\instalagrande\*.bmp
WizardSmallImageFile=..\res\instalapequeno\*.bmp
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
Name: "accuterm"; Description: "Emulador Accuterm 7.3"; ExtraDiskSpaceRequired: 58300826; Types: compact custom full; Flags: fixed
Name: "geratalhos"; Description: "Gerador de Atalhos do Prisma"; Types: compact custom full; Flags: fixed
Name: "pdfprisma"; Description: "Componente Prisma PDF"; Types: compact custom full; Flags: fixed
Name: "java"; Description: "Java 12"; Types: compact custom full; Flags: fixed
Name: "ajuda"; Description: "Ajuda e Documentação"; Types: compact custom full; Flags: fixed

[Dirs]
Name: "{localappdata}\{#AppOrganization}"; Flags: uninsalwaysuninstall; Components: geratalhos;
Name: "{localappdata}\{#AppOrganization}\{#AppName}"; Flags: uninsalwaysuninstall; Components: geratalhos;
Name: "{pf}\Java\jre6\bin"; Flags: uninsalwaysuninstall; Components: pdfprisma;
Name: "{app}\jre"; Flags: uninsalwaysuninstall; Components: java;

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\accuterm\setup.ini"; DestDir: "{app}\emulador"; Flags: ignoreversion; Components: accuterm;
Source: "..\accuterm\atwin71.ini"; DestDir: "{app}\emulador\accextra"; Flags: ignoreversion; Components: accuterm;
Source: "..\accuterm\menu71.ini"; DestDir: "{app}\emulador\accextra"; Flags: ignoreversion; Components: accuterm;
Source: "..\scripts\AtalhosSistemas.bas"; DestDir: "{app}\emulador\accextra"; Flags: ignoreversion; Components: accuterm;
Source: "..\scripts\ScriptManCola.bas"; DestDir: "{app}\emulador\accextra"; Flags: ignoreversion; Components: accuterm;
Source: "..\bin\atwin71.msi"; DestDir: "{app}\emulador"; Flags: ignoreversion; AfterInstall: InstalarAccuterm(); Components: accuterm;
Source: "..\bin\config32.exe"; DestDir: "{app}"; DestName: "config.exe"; Flags: ignoreversion; Components: pdfprisma;
Source: "..\bin\geratalhos32.exe"; DestDir: "{app}"; DestName: "geratalhos.exe"; Flags: ignoreversion; Components: geratalhos;
Source: "..\bin\loader32.exe"; DestDir: "{app}"; DestName: "loader.exe"; Flags: ignoreversion; Components: pdfprisma;
Source: "..\bin\manual.pdf"; DestDir: "{app}"; Flags: ignoreversion; Components: pdfprisma;
Source: "..\bin\limparcnislinha.cmd"; DestDir: "{app}"; Flags: ignoreversion; Components: pdfprisma;
Source: "..\bin\listaol.csv"; DestDir: "{app}"; Flags: ignoreversion; Components: geratalhos;
Source: "..\bin\prisma.chm"; DestDir: "{app}"; Flags: ignoreversion; Components: ajuda;
Source: "..\bin\modelos\config.prc"; DestDir: "{app}\modelos"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: geratalhos;
Source: "..\bin\modelos\prisma.prm"; DestDir: "{app}\modelos"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: geratalhos;
Source: "..\bin\modelos\prismapdf32.prc"; DestDir: "{app}\modelos"; DestName: "prismapdf.prc"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: pdfprisma;
Source: "..\bin\temas\*"; DestDir: "{app}\temas"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: geratalhos;
Source: "..\fontes\CascadiaMono.ttf"; DestDir: "{fonts}"; FontInstall: "Cascadia Mono"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Bold.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Light.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code Light"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Medium.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code Medium"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Regular.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-Retina.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code Retina"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FiraCode-SemiBold.otf"; DestDir: "{fonts}"; FontInstall: "Fira Code SemiBold"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FreeMono.ttf"; DestDir: "{fonts}"; FontInstall: "FreeMono"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\FreeMonoBold.ttf"; DestDir: "{fonts}"; FontInstall: "FreeMono"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\fontes\Unispace Bold.ttf"; DestDir: "{fonts}"; FontInstall: "Unispace"; Flags: onlyifdoesntexist uninsneveruninstall; Components: geratalhos;
Source: "..\bin\jre32\bin\*"; DestDir: "{app}\jre\bin"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: java;
Source: "..\bin\jre32\conf\*"; DestDir: "{app}\jre\conf"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: java;
Source: "..\bin\jre32\lib\*"; DestDir: "{app}\jre\lib"; Flags: ignoreversion createallsubdirs recursesubdirs; Components: java;
Source: "..\bin\jre32\release"; DestDir: "{app}\jre"; Flags: ignoreversion; AfterInstall: OtimizarJava(); Components: java;

[Icons]
Name: "{group}\Gerador de Atalhos do Prisma"; Filename: "{app}\geratalhos.exe"; WorkingDir: "{app}"; Comment: "Crie atalhos do Prisma na área de trabalho."; Components: geratalhos;
Name: "{group}\Manual para Geração de PDF no Prisma"; Filename: "{app}\manual.pdf"; WorkingDir: "{app}"; Components: pdfprisma;
Name: "{group}\Configurações do PrismaPDF"; Filename: "{app}\config.exe"; WorkingDir: "{app}"; Comment: "Configure o componente PDF do Prisma."; Components: pdfprisma;
Name: "{group}\Ajuda do Prisma"; Filename: "{app}\prisma.chm"; WorkingDir: "{app}"; Comment: "Veja a ajuda do Prisma."; Components: ajuda;

[Registry]
Root: HKLM; Subkey: "Software\Classes\.prt"; ValueType: string; ValueName: ""; ValueData: "Prisma.ArquivoTema.1"; Flags: uninsdeletevalue; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\Prisma.ArquivoTema.1"; ValueType: string; ValueName: ""; ValueData: "Arquivo de Tema do Prisma"; Flags: uninsdeletekey; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\Prisma.ArquivoTema.1\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\geratalhos.exe,3"; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\Prisma.ArquivoTema.1\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\geratalhos.exe"" /it ""%1"""; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\.prc"; ValueType: string; ValueName: ""; ValueData: "Prisma.ArquivoConfig.1"; Flags: uninsdeletevalue; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\Prisma.ArquivoConfig.1"; ValueType: string; ValueName: ""; ValueData: "Arquivo de Configurações do Prisma"; Flags: uninsdeletekey; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\Prisma.ArquivoConfig.1\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\geratalhos.exe,4"; Components: geratalhos;
Root: HKLM; Subkey: "Software\Classes\Prisma.ArquivoConfig.1\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """%SystemRoot%\system32\NOTEPAD.EXE %1"""; Components: geratalhos;
Root: HKCU; Subkey: "Software\INSS\Prisma"; ValueType: string; ValueName: "Versao"; ValueData: "1.0.0";
Root: HKCU; Subkey: "Software\INSS\Prisma"; ValueType: string; ValueName: "Pasta"; ValueData: "{app}";
Root: HKCU; Subkey: "Software\INSS\Prisma\Componentes"; ValueType: string; ValueName: "accuterm"; ValueData: "1"; Components: accuterm;
Root: HKCU; Subkey: "Software\INSS\Prisma\Componentes"; ValueType: string; ValueName: "geratalhos"; ValueData: "1"; Components: geratalhos;
Root: HKCU; Subkey: "Software\INSS\Prisma\Componentes"; ValueType: string; ValueName: "java"; ValueData: "1"; Components: java;
Root: HKCU; Subkey: "Software\INSS\Prisma\Componentes"; ValueType: string; ValueName: "pdfprisma"; ValueData: "1"; Components: pdfprisma;
Root: HKCU; Subkey: "Software\INSS\Prisma\Componentes"; ValueType: string; ValueName: "ajuda"; ValueData: "1"; Components: ajuda;
Root: HKCU; Subkey: "Software\Asent\Atwin70\ScriptEditor\Settings"; ValueType: string; ValueName: "FontName"; ValueData: "Consolas"; Components: accuterm;
Root: HKCU; Subkey: "Software\Asent\Atwin70\ScriptEditor\Settings"; ValueType: string; ValueName: "FontSize"; ValueData: "12"; Components: accuterm;

[Run]
Filename: "{app}\geratalhos.exe"; Description: "Executar o Gerador de Atalhos do Prisma imediatamente."; Flags: nowait postinstall skipifsilent runasoriginaluser; Components: geratalhos;
Filename: "schtasks"; \
  Parameters: "/Create /RU SYSTEM /F /SC DAILY /TN ""Limpeza diária do Componente PrismaPDF"" /TR ""'{app}\limparcnislinha.cmd'"" /ST 01:00"; \
  Flags: runhidden; \
  StatusMsg: "Definindo tarefas agendadas..."; \
  Components: pdfprisma;

Filename: "schtasks"; \
  Parameters: "/Create /RU SYSTEM /F /SC ONLOGON /TN ""Limpeza durante logon do Componente PrismaPDF"" /TR ""'{app}\limparcnislinha.cmd'"""; \
  Flags: runhidden; \
  StatusMsg: "Definindo tarefas agendadas..."; \
  Components: pdfprisma;

[UninstallRun]
Filename: "schtasks"; \
  Parameters: "/Delete /F /TN ""Limpeza diária do Componente PrismaPDF"""; \
  Flags: runhidden; \
  StatusMsg: "Excluindo tarefas agendadas..."; \
  Components: pdfprisma;

Filename: "schtasks"; \
  Parameters: "/Delete /F /TN ""Limpeza durante logon do Componente PrismaPDF"""; \
  Flags: runhidden; \
  StatusMsg: "Excluindo tarefas agendadas..."; \
  Components: pdfprisma;

[Code]
function CreateSoftLink(lpSymlinkFileName, lpTargetFileName: String; dwFlags: Integer): Boolean;
  external 'CreateSymbolicLinkW@kernel32.dll stdcall';

procedure CriarJavaLink;
var
  ExistingFile, LinkFile: string;
begin
  ExistingFile := ExpandConstant('{app}\loader.exe');
  LinkFile := ExpandConstant('{commonpf}\Java\jre6\bin\java.exe');
  CreateSoftLink(LinkFile, ExistingFile, 0);
end;

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

procedure ExecutarApp(App, Param, Status: String; Exibicao: Integer);
var
  TextoStatus: string;
  Resultado: Integer;
begin
  TextoStatus := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := Status;
  WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    if not Exec(App, Param, '', Exibicao, ewWaitUntilTerminated, Resultado) then
      MsgBox('Ocorreu um erro na instalação. Tente executar o programa de instalação novamente.', mbError, MB_OK);
  finally
    WizardForm.StatusLabel.Caption := TextoStatus;
    WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

procedure InstalarAccuterm();
var
  Config, Caminho, Parametros: string;
  Status: String;
begin
  Caminho := ExpandConstant('{app}\emulador\atwin71.msi');
  Config := ExpandConstant('"{app}\emulador\setup.ini"');
  Parametros := '/q /i "' + Caminho + '" ALLUSERS="1" LICENSEACCEPTED="YES" SETUPINI=' + Config;
  Status := 'Instalando e configurando o emulador Accuterm 7.3. Aguarde...';
  ExecutarApp('msiexec', Parametros, Status, SW_SHOW);
end;

procedure OtimizarJava();
var
  EXE: String;
  Parametros: string;
  Status: String;
begin
  EXE := ExpandConstant('{app}\jre\bin\java.exe');
  Parametros := '-Xshare:dump';
  Status := 'Otimizando o Java 12. Aguarde...';
  ExecutarApp(EXE, Parametros, Status, SW_HIDE);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
    { Apaga o diretório C:\CNISLINHA }
    DelTree('C:\CNISLINHA', True, True, True);

    { Cria o diretório C:\cnislinha (minúsculo) }
    CreateDir('C:\cnislinha');
  end
  else if CurStep = ssPostInstall then
  begin
    
    { Remove o caminho do JRE 6 do systempath }
    EnvRemovePath(ExpandConstant('{commonpf}') + '\Java\jre6\bin');
    EnvRemovePath(ExpandConstant('{commonpf32}') + '\Java\jre6\bin');

    {  Cria um link simbolico que finge ser o executavel Java  }
    CriarJavaLink;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Diretorio: String;
begin
  if CurUninstallStep = usUninstall then
  begin
    { Apaga do diretório Aplicativos do INSS se estiver vazio }

    Diretorio := ExpandConstant('{commonpf}\{#SetupSetting("AppOrganization")}');
    if DirEstaVazio(Diretorio) then
      DelTree(Diretorio, True, True, True);

    { Versões beta usavam Aplicações do INSS\Gerador de Atalhos do Prisma }
    Diretorio := ExpandConstant('{userappdata}\Aplicações do INSS\Gerador de Atalhos do Prisma');
    DelTree(Diretorio, True, True, True);

    { Versões anteriores do Componente PDF usavam Aplicações do INSS\Componente PrismaPDF }
    Diretorio := ExpandConstant('{userappdata}\Aplicações do INSS\Componente PrismaPDF');
    DelTree(Diretorio, True, True, True);
    Diretorio := ExpandConstant('{userappdata}\Aplicações do INSS');
    if DirEstaVazio(Diretorio) then
      DelTree(Diretorio, True, True, True);

    { Apaga o softlink }
    DeleteFile(ExpandConstant('{commonpf}\Java\jre6\bin\java.exe'));

    { Apaga do diretório do softlink }
    DelTree(ExpandConstant('{commonpf}\Java\jre6'), True, True, True);

    { Apaga o diretório C:\cnislinha }
    DelTree('C:\cnislinha', True, True, True);
  end;
end;