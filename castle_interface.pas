unit castle_interface;

interface

uses
 Forms,
 ComObj,
 ActiveX,
 castleclient_TLB,
 Dialogs,
 Variants,
 ComServ,
 Windows,
 Classes,
 Threads,
 castle_utils,
 SysUtils,
 ComCtrls,
 VirtualTrees,
 Graphics,
 Jpeg;

const
 //
 UL_LogMessage = $1000 + 1;
 //
 UT_RefreshList = $4000 + 1;
 UT_UserListRef = $4000 + 2;
 UT_LogMessage = $4000 + 3;
 UT_Exception = $4000 + 13;
 UT_SetRoom = $4000 + 30;
 UT_GetRooms = $4000 + 31;
 UT_GetTime = $4000 + 32;
 UT_UpdateRooms = $4000 + 33;
 UT_UpdateRoomsMenu = $4000 + 34;
 UT_UpdateTime = $4000 + 35;
 UT_LockChat = $4000 + 40;
 UT_UnLockChat = $4000 + 41;
 //
 UC_Dologin = $3000;
 UC_WeLogin = $3000 + 1;
 UC_HostNotFound = $3000 + 2;
 UC_LoginFailed = $3000 + 3;
 UC_UnregUser = $3000 + 4;
 UC_RefreshChat = $3000 + 5;
 UC_GetChatFor = $3000 + 6;
 UC_ChatFor = $3000 + 7;
 UC_Exceptioon = $3000 + 13;
 UC_WeStop = $3000 + 100;
 UC_ChangeStatus = $3000 + 15;
 UC_SaveAll = $3000 + 20;
 UC_StartPrivate = $3000 + 25;
 UC_GetAvatar = $3000 + 30;
 UC_GetSmile = $3000 + 31;
 UC_StatRooms = $3000 + 35;
 UC_PrivateMess = $3000 + 40;
 UC_ChatLocked = $3000 + 45;
 //
 UC_MustStop = $3000 + 200;
 //
 UC_StartUsers = $3100 + 6;
 UC_StartSay = $3100 + 8;
 UC_Informer = $3100 + 10;
 //
 UC_ReadedBytes = $3200 + 1;
 //
 US_SendThis = $3500 + 1;
 US_SendThisP = $3500 + 3;
 US_TextSend = $3500 + 2;
 US_TextSendP = $3500 + 4;
 //
 UC_ChangeRoom = $3500 + 1;
 //
 USER_Add = $5000 + 1;
 USER_Del = $5000 + 2;
 //
 UP_We_Have_Messsage = $6000 + 1;
 UP_CheckNewMessage = $6000 + 2;
 UP_SendThisMessage = $6000 + 3;
 // UP_TextSend = $6000 + 4; // Посылка почтового сообщения
 //
 TC_SetSmile = $10000 + 1;
 TC_AddFirst = $10000 + 2;
 TC_SetPrivate = $10000 + 3;
 //
 
