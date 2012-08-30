LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"

ShowInstDetails show
ShowUninstDetails show

XPStyle on

Name "Клиент Замока ИФ"

OutFile "cc_1.2.0.26.exe"

InstallDir "$PROGRAMFILES\Клиент замка ИФ"

ComponentText "Эта программа установит вам Клиента Замка ИФ на ваш компьютер"

DirText "Выберите директорию для установки"

;--------------------------------

Section "Исполняемые файлы (обязательно)"

  SectionIn RO

  SetOutPath $INSTDIR
  
  File ..\castleclient.exe
; File ..\castleclient.chm
  File ..\webnames.dat
  WriteUninstaller "uninstall.exe"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Клиент Замка ИФ" "DisplayName" "Клиент Замка ИФ (только удаление)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Клиент Замка ИФ" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"

  
SectionEnd

Section "Смайлики чата"

  SectionIn RO
  SetOutPath "$INSTDIR\smiles"
  File ..\smiles\*.*  
  
SectionEnd

Section "Звуковое сопровождение"

  SetOutPath "$INSTDIR\sounds"
  File ..\sounds\*.*  
  
SectionEnd


Section "Аватары пользователей"

  CreateDirectory "$INSTDIR\avatars"
  SetOutPath "$INSTDIR\avatars"
  File ..\avatars\*.*
  
SectionEnd


Section "Дополнительные стили"
              
  CreateDirectory "$INSTDIR\styles"
  SetOutPath "$INSTDIR\styles"
  File ..\styles\*.*
  
SectionEnd


Section "Добавить ярлык в Пуск"
              
  CreateDirectory "$SMPROGRAMS\Клиент Замка ИФ"
  CreateShortCut "$SMPROGRAMS\Клиент Замка ИФ\Удалить Клиента Замка ИФ.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Клиент Замка ИФ\Клиент Замка ИФ.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0
  CreateShortCut "$SMPROGRAMS\Клиент Замка ИФ\Клиент Замка ИФ.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0
  
SectionEnd

Section "Добавить ярлык на Рабочий стол"

  CreateShortCut "$DESKTOP\Клиент Замка ИФ.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0

SectionEnd


Section "Добавить ярлык на Панель быстрого запуска"

  CreateShortCut "$QUICKLAUNCH\Клиент Замка ИФ.lnk" "$INSTDIR\castleclient.exe" "" "$INSTDIR\castleclient.exe" 0

SectionEnd



UninstallText "Эта программа удалит Клиента Замка ИФ с вашего компьютера"

Section "Uninstall"

  Delete "$INSTDIR\*.*"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\Styles\*.*"
  Delete "$INSTDIR\avatars\*.*"
  Delete "$INSTDIR\sounds\*.*"
  Delete "$INSTDIR\smiles\*.*"
  Delete "$SMPROGRAMS\Клиент Замка ИФ\*.*"
  Delete "$QUICKLAUNCH\Клиент Замка ИФ.lnk"
  Delete "$DESKTOP\Клиент Замка ИФ.lnk"
  
  RMDir "$SMPROGRAMS\Клиент Замка ИФ"
  RMDir "$INSTDIR\Styles"
  RMDir "$INSTDIR\smiles"
  RMDir "$INSTDIR\avatars"  
  RMDir "$INSTDIR\sounds"
  RMDir "$INSTDIR"

  DeleteRegKey HKCU "Software\Phoenix lab.\Замок ИФ\Архив"
  DeleteRegKey HKCU "Software\Phoenix lab.\Замок ИФ\Помощь"
  DeleteRegKey HKCU "Software\Phoenix lab.\Замок ИФ\Главное"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Клиент Замка ИФ"

  ifFileExists "$INSTDIR\profiles\*.*" Mess NoMess
  Mess:
   MessageBox MB_OK|MB_ICONINFORMATION "Директорию с профилями удалите самостоятельно"
  NoMess:

SectionEnd