
; WARNING: If you change TheAppName you also need to change TheDefaultDir!
#define TheAppName "Sphinx"
#define TheAppVersion "0.0.0"
#define TheYear "2021"
#define TheDefaultDir "C:\Sphinx"
#define ThePythonPath "{app}\Python"
#define TheOutputDir "..\_out"
; Python-related defines
#define ThePythonVersion "3.8.8"
#define ThePythonArchive "python-embed-amd64.zip"
#define ThePythonPTH "python38._pth"
#define TheGetPipScript "get-pip.py"

[Setup]
AppId={{9396B7EC-FBF3-4810-943E-7B58CE983227}
AppName={#TheAppName}
AppVersion={#TheAppVersion}
AppVerName={#TheAppName} {#TheAppVersion}
VersionInfoVersion={#TheAppVersion}
DefaultDirName={#TheDefaultDir}
DisableProgramGroupPage=yes
OutputDir={#SourcePath}{#TheOutputDir}
OutputBaseFilename=SphinxInstaller_x64
Compression=lzma2/ultra64
SolidCompression=yes
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; 7-zip
Source: "{#SourcePath}..\vendor\7-zip\7za.exe"; DestDir: "{tmp}"; Flags: ignoreversion
; Python patch so we can use pip
Source: "{#SourcePath}..\{#ThePythonPTH}"; DestDir: "{#ThePythonPath}\"; Flags: ignoreversion
; requirements.txt
Source: "{#SourcePath}..\requirements.txt"; DestDir: "{#ThePythonPath}\"; Flags: ignoreversion
; Python archive
Source: "{tmp}\{#ThePythonArchive}"; DestDir: "{tmp}"; Flags: external; \
    Check: DwinsHs_Check(ExpandConstant('{tmp}\{#ThePythonArchive}'), \
    'https://www.python.org/ftp/python/{#ThePythonVersion}/python-{#ThePythonVersion}-embed-amd64.zip', '{#TheAppName}', 'get', 0, 0);
; pip
Source: "{tmp}\{#TheGetPipScript}"; DestDir: "{tmp}"; Flags: external; \
    Check: DwinsHs_Check(ExpandConstant('{tmp}\{#TheGetPipScript}'), \
    'https://bootstrap.pypa.io/get-pip.py', '{#TheAppName}', 'get', 0, 0)

[Code]
#define DwinsHs_Use_Predefined_Downloading_WizardPage
#define DwinsHs_Auto_Continue
#include "dwinshs\dwinshs.iss"

procedure InitializeWizard();
begin
  DwinsHs_InitializeWizard(wpPreparing);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  DwinsHs_CurPageChanged(CurPageID, nil, nil);
end;

function ShouldSkipPage(CurPageId: Integer): Boolean;
begin
  Result := False;
  DwinsHs_ShouldSkipPage(CurPageId, Result);
end;

function BackButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  DwinsHs_BackButtonClick(CurPageID);
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  DwinsHs_CancelButtonClick(CurPageID, Cancel, Confirm);
end;

[UninstallDelete]
Type: filesandordirs; Name: "{#ThePythonPath}"

[Run]
Filename: "{tmp}\7za.exe"; Parameters: "x -aos ""{tmp}\{#ThePythonArchive}"" -o""{#ThePythonPath}"""; Flags: runhidden runascurrentuser
Filename: "{#ThePythonPath}\python.exe"; Parameters: """{tmp}\{#TheGetPipScript}"" --no-warn-script-location"; Flags: runhidden runascurrentuser
Filename: "{#ThePythonPath}\Scripts\pip.exe"; Parameters: "install --upgrade pip --no-warn-script-location"; Flags: runhidden runascurrentuser
Filename: "{#ThePythonPath}\Scripts\pip.exe"; Parameters: "install -r ""{#ThePythonPath}\requirements.txt"" --no-warn-script-location"; Flags: runhidden runascurrentuser