type
 TTCastleClient = class(TAutoObject, ICastleClient)
 protected
  TWindow: THandle;
  procedure Set_DoLogin(Value: OleVariant); safecall;
  function Get_GetLogin: OleVariant; safecall;
  function Get_GetProxyAddr: OleVariant; safecall;
  function Get_GetProxyPort: OleVariant; safecall;
  function Get_GetProxyUser: OleVariant; safecall;
  function Get_GetProxyPass: OleVariant; safecall;
  function Get_GetUseProxy: WordBool; safecall;
  function Get_GetUseProxyAuth: WordBool; safecall;
  function Get_GetPass: OleVariant; safecall;
  function Get_SaveChatLogin: WordBool; safecall;
  function Get_SaveProxyLogin: WordBool; safecall;
  procedure Set_SetSmile(Value: OleVariant); safecall;
  procedure Set_SetNick(Value: OleVariant); safecall;
  procedure Set_SetPrivateName(Value: OleVariant); safecall;
  procedure Set_DoConfig(Value: OleVariant); safecall;
  procedure Set_GetNickInfo(Value: OleVariant); safecall;
  procedure Set_SetRoom(Value: OleVariant); safecall;
  procedure Set_IncRoom(Value: Integer); safecall;
  procedure Set_ShowMail(Value: OleVariant); safecall;
  procedure Set_UlockChat(Value: OleVariant); safecall;
 public
  property Window: THandle read TWindow write TWindow;
 end;
 
 TUserStatus = (usOnline, usOffline, usNoActive, usDisabled);
 
 TChatUsers = class;

 TChatUser = class
 protected
  fid: string;
  fUserName: string;
  fICQ: string;
  fInfo: string;
  fComment: string;
  fNickColor: string;
  fTextColor: string;
  fDefNickColor: string;
  fDefTextColor: string;
  fStatus: TUserStatus;
  fRecvText: Boolean;
  fParent: TChatUsers;
  procedure UpdateStatus(NewStatus: TUserStatus);
 public
  Node: PVirtualNode;
  InfoForm: TForm;
  property Id: string read fId write fId;
  property UserName: string read fUserName write fUserName;
  property ICQ: string read fICQ write fICQ;
  property Info: string read fInfo write fInfo;
  property Comment: string read fComment write fComment;
  property NickColor: string read fNickColor write fNickColor;
  property TextColor: string read fTextColor write fTextColor;
  property DefNickColor: string read fDefNickColor write fDefNickColor;
  property DefTextColor: string read fDefTextColor write fDefTextColor;
  property Status: TUserStatus read fStatus write UpdateStatus;
  property RecvText: Boolean read fRecvText write fRecvText;
  property Parent: TChatUsers read fParent write fParent;
  procedure ShowInfo(ActiveTab: Integer);
  constructor Create;
 end;
 
 TChatUsers = class
 private
  fChatUsers: TStringList;
 protected
  procedure SaveToFile(FileName: string);
  procedure LoadFromFile(FileName: string);
 public
  //
  property ChatUsers: TStringList read fChatUsers;
  procedure UpdateUser(fId, fUserName: string; fStatus: TUserStatus; fRecvText: boolean);
  function IsNick(Nick: string): Boolean;
  constructor Create;
  destructor Destroy; override;
  //
  function GetUser(Name: string): TChatUser;
  function GetUserBan(Name: string): Boolean;
  procedure Sort;
 end;
 
 TTextType = (
  ttBegin, // Начало лога
  ttChat,
  ttPrivate,
  ttStrajIn,
  ttStrajOut,
  ttAdmin,
  ttPrivateM);
 
 TChatText = class(TObject)
  room_name: string;
  IsShow: Boolean;
  TextType: TTextType;
  Avatar: string;
  FromNickColor: string;
  NickColor: string;
  TextColor: string;
  FromNick: string; // if private
  ToNick: string;
  Text: string;
  fDate: TDateTime;
 public
  constructor Create;
 end;
 
 TStyle = record
  Font: string;
  Color: string;
  Size: Integer;
 end;
 
 TUsersThread = class(TSockMsgThread)
 private
  fNumber: string;
  fId: string;
  fTimeOut: Integer;
  fParentHandle: THandle;
 protected
  function GetUserList: string;
  function GetPrivateUserList: string;
  procedure DoExecute; override;
  procedure HandleException(E: Exception); override;
  procedure HandleMessage(var Msg: TMsg); override;
  procedure RefreshUsers;
 public
  constructor Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
  destructor Destroy; override;
 end;
 
 TChatThread = class(TSockMsgThread)
 private
  fChatLocked: boolean;
  fUserName: string;
  fPassword: string;
  fNumer: string;
  fId: string;
  fProxyAuth: string;
  fProxyAddr: string;
  fProxyPort: string;
  fTimeOut: Integer;
  fParentHandle: THandle;
  fOldMessage: Word;
 protected
  procedure DoExecute; override;
  procedure HandleException(E: Exception); override;
  procedure HandleMessage(var Msg: TMsg); override;
  procedure DoLoadAll;
  procedure DoSaveAll;
  procedure ChangeStatus;
  procedure GetAvatar(id: string);
  procedure GetSmile(name: string);
  procedure LockChat;
  procedure UlockChat(password: string);
 public
  property ChatLocked: boolean read fChatLocked;
  constructor Create(UserName, Password, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
  destructor Destroy; override;
  procedure RefreshChat;
  procedure ExitFromChat;
 end;
 
 TSayThread = class(TSockMsgThread)
 private
  fNumber: string;
  fId: string;
  fTimeOut: Integer;
  fParentHandle: THandle;
 protected
  procedure DoExecute; override;
  procedure HandleException(E: Exception); override;
  procedure HandleMessage(var Msg: TMsg); override;
  procedure Say(SayStr: string);
  procedure SayPrivate(UserId, SayStr: string);
 public
  constructor Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
  destructor Destroy; override;
 end;
 
 PChatLogView = ^TChatLogView;
 TChatLogView = record
  Name: string;
  Messages: TList;
 end;
 
 TChatLog = class
 protected
  fFirstMessage: Integer;
  fChatLog: TList;
  fChatDate: TDateTime;
  fWeBusy: Boolean;
  fKnownRooms: TStringList;
  procedure WaitBusy;
 public
  procedure AddRoom(room_name: string);
  property KnowRooms: TStringList read fKnownRooms;
  property ChatDate: TDateTime read fChatDate;
  constructor Create;
  destructor Destroy; override;
  function GetLastString: string;
  procedure AddMess(var ChatMessage: TChatText);
  function NewMessage: TChatText;
  procedure LoadFromFile(FileName: string);
  procedure SaveToFile(FileName: string);
  procedure GetMessages(var List: TList; Count, From: Integer);
  procedure GetLogByPart(room_name: string; var List: TVirtualStringTree);
  procedure GetMessagetFor(var List: TList; Nick: string); overload;
  procedure GetMessagetFor(var List: TList; Nick: string; Count: Integer); overload;
 end;
 
 TWebNames = class
 private
  fNames: TStringList;
 public
  function InArray(uName: string): Boolean;
  function GetLink(uName: string): string;
  procedure LoadFromFile(FileName: string);
  constructor Create;
  destructor Destroy; override;
 end;
 
 TPrivateMessages = class(TSockMsgThread)
  // http://castle.istu.edu/cgi-bin/castle_if/tools/readsoob.pl?id=55FEZBxnDHXRw&numer=63783
 private
  fNumber: string;
  fId: string;
  fTimeOut: Integer;
  fParentHandle: THandle;
  fMessages: TList;
 protected
  function NewMessage: TChatText;
  procedure CheckNewMessages;
  procedure ParceMessages(InHTML: string);
  procedure DoExecute; override;
  procedure HandleException(E: Exception); override;
  procedure HandleMessage(var Msg: TMsg); override;
  procedure LoadFromFile(FileName: string);
  procedure SaveToFile(FileName: string);
  procedure PostPMessage(Who, fText: string);
 public
  constructor Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
  destructor Destroy; override;
  property Messages: TList read fMessages;
 end;
 
 TRoomThread = class(TSockMsgThread)
  fNumber: string;
  fId: string;
  fTimeOut: Integer;
  fParentHandle: THandle;
  fActiveRoom: string;
  fChatDate: string;
  fRooms: TStringList;
 protected
  procedure DoExecute; override;
  procedure HandleException(E: Exception); override;
  procedure HandleMessage(var Msg: TMsg); override;
  procedure GetRooms;
  procedure GetTime;
  procedure SetRoom(RoomId: string);
  function GetRoomByN(num: Integer): string;
  procedure UpdateRooms;
 public
  property ActiveRoom: string read fActiveRoom;
  constructor Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
  destructor Destroy; override;
 end;
 
const
 IT_Error = $9000 + 1;
 IT_Login = $9000 + 2;
 IT_Logout = $9000 + 3;
 IT_SetText = $9000 + 10;
 IT_SetUrl = $9000 + 11;
 IT_SetNews = $9000 + 20;
 
type
 TInformerThread = class(TSockMsgThread)
 private
  fUserName: string;

  fLocalIp: string;
  fOutIp: string;

  fChatNews: string;

  fParentHandle: THandle;

 protected
  procedure DoExecute; override;
  procedure GetNews;
  procedure BeginChat;
  procedure UserOnline;
  procedure EndChat;
  procedure GetTextReklama;
 public
  constructor Create(User, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
  destructor Destroy; override;
 end;
 
 TConfig = class(TObject)
 private
  fConfig: TStringList;
 protected
  function GetValue_Str(Value: string): string;
  procedure SetValue_Str(Name, Value: string);
  function GetValue_Int(Value: string): integer;
  procedure SetValue_Int(Name: string; Value: integer);
  function GetValue_Bool(Value: string): Boolean;
  procedure SetValue_Bool(Name: string; Value: Boolean);
  function SaveConfig(FileName: string): boolean;
  function LoadConfig(FileName: string): boolean;
 public
  property Value_Str[Name: string]: string read GetValue_Str write SetValue_Str;
  property Value_Int[Name: string]: integer read GetValue_Int write SetValue_Int;
  property Value_Bool[Name: string]: Boolean read GetValue_Bool write SetValue_Bool;
  constructor Create(User: string);
  destructor Destroy; override;
 end;
 
function RawToHTML(RawList: TList; UseTime: Boolean): string;

var
 ChatThread: TChatThread;
 UserThread: TUsersThread;
 SayThread: TSayThread;
 ChatLog: TChatLog;
 ChatUsers: TChatUsers;
 WebNames: TWebNames;
 PrivateMessages: TPrivateMessages;
 InformerThread: TInformerThread;
 RoomThread: TRoomThread;
 Config: TConfig;
 
implementation

uses
 Main,
 castle_userinfo,
 castle_setup,
 DateUtils,
 Crypt32,
 Math,
 StrUtils,
 NetLayerU;

////////////////////////////////////////////////////////////////////////////////

function TConfig.GetValue_Str(Value: string): string;
var
 i: integer;
begin
 i := fConfig.IndexOf(Value);
 
 if i > -1 then
  Result := BufToStr(Integer(fConfig.Objects[i]), False) else
  Result := '';
end;

procedure TConfig.SetValue_Str(Name, Value: string);
var
 i: integer;
begin
 i := fConfig.IndexOf(Name);
 
 if i = -1 then
  i := fConfig.AddObject(Name, nil);
 
 if fConfig.Objects[i] <> nil then
  FreeMem(Pointer(fConfig.Objects[i]));
 
 fConfig.Objects[i] := TObject(StrToBuf(Value));
end;

function TConfig.GetValue_Int(Value: string): integer;
begin
 Result := StrToIntDef(GetValue_Str(Value), 0);
end;

procedure TConfig.SetValue_Int(Name: string; Value: integer);
begin
 SetValue_Str(Name, IntToStr(Value));
end;

function TConfig.GetValue_Bool(Value: string): Boolean;
begin
 Result := StrToBoolDef(GetValue_Str(Value), true);
end;

procedure TConfig.SetValue_Bool(Name: string; Value: Boolean);
begin
 SetValue_Str(Name, BoolToStr(Value, True));
end;

function TConfig.LoadConfig(FileName: string): boolean;
var
 zStream: TFileStream;
 z, i: integer;
 s: string;
begin
 Result := False;
 
 if FileExists(FileName) then
  begin
   zStream := TFileStream.Create(FileName, fmOpenRead);

   SetLength(s, BinaryHeaderLength);

   zStream.Read(s[1], BinaryHeaderLength);

   if s = BinaryHeader then
    begin
     zStream.Read(z, sizeof(Integer));
     for i := 0 to z - 1 do
      begin
       s := ReadStr(zStream);
       SetValue_Str(s, ReadStr(zStream));
      end;
     Result := True;
    end else
    Result := False;

   FreeAndNil(zStream);
  end;
end;

function TConfig.SaveConfig(FileName: string): boolean;
var
 zStream: TFileStream;
 i: integer;
begin
 try
  zStream := TFileStream.Create(FileName, fmCreate or fmOpenWrite);

  i := fConfig.Count;

  zStream.Write(BinaryHeader, BinaryHeaderLength);
  zStream.Write(i, sizeof(Integer));

  for i := 0 to fConfig.Count - 1 do
   begin
    WriteStr(zStream, fConfig[i]);
    WriteStr(zStream, BufToStr(Integer(fConfig.Objects[i])));
   end;

  FreeAndNil(zStream);
  Result := True;
 except
  Result := False;
 end;
 
end;

constructor TConfig.Create(User: string);
var
 s: string;
begin
 fConfig := TStringList.Create;
 
 if not LoadConfig(ProfileDir + '\Config.dat') then
  begin
   Value_Int['RefreshChatTime'] := 15;
   Value_Int['RefreshUsersTime'] := 120;
   Value_Int['MaxMessagesCount'] := 35;
   Value_Int['RefreshPrivateTime'] := 600;
   Value_Bool['SaveLogToHTML'] := False;
   Value_Bool['AddTimeInHtmlLog'] := False;
   Value_Bool['PlaySounds'] := True;
   Value_Bool['ShowNewMail'] := True;
   Value_Int['MaxLogMessages'] := 99999;
   Value_Int['MaxLogDays'] := 356;

   s := ExtractFileDir(ParamStr(0)) + '\sounds\';

   Value_Str['Sound_Mail'] := s + 'mail.wav';
   Value_Str['Sound_Problem'] := s + 'problem.wav';
   Value_Str['Sound_Login'] := s + 'login.wav';
   Value_Str['Sound_Admin'] := s + 'admin.wav';
   Value_Str['Sound_Online'] := s + 'online.wav';
   Value_Str['Sound_Offline'] := s + 'offline.wav';
   Value_Str['Sound_Private'] := s + 'message_p.wav';
   Value_Str['Sound_Message'] := s + 'message.wav';
  end;
end;

destructor TConfig.Destroy;
begin
 SaveConfig(ProfileDir + '\Config.dat');
 FreeAndNil(fConfig);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TChatUser.UpdateStatus(NewStatus: TUserStatus);
begin
 fStatus := NewStatus;
 if (fStatus = usDisabled) then UserThread.PostMessage(USER_Del, Integer(Self), 0) else
  if (fStatus = usOnline) or
   (fStatus = usOffline) or
   (fStatus = usNoActive) then
   UserThread.PostMessage(USER_Add, Integer(Self), 0);
end;

procedure TChatUser.ShowInfo(ActiveTab: Integer);
begin
 if InfoForm = nil then
  begin
   InfoForm := TfrmUserInfo.Create(Application.MainForm);
   with TfrmUserInfo(InfoForm) do
    begin
     User := Self;
     lName.Caption := UserName;
     eICQ.Text := ICQ;
     eInfo.Text := Info;
     eMemo.Text := Comment;
     eNickColor.Text := DefNickColor;
     eTextColor.Text := DefTextColor;
     cbRecvText.Checked := RecvText;
     if not WebNames.InArray(UserName) then chat_irk_ru.Visible := False;
     if ActiveTab > 0 then PageControl.ActivePageIndex := ActiveTab;
     PageControlChange(InfoForm);
     Show;
    end;
  end else InfoForm.BringToFront;
end;

constructor TChatUser.Create;
begin
 fStatus := usDisabled;
 fRecvText := True;
 Node := nil;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TChatUsers.SaveToFile(FileName: string);
var
 zStream: TFileStream;
 i: Integer;
begin
 try
  zStream := TFileStream.Create(FileName + '.dat', fmCreate or fmOpenWrite);

  i := fChatUsers.Count;

  zStream.Write(BinaryHeader, BinaryHeaderLength);
  zStream.Write(i, sizeof(Integer));

  for i := 0 to fChatUsers.Count - 1 do
   with TChatUser(fChatUsers.Objects[i]) do
    begin
     WriteStr(TFileStream(zSTream), UserName);
     WriteStr(TFileStream(zSTream), ICQ);
     WriteStr(TFileStream(zSTream), Info);
     WriteStr(TFileStream(zSTream), Comment);
     WriteStr(TFileStream(zSTream), NickColor);
     WriteStr(TFileStream(zSTream), TextColor);
     WriteStr(TFileStream(zSTream), DefNickColor);
     WriteStr(TFileStream(zSTream), DefTextColor);
     zStream.Write(RecvText, sizeof(Integer));
    end;

  FreeAndNil(zStream);
 except
  on E: Exception do
   EMsg('Невозможно сохранить файл пользователей!'#13#10'Причина: ' + SysErrorMessage(GetLastError) + #13#10 + E.Message);
 end
end;

procedure TChatUsers.LoadFromFile(FileName: string);
var
 zStream: TFileStream;
 i, Count, d: Integer;
 s: string;
begin
 FileName := FileName + '.dat';
 if FileExists(FileName) then
  try
   zStream := TFileStream.Create(FileName, fmOpenRead);

   SetLength(s, BinaryHeaderLength);

   zStream.Read(s[1], BinaryHeaderLength);

   if s = BinaryHeader then
    begin
     zStream.Read(Count, sizeof(Integer));

     for i := 0 to Count - 1 do
      begin
       s := ReadStr(TFileStream(zSTream));
       with GetUser(s) do
        begin
         UserName := s;
         ICQ := ReadStr(TFileStream(zSTream));
         Info := ReadStr(TFileStream(zSTream));
         Comment := ReadStr(TFileStream(zSTream));
         NickColor := ReadStr(TFileStream(zSTream));
         TextColor := ReadStr(TFileStream(zSTream));
         DefNickColor := ReadStr(TFileStream(zSTream));
         DefTextColor := ReadStr(TFileStream(zSTream));
         zStream.Read(d, sizeof(Integer));
         RecvText := Boolean(d);
        end;
      end;
     FreeAndNil(zStream);
    end else
    begin
     FreeAndNil(zStream);
     DeleteFile(FileName + '.dat');
    end;
  except
   on E: Exception do
    EMsg('Невозможно открыть файл пользователей!'#13#10'Причина: ' + SysErrorMessage(GetLastError) + #13#10 + E.Message);
  end;
end;

procedure TChatUsers.UpdateUser(fId, fUserName: string; fStatus: TUserStatus; fRecvText: boolean);
var
 i: Integer;
 User: TChatUser;
begin
 i := fChatUsers.IndexOf(fUserName);
 if i > -1 then
  begin
   User := TChatUser(fChatUsers.Objects[i]);
   User.UserName := fUserName;
   User.id := fId;
   User.Status := fStatus;
   User.RecvText := fRecvText;
  end else
  with GetUser(fUserName) do
   begin
    id := fId;
    Status := fStatus;
    RecvText := fRecvText;
   end;
end;

function TChatUsers.IsNick(Nick: string): Boolean;
begin
 if fChatUsers.IndexOf(Nick) > -1 then
  Result := True else
  Result := False;
end;

constructor TChatUsers.Create;
begin
 fChatUsers := TStringList.Create;
end;

destructor TChatUsers.Destroy;
var
 i: Integer;
begin
 for i := 0 to fChatUsers.Count - 1 do fChatUsers.Objects[i].Free;
 FreeAndNil(fChatUsers);
 inherited;
end;

function TChatUsers.GetUser(Name: string): TChatUser;
var
 i: Integer;
begin
 Result := nil;
 i := fChatUsers.IndexOf(Name);
 if Length(Name) > 0 then
  if i > -1 then
   Result := TChatUser(fChatUsers.Objects[i]) else
   begin
    Result := TChatUser.Create;
    Result.UserName := Name;
    fChatUsers.AddObject(Name, Result);
    if Result.Status <> usDisabled then
     UserThread.PostMessage(USER_Add, Integer(Result), 0);
  end else
  EMsg('TChatUsers->GetUser(): UserName = null');
end;

function TChatUsers.GetUserBan(Name: string): Boolean;
var
 User: TChatUser;
begin
 Result := False;
 User := GetUser(Name);
 if User <> nil then Result := not User.RecvText;
end;

procedure TChatUsers.Sort;
begin
 fChatUsers.Sort;
end;

// TChatText ////////////////////////////////////////////////////////////////

constructor TChatText.Create;
begin
 if not Assigned(RoomThread) then
  room_name := 'Основная' else
  room_name := RoomThread.ActiveRoom;
end;

// TUsersThread ////////////////////////////////////////////////////////////////

function TUsersThread.GetUserList: string;
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/users.pl?numer=' + fNumber, '', '', '');
 if Pos('200 OK', s) > 0 then
  Result := s else
  Result := '';
end;

function TUsersThread.GetPrivateUserList: string;
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/private.pl?action=show&numer=' + fNumber + '&id=' + fId, '', '', '');
 if Pos('200 OK', s) > 0 then
  Result := s else
  Result := '';
end;

procedure TUsersThread.DoExecute;
begin
 CreateMessageQueue;
 
 DoMainLog('UserThread: Started');
 
 RefreshUsers;
 
 while not Terminated do
  case MsgWaitForMultipleObjects(1, StopEvent, False, fTimeOut, QS_ALLINPUT) of
   WAIT_OBJECT_0: Break;
   WAIT_OBJECT_0 + 1: CheckMessages;
   WAIT_TIMEOUT:
    begin
     PostMessage(UT_RefreshList, 0, 0);
     PostMessage(UT_SetRoom, 0, 0);
    end;
  end;
 
 DoMainLog('UserThread: Stopped');
end;

procedure TUsersThread.HandleException;
begin
 EMsg('Ошибка в UsersThread: ' + E.Message);
 DoMainLog('Ошибка в UsersThread: ' + E.Message);
 ChatThread.PostMessage(UC_StartUsers, 0, 0);
end;

procedure TUsersThread.HandleMessage(var Msg: TMsg);
begin
 case Msg.message of
  UT_RefreshList: RefreshUsers;
  //!!! UT_SetRoom: RefreshRoom;
  USER_Add: SendMessage(fParentHandle, USER_Add, Msg.wParam, 0);
  USER_Del: SendMessage(fParentHandle, USER_Del, Msg.wParam, 0);
 else inherited;
 end;
end;

procedure TUsersThread.RefreshUsers;

 procedure AddUser(uStatus, Name: string);
 begin
  with ChatUsers.GetUser(Name) do
   begin
    if uStatus = 'online' then
     Status := usOnline else
     Status := usOffline;
   end;
 end;
 
 procedure DoParceUsers(var s: string);

 const
  sf = '<img src="/images/';
  sl = '.gif">';
  uf = ')">';
  ul = '</a><br>';

 var
  i: Integer;
  un, su: string;

 begin
  i := Pos(sf, s);
  while i > 0 do
   begin
    Delete(s, 1, i + Length(sf) - 1);
    i := Pos(sl, s);
    su := Copy(s, 1, i - 1);
    i := Pos(uf, s);
    Delete(s, 1, i + Length(uf) - 1);
    i := Pos(ul, s);
    un := Copy(s, 1, i - 1);
    AddUser(su, un);
    i := Pos(sf, s);
   end;
 end;
 
 procedure DoParceId(ss: string);

 const
  idf = '<option value=';
  idl = '>';
  ul = '<';

 var
  i: Integer;
  uid, un, s: string;

 begin
  s := ss;
  i := Pos(idf, s);
  while i > 0 do
   begin
    Delete(s, 1, i + Length(idf));
    i := Pos('"', s);
    uid := Copy(s, 1, i - 1);
    i := Pos(idl, s);
    Delete(s, 1, i);
    i := Pos(ul, s);
    un := Copy(s, 1, i - 2);
    ChatUsers.GetUser(un).id := uid;
    i := Pos(idf, s);
   end;
 end;
 
var
 s: string;
 i: Integer;
 
begin
 DoMainLog('Обновление списка чатланов');
 
 s := GetUserList;
 
 for i := 0 to ChatUsers.ChatUsers.Count - 1 do
  if Pos(TChatUser(ChatUsers.ChatUsers.Objects[i]).UserName, s) < 1 then
   TChatUser(ChatUsers.ChatUsers.Objects[i]).UpdateStatus(usDisabled);
 
 repeat
  i := Pos(#13#10, s);
  if (i = 0) then Break;
  Delete(s, i, 2);
 until False;
 
 DoParceUsers(s);
 
 s := GetPrivateUserList;
 
 repeat
  i := Pos(#13#10, s);
  if (i = 0) then Break;
  Delete(s, i, 2);
 until False;
 
 repeat
  i := Pos('  ', s);
  if (i = 0) then Break;
  Delete(s, i, 2);
 until False;
 
 repeat
  i := Pos('selected', s);
  if (i = 0) then Break;
  Delete(s, i, 8);
 until False;
 
 DoParceId(s);
 
 SendMessage(fParentHandle, UT_UserListRef, 0, 0);
 
 DoMainLog('Обновление списка чатланов завершено');
end;

constructor TUsersThread.Create;
begin
 fNumber := numer;
 fId := Id;
 fTimeOut := TimeOut;
 fParentHandle := ParentHandle;
 // fChatUsers.LoadFromFile(ProfileDir+'\Users');
 inherited Create(fParentHandle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
end;

destructor TUsersThread.Destroy;
begin
 inherited;
 DoMainLog('UsersThread->Destroy = ok');
end;

// TChatThread /////////////////////////////////////////////////////////////////

procedure TChatThread.DoExecute;
const
 nf = 'main/window.pl?numer=';
 nl = '&id=';
 idl = '" name=message>';
 
var
 s: string;
 i: Integer;
begin
 DoMainLog('ChatThread: Started');
 CreateMessageQueue;
 
 fOldMessage := 0;
 
 DoMainLog('ChatThread: Аунтификация на прокси сервере');
 // GetPage('POST', Proxy_Addr, '', '', '');
 
 DoMainLog('ChatThread: Получение страницы с данными пользователя');
 s := GetPage('POST', ChatHost + '/cgi-bin/castle_if/main/main.pl', '', 'nick=' + fUserName + '&pass=' + fPassword, '');
 DoMainLog('ChatThread: Получение страницы с данными пользователя');
 
 if Pos('200 OK', s) > 0 then
  if Pos('неверный пароль', s) > 0 then
   begin
    if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Problem']);
    DoMainLog('ChatThread: Пароль неверен');
    SendMessage(fParentHandle, UC_LoginFailed, 0, 0);
    fOldMessage := UC_LoginFailed;
   end else
   if Pos('незарегистрированных пользователей', s) > 0 then
    begin
     if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Problem']);
     DoMainLog('ChatThread: Незарегистированный пользователь');
     SendMessage(fParentHandle, UC_UnregUser, 0, 0);
     fOldMessage := UC_UnregUser;
    end else
    begin
     i := Pos(nf, s);
     Delete(s, 1, i + Length(nf) - 1);
     i := Pos(nl, s);
     fNumer := Copy(s, 1, i - 1);
     Delete(s, 1, i + Length(nl) - 1);
     i := Pos(idl, s);
     fId := Copy(s, 1, i - 1);

     if Length(fNumer) > 0 then
      begin

       if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Login']);

       ChatLog := TChatLog.Create;
       ChatUsers := TChatUsers.Create;

       Synchronize(DoLoadAll);

       SendMessage(fParentHandle, UC_WeLogin, 0, 0);

       PostMessage(UC_StartUsers, 0, 0);
       PostMessage(UC_StartSay, 0, 0);
       PostMessage(UC_StartPrivate, 0, 0);
       PostMessage(UC_StatRooms, 0, 0);
       PostMessage(UC_Informer, 0, 0);

       PostMessage(UC_RefreshChat, 0, 0);

       while not Terminated do
        case MsgWaitForMultipleObjects(1, StopEvent, False, fTimeOut, QS_ALLINPUT) of
         WAIT_OBJECT_0: Break;
         WAIT_OBJECT_0 + 1: CheckMessages;
         WAIT_TIMEOUT: PostMessage(UC_RefreshChat, 0, 0);
        end;

       TimeSeparator := '.';

       TimeSeparator := ':';

       Synchronize(DoSaveAll);

       FreeAndNil(ChatUsers);
       FreeAndNil(ChatLog);
      end;
   end else
   begin
    if Config.Value_Bool['PlaySounds'] then Config.Value_Str['Sound_Problem'];
    DoMainLog('ChatThread: Id пользователя не найдено');
    SendMessage(fParentHandle, UC_HostNotFound, 0, 0);
    fOldMessage := UC_HostNotFound;
   end;

   DoMainLog('ChatThread: Stopped');
   if fOldMessage = 0 then
    SendMessage(fParentHandle, UC_WeStop, 0, 0);
end;

procedure TChatThread.HandleException(E: Exception);
begin
 EMsg('Ошибка в ChatThread: ' + E.Message);
 DoMainLog('Ошибка в ChatThread: ' + E.Message);
 UserThread.StopThread;
 SayThread.StopThread;
 SendMessage(fParentHandle, UC_Exceptioon, 0, 0);
end;

procedure TChatThread.HandleMessage(var Msg: TMsg);
var
 List: TList;
begin
 case Msg.message of
  // Proxy Message
  UC_ReadedBytes: SendMessage(fParentHandle, UC_ReadedBytes, Msg.wParam, Msg.lParam);
  IT_SetText: SendMessage(fParentHandle, IT_SetText, Msg.wParam, Msg.lParam);
  UT_UpdateRooms: SendMessage(fParentHandle, UT_UpdateRooms, Msg.wParam, Msg.lParam);
  US_Message: SendMessage(fParentHandle, UL_LogMessage, Msg.wParam, Msg.lParam);
  UT_UpdateTime: SendMessage(fParentHandle, UT_UpdateTime, Msg.wParam, Msg.lParam);
  //
  UC_GetAvatar: GetAvatar(BufToStr(Msg.wParam));
  UC_GetSmile: GetSmile(BufToStr(Msg.wParam));
  UC_GetChatFor:
   begin
    List := TList.Create;
    ChatLog.GetMessagetFor(List, BufToStr(Msg.wParam), Config.Value_Int['MaxMessagesCount']);
    SendMessage(Msg.lParam, UC_ChatFor, StrToBuf(RawToHTML(List, False)), 0);
    FreeAndNil(List);
   end;
  UC_RefreshChat:
   begin // Refresh Chat
    RefreshChat;
    if not fChatLocked then
     begin
      List := TList.Create;
      ChatLog.GetMessages(List, Config.Value_Int['MaxMessagesCount'] - 1, 0);

      SendMessage(fParentHandle, UC_RefreshChat, 0, StrToBuf(RawToHTML(List, False)));
      FreeAndNil(List);
     end;
   end;
  UC_StartUsers:
   begin
    DoMainLog('Starting UsersThread');
    UserThread := TUsersThread.Create(fNumer, fId, fProxyAuth, fProxyAddr, fProxyPort, Config.Value_Int['RefreshUsersTime'] * 1000, fParentHandle);
   end;
  UC_StartSay:
   begin
    DoMainLog('Starting SayThread');
    SayThread := TSayThread.Create(fNumer, fId, fProxyAuth, fProxyAddr, fProxyPort, fTimeOut, fParentHandle);
   end;
  UC_StartPrivate:
   begin
    DoMainLog('Starting PrivateThread');
    PrivateMessages := TPrivateMessages.Create(fNumer, fId, fProxyAuth, fProxyAddr, fProxyPort, Config.Value_Int['RefreshPrivateTime'] * 1000, fParentHandle);
   end;
  UC_Informer:
   begin
    DoMainLog('Starting InformerThread');
    InformerThread := TInformerThread.Create(ChatUserName, fProxyAuth, fProxyAddr, fProxyPort, 600 * 1000, fParentHandle);
   end;
  UC_StatRooms:
   begin
    DoMainLog('Starting RoomThread');
    RoomThread := TRoomThread.Create(fNumer, fId, fProxyAuth, fProxyAddr, fProxyPort, 60 * 1000, fParentHandle);
   end;
  UT_LockChat: LockChat;
  UT_UnLockChat: UlockChat(BufToStr(Msg.wParam));
  UC_ChangeStatus: ChangeStatus;
  UC_SaveAll: Synchronize(DoSaveAll);
  UC_MustStop:
   begin
    DoMainLog('ChatThread prepare to terminate');

    UserThread.StopThread;
    UserThread.WaitFor;
    FreeAndNil(UserThread);

    SayThread.StopThread;
    SayThread.WaitFor;
    FreeAndNil(SayThread);

    PrivateMessages.StopThread;
    PrivateMessages.WaitFor;
    FreeAndNil(PrivateMessages);

    InformerThread.StopThread;
    InformerThread.WaitFor;
    FreeAndNil(InformerThread);

    RoomThread.StopThread;
    RoomThread.WaitFor;
    FreeAndNil(RoomThread);

    ExitFromChat;

    // Статистика
    GetPage('POST', 'http://ion.irk.ru/ccs.php.php', '', 'status=quit&nick=' + fUserName, '');

    Terminate;
   end;
 else inherited;
 end;
end;

procedure TChatThread.DoLoadAll;
begin
 ChatLog.LoadFromFile(ProfileDir + '\ChatLog');
 ChatUsers.LoadFromFile(ProfileDir + '\Users');
end;

procedure TChatThread.DoSaveAll;
begin
 DoMainLog('Сохранение данных');
 ChatLog.SaveToFile(ProfileDir + '\ChatLog');
 ChatUsers.SaveToFile(ProfileDir + '\Users');
end;

procedure TChatThread.ChangeStatus;
begin
 DoMainLog('Изменяем личный статус');
 GetPage('GET', ChatHost + '/cgi-bin/castle_if/tools/status.pl?numer=' + fNumer + '&id=' + fid, '', '', '');
end;

procedure TChatThread.GetAvatar(id: string);
var
 s: string;
begin
 // 38924 - Shershaviy
 DoMainLog('Получаем Аватар #' + id);
 if DirectoryExists(LocalDir + 'avatars') or CreateDir(LocalDir + 'avatars') then
  begin
   s := GetPage('GET', ChatHost + '/avatars/' + id + '.gif', '', '', '');
   if Pos('HTTP/1.1 200', s) > 0 then
    begin
     Delete(s, 1, Pos(#$0A#$0A, s) + 1);
     StringToFile(s, LocalDir + 'avatars\' + id + '.gif');
    end else DoMainLog('Ошибка получения аватара, не найден аватар на сервере');
  end else DoMainLog('Ошибка получения аватара, невозможно создать директорию');
end;

procedure TChatThread.GetSmile(name: string);
var
 s: string;
begin
 DoMainLog('Получаем Смайл ' + name);
 if DirectoryExists(LocalDir + 'smiles') or CreateDir(LocalDir + 'smiles') then
  begin
   s := GetPage('GET', ChatHost + '/smile/' + name + '.gif', '', '', '');
   if pos('HTTP/1.1 200', s) > 0 then
    begin
     Delete(s, 1, Pos(#$0A#$0A, s) + 1);
     StringToFile(s, LocalDir + 'smiles\' + name + '.gif');
    end else DoMainLog('Ошибка получения смайла, не найден смайл на сервере');
  end else DoMainLog('Ошибка получения смайла, невозможно создать директорию');
end;

procedure TChatThread.LockChat;
begin
 GetPage('GET', ChatHost + '/cgi-bin/castle_if/tools/lock.pl?id=' + fId + '&numer=' + fNumer + '&action=lock', '', '', ' ');
 PostMessage(UC_RefreshChat, 0, 0);
end;

procedure TChatThread.UlockChat(password: string);
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/tools/lock.pl?id=' + fId + '&password=' + password + '&numer=' + fNumer + '&action=unlock', '', '', '</p></font>');
 if Pos('Блокировка снята', s) > 0 then
  begin
   fChatLocked := False;
   PostMessage(UC_RefreshChat, 0, 0);
   RoomThread.PostMessage(UT_GetRooms, 0, 0);
  end;
end;

constructor TChatThread.Create(UserName, Password, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
begin
 fUserName := UserName;
 fPassword := Password;
 fProxyAuth := ProxyAuth;
 fProxyAddr := ProxyAddr;
 fProxyPort := ProxyPort;
 fTimeOut := TimeOut;
 fParentHandle := ParentHandle;
 inherited Create(fParentHandle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
end;

destructor TChatThread.Destroy;
begin
 inherited;
 DoMainLog('ChatThread->Destroy = ok');
end;

procedure TChatThread.RefreshChat;

 function ParceUserString(InStr: string): TChatText;
 var
  i: Integer;
  s: string;
 begin
  Result := TChatText.Create;

  // <a href="javascript:parent.frames['ctrl'].fu('MAA-wise')"><font color="000000"><b><b><font color="#ffffff">M</font><font color="#ecfbea">A</font><font color="#d1f5cb">A</font><font color="#b1f0a7">-</font><font color="#8fe880">w</font><font color="#6ce158">i</font><font color="#4cdb35">s</font><font color="#31d515">e</font></b>:</b></a></u> <font color=71FD00>Gillian, [img cvetk]<br>

  // <a href="javascript:parent.frames['ctrl'].fu('Artyomka')"><font color="000000"><b><font color=7320d9>A</font><font color=863fde>r</font><font color=995ee3>t<font color=ad7ee9>y</font><font color=c09dee>o</font><font color=d4bdf4>m</font><font color=e7dcf9>k</font><font color=fbfcff>a</font>:</b></a></u> <font color=dab6ff>и чо?<br>

  // InStr := StringReplace(InStr, '[img ', '!img ', [rfReplaceAll, rfIgnoreCase]);

  i := Pos('.fu(''', InStr);

  if i > 0 then
   begin
    Delete(InStr, 1, i + 4);
    i := Pos(''')', InStr);
    Result.FromNick := copy(InStr, 1, i - 1);
    Delete(InStr, 1, i + 3);
   end;

  i := Pos('color="', InStr);
  if i > 0 then
   begin
    Delete(InStr, 1, i + 6);
    i := Pos('"', InStr);
    Result.NickColor := Copy(InStr, 1, i - 1);
    Delete(InStr, 1, i + 1);
   end;

  if Pos('<b><font color=', InStr) > 0 then // Gradient :((((
   begin
    i := Pos(':</b>', InStr);
    Result.Avatar := Copy(InStr, 1, i - 1) + '</b>';
    Delete(InStr, 1, i + 2);
   end;

  if Pos('<b><img src="/', InStr) > 0 then
   begin
    Delete(InStr, 1, i - 4);
    i := Pos('border=0', InStr);
    Result.Avatar := Copy(InStr, 1, i + 8);
    i := pos('ars/', InStr);
    Delete(InStr, 1, i + 3);
    i := pos('.gif', InStr);
    s := Copy(InStr, 1, i - 1);
    if FileExists(LocalDir + 'avatars\' + s + '.gif') then
     Result.Avatar := StringReplace(Result.Avatar, '"/', '"file:///' + makePath(LocalDir) + '', [rfReplaceAll, rfIgnoreCase]) else
     begin
      Result.Avatar := '';
      GetAvatar(s);
     end;
    Delete(InStr, 1, i + 8);
   end;

  i := Pos(':', InStr);
  if Length(Result.FromNick) = 0 then
   Result.FromNick := Copy(InStr, 1, i - 1);
  Delete(InStr, 1, i + 4);

  i := Pos('color=', InStr);
  Delete(InStr, 1, i + 5);
  i := Pos('>', InStr);
  Result.TextColor := Copy(InStr, 1, i - 1);
  Delete(InStr, 1, i);
  i := Pos(',', InStr);

  if i > 0 then
   begin
    s := Copy(InStr, 1, i - 1);
    if ChatUsers.IsNick(s) then
     begin
      Result.ToNick := s;
      Delete(InStr, 1, i);
      InStr := TrimLeft(InStr);
     end;
   end;

  i := Pos('<br>', InStr);
  Result.Text := Copy(InStr, 1, i - 1);

  Result.TextType := ttChat;
 end;
 
 function ParcePrivateString(InStr: string): TChatText;
  // <font color=ff8000><i><b>Приват от <a href=/cgi-bin/castle_if/main/private.pl?action=print&numer=14648&id=13YmPr4fJw046&user=14648 target=right><font color=ff8000>User1</font></a> к <a href=/cgi-bin/castle_if/main/private.pl?action=print&numer=14648&id=13YmPr4fJw046&user=14648 target=right><font color=ff8000>User2</font></a> - Private String 123!!!</b></i><br>
  // <font color=ff8000><i><b>Приват от <a href=/cgi-bin/castle_if/main/private.pl?action=print&numer=63783&id=48MPDW2lSHqC2&user=63783 target=right><font color=ff8000>234</font></a> к <a href=/cgi-bin/castle_if/main/private.pl?action=print&numer=63783&id=48MPDW2lSHqC2&user=63783 target=right><font color=ff8000>234</font></a> - 123</b></i><br>
 var
  i: Integer;
 begin
  Result := TChatText.Create;
  //  Result.HTMLText := InStr;

  i := Pos('=right>', InStr);
  Delete(InStr, 1, i + 5);
  i := Pos('color=', InStr);
  Delete(InStr, 1, i + 5);
  i := Pos('>', InStr);
  Result.FromNickColor := Copy(InStr, 1, i - 1);
  Delete(InStr, 1, i);
  i := Pos('</font></a>', InStr);
  Result.FromNick := Copy(InStr, 1, i - 1);
  Delete(InStr, 1, i + 10);
  i := Pos('color=', InStr);
  Delete(InStr, 1, i + 5);
  i := Pos('>', InStr);
  Result.NickColor := Copy(InStr, 1, i - 1);
  Delete(InStr, 1, i);
  i := Pos('</font></a>', InStr);
  Result.ToNick := Copy(InStr, 1, i - 1);
  Delete(InStr, 1, i + 13);
  i := Pos('</b>', InStr);
  Result.Text := Copy(InStr, 1, i - 1);
  Result.TextType := ttPrivate;
 end;
 
 function ParceStrajString(InStr: string): TChatText;
  // <table width=100%><tr><td width=35%></td><td valign=top><font color=b8826d face="arial cyr" size=-2><b>Стражник:</b></td><td width=65% align=left><font color=b8826d face="arial cyr" size=-2>&nbsp;заключенный User2 some доставлен в замок 3:38</td></tr></table>
 var
  i: Integer;
 begin
  Result := TChatText.Create;
  Result.FromNick := 'Стражник';
  Result.FromNickColor := 'b8826d';
  //  Result.HTMLText := InStr;

  i := Pos('заключенный ', InStr);
  if i > 0 then
   begin
    Delete(InStr, 1, i + 11);
    i := Pos(' доставлен', InStr);
    Result.ToNick := Copy(InStr, 1, i - 1);
    Result.TextType := ttStrajIn;
    Result.Text := 'доставлен';
    i := 0;
   end else

   i := Pos('сбежал', InStr);
  if i > 0 then
   begin
    i := Pos('&nbsp;', InStr);
    Delete(InStr, 1, i + 5);
    i := Pos('сбежал', InStr);
    Result.ToNick := Copy(InStr, 1, i - 2);
    Result.TextType := ttStrajOut;
    Result.Text := 'сбежал';
   end;

  i := Pos('зам', InStr);
  if i > 0 then
   begin
    Delete(InStr, 1, i + 4);
    i := Pos(' ', InStr);
    Delete(InStr, 1, i);
    i := Pos('</td>', InStr);
    InStr := Copy(InStr, 1, i - 1) + ':00';
    Result.fDate := StrToDateTimeDef(InStr, Now);
   end;

  Result.NickColor := 'b8826d';
 end;
 
 function ReplaceImage(InStr: string): string;
  // <img src="/smile/gubi.gif">
 begin
  Result := StringReplace(InStr, '[img', '<font color=red>[Я велик0й кульц, хацкер ', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<img src="/smile/', '[img ', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '.gif">', ']', [rfReplaceAll, rfIgnoreCase]);
 end;
 
 procedure AddMessage(ChMess: TChatText);
 begin
  if (ChMess.TextType <> ttStrajIn) and (ChMess.TextType <> ttStrajOut) then
   ChMess.fDate := Now;
  ChatLog.AddMess(ChMess);
 end;
 
var
 Chl: TStringList;
 s: string;
 i, z: Integer;
 
begin
 if not ChatLocked then
  begin
   Chl := TStringList.Create;

   OutputDebugString(PChar('GetLastString: ' + ChatLog.GetLastString));

   s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/window.pl?numer=' + fNumer + '&id=' + fid, '', '', ChatLog.GetLastString);

   if Pos('Чат заблокирован', s) > 0 then
    begin
     fChatLocked := True;
     SendMessage(ParentHandle, UC_ChatLocked, 0, 1);
     Exit;
    end;

   i := Pos('</STYLE>', s);
   Delete(s, 1, i + 7);
   i := Pos('</body>', s);
   Delete(s, i, length(s));

   s := ReplaceImage(s);

   s := StringReplace(s, #$A, '', [rfReplaceAll, rfIgnoreCase]);
   s := StringReplace(s, #$D, '', [rfReplaceAll, rfIgnoreCase]);
   s := StringReplace(s, '<br>', '<br>'#$A, [rfReplaceAll, rfIgnoreCase]);
   s := StringReplace(s, '</table>', '</table>'#$A, [rfReplaceAll, rfIgnoreCase]);

   Chl.Text := s;

   for i := 0 to Chl.Count - 1 do
    if not Length(Chl[i]) > 1 then Chl.Delete(i);

   s := ChatLog.GetLastString;

   for i := 0 to Chl.Count - 1 do
    if Pos(s, Chl[i]) > 0 then
     begin
      for z := Chl.Count - 1 downto i do Chl.Delete(z);
      Break;
     end;

   s := Chl.Text;

   for i := Chl.Count - 1 downto 0 do
    begin
     //<a href="javascript:parent.frames['ctrl'].fu('<i>
     if Copy(Chl[i], 1, 19) = '<font color=ff8000>' then AddMessage(ParcePrivateString(Chl[i])) else
      if Copy(Chl[i], 1, 19) = '<a href="javascript' then AddMessage(ParceUserString(Chl[i])) else
       if Copy(Chl[i], 1, 13) = '<font color="' then AddMessage(ParceUserString(Chl[i])) else
        if Copy(Chl[i], 1, 19) = '<table width=100%><' then AddMessage(ParceStrajString(Chl[i]));
    end;

   FreeAndNil(Chl);
  end;
end;

procedure TChatThread.ExitFromChat;
begin
 GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/exit.pl?numer=' + fNumer + '&id=' + fid, '', '', '');
end;

// TSayThread //////////////////////////////////////////////////////////////////

procedure TSayThread.DoExecute;
begin
 CreateMessageQueue;
 
 DoMainLog('SayThread: Started');
 
 while not Terminated do
  case MsgWaitForMultipleObjects(1, StopEvent, False, fTimeOut, QS_ALLINPUT) of
   WAIT_OBJECT_0: Break;
   WAIT_OBJECT_0 + 1: CheckMessages;
  end;
 
 DoMainLog('SayThread: Stopped');
end;

procedure TSayThread.HandleException(E: Exception);
begin
 EMsg('Ошибка в SayThread: ' + E.Message);
 DoMainLog('Ошибка в SayThread: ' + E.Message);
 ChatThread.PostMessage(UC_StartSay, 0, 0);
end;

procedure TSayThread.HandleMessage(var Msg: TMsg);
begin
 case Msg.message of
  US_SendThis: Say(BufToStr(Msg.lParam));
  US_SendThisP: SayPrivate(BufToStr(Msg.wParam), BufToStr(Msg.lParam));
 else inherited;
 end;
end;

procedure TSayThread.Say(SayStr: string);
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/ctrl.pl?numer=' + fNumber + '&id=' + fid + '&message=' + HEncode(SayStr), '', '', '200 OK');
 if Pos('200 OK', s) > 0 then
  SendMessage(fParentHandle, US_TextSend, 0, 0);
end;

procedure TSayThread.SayPrivate(UserId, SayStr: string);
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/private.pl?' + 'user=' + UserId + '&message=' + HEncode(SayStr) + '&id=' + fid + '&numer=' + fNumber + '&action=print', '', '', '200 OK');
 if Pos('200 OK', s) > 0 then
  SendMessage(fParentHandle, US_TextSendP, 0, 0);
end;

constructor TSayThread.Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
begin
 fNumber := numer;
 fId := Id;
 fTimeOut := TimeOut;
 fParentHandle := ParentHandle;
 inherited Create(ParentHandle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
end;

destructor TSayThread.Destroy;
begin
 inherited;
 DoMainLog('SayThread->Destroy = ok');
end;

////////////////////////////////////////////////////////////////////////////////

procedure TChatLog.WaitBusy;
begin
 // while fWeBusy do Sleep(50);
end;

constructor TChatLog.Create;
begin
 fChatLog := TList.Create;
 fKnownRooms := TStringList.Create;
 fKnownRooms.Sorted := True;
 fWeBusy := False;
end;

destructor TChatLog.Destroy;
//var
// i: Integer;
begin
 
 //!!! MEM LEACK
 //!!! for i := 0 to fChatLog.Count - 1 do
 //!!!  TObject(fChatLog[i]).Free;
 
 FreeAndNil(fKnownRooms);
 FreeAndNil(fChatLog);
 inherited;
end;

function TChatLog.GetLastString: string;
begin
 WaitBusy;
 fWeBusy := True;
 //
 if fChatLog.Count > 0 then
  if Length(TChatText(fChatLog[0]).Text) > 1 then
   Result := TChatText(fChatLog[0]).Text else
  Result := TChatText(fChatLog[1]).Text else
  Result := '';
 //
 fWeBusy := False;
end;

procedure TChatLog.AddRoom(room_name: string);
begin
 if fKnownRooms.IndexOf(room_name) = -1 then fKnownRooms.Add(room_name);
end;

procedure TChatLog.AddMess(var ChatMessage: TChatText);
begin
 WaitBusy;
 fWeBusy := True;
 
 fChatLog.Insert(0, ChatMessage);
 
 AddRoom(ChatMessage.room_name);
 
 if ChatMessage.TextType = ttAdmin then
  begin
   if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Admin']);
  end else
  if ChatMessage.TextType = ttStrajIn then
   begin
    if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Online']);
   end else
   if ChatMessage.TextType = ttStrajOut then
    begin
     if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Offline']);
    end else
    if ChatMessage.ToNick = ChatUserName then
     begin
      if ChatMessage.TextType = ttPrivate then
       begin
        if not ChatMessage.IsShow then
         begin
          SendMessage(ChatThread.fParentHandle, UC_PrivateMess, Integer(ChatMessage), 0);
          ChatMessage.IsShow := True;
         end;
        if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Private']);
       end;
      if ChatMessage.TextType = ttChat then if Config.Value_Bool['PlaySounds'] then PlayWav(Config.Value_Str['Sound_Message']);
     end;
 fWeBusy := False;
end;

function TChatLog.NewMessage: TChatText;
begin
 WaitBusy;
 fWeBusy := True;
 
 Result := TChatText.Create;
 fChatLog.Insert(0, Result);
 
 fWeBusy := False;
end;

procedure TChatLog.LoadFromFile(FileName: string);
var
 BCHatLog: TChatText;
var
 zSTream: TFileStream;
 s: string;
 i, Count: Integer;
begin
 WaitBusy;
 fWeBusy := True;
 
 if FileExists(FileName + '.dat') then
  try
   begin
    zStream := TFileStream.Create(FileName + '.dat', fmOpenRead);

    Count := 0;

    SetLength(s, BinaryHeaderLength);

    zSTream.Read(s[1], BinaryHeaderLength);

    if s = BinaryHeader then
     begin

      zSTream.Read(Count, SizeOf(Integer));

      if Count > Config.Value_Int['MaxLogMessages'] then Count := Config.Value_Int['MaxLogMessages'];

      for i := 0 to Count - 1 do
       with NewMessage do
        begin
         zSTream.Read(TextType, sizeof(Integer));
         room_name := 'Основная';
         room_name := ReadStr(TFileStream(zSTream));
         AddRoom(room_name);
         FromNickColor := ReadStr(TFileStream(zSTream));
         NickColor := ReadStr(TFileStream(zSTream));
         TextColor := ReadStr(TFileStream(zSTream));
         FromNick := ReadStr(TFileStream(zSTream));
         ToNick := ReadStr(TFileStream(zSTream));
         Text := ReadStr(TFileStream(zSTream));
         zSTream.Read(fDate, sizeof(TDateTime));
        end;
      FreeAndNil(zStream);
     end else
     begin
      FreeAndNil(zStream);
      DeleteFile(FileName + '.dat');
     end;
   end;
  except
   on E: Exception do
    EMsg('Невозможно загрузить файл архива!'#13#10'Причина: ' + SysErrorMessage(GetLastError) + #13#10 + E.Message);
  end;
 
 fFirstMessage := fChatLog.Count;
 
 BCHatLog := TChatText.Create;
 with BCHatLog do
  begin
   TextType := ttBegin;
   FromNick := 'System';
   fDate := Now;
   fChatDate := fDate;
   Text := DateTimeToStr(fDate);
   room_name := 'Основная';
  end;
 AddMess(BCHatLog);
 
 fWeBusy := False;
 
end;

procedure TChatLog.SaveToFile(FileName: string);
var
 s: TStringList;
 i: Integer;
 zSTream: TFileStream;
 oMode: Word;
 tmpList: TList;
begin
 
 WaitBusy;
 fWeBusy := True;
 
 if Config.Value_Bool['SaveLogToHTML'] then
  begin
   s := TStringList.Create;
   s.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'#13#10 +
    '<SCRIPT LANGUAGE="JavaScript"><!-- function SetName(l) --> </SCRIPT>'#13#10 +
    '<HTML>'#13#10 +
    '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1251">'#13#10 +
    '<style>'#13#10 +
    'body {color:#b8826d; background:Black !important}'#13#10 +
    ' a {text-decoration: none; font-weight: bolder !important}'#13#10 +
    '.AdminName {font: normal 100% Courier New; color: Gray !important}'#13#10 +
    '.AdminText {font: 100% Courier New; color: Gray !important}'#13#10 +
    '.StrajName {font: 100% Courier New; color: #006699; text-align: center !important}'#13#10 +
    '.StrajText {font: 100% Courier New; color: #006699; text-align: center !important}'#13#10 +
    '.PrivateName {font: 100% Courier New; color: Red !important}'#13#10 +
    '.PrivateText {font: bolder 100% Courier New; color: Gray !important}'#13#10 +
    '.ChatText {font: 100% Courier New; color: Gray !important}'#13#10 +
    '.ChatName {font: 100% Courier New; color: White !important}'#13#10 +
    '.OurNick {font: 100% Courier New; color: Red !important}'#13#10 +
    '</style>'#13#10 +
    '</HEAD>'#13#10 +
    '<BODY>');

   tmpList := TList.Create;

   GetMessages(tmpList, fChatLog.Count - fFirstMessage, 0);

   s.Add(RawToHTML(tmpList, Config.Value_Bool['AddTimeInHtmlLog']));
   s.Add('</BODY></HTML>');

   FreeAndNil(tmpList);

   s.SaveToFile(FileName + '_' + FormatDateTime('hh.mm-dd.mm.yyyy', ChatDate) + '.html');

   FreeAndNil(s);
  end;
 
 try
  oMode := fmOpenWrite or fmCreate;

  if FileExists(FileName + '.dat') then oMode := fmOpenWrite;

  zStream := TFileStream.Create(FileName + '.dat', oMode);

  i := fChatLog.Count;

  zSTream.Write(BinaryHeader, BinaryHeaderLength);
  zSTream.Write(i, SizeOf(Integer));
  zSTream.Seek(0, soFromEnd);

  for i := fChatLog.Count - fFirstMessage - 1 downto 0 do
   with TChatText(fChatLog[i]) do
    begin
     zSTream.Write(TextType, SizeOf(Integer));
     WriteStr(zSTream, room_name);
     WriteStr(zSTream, FromNickColor);
     WriteStr(zSTream, NickColor);
     WriteStr(zSTream, TextColor);
     WriteStr(zSTream, FromNick);
     WriteStr(zSTream, ToNick);
     WriteStr(zSTream, Text);
     zSTream.Write(fDate, sizeof(TDateTime));
    end;

  FreeAndNil(zSTream);
 except
  on E: Exception do
   EMsg('Невозможно сохранить файл архива!'#13#10'Причина: ' + SysErrorMessage(GetLastError) + #13#10 + E.Message);
 end;
 
 fWeBusy := False;
end;

procedure TChatLog.GetMessages(var List: TList; Count, From: Integer);
var
 i: Integer;
 ar: string;
begin
 WaitBusy;
 fWeBusy := True;
 
 ar := RoomThread.ActiveRoom;
 
 if Count > fChatLog.Count - 1 then Count := fChatLog.Count - 1;
 
 i := From;
 
 while i <> Count do
  begin
   if TChatText(fChatLog[i]).TextType = ttBegin then Break else
    begin
     if TChatText(fChatLog[i]).room_name = ar then List.Add(fChatLog[i]);
     inc(i);
    end;
  end;
 
 fWeBusy := False;
end;

procedure TChatLog.GetLogByPart(room_name: string; var List: TVirtualStringTree);
var
 i: Integer;
 Node: PVirtualNode;
 NodeD: PChatLogView;
begin
 WaitBusy;
 fWeBusy := True;
 
 List.BeginUpdate;
 
 List.Clear;
 
 Node := List.AddChild(nil);
 NodeD := List.GetNodeData(Node);
 NodeD.Messages := TList.Create;
 NodeD.Name := '!';
 
 for i := 0 to fChatLog.Count - 1 do
  begin
   if TChatText(fChatLog[i]).TextType = ttBegin then
    begin
     NodeD.Name := DateTimeToStr(TChatText(fChatLog[i]).fDate) + ' (' + IntToStr(NodeD.Messages.Count) + ')';
     if NodeD.Messages.Count < 1 then List.DeleteNode(Node);
     Node := List.AddChild(nil);
     NodeD := List.GetNodeData(Node);
     NodeD.Messages := TList.Create;
     NodeD.Name := '???';
    end else
    if TChatText(fChatLog[i]).room_name = room_name then NodeD.Messages.Add(fChatLog[i]);
  end;
 
 List.DeleteNode(Node);
 
 List.EndUpdate;
 
 fWeBusy := False;
end;

procedure TChatLog.GetMessagetFor(var List: TList; Nick: string);
var
 i: Integer;
begin
 WaitBusy;
 fWeBusy := True;
 
 for i := 0 to fChatLog.Count - 1 do
  with TChatText(fChatLog[i]) do
   if ((FromNick = Nick) or (ToNick = Nick) or (TextType = ttBegin)) then
    if not ((TextType = ttBegin) and (List.Count - 1 > -1) and (TChatText(fChatLog[i]).TextType = TChatText(List[List.Count - 1]).TextType)) then
     List.Add(fChatLog[i]);
 
 fWeBusy := False;
end;

procedure TChatLog.GetMessagetFor(var List: TList; Nick: string; Count: Integer);
var
 i, i2: Integer;
begin
 WaitBusy;
 fWeBusy := True;
 
 i2 := fChatLog.Count - 1;
 
 if i2 > Count then i2 := Count;
 
 for i := 0 to i2 do
  with TChatText(fChatLog[i]) do
   if (((FromNick = Nick) and (ToNick = ChatUserName)) or ((FromNick = Nick) and (TextType = ttStrajOut)) or ((FromNick = ChatUserName) and (ToNick = Nick))) then
    List.Add(fChatLog[i]);
 
 fWeBusy := False;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TTCastleClient.Set_DoLogin(Value: OleVariant); safecall;
begin
 SendMessage(TWindow, UC_Dologin, StrToBuf(VarToStr(Value)), 0);
end;

function TTCastleClient.Get_GetLogin: OleVariant; safecall;
begin
 Result := ChatUserName;
end;

function TTCastleClient.Get_GetProxyAddr: OleVariant; safecall;
begin
 Result := ChatProxyAddr;
end;

function TTCastleClient.Get_GetProxyPort: OleVariant; safecall;
begin
 Result := ChatProxyPort;
end;

function TTCastleClient.Get_GetProxyUser: OleVariant; safecall;
begin
 Result := ChatProxyUser;
end;

function TTCastleClient.Get_GetProxyPass: OleVariant; safecall;
begin
 Result := ChatProxyPass;
end;

function TTCastleClient.Get_GetUseProxy: WordBool; safecall;
begin
 if Length(ChatProxyAddr) > 0 then
  Result := True else
  Result := False;
end;

function TTCastleClient.Get_GetUseProxyAuth: WordBool; safecall;
begin
 if Length(ChatProxyUser) > 0 then
  Result := True else
  Result := False;
end;

function TTCastleClient.Get_GetPass: OleVariant; safecall;
begin
 Result := ChatPassword;
end;

function TTCastleClient.Get_SaveChatLogin: WordBool; safecall;
begin
 Result := ChatSavePass;
end;

function TTCastleClient.Get_SaveProxyLogin: WordBool; safecall;
begin
 Result := ChatProxySavePass;
end;

procedure TTCastleClient.Set_SetSmile(Value: OleVariant); safecall;
begin
 SendMessage(TWindow, TC_SetSmile, StrToBuf(' ' + Value), 0);
end;

procedure TTCastleClient.Set_SetNick(Value: OleVariant); safecall;
begin
 SendMessage(TWindow, TC_AddFirst, StrToBuf(Value + ', '), 0);
end;

procedure TTCastleClient.Set_SetPrivateName(Value: OleVariant); safecall;
begin
 SendMessage(TWindow, TC_SetPrivate, StrToBuf(Value), 0);
end;

procedure TTCastleClient.Set_DoConfig(Value: OleVariant); safecall;
begin
 with TfrmSetup.Create(Application.MainForm) do
  begin
   ShowModal;
   Free;
  end;
end;

procedure TTCastleClient.Set_GetNickInfo(Value: OleVariant); safecall;
begin
end;

procedure TTCastleClient.Set_SetRoom(Value: OleVariant); safecall;
begin
 RoomThread.PostMessage(UT_SetRoom, StrToBuf(Value), 0);
end;

procedure TTCastleClient.Set_IncRoom(Value: Integer); safecall;
begin
 RoomThread.PostMessage(UT_SetRoom, StrToBuf(RoomThread.GetRoomByN(Value)), 0);
end;

procedure TTCastleClient.Set_ShowMail(Value: OleVariant);
begin
 PrivateMessages.PostMessage(UP_CheckNewMessage, 0, 0);
 SendMessage(frmCastle.Handle, UP_We_Have_Messsage, 1, 0);
 RoomThread.PostMessage(UT_GetTime, 0, 0);
end;

procedure TTCastleClient.Set_UlockChat(Value: OleVariant); safecall;
begin
 ChatThread.PostMessage(UT_UnLockChat, StrToBuf(VarToStr(Value)), 0);
end;

////////////////////////////////////////////////////////////////////////////////

function TWebNames.InArray(uName: string): Boolean;
var
 i: Integer;
begin
 i := fNames.IndexOf(uName);
 if i > 0 then Result := True else Result := False;
end;

function TWebNames.GetLink(uName: string): string;
begin
 Result := fNames[fNames.IndexOf(uName) + 1];
end;

procedure TWebNames.LoadFromFile(FileName: string);
var
 fin: TFileStream;
 i, Count: Integer;
begin
 if FileExists(FileName) then
  begin
   fin := TFileStream.Create(FileName, fmOpenRead);
   fin.Read(Count, SizeOf(Integer));
   for i := 0 to Count - 1 do
    begin
     fNames.Add(Decrypt(ReadStr(fin), StartKey, MultKey, AddKey));
     fNames.Add(Decrypt(ReadStr(fin), StartKey, MultKey, AddKey));
    end;
   FreeAndNil(fin);
  end;
end;

constructor TWebNames.Create;
begin
 fNames := TStringList.Create;
end;

destructor TWebNames.Destroy;
begin
 FreeAndNil(fNames);
end;

////////////////////////////////////////////////////////////////////////////////

function TPrivateMessages.NewMessage: TChatText;
begin
 Result := TChatText.Create;
 Result.TextType := ttPrivateM;
 fMessages.Insert(0, Result);
end;

procedure TPrivateMessages.ParceMessages(InHTML: string);

 function GetLast(What, Where: string): Integer;
 var
  i: Integer;
 begin
  Result := 0;
  for i := length(Where) downto 1 do
   if Where[i] = What then
    begin
     Result := i;
     Break;
    end;
 end;
 
var
 i, z: integer;
 tmp: string;
 
begin
 i := Pos('<font color=#ffff00', InHTML);
 while i > 0 do
  with NewMessage do
   begin
    Delete(InHTML, 1, i + 26);
    i := Pos('</', InHTML);
    FromNick := copy(InHTML, 1, i - 1);
    Delete(InHTML, 1, i + 11);
    i := Pos('</font>', InHTML);
    text := copy(InHTML, 1, i - 1);
    text := Trim(text);
    i := GetLast('(', text);
    z := GetLast(')', text);
    tmp := copy(text, i + 1, z - i - 1);
    Delete(text, i - 1, z - 1);
    i := Pos(' ', tmp);
    tmp := tmp + ' ' + Copy(tmp, 1, i - 1);
    Delete(tmp, 1, i);
    fDate := StrToDateTime(tmp);
    i := Pos('<font color=#ffff00', InHTML);
   end;
end;

procedure TPrivateMessages.CheckNewMessages;
// http://castle.istu.edu/cgi-bin/castle_if/tools/readsoob.pl?id=55FEZBxnDHXRw&numer=63783
// s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/private.pl?' + 'user=' + UserId + '&message=' + HEncode(SayStr) + '&id=' + fid + '&numer=' + fNumber + '&action=print', '', '', '', True);
var
 s: string;
 mc: Integer;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/tools/readsoob.pl?id=' + fId + '&numer=' + fNumber, '', '', '');
 mc := fMessages.Count;
 ParceMessages(s);
 if mc < fMessages.Count then
  SendMessage(fParentHandle, UP_We_Have_Messsage, 0, 0);
end;

procedure TPrivateMessages.DoExecute;
begin
 DoMainLog('PrivateMessages->DoExecute(Begin)');
 CreateMessageQueue;
 
 LoadFromFile(ProfileDir + '\Private');
 
 PostMessage(UP_CheckNewMessage, 0, 0);
 
 while not Terminated do
  case MsgWaitForMultipleObjects(1, StopEvent, False, fTimeOut, QS_ALLINPUT) of
   WAIT_OBJECT_0: Break;
   WAIT_OBJECT_0 + 1: CheckMessages;
   WAIT_TIMEOUT: PostMessage(UP_CheckNewMessage, 0, 0);
  end;
 
 SaveToFile(ProfileDir + '\Private');
 
 DoMainLog('PrivateMessages->DoExecute(End)');
end;

procedure TPrivateMessages.HandleMessage(var Msg: TMsg);
begin
 case Msg.message of
  UP_CheckNewMessage: CheckNewMessages;
  UP_SendThisMessage: PostPMessage(BufToStr(Msg.lParam), BufToStr(Msg.wParam));
 else inherited;
 end;
end;

procedure TPrivateMessages.HandleException(E: Exception);
begin
end;

procedure TPrivateMessages.LoadFromFile(FileName: string);
var
 i, cnt: Integer;
 s: string;
 zStream: TFileStream;
begin
 if FileExists(FileName + '.dat') then
  try
   begin
    zStream := TFileStream.Create(FileName + '.dat', fmOpenRead);

    SetLength(s, BinaryHeaderLength);
    zStream.Read(s[1], BinaryHeaderLength);

    if s = BinaryHeader then
     begin

      zStream.Read(cnt, SizeOf(Integer));

      for i := 0 to cnt - 1 do
       with NewMessage do
        begin
         FromNick := ReadStr(zStream);
         Text := ReadStr(zStream);
         zStream.Read(fDate, SizeOf(TDateTime));
        end;
     end;

    FreeAndNil(zStream);
   end;
  except
   on E: Exception do
    EMsg('Невозможно загрузить файл приватных сообщений!'#13#10'Причина: ' + SysErrorMessage(GetLastError) + #13#10 + E.Message);
  end;
end;

procedure TPrivateMessages.SaveToFile(FileName: string);
var
 i: Integer;
 zStream: TFileStream;
begin
 try
  zStream := TFileStream.Create(FileName + '.dat', fmCreate or fmOpenWrite);

  zStream.Write(BinaryHeader, BinaryHeaderLength);

  zStream.Write(fMessages.Count, SizeOf(Integer));

  for i := fMessages.Count - 1 downto 0 do
   with TChatText(fMessages[i]) do
    begin
     WriteStr(zStream, FromNick);
     WriteStr(zStream, Text);
     zStream.Write(fDate, SizeOf(TDateTime));
    end;

  FreeAndNil(zStream);
 except
  on E: Exception do
   EMsg('Невозможно сохранить файл приватных сообщений!'#13#10'Причина: ' + SysErrorMessage(GetLastError) + #13#10 + E.Message);
 end;
end;

procedure TPrivateMessages.PostPMessage(Who, fText: string);
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/tools/soobch.pl?action=print&numer=' + fNumber + '&id=' + fid + '&nick=' + HEncode(Who) + '&message=' + HEncode(fText), '', '', '200 OK');
 // if Pos('HTTP/1.1 200 OK', s) > 0 then SendMessage(fParentHandle, UP_TextSend, 0, 0);
end;

constructor TPrivateMessages.Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
begin
 DoMainLog('PrivateMessages->Create(Begin)');
 fNumber := numer;
 fId := Id;
 fTimeOut := TimeOut;
 fParentHandle := ParentHandle;
 fMessages := TList.Create;
 inherited Create(ParentHandle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
 DoMainLog('PrivateMessages->Create(End)');
end;

destructor TPrivateMessages.Destroy;
begin
 DoMainLog('PrivateMessages->Destroy(Begin)');
 FreeAndNil(fMessages);
 inherited;
 DoMainLog('PrivateMessages->Destroy(End)');
end;

////////////////////////////////////////////////////////////////////////////////

procedure TRoomThread.DoExecute;
begin
 CreateMessageQueue;
 
 DoMainLog('RoomThread: Started');
 
 PostMessage(UT_GetTime, 0, 0);
 PostMessage(UT_GetRooms, 0, 0);
 
 while not Terminated do
  case MsgWaitForMultipleObjects(1, StopEvent, False, fTimeOut, QS_ALLINPUT) of
   WAIT_OBJECT_0: Break;
   WAIT_OBJECT_0 + 1: CheckMessages;
   WAIT_TIMEOUT: GetTime;
  end;
 
 DoMainLog('RoomThread: Stopped');
end;

procedure TRoomThread.GetRooms;
var
 s, s1, s2: string;
 i: Integer;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/rooms.pl?id=' + fId + '&numer=' + fNumber + '&action=ch_room', '', '', '');
 if Pos('200 OK', s) > 0 then
  begin
   i := pos('VALUE="', s);
   while i > 0 do
    begin
     Delete(s, 1, i + 6);
     s1 := Copy(s, 1, Pos('"', s) - 1);
     Delete(s, 1, Pos('<font size=2>', s) + 12);
     i := Pos('</td>', s) - 1;
     s2 := Copy(s, 1, i);
     Delete(s, 1, i);
     fRooms.AddObject(s1, TObject(StrToBuf(s2)));
     i := pos('VALUE="', s);
    end;

   PostMessage(UT_UpdateRoomsMenu, 0, 0);
  end;
end;

procedure TRoomThread.UpdateRooms;
var
 s: string;
 i: integer;
begin
 if not ChatThread.ChatLocked then
  begin
   s := '<font size=2><b><a href="#" OnClick="window.external.IncRoom = 1">&lt;&lt;&lt;</a>&nbsp;&nbsp;&nbsp;<select width="50" OnChange="window.external.SetRoom = this.options[this.selectedIndex].value">';

   for i := 0 to fRooms.Count - 1 do
    begin
     if fActiveRoom = BufToStr(Integer(fRooms.Objects[i]), False) then
      s := s + '<OPTION value="' + fRooms[i] + '" selected>' + BufToStr(Integer(fRooms.Objects[i]), False) + '</OPTION>' else
      s := s + '<OPTION value="' + fRooms[i] + '">' + BufToStr(Integer(fRooms.Objects[i]), False) + '</OPTION>';
    end;

   s := s + '</select>&nbsp;&nbsp;&nbsp;<a href="#" OnClick="window.external.IncRoom = -1">&gt;&gt;&gt;</a></b></font>';

   SendMessage(ParentHandle, UT_UpdateRooms, StrToBuf(s), 0);
  end else
  SendMessage(ParentHandle, UT_UpdateRooms, StrToBuf(''), 0);
end;

procedure TRoomThread.GetTime;
var
 s: string;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/time.pl?id=' + fId + '&numer=' + fNumber + '&ch=temp', '', '', '');
 // Новое сообщение
 if Pos('200 OK', s) > 0 then
  begin
   Delete(s, 1, Pos('<font size=2>&nbsp; ', s) + 19);
   if Pos('Новое сообщение', s) > 0 then
    fChatDate := '<a href="#" onclick="window.external.ShowMail = true"><font color=red>Новое сообщение</font></a>' else
    fChatDate := Copy(s, 1, Pos('&nbsp;&nbsp;&nbsp;&nbsp;', s) - 2);
   Delete(s, 1, Pos('&lt;&lt;&lt;</a>', s) + 17);

   fActiveRoom := Copy(s, 1, Pos('<a ', s) - 2);

   if s <> fActiveRoom then PostMessage(UT_UpdateRoomsMenu, 0, 0);

   SendMessage(ParentHandle, UT_UpdateTime, StrToBuf('<font size=2><b>' + fChatDate + '</b></font></td>'), 0);

  end;
end;

procedure TRoomThread.SetRoom(RoomId: string);
begin
 if fRooms.IndexOf(RoomId) > -1 then
  begin
   GetPage('GET', ChatHost + '/cgi-bin/castle_if/main/rooms.pl?job=ch_room&id=' + fId + '&numer=' + fNumber + '&room=' + RoomId, '', '', '');
   GetTime;
   UpdateRooms;
   SendMessage(ParentHandle, UC_RefreshChat, 0, StrToBuf('<CENTER>Обновление комнаты, подождите...</CENTER>'));
   ChatThread.PostMessage(UC_RefreshChat, 0, 0);
   UserThread.PostMessage(UT_RefreshList, 0, 0);
  end;
end;

function TRoomThread.GetRoomByN(num: Integer): string;
var
 i: integer;
begin
 for i := 0 to fRooms.Count - 1 do
  if BufToStr(Integer(fRooms.Objects[i]), False) = fActiveRoom then
   begin
    num := i - num;
    if num < 0 then num := fRooms.Count - 1;
    Result := fRooms[num];
   end;
end;

procedure TRoomThread.HandleMessage(var Msg: TMsg);
begin
 case Msg.message of
  UT_UpdateRoomsMenu: UpdateRooms;
  UT_GetTime: GetTime;
  UT_GetRooms: GetRooms;
  UT_SetRoom: SetRoom(BufToStr(Msg.wParam));
 else inherited;
 end;
end;

procedure TRoomThread.HandleException(E: Exception);
begin
 EMsg('Ошибка в RoomThread: ' + E.Message);
 DoMainLog('Ошибка в RoomThread: ' + E.Message);
end;

constructor TRoomThread.Create(numer, id, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
begin
 DoMainLog('RoomThread->Create(Begin)');
 fNumber := numer;
 fId := Id;
 fTimeOut := TimeOut;
 fParentHandle := ParentHandle;
 fRooms := TStringList.Create;
 fActiveRoom := 'Основная';
 inherited Create(ParentHandle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
 DoMainLog('RoomThread->Create(End)');
end;

destructor TRoomThread.Destroy;
begin
 DoMainLog('RoomThread->Destroy(Begin)');
 FreeAndNil(fRooms);
 inherited;
 DoMainLog('RoomThread->Destroy(End)');
end;

////////////////////////////////////////////////////////////////////////////////

constructor TInformerThread.Create(User, ProxyAuth, ProxyAddr, ProxyPort: string; TimeOut: Integer; ParentHandle: THandle);
begin
 fParentHandle := ParentHandle;
 fUserName := User;
 fProxyAuth := ProxyAuth;
 fProxyAddr := ProxyAddr;
 fProxyPort := ProxyPort;
 inherited Create(fParentHandle, ChatVersion, fProxyAuth, ProxyAddr, ProxyPort);
end;

destructor TInformerThread.Destroy;
begin
end;

procedure TInformerThread.DoExecute;
begin
 
 BeginChat;
 GetNews;
 GetTextReklama;
 
 while not Terminated do
  case MsgWaitForMultipleObjects(1, StopEvent, False, 300000 {5 min}, QS_ALLINPUT) of
   WAIT_OBJECT_0: Break;
   WAIT_OBJECT_0 + 1: CheckMessages;
   WAIT_TIMEOUT:
    begin
     UserOnline;
     GetTextReklama;
     GetNews;
    end;
  end;
 
 EndChat;
 
end;

procedure TInformerThread.GetNews;
var
 ts: string;
 i: Integer;
begin
 ts := GetPage('GET', ChatHost + '/top.html', '', '', '');
 i := pos('<!--news-->', ts);
 Delete(ts, 1, i + 10);
 i := pos('<!--news-->', ts) - 1;
 fChatNews := Copy(ts, 1, i);
 if Length(fChatNews) < 1 then fChatNews := '<center><b><a href=http://ion.irk.ru target=_blank>http://ion.irk.ru</a></b></center>';
 SendMessage(ParentHandle, IT_SetNews, StrToBuf(fChatNews), 0);
end;

procedure TInformerThread.BeginChat;
var
 lip: Cardinal;
begin
 lip := SocketResolveHost('');
 fLocalIp := IPToStr(lip);
 fOutIp := GetPage('GET', 'http://ion.irk.ru/ccs.php', '', '', '');
 
 Delete(fOutIp, 1, Pos(#$A#$A, fOutIp) + 1);
 
 GetPage('POST', 'http://ion.irk.ru/ccs.php', '', 'nick=' + fUserName + '&localip=' + fLocalIp + '&outip=' + Trim(fOutIp) + '&status=begin', '');
end;

procedure TInformerThread.UserOnline;
begin
 GetPage('POST', 'http://ion.irk.ru/ccs.php', '', 'nick=' + fUserName + '&localip=' + fLocalIp + '&outip=' + Trim(fOutIp) + '&status=online', '');
end;

procedure TInformerThread.EndChat;
begin
 GetPage('POST', 'http://ion.irk.ru/ccs.php', '', 'nick=' + fUserName + '&localip=' + fLocalIp + '&outip=' + Trim(fOutIp) + '&status=end', '');
end;

procedure TInformerThread.GetTextReklama;
var
 s: string;
begin
 s := GetPage('GET', 'http://ion.irk.ru/ccs.php?txtrek=', '', '', '');
 Delete(s, 1, Pos(#$A#$A, s) + 1);
 SendMessage(ParentHandle, IT_SetText, StrToBuf(s), 0);
end;

////////////////////////////////////////////////////////////////////////////////

function RawToHTML(RawList: TList; UseTime: Boolean): string;
var
 i: Integer;
 
 function ParceSmile(InStr: string): string;
 var
  i: integer;
  s: string;
 begin
  i := Pos('[img ', InStr);
  while i > 0 do
   begin
    s := Copy(InStr, i + 5, PosEx(']', InStr, i) - 5 - i);
    if not FileExists(LocalDir + 'smiles\' + s + '.gif') then ChatThread.PostMessage(UC_GetSmile, StrToBuf(s), 0);
    InStr := StringReplace(InStr, '[img ', '<img src="file:///' + makePath(LocalDir) + 'smiles\', [rfIgnoreCase]);
    InStr := StringReplace(InStr, ']', '.gif">', [rfIgnoreCase]);
    i := Pos('[img ', InStr);
   end;
  Result := InStr;
 end;
 
begin
 Result := '<table cellpadding="0" cellspacing="0" width="100%">'#13#10;
 
 for i := 0 to RawList.Count - 1 do
  with TChatText(RawList[i]) do
   begin
    case TextType of
     ttChat:
      if UseTime or (ChatUsers.GetUser(FromNick).RecvText) then
       begin
        if UseTime or (ToNick = '') or ChatUsers.GetUser(ToNick).RecvText then
         begin
          Result := Result + '<tr>';

          if UseTime then Result := Result + '<td width="1%"><font style="color: ' + NickColor + '" class="ChatName">' + FormatDateTime('hh:mm', fDate) + '&nbsp;</font></td>';

          Result := Result + '<td><a style="color: ' + NickColor + '" class="';

          if FromNick = ChatUserName then
           Result := Result + 'OurNick' else
           Result := Result + 'ChatName';

          Result := Result + '" href="javascript:SetName(''' + FromNick + ''');">';

          if (not UseTime) and (length(Avatar) > 0) then
           Result := Result + Avatar + '</a><font style="color: ' + TextColor + '" class="ChatText">:&nbsp' else
           Result := Result + FromNick + '</a><font style="color: ' + TextColor + '" class="ChatText">:&nbsp';

          if Length(ToNick) > 0 then
           begin
            if ToNick = ChatUserName then
             Result := Result + '<font style="color: ' + NickColor + '" class="OurNick">' + ToNick + '</font>, ' else
             Result := Result + ToNick + ', ';
           end else
           Result := Result + ToNick;

          Result := Result + ParceSmile(Text) + '</font></td></tr>'#13#10;
         end;
       end;

     ttStrajIn: Result := Result + '<tr><td colspan="2" align="center" valign="top"><font style="color: ' + NickColor + '" face="arial cyr" size="-2" class="StrajName"><b>' + FromNick + '</b>:</font><font style="color: ' + NickColor + '" size=-2 class="StrajText">&nbsp;Заключенный ' + ToNick + ' доставлен в замок в ' + FormatDateTime('hh:mm', fDate) + '</font></td></tr>'#13#10;
     ttStrajOut: Result := Result + '<tr><td colspan="2" align="center" valign=top><font style="color: ' + NickColor + '" face="arial cyr" size="-2" class="StrajName"><b>' + FromNick + '</b>:</font><font style="color: ' + NickColor + '" size=-2 class="StrajText">&nbsp;Заключенный ' + ToNick + ' сбежал из замка в ' + FormatDateTime('hh:mm', fDate) + '</font></td></tr>'#13#10;
     ttPrivate: if UseTime then
       Result := Result + '<tr><td style="color: #ff8000; font: bolder italic;"><font style="color: ' + NickColor + '" class="ChatName">' + FormatDateTime('hh:mm', fDate) + '</font></td><td><font style="color: ' + TextColor + '" class="PrivateText">Приват от&nbsp;</font><a style="color: ' + NickColor + '" class="PrivateName" href="javascript:SetPrivateName(''' + FromNick + ''');">' + FromNick + '</a><font style="color: ' + TextColor + '" class="PrivateText"> для </font><a style="color: ' + NickColor + '" class="PrivateName" href="javascript:SetPrivateName(''' + ToNick + ''');">' + ToNick + '</a><font style="color: ' + TextColor + '" class="PrivateText">: ' + ParceSmile(Text) + '</font></tr></td>'#13#10 else
       Result := Result + '<tr><td style="color: #ff8000; font: bolder italic;" colspan="2"><font style="color: ' + TextColor + '" class="PrivateText">Приват от&nbsp;</font><a style="color: ' + NickColor + '" class="PrivateName" href="javascript:SetPrivateName(''' + FromNick + ''');">' + FromNick + '</a><font style="color: ' + TextColor + '" class="PrivateText"> для </font><a style="color: ' + NickColor + '" class="PrivateName" href="javascript:SetPrivateName(''' + ToNick + ''');">' + ToNick + '</a><font style="color: ' + TextColor + '" class="PrivateText">: ' + ParceSmile(Text) + '</font></tr></td>'#13#10;
     ttBegin: Result := Result + '<tr><td colspan="2" align="center" valign=top><font style="font: bolder"><b>System: Начат лог в ' + DateTimeToStr(fDate) + '</b></font></td></tr>'#13#10;
     ttPrivateM: Result := Result + '<tr><td width="100%"><font style="color: #ffff00" class="ChatName">' + FromNick + '</font><font class="ChatText">: ' + ParceSmile(Text) + ' (' + FormatDateTime('hh:nn dd.mm.yy', fDate) + ')</font></tr></td>'#13#10;
    end;
   end;
 Result := Result + '</table>';
end;

////////////////////////////////////////////////////////////////////////////////

initialization
 
 TAutoObjectFactory.Create(ComServer, TTCastleClient, CLASS_TCastleClient, ciInternal, tmApartment);
 
finalization
 
end.

