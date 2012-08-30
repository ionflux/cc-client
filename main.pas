unit main;

interface

uses
 Windows,
 Messages,
 SysUtils,
 SHDocVw_TLB,
 EmbeddedWB,
 Menus,
 mshtml,
 castle_interface,
 castle_utils,
 Controls,
 Classes,
 Forms,
 Crypt32,
 NetLayerU,
 castle_messages,
 ImgList,
 VirtualTrees,
 ExtCtrls,
 ComCtrls,
 StdCtrls,
 OleCtrls,
 Graphics,
 Dialogs,
 ShellApi,
 CoolTrayIcon,
 VersionInfo,
 ToDO;

const
 RegKey = '\Software\Phoenix lab.\Замок ИФ';
 TplChatVersion = 'Castle.IF/%s (compatible; Local Client (Cristmas Edition RC1) by Dmitriy Stepanov [ion@vesti.irk.ru]; compiled at %s)';
 ChatHost = 'http://castle.istu.edu';
 PrivateDelo = 'Личное дело "%s"';
 BinaryHeader = 'cc data v.1.1';
 BinaryHeaderLength = 13;
 
type
 TfrmCastle = class(TForm)
  pHTML: TPanel;
  WBChat: TEmbeddedWB;
  pmChat: TPopupMenu;
  miCopy: TMenuItem;
  miRefresh: TMenuItem;
  miChatStyle: TMenuItem;
  sbLog: TStatusBar;
  tChatUptime: TTimer;
  ImageList: TImageList;
  pmUsers: TPopupMenu;
  miPrivateInfo: TMenuItem;
  N1: TMenuItem;
  miVBig: TMenuItem;
  miBig: TMenuItem;
  miNormal: TMenuItem;
  miSmall: TMenuItem;
  miVSmall: TMenuItem;
  chatirkru: TMenuItem;
  N2: TMenuItem;
  N3: TMenuItem;
  N5: TMenuItem;
  N6: TMenuItem;
  N7: TMenuItem;
  TrayIcon: TCoolTrayIcon;
  ImageListCH: TImageList;
  pCTRL: TPanel;
  k_send: TImage;
  k_obn: TImage;
  k_sendprivat: TImage;
  k_lat2rus: TImage;
  eSendMessage: TComboBox;
    sRigth: TPanel;
    WBSmiles: TEmbeddedWB;
    pINFO: TPanel;
    iMessages: TImage;
    iSetup: TImage;
    iArchive: TImage;
    iLockChat: TImage;
    iRules: TImage;
    iAdmin: TImage;
    iExit: TImage;
    vstUsers: TVirtualStringTree;
    k_status: TImage;
    k_users_refresh: TImage;
    Label1: TLabel;
  procedure FormCreate(Sender: TObject);
  function WBChatShowContextMenu(const dwID: Cardinal; const ppt: PPoint; const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HRESULT;
  procedure miCopyClick(Sender: TObject);
  procedure miRefreshClick(Sender: TObject);
  function WBChatGetExternal(out ppDispatch: IDispatch): HRESULT;
  procedure iExitClick(Sender: TObject);
  procedure k_obnClick(Sender: TObject);
  procedure iAdminClick(Sender: TObject);
  procedure iRulesClick(Sender: TObject);
  function WBSmilesShowContextMenu(const dwID: Cardinal;
   const ppt: PPoint; const pcmdtReserved: IInterface;
   const pdispReserved: IDispatch): HRESULT;
  procedure WndProc(var Msg: TMessage); override;
  procedure tChatUptimeTimer(Sender: TObject);
  procedure k_users_refreshClick(Sender: TObject);
  procedure k_sendClick(Sender: TObject);
  procedure eSendMessage1KeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure iSetupClick(Sender: TObject);
  procedure miSetStyle(Sender: TObject);
  procedure iArchiveClick(Sender: TObject);
  procedure WBChatDocumentComplete(ASender: TObject;
   const pDisp: IDispatch; var URL: OleVariant);
  procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  procedure WBChatRefresh(Sender: TObject; CmdID: Integer;
   var Cancel: Boolean);
  procedure miVBigClick(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure FormShow(Sender: TObject);
  procedure k_statusClick(Sender: TObject);
  procedure miPrivateInfoClick(Sender: TObject);
  procedure k_sendprivatClick(Sender: TObject);
  procedure lvUsersInsert;
  procedure lvUsersCustomDrawItem(Sender: TCustomListView;
   Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  procedure mPrivateKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure iMessagesClick(Sender: TObject);
  function AppHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
  procedure pmUsersPopup(Sender: TObject);
  procedure chatirkruClick(Sender: TObject);
  procedure FormKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure CreateParams(var Params: TCreateParams); override;
  procedure pmChatChange(Sender: TObject; Source: TMenuItem;
   Rebuild: Boolean);
  procedure N2Click(Sender: TObject);
  procedure N3Click(Sender: TObject);
  function WBChatShowHelp(hwnd: Cardinal; pszHelpFile: PWideChar;
   uCommand, dwData: Integer; ptMouse: TPoint;
   var pDispatchObjectHit: IDispatch): HRESULT;
  function WBSmilesShowHelp(hwnd: Cardinal; pszHelpFile: PWideChar;
   uCommand, dwData: Integer; ptMouse: TPoint;
   var pDispatchObjectHit: IDispatch): HRESULT;
  procedure lvUsersKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure vstUsersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
   Column: TColumnIndex; TextType: TVSTTextType;
   var CellText: WideString);
  procedure vstUsersGetImageIndex(Sender: TBaseVirtualTree;
   Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
   var Ghosted: Boolean; var ImageIndex: Integer);
  procedure vstUsersGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
   Column: TColumnIndex; TextType: TVSTTextType;
   var CellText: WideString);
  procedure vstUsersDblClick(Sender: TObject);
  function wbrecShowContextMenu(const dwID: Cardinal; const ppt: PPoint;
   const pcmdtReserved: IInterface;
   const pdispReserved: IDispatch): HRESULT;
  procedure N6Click(Sender: TObject);
  procedure WBChatDownloadComplete(Sender: TObject);
  procedure TrayIconClick(Sender: TObject);
  procedure WBChatDownloadBegin(Sender: TObject);
  procedure vstUsersChecked(Sender: TBaseVirtualTree;
   Node: PVirtualNode);
  procedure iLockChatClick(Sender: TObject);
  procedure WBSmilesDocumentComplete(ASender: TObject;
   const pDisp: IDispatch; var URL: OleVariant);
  procedure WBSmilesRefresh(Sender: TObject; CmdID: Integer;
   var Cancel: Boolean);
  procedure k_lat2rusClick(Sender: TObject);
  procedure WBSmilesBeforeNavigate2(ASender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool);
  procedure FocuseEditor;
  procedure ShowPrivateMess(var Mess: TChatText);
 public
  WBChat_Busy: Boolean;
  ActiveUNode: PVirtualNode;
  InActiveUNode: PVirtualNode;
  frmMessages: TfrmMessages;
  SmilesLoaded: Boolean;
  function GetNodeByName(UserName: string): PVirtualNode;
  procedure ShowPrivateMail;
  procedure AppExcept(Sender: TObject; E: Exception);
  procedure LoadSettings;
  procedure SaveSettings;
  procedure DoLogin(UserName, UserPassword, ProxyAddr, ProxyPort, ProxyAuth: string);
  procedure DoLogOut;
  procedure DoLog(Str: string);
  procedure AddEditText(aText: string);
  procedure AddFirst(Text: string);
  procedure SetStyle(Style: string; Where: TEmbeddedWB);
  procedure SetPrivateName(UserName: string);
  function FindPWnd(UserName: string): boolean;
  // procedure ReplaceHTML(idTag, HTML: string);
 end;
 
 PvUserInfo = ^TvUserInfo;
 TvUserInfo = record
  Status: TUserStatus;
  UserNick: string;
  UserId: string;
  UserInfo: Pointer;
 end;
 
var
 frmCastle: TfrmCastle;
 ChatUserName: string;
 ChatPassword: string;
 ChatSavePass: boolean;
 ChatProxyAddr: string;
 ChatProxyPort: string;
 ChatProxyUser: string;
 ChatProxyPass: string;
 ChatProxyAuth: string;
 ChatProxySavePass: boolean;
 ChatVersion: string;
 LocalDir: string;
 ProfileDir: string;
 ChatPWindows: TList;
 //
 ChatUptime: TDateTime = 0;
 UseUptime: Boolean = False;
 //
 ChatStyles: TStringList;
 //
 ReadedBytes: Cardinal;
 
function SortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;

implementation

{$R *.dfm}
{$R all.res}
{$R WindowsXP.res}

uses Registry,
 DateUtils,
 castle_archive,
 castle_userinfo,
 castle_setup,
 StrUtils,
 castle_help,
 castle_ot_chat,
 castle_baloon;

procedure TfrmCastle.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
 with Params do
  WinClassName := '** *** **** *****';
end;

procedure TfrmCastle.WndProc(var Msg: TMessage);
var
 Data: PvUserInfo;
 Node: PVirtualNode;
 Sl: TStringList;
 i: Integer;
 ps: string;
 pmess: TChatText;
 
 function GetPar(var strin: string): string;
 begin
  i := Pos(',', strin);
  Result := Copy(strin, 1, i - 1);
  Delete(strin, 1, i);
 end;

begin
 case Msg.Msg of
  UT_UserListRef:
   begin
    vstUsers.Repaint;
   end;
  UC_ReadedBytes:
   begin
    ReadedBytes := ReadedBytes + Cardinal(Msg.WParam);
    sbLog.Panels[4].Text := ' Скачанно: ' + IntToStr(ReadedBytes div 1024) + ' кб.';
   end;
  CW_FreeUs: ChatPWindows.Extract(Pointer(Msg.WParam));
  UL_LogMessage: DoLog(BufToStr(Msg.LParam));
  UC_HostNotFound: ReplaceHTML(WBChat, 'info', 'Невозможно подключится к чату, не найден сервер чата');
  UC_LoginFailed: ReplaceHTML(WBChat, 'info', 'Вы несмогли войти в чат, неверное имя пользователя или пароль');
  UC_UnregUser: ReplaceHTML(WBChat, 'info', 'Запрещен вход в чат незарегистрированных пользователей');
  UC_WeLogin:
   begin
    WBChat.Go('res://' + makePath(paramstr(0)) + '/loading');
    pINFO.Visible := True;
    sRigth.Visible := True;
    pCTRL.Visible := True;
    eSendMessage.SetFocus;
   end;
  UC_WeStop,
   UC_Exceptioon:
   begin
    ChatUptime := 0;

    sbLog.Panels[0].Text := '';
    sbLog.Panels[0].Width := 0;

    sbLog.Panels[1].Text := '';
    sbLog.Panels[1].Width := 0;

    tChatUptime.Enabled := False;
    pINFO.Visible := False;
    sRigth.Visible := False;
    pCTRL.Visible := False;
    WBChat.Go('res://' + makePath(paramstr(0)) + '/login');
   end;
  UC_RefreshChat:
   begin
    ReplaceHTML(WBChat, 'chat', BufToStr(Msg.LParam));
    for i := 0 to ChatPWindows.Count - 1 do
     TfrmChatWith(ChatPWindows[i]).TimerTimer(Self);
   end;
  UT_UpdateRooms:
   begin
    ps := BufToStr(Msg.wParam);
    ReplaceHTML(WBChat, 'theroom', ps);
   end;
  USER_Add:
   begin
    if TChatUser(Msg.WParam).Node = nil then
     begin
      Node := vstUsers.AddChild(nil);
      Data := vstUsers.GetNodeData(Node);
      Data.UserInfo := TChatUser(Msg.WParam);
      TChatUser(Data.UserInfo).Node := Node;

      Node.CheckType := ctCheckBox;

      if TChatUser(Data.UserInfo).RecvText then
       Node.CheckState := csCheckedNormal else
       Node.CheckState := csUncheckedNormal;

      Data.UserNick := TChatUser(Data.UserInfo).UserName;
      Data.UserId := TChatUser(Data.UserInfo).Id;
      Data.Status := TChatUser(Data.UserInfo).Status;
      lvUsersInsert;
     end;
   end;
  USER_Del:
   begin
    if TChatUser(Msg.WParam).Node <> nil then
     begin
      vstUsers.DeleteNode(TChatUser(Msg.WParam).Node);
      TChatUser(Msg.WParam).Node := nil;
     end;
    lvUsersInsert;
   end;
  UP_We_Have_Messsage:
   begin
    if (Config.Value_Bool['PlaySounds']) and (Msg.WParam <> 1) then PlayWav(Config.Value_Str['Sound_Mail']);
    SendMessage(frmMessages.Handle, PM_CheckMessages, 0, 0);
    if (Config.Value_Bool['ShowNewMail']) or (Msg.WParam = 1) then ShowPrivateMail;
   end;
  IT_SetNews:
   begin
    ReplaceHTML(WBChat, 'news', BufToStr(Msg.wParam));
   end;
  UT_UpdateTime:
   begin
    ReplaceHTML(WBChat, 'thetime', BufToStr(Msg.wParam));
   end;
  IT_SetText:
   begin
    Sl := TStringList.Create;
    Sl.Text := BufToStr(Msg.wParam);
    // wbrec.LoadFromStrings(Sl); //
    Sl.Free;
   end;
  TC_SetSmile: AddEditText(BufToStr(Msg.WParam));
  TC_AddFirst: AddFirst(BufToStr(Msg.WParam));
  TC_SetPrivate: SetPrivateName(BufToStr(Msg.WParam));
  UC_Dologin:
   begin
    ps := BufToStr(Msg.WParam);

    ChatUserName := GetPar(ps);
    ChatPassword := GetPar(ps);
    ChatSavePass := StrToBool(GetPar(ps));

    if StrToBool(GetPar(ps)) then // Use Proxy Server
     begin
      ChatProxyAddr := GetPar(ps);
      ChatProxyPort := GetPar(ps);
     end else
     begin
      GetPar(ps);
      GetPar(ps);
      ChatProxyPort := '';
      ChatProxyAddr := '';
     end;

    if StrToBool(GetPar(ps)) then // Use Auhtorasation
     begin
      ChatProxyUser := GetPar(ps);
      ChatProxyPass := GetPar(ps);
      ChatProxyAuth := ChatProxyUser + ':' + ChatProxyPass;
     end else
     begin
      GetPar(ps);
      GetPar(ps);
      ChatProxyUser := '';
      ChatProxyPass := '';
     end;

    ChatProxySavePass := StrToBool(ps);

    DoLogin(ChatUserName, ChatPassword, ChatProxyAddr, ChatProxyPort, ChatProxyAuth);
   end;
  UC_PrivateMess:
   begin
    pmess := TChatText(Msg.WParam);
    if not pmess.IsShow then ShowPrivateMess(pmess);
    pmess.IsShow := true;
   end;
  UC_ChatLocked:
   begin
    ReplaceHTML(WBChat, 'chat', '<center><font size=2><b><i>БЛОКИРОВКА</i></b><br>Чат заблокирован, для возврата введите свой пароль и нажмите "Enter".</font><br><br><input type=password name=password size=15><br>'+'<br><INPUT type=image src="k_enter1" alt="Снять блокировку" onClick="Ulock()" value=Sent border=0>');
   end;
 else
  inherited;
 end;
end;

procedure TfrmCastle.AppExcept(Sender: TObject; E: Exception);
begin
 DoLog('Ошибка программы: ' + E.Message);
 EMsg('Ошибка программы: ' + E.Message);
end;

procedure TfrmCastle.LoadSettings;
begin
 ChatUserName := ReadReg(RegKey, 'UserName', '');
 ChatSavePass := StrToBool(ReadReg(RegKey, 'SavePass', 'false'));
 
 if ChatSavePass then
  ChatPassword := Decrypt(ReadReg(RegKey, 'Password', ''), StartKey, MultKey, AddKey);
 
 ChatProxyAddr := ReadReg(RegKey, 'ProxyAddr', '');
 ChatProxyPort := ReadReg(RegKey, 'ProxyPort', '');
 
 ChatProxyUser := ReadReg(RegKey, 'ProxyUser', '');
 
 ChatProxySavePass := StrToBool(ReadReg(RegKey, 'ProxySavePass', 'false'));
 
 if ChatProxySavePass then
  ChatProxyPass := Decrypt(ReadReg(RegKey, 'ProxyPass', ''), StartKey, MultKey, AddKey);
end;

procedure TfrmCastle.SaveSettings;
begin
 WriteReg(RegKey, 'UserName', ChatUserName);
 WriteReg(RegKey, 'SavePass', BoolToStr(ChatSavePass, true));
 
 if ChatSavePass then
  WriteReg(RegKey, 'Password', Encrypt(ChatPassword, StartKey, MultKey, AddKey));
 
 WriteReg(RegKey, 'ProxyAddr', ChatProxyAddr);
 WriteReg(RegKey, 'ProxyPort', ChatProxyPort);

 WriteReg(RegKey, 'ProxyUser', ChatProxyUser);
 
 WriteReg(RegKey, 'ProxySavePass', BoolToStr(ChatProxySavePass, true));
 
 if ChatProxySavePass then
  WriteReg(RegKey, 'ProxyPass', Encrypt(ChatProxyPass, StartKey, MultKey, AddKey));
end;

procedure TfrmCastle.DoLogin(UserName, UserPassword, ProxyAddr, ProxyPort, ProxyAuth: string);
begin
 SaveSettings;
 
 ChatUserName := ReplaceCharsIn(ChatUserName);
 
 UseUptime := True;
 
 sbLog.Panels[1].Text := TimeToStr(ChatUptime);
 sbLog.Panels[1].Width := 60;
 
 if not DirectoryExists(LocalDir + 'profiles') then
  begin
   if not CreateDir(LocalDir + 'profiles') then
    begin
     DoLog('Невозможно создать директорию для профилей: ' + LocalDir + 'profiles');
     EMsg('Невозможно создать директорию для профилей'#13#10 + LocalDir + 'profiles');
     Exit;
    end;
  end;
 
 ProfileDir := LocalDir + 'profiles\' + ChatUserName;
 
 if not DirectoryExists(ProfileDir) then
  begin
   if not CreateDir(ProfileDir) then
    begin
     DoLog('Невозможно создать директорию профиля: ' + ProfileDir);
     EMsg('Невозможно создать директорию профиля'#13#10 + ProfileDir);
     Exit;
    end;
  end;
 
 if Assigned(ChatThread) then FreeAndNil(ChatThread);
 
 Config := TConfig.Create(UserName);
 
 ChatThread := TChatThread.Create(UserName, UserPassword, ProxyAuth, ProxyAddr, ProxyPort, 10000, Handle);
 
 if Assigned(ChatThread) then
  begin
   if FileExists(ProfileDir + '\say.dat') then eSendMessage.Items.LoadFromFile(ProfileDir + '\say.dat');
  end;
 
 sbLog.Panels[0].Width := Canvas.TextWidth(ChatUserName) + 15;
 sbLog.Panels[0].Text := ChatUserName;
end;

procedure TfrmCastle.DoLogOut;
begin
 UseUptime := False;
 
 sbLog.Panels[0].Width := 0;
 sbLog.Panels[1].Width := 0;
 
 eSendMessage.Items.SaveToFile(ProfileDir + '\say.dat');
 
 if Assigned(ChatThread) then
  begin
   ChatThread.PostMessage(UC_MustStop, 0, 0);
   ChatThread.WaitFor;
  end;
 
 FreeAndNil(Config);
end;

procedure TfrmCastle.DoLog(Str: string);
begin
 sbLog.Panels[3].Text := ' ' + Str;
end;

procedure TfrmCastle.AddEditText(aText: string);
begin
 eSendMessage.Text := eSendMessage.Text + aText;
 FocuseEditor;
end;

procedure TfrmCastle.AddFirst(Text: string);
begin
 eSendMessage.Text := Text + eSendMessage.Text;
 FocuseEditor;
end;

procedure InitStyles;

 procedure FSCB(FileDir, FileName: string);
 begin
  ChatStyles.AddObject(Copy(FileName, 1, Pos('.', FileName) - 1), TObject(StrToBuf(FileToString(FileDir + FileName))));
 end;
 
begin
 SearchFiles(ExtractFilePath(ParamStr(0)) + 'styles\', '*.css', @FSCB);
end;

procedure TfrmCastle.miSetStyle(Sender: TObject);
begin
 WriteReg(RegKey, TComponent(TPopupMenu(TMenuItem(Sender).Owner).PopupComponent).Name + '_Style', StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll, rfIgnoreCase]));
 SetStyle(BufToStr(TMenuItem(Sender).Tag, False), TEmbeddedWB(TPopupMenu(TMenuItem(Sender).Owner).PopupComponent));
end;

procedure TfrmCastle.FormCreate(Sender: TObject);
var
 i: Integer;
 NewItem: TMenuItem;
 DefChatStyle: string;
 CastleIFStyle: string;
begin
 Application.OnException := AppExcept;
 Application.OnHelp := AppHelp;
 
 ChatVersion := Format(TplChatVersion, [GetVersionInfo, FormatDateTime('hh:mm:ss dd/mm/yyyy', GetBuildTime)]);
 
 LoadSettings;
 
 InitStyles;
 
 WebNames := TWebNames.Create;
 WebNames.LoadFromFile(LocalDir + '\webnames.dat');
 
 k_sendprivat.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_private');
 k_send.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_enter');
 k_obn.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_obn');
 k_users_refresh.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_obn');
 k_status.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_status');
 
 WBChat.Go('res://' + makePath(paramstr(0)) + '/login');
 WBSmiles.Go('res://' + makePath(paramstr(0)) + '/smiles');
 // wbrec.Go('res://' + makePath(paramstr(0)) + '/rekl');

 SmilesLoaded := false;
 
 DefChatStyle := 'body {color:#b8826d; background:Black !important}'#13#10 +
  '.AdminName {font: normal 100% Courier New; color: Gray !important}'#13#10 +
  '.AdminText {font: 100% Courier New; color: Gray !important}'#13#10 +
  '.StrajName {font: 100% Courier New; color: #006699; text-align: center !important}'#13#10 +
  '.StrajText {font: 100% Courier New; color: #006699; text-align: center !important}'#13#10 +
  '.PrivateName {font: 100% Courier New; color: Red !important}'#13#10 +
  '.PrivateText {font: bolder 100% Courier New; color: Gray !important}'#13#10 +
  '.ChatText {font: 100% Courier New; color: Gray !important}'#13#10 +
  '.ChatName {font: 100% Courier New; color: White !important}'#13#10 +
  '.OurNick {font: 100% Courier New; color: Red !important}';
 
 CastleIFStyle := 'body {color: #b8826d; background: Black !important}'#13#10 +
  'a {text-decoration: none; font-weight: bolder !important}'; //#13#10 +
 // '.OurNick {font: color: Red !important}';
 
 ChatStyles.Sort;
 
 ChatStyles.InsertObject(0, 'Клиент Замка ИФ', TObject(StrToBuf(DefChatStyle)));
 ChatStyles.InsertObject(0, 'Замок ИФ', TObject(StrToBuf(CastleIFStyle)));
 
 for i := 0 to ChatStyles.Count - 1 do
  begin
   NewItem := TMenuItem.Create(pmChat);
   with NewItem do
    begin
     Caption := ChatStyles[i];
     Tag := Integer(ChatStyles.Objects[i]);
     OnClick := miSetStyle;
     miChatStyle.Add(NewItem);
    end;
  end;
 
 NewItem := TMenuItem.Create(miChatStyle);
 NewItem.Caption := '-';
 miChatStyle.Insert(2, NewItem);
 
 sbLog.Panels[0].Width := 0; // 150
 sbLog.Panels[1].Width := 0; // 60
 
 DoLog('programm started (styles: ' + IntToStr(ChatStyles.Count - 1) + ')');
 
 vstUsers.NodeDataSize := SizeOf(TvUserInfo);
 
 frmMessages := TfrmMessages.Create(Self);
 
end;

function TfrmCastle.WBChatShowContextMenu(const dwID: Cardinal;
 const ppt: PPoint; const pcmdtReserved: IInterface;
 const pdispReserved: IDispatch): HRESULT;
begin
 pmChat.PopupComponent := WBChat;
 pmChat.Popup(ppt.X, ppt.Y);
 result := S_OK;
end;

procedure TfrmCastle.miCopyClick(Sender: TObject);
var
 frDoc: Iwebbrowser2;
 oHTML_Doc: IHTMLDocument2;
begin
 with TEmbeddedWB(TfrmCastle(TMenuItem(Sender).Owner).pmChat.PopupComponent) do
  begin
   ExecWB(OLECMDID_COPY, OLECMDEXECOPT_PROMPTUSER);
   frDoc := DefaultInterface;
   frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
   oHTML_Doc.selection.empty;
  end;
end;

procedure TfrmCastle.miRefreshClick(Sender: TObject);
begin
 if Assigned(ChatThread) then ChatThread.PostMessage(UC_RefreshChat, 0, 0);
end;

function TfrmCastle.WBChatGetExternal(out ppDispatch: IDispatch): HRESULT;
var
 MyIDispatch: TTCastleClient;
begin
 MyIDispatch := TTCastleClient.Create;
 MyIDispatch.Window := Self.Handle;
 ppDispatch := MyIDispatch;
 result := S_OK;
end;

procedure TfrmCastle.iExitClick(Sender: TObject);
begin
 DoLogOut;
 Close;
end;

procedure TfrmCastle.k_obnClick(Sender: TObject);
begin
 ChatThread.PostMessage(UC_RefreshChat, 0, 0);
end;

procedure TfrmCastle.SetStyle(Style: string; Where: TEmbeddedWB);
var
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
 s, ovStyles: OleVariant;
begin
 frDoc := Where.DefaultInterface;
 frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
 
 s := 0;
 
 if oHTML_Doc.styleSheets.length > 0 then
  begin
   ovStyles := oHTML_Doc.styleSheets.Item(s);
   ovStyles.cssText := Style;
  end;
end;

procedure TfrmCastle.iAdminClick(Sender: TObject);
begin
 ShellExecute(0, 'open', 'http://castle.istu.edu/admin/', '', '', SW_NORMAL);
end;

procedure TfrmCastle.iRulesClick(Sender: TObject);
begin
 sRigth.Visible := not sRigth.Visible;
end;

function TfrmCastle.WBSmilesShowContextMenu(const dwID: Cardinal;
 const ppt: PPoint; const pcmdtReserved: IInterface;
 const pdispReserved: IDispatch): HRESULT;
begin
 result := S_OK;
end;

procedure TfrmCastle.tChatUptimeTimer(Sender: TObject);
begin
 if UseUptime then
  begin
   ChatUptime := IncSecond(ChatUptime, 1);
   sbLog.Panels[1].Text := TimeToStr(ChatUptime);
  end;
 
 sbLog.Panels[2].Text := TimeToStr(Now);
end;

procedure TfrmCastle.k_users_refreshClick(Sender: TObject);
begin
 if Assigned(ChatThread) then
  if Assigned(UserThread) then
   UserThread.PostMessage(UT_RefreshList, 0, 0);
end;

procedure TfrmCastle.k_sendClick(Sender: TObject);
begin
 eSendMessage.Items.Add(eSendMessage.Text);
 SayThread.PostMessage(US_SendThis, 0, StrToBuf(eSendMessage.Text));
 eSendMessage.Text := '';
end;

procedure TfrmCastle.eSendMessage1KeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 if ((ssCtrl in Shift) and (Key = 65)) then
  begin
   k_lat2rusClick(Sender);
   FocuseEditor;
  end;
 if (Key = VK_RETURN) then
  begin
   eSendMessage.Items.Add(eSendMessage.Text);
   if (ssCtrl in Shift) then k_sendprivatClick(Sender) else k_sendClick(Sender);
  end;
 if (Key = VK_UP) or (Key = VK_DOWN) then Key := 0;
end;

procedure TfrmCastle.iSetupClick(Sender: TObject);
begin
 with TfrmSetup.Create(Self) do
  begin
   ShowModal;
   Free;
  end;
end;

procedure TfrmCastle.iArchiveClick(Sender: TObject);
begin
 TfrmArchive.Create(Self);
end;

procedure TfrmCastle.WBChatDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
var
 i: Integer;
 s: string;
begin
 if pos('/loading', URL) > 0 then
  begin
   s := ReadReg(RegKey, 'WBChat_Style', '???');
   for i := 0 to miChatStyle.Count - 1 do
    if miChatStyle.Items[i].Caption = s then
     begin
      pmChat.PopupComponent := WBChat;
      miChatStyle.Items[i].OnClick(miChatStyle.Items[i]);
     end;
  end;
 if pos('/about', URL) > 0 then ReplaceHTML(WBChat, 'ver', '<b>'+ChatVersion+'</b>');
end;

procedure TfrmCastle.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 DoLogOut;
end;

procedure TfrmCastle.WBChatRefresh(Sender: TObject; CmdID: Integer; var Cancel: Boolean);
begin
 Cancel := True;
 if Assigned(ChatThread) then ChatThread.PostMessage(UC_RefreshChat, 0, 0);
end;

procedure TfrmCastle.miVBigClick(Sender: TObject);
begin
 TEmbeddedWB(TfrmCastle(TMenuItem(Sender).Owner).pmChat.PopupComponent).Zoom(TMenuItem(Sender).Tag);
end;

procedure TfrmCastle.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveFormState(RegKey + '\Главное', Self);
 FreeAndNil(frmMessages);
end;

procedure TfrmCastle.FormShow(Sender: TObject);
begin
 ReadFormState(RegKey + '\Главное', Self);
end;

procedure TfrmCastle.k_statusClick(Sender: TObject);
begin
 ChatThread.PostMessage(UC_ChangeStatus, 0, 0);
end;

procedure TfrmCastle.miPrivateInfoClick(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   TChatUser(Data.UserInfo).ShowInfo(0);
  end;
end;

procedure TfrmCastle.k_sendprivatClick(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   eSendMessage.Items.Add(eSendMessage.Text);
   SayThread.PostMessage(US_SendThisP, StrToBuf(Data.UserId), StrToBuf(eSendMessage.Text));
   eSendMessage.Text := '';
  end;
end;

procedure TfrmCastle.SetPrivateName(UserName: string);
begin
 vstUsers.Selected[GetNodeByName(UserName)] := True;
end;

function TfrmCastle.FindPWnd(UserName: string): boolean;
var
 i: Integer;
begin
 Result := False;
 for i := 0 to ChatPWindows.Count - 1 do
  if TfrmChatWith(ChatPWindows[i]).fUser.UserName = UserName then
   begin
    TfrmChatWith(ChatPWindows[i]).BringToFront;
    Result := true;
    Break;
   end;
end;

{procedure TfrmCastle.ReplaceHTML(idTag, HTML: string);
var
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
begin
 while WBChat_Busy do Application.ProcessMessages;
 frDoc := WBChat.DefaultInterface;
 frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
 try
  HTMLTable(oHTML_Doc.all.item(idTag, varEmpty)).innerHTML := HTML;
 except
  on E: Exception do EMsg('Ошибка замены текста: ' + idTag);
 end;
end;}

procedure TfrmCastle.lvUsersInsert;
begin
 if (vstUsers.RootNodeCount > 9999) then
  Label1.Caption := 'Заключенных: 0' else
  Label1.Caption := 'Заключенных: ' + IntToStr(vstUsers.RootNodeCount) + ' чел.';
end;

procedure TfrmCastle.lvUsersCustomDrawItem(Sender: TCustomListView;
 Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
 if Assigned(TChatUser(Item.Data)) then
  with TChatUser(Item.Data) do
   begin
    Item.Checked := RecvText;
    if UserName = Item.Caption then Font.Style := Font.Style + [fsBold];
    case Status of
     usOffline: Item.ImageIndex := 0;
     usOnline: Item.ImageIndex := 1;
     usNoActive: Item.ImageIndex := 2;
    end;
   end;
end;

procedure TfrmCastle.mPrivateKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 if key = VK_RETURN then k_sendprivatClick(Sender);
end;

function SortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
begin
 Result := AnsiCompareStr(ReplaceCharsOut(Item1.Caption), ReplaceCharsOut(Item2.Caption));
end;

procedure TfrmCastle.iMessagesClick(Sender: TObject);
begin
 ShowPrivateMail;
end;

procedure TfrmCastle.FocuseEditor;
begin
 pCTRL.SetFocus;
 with eSendMessage do
  begin
   SetFocus;
   SelStart := Length(Text);
   SelLength := 0;
  end;
end;

procedure TfrmCastle.ShowPrivateMess(var Mess: TChatText);
begin
 with TfrmBaloon.Create(Self) do
  begin
   Caption := 'Приват от: ' + Mess.FromNick;
   ltext.Text := Mess.Text;
   Show;
  end;
end;

function TfrmCastle.GetNodeByName(UserName: string): PVirtualNode;
var
 Node: PVirtualNode;
 Data: PvUserInfo;
begin
 Result := nil;
 
 if UserName <> '' then
  begin
   Node := vstUsers.GetFirst;
   Data := vstUsers.GetNodeData(Node);

   while (Node <> nil) and (Data.UserNick <> UserName) do
    begin
     Node := vstUsers.GetNext(Node);
     Data := vstUsers.GetNodeData(Node);
    end;
   if (Data <> nil) and (Data.UserNick = UserName) then Result := Node;
  end;
end;

procedure TfrmCastle.ShowPrivateMail;
begin
 // SendMessage(frmMessages.Handle, PM_ChechMessages, 0, 0);
 frmMessages.Show;
end;

function TfrmCastle.AppHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
begin
 Result := True;
end;

procedure TfrmCastle.pmUsersPopup(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   miPrivateInfo.Caption := Format(PrivateDelo, [Data.UserNick]);
   miPrivateInfo.Visible := True;
   if not WebNames.InArray(TChatUser(Data.UserInfo).UserName) then chatirkru.Visible := False else chatirkru.Visible := True;
  end else
  begin
   chatirkru.Visible := False;
   miPrivateInfo.Visible := False;
  end;
end;

procedure TfrmCastle.chatirkruClick(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   TChatUser(Data.UserInfo).ShowInfo(4);
  end;
end;

procedure TfrmCastle.FormKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 case Key of
  115: if (ssAlt in Shift) then ChatThread.PostMessage(UC_SaveAll, 0, 0);
  VK_F5: if Assigned(ChatThread) then ChatThread.PostMessage(UC_RefreshChat, 0, 0);
 end;
end;

procedure TfrmCastle.pmChatChange(Sender: TObject; Source: TMenuItem;
 Rebuild: Boolean);
begin
 if TPopupMenu(Sender).PopupComponent <> WBChat then
  miRefresh.Visible := False else
  miRefresh.Visible := True;
end;

procedure TfrmCastle.N2Click(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   TChatUser(Data.UserInfo).ShowInfo(3);
  end;
end;

procedure TfrmCastle.N3Click(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   TChatUser(Data.UserInfo).ShowInfo(1);
  end;
end;

function TfrmCastle.WBChatShowHelp(hwnd: Cardinal; pszHelpFile: PWideChar;
 uCommand, dwData: Integer; ptMouse: TPoint;
 var pDispatchObjectHit: IDispatch): HRESULT;
begin
 PostMessage(Self.Handle, WM_HELP, uCommand, dwData);
 result := S_OK;
end;

function TfrmCastle.WBSmilesShowHelp(hwnd: Cardinal;
 pszHelpFile: PWideChar; uCommand, dwData: Integer; ptMouse: TPoint;
 var pDispatchObjectHit: IDispatch): HRESULT;
begin
 SendMessage(Self.Handle, WM_HELP, uCommand, dwData);
 result := S_OK;
end;

procedure TfrmCastle.lvUsersKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 if key = 68 then
  ShowMessage(ChatLog.GetLastString);
end;

procedure TfrmCastle.vstUsersGetText(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
 var CellText: WideString);
var
 Data: PvUserInfo;
begin
 Data := Sender.GetNodeData(Node);
 CellText := Data.UserNick;
end;

procedure TfrmCastle.vstUsersGetImageIndex(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
 var Ghosted: Boolean; var ImageIndex: Integer);
var
 Data: PvUserInfo;
begin
 Data := Sender.GetNodeData(Node);
 case Column of
  4: case TChatUser(Data.UserInfo).RecvText of
    true: ImageIndex := 5;
    false: ImageIndex := 4;
   end;
  0:
   case Data.Status of
    usOnline: ImageIndex := 1;
    usOffline: ImageIndex := 0;
    usNoActive: ImageIndex := 2;
    usDisabled: ImageIndex := 3;
   end;
 end;
end;

procedure TfrmCastle.vstUsersGetHint(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
 var CellText: WideString);
var
 Data: PvUserInfo;
begin
 Data := Sender.GetNodeData(Node);
 with TChatUser(Data.UserInfo) do
  CellText := '* Ник: ' + UserName + #13#10 +
   IfThen((Length(ICQ) > 0), #13#10'* ICQ: ' + ICQ) +
   IfThen((Length(Info) > 0), #13#10'* Инфо: ' + Info) +
   IfThen((Length(Comment) > 0), #13#10'* Комментарий:'#13#10 + Comment) +
   IfThen(WebNames.InArray(UserName), #13#10'* Присутствует в галерее на chat.irk.ru');
end;

procedure TfrmCastle.vstUsersDblClick(Sender: TObject);
var
 Data: PvUserInfo;
begin
 if vstUsers.GetFirstSelected <> nil then
  begin
   Data := vstUsers.GetNodeData(vstUsers.GetFirstSelected);
   AddFirst(Data.UserNick + ', ');
  end;
end;

function TfrmCastle.wbrecShowContextMenu(const dwID: Cardinal;
 const ppt: PPoint; const pcmdtReserved: IInterface;
 const pdispReserved: IDispatch): HRESULT;
begin
 result := S_OK;
end;

procedure TfrmCastle.N6Click(Sender: TObject);
var
 pNode: PVirtualNode;
 pData: PvUserInfo;
 ChatWnd: TfrmChatWith;
begin
 pNode := vstUsers.GetFirstSelected;
 if pNode <> nil then
  begin
   pData := vstUsers.GetNodeData(pNode);
   if pData <> nil then
    if not FindPWnd(pData.UserNick) then
     begin
      ChatWnd := TfrmChatWith.Create(Self);
      ChatPWindows.Add(ChatWnd);
      with ChatWnd do
       begin
        fParentWnd := Self.Handle;
        SetUser(TChatUser(pData.UserInfo));
        Show;
       end;
     end;
  end;
end;

procedure TfrmCastle.WBChatDownloadComplete(Sender: TObject);
begin
 WBChat_Busy := False;
end;

procedure TfrmCastle.TrayIconClick(Sender: TObject);
begin
 if Application.MainForm.Visible then
  begin
   Application.Minimize;
  end else
  begin
   Application.Restore;
   Application.MainForm.Visible := True;
   Application.BringToFront;
  end;
end;

procedure TfrmCastle.WBChatDownloadBegin(Sender: TObject);
begin
 WBChat_Busy := True;
end;

procedure TfrmCastle.vstUsersChecked(Sender: TBaseVirtualTree;
 Node: PVirtualNode);
var
 Data: PvUserInfo;
begin
 Data := Sender.GetNodeData(Node);
 if Data <> nil then
  TChatUser(Data.UserInfo).RecvText := not TChatUser(Data.UserInfo).RecvText;
end;

procedure TfrmCastle.iLockChatClick(Sender: TObject);
begin
 ChatThread.PostMessage(UT_LockChat, 0, 0);
 ChatThread.PostMessage(UC_RefreshChat, 0, 0);
end;

procedure TfrmCastle.WBSmilesDocumentComplete(ASender: TObject;
 const pDisp: IDispatch; var URL: OleVariant);
var
 ts: TStringList;
begin
 if not SmilesLoaded then
  begin
   ts := TStringList.Create;
   WBSmiles.SaveToStrings(ts);
   ts.Text := StringReplace(ts.Text, 'path\', makePath(ExtractFilePath(ParamStr(0))), [rfReplaceAll, rfIgnoreCase]);
   WBSmiles.LoadFromStrings(ts);
   FreeAndNil(ts);
   SmilesLoaded := True;
  end;
end;

procedure TfrmCastle.WBSmilesRefresh(Sender: TObject; CmdID: Integer;
 var Cancel: Boolean);
begin
 Cancel := True;
end;

procedure TfrmCastle.k_lat2rusClick(Sender: TObject);
var
 s, s1: string;
 i: integer;
begin
 i := Pos(',', eSendMessage.Text);
 s := copy(eSendMessage.Text, 1, i - 1);
 
 if (i > 0) and (ChatUsers.IsNick(s)) then
  begin
   s1 := s;
   s := eSendMessage.Text;
   Delete(s, 1, i);
   s := ReplaceCharsLatToRus(s);
   eSendMessage.Text := s1 + ',' + s;
  end
 else eSendMessage.Text := ReplaceCharsLatToRus(eSendMessage.Text);
end;

procedure TfrmCastle.WBSmilesBeforeNavigate2(ASender: TObject;
 const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
 Headers: OleVariant; var Cancel: WordBool);
begin
 if Pos('smiles', URL) = 0 then Cancel := True;
end;

initialization
 
 ChatStyles := TStringList.Create;
 
 LocalDir := ExtractFilePath(ParamStr(0));
 ChatPWindows := TList.Create;
 
finalization
 
 FreeAndNil(ChatPWindows);
 FreeAndNil(ChatStyles);
 
end.

