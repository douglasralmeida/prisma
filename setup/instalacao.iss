; Script para o instalador das Configurações de Belo Horizonte para Prisma

#define MyAppName "Configurações de Belo Horizonte para Prisma"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Douglas R. Almeida"
#define MyAppURL "https://github.com/douglasralmeida"

[Setup]

AppId=abcd
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AllowNoIcons=yes
ArchitecturesInstallIn64BitMode=x64
ChangesEnvironment=true
Compression=lzma
DefaultDirName={pf}\Aplicativos do INSS\Configurações de Belo Horizonte para Prisma
DefaultGroupName=Aplicativos do INSS\Configurações de Belo Horizonte para Prisma
DisableWelcomePage=False
MinVersion=0,6.1
OutputBaseFilename=prismabhinstala
SetupIconFile=..\res\setupicone.ico
SolidCompression=yes
ShowLanguageDialog=no
UninstallDisplayName=Configurações de Belo Horizonte para Prisma
UninstallDisplayIcon={uninstallexe}
VersionInfoVersion=1.0.0
VersionInfoProductVersion=1.0
WizardImageFile=..\res\setupgrande.bmp
WizardSmallImageFile=..\res\setuppequeno.bmp

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"