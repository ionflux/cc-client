LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"

ShowInstDetails show
ShowUninstDetails show

XPStyle on

Name "������ ������ ��"

OutFile "cc_1.2.0.26.exe"

InstallDir "$PROGRAMFILES\������ ����� ��"

ComponentText "��� ��������� ��������� ��� ������� ����� �� �� ��� ���������"

DirText "�������� ���������� ��� ���������"

;--------------------------------

Section "����������� ����� (�����������)"

  SectionIn RO

  SetOutPath $INSTDIR
  
  File ..\castleclient.exe
; File ..\castleclient.chm
  File ..\webnames.dat
  WriteUninstaller "uninstall.exe"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\������ ����� ��" "DisplayName" "������ ����� �� (������ ��������)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\������ ����� ��" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"

  
SectionEnd

Section "�������� ����"

  SectionIn RO
  SetOutPath "$INSTDIR\smiles"
  File ..\smiles\*.*  
  
SectionEnd

Section "�������� �������������"

  SetOutPath "$INSTDIR\sounds"
  File ..\sounds\*.*  
  
SectionEnd


Section "������� �������������"

  CreateDirectory "$INSTDIR\avatars"
  SetOutPath "$INSTDIR\avatars"
  File ..\avatars\*.*
  
SectionEnd


Section "�������������� �����"
              
  CreateDirectory "$INSTDIR\styles"
  SetOutPath "$INSTDIR\styles"
  File ..\styles\*.*
  
SectionEnd


Section "�������� ����� � ����"
              
  CreateDirectory "$SMPROGRAMS\������ ����� ��"
  CreateShortCut "$SMPROGRAMS\������ ����� ��\������� ������� ����� ��.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\������ ����� ��\������ ����� ��.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0
  CreateShortCut "$SMPROGRAMS\������ ����� ��\������ ����� ��.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0
  
SectionEnd

Section "�������� ����� �� ������� ����"

  CreateShortCut "$DESKTOP\������ ����� ��.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0

SectionEnd


Section "�������� ����� �� ������ �������� �������"

  CreateShortCut "$QUICKLAUNCH\������ ����� ��.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0

SectionEnd



UninstallText "��� ��������� ������ ������� ����� �� � ������ ����������"

Section "Uninstall"

  Delete "$INSTDIR\*.*"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\Styles\*.*"
  Delete "$INSTDIR\avatars\*.*"
  Delete "$INSTDIR\sounds\*.*"
  Delete "$INSTDIR\smiles\*.*"
  Delete "$SMPROGRAMS\������ ����� ��\*.*"
  Delete "$QUICKLAUNCH\������ ����� ��.lnk"
  Delete "$DESKTOP\������ ����� ��.lnk"
  
  RMDir "$SMPROGRAMS\������ ����� ��"
  RMDir "$INSTDIR\Styles"
  RMDir "$INSTDIR\smiles"
  RMDir "$INSTDIR\avatars"  
  RMDir "$INSTDIR\sounds"
  RMDir "$INSTDIR"

  DeleteRegKey HKCU "Software\Phoenix lab.\����� ��\�����"
  DeleteRegKey HKCU "Software\Phoenix lab.\����� ��\������"
  DeleteRegKey HKCU "Software\Phoenix lab.\����� ��\�������"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\������ ����� ��"

  ifFileExists "$INSTDIR\profiles\*.*" Mess NoMess
  Mess:
   MessageBox MB_OK|MB_ICONINFORMATION "���������� � ��������� ������� ��������������"
  NoMess:

SectionEnd