; Script para o instalador do Cliente do Prisma

#define MyAppName "Prisma"
#define MyAppVersion "1.0"
#define MyAppPublisher "Douglas R. Almeida"
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
ChangesEnvironment=true
Compression=lzma
DefaultDirName={pf}\Aplicativos do INSS\Prisma
DefaultGroupName=Aplicativos do INSS\Prisma
DisableWelcomePage=False
MinVersion=0,6.1
OutputBaseFilename=prismainstala
OutputDir=..\dist
SetupIconFile=..\res\setup.icone.ico
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName=Prisma
UninstallDisplayIcon={uninstallexe}
VersionInfoVersion=1.0.0
VersionInfoProductVersion=1.0
WizardImageFile=..\res\setup.grande.bmp
WizardSmallImageFile=..\res\setup.pequeno.bmp

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\bin\accuterm73.exe"; DestDir: "{app}\emulador"; DestName: "accuterm73.exe"; Flags: ignoreversion; Components: accuterm;
Source: "..\bin\geratalhos.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: geratalhos;

[Components]
Name: "accuterm"; Description: "Emulador Accuterm 7.3"; ExtraDiskSpaceRequired: 1024; Types: compact custom full; Flags: fixed
Name: "geratalhos"; Description: "Gerador de Atalhos do Prisma"; Types: compact custom full; Flags: fixed
