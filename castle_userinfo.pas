unit castle_userinfo;

interface

uses
 Windows,
 Messages,
 SysUtils,
 ExtCtrls,
 Graphics,
 StdCtrls,
 Controls,
 ComCtrls,
 Forms,
 gifimage,
 Threads,
 Classes,
 ShellApi,
 Buttons,
 JPeg,
 Menus,
 ClipBrd,
 VirtualTrees,
 castle_interface,
 OleCtrls,
 SHDocVw_TLB,
 EmbeddedWB;

const
 LC = 'Обновление';
 LC1 = 'Просмотр личного дела заключенного';
 
type
 
 TInfoThread = class;
 TChirThread = class;
 
 TfrmUserInfo = class(TForm)
  PageControl: TPageControl;
  tsDelo: TTabSheet;
  tsMemo: TTabSheet;
  eICQ: TEdit;
  eInfo: TMemo;
  eMemo: TMemo;
  Panel1: TPanel;
  btnClose: TButton;
  Panel2: TPanel;
  Image1: TImage;
  lName: TLabel;
  Label2: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  btnRefresh: TButton;
  btnSave: TButton;
  tsSetup: TTabSheet;
  Label1: TLabel;
  Label6: TLabel;
  cbRecvText: TCheckBox;
  eNickColor: TEdit;
  eTextColor: TEdit;
  Timer: TTimer;
  PopupMenu1: TPopupMenu;
  N1: TMenuItem;
  TabSheet1: TTabSheet;
  lvHistory: TVirtualStringTree;
  chat_irk_ru: TTabSheet;
  eNick: TEdit;
  Label7: TLabel;
  Label8: TLabel;
  eEmail: TEdit;
  Label9: TLabel;
  Label10: TLabel;
  eWeb: TEdit;
  eCICQ: TEdit;
  eSity: TEdit;
  eName: TEdit;
  Label11: TLabel;
  Label14: TLabel;
  mInfo: TMemo;
    Panel3: TPanel;
    ch_image: TImage;
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure btnCloseClick(Sender: TObject);
  procedure btnSaveClick(Sender: TObject);
  procedure TimerTimer(Sender: TObject);
  procedure btnRefreshClick(Sender: TObject);
  procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure UrlStrMouseEnter(Sender: TObject);
  procedure UrlStrMouseLeave(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure PageControlChange(Sender: TObject);
  procedure lvHistoryInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
  procedure FormShow(Sender: TObject);
  procedure lvHistoryGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  procedure lvHistoryPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  procedure CreateParams(var Params: TCreateParams); override;
  procedure chat_irk_ruShow(Sender: TObject);
  procedure ShowChirInfo(UserName: string);
    procedure eEmailDblClick(Sender: TObject);
    procedure eWebDblClick(Sender: TObject);
 private
  t, x, z, y: Integer;
  InfoThread: TInfoThread;
  ChirThread: TChirThread;
  historyParced: Boolean;
  procedure ParceHistory;
 public
  User: TChatUser;
 end;
 
 TInfoThread = class(TSockMsgThread)
  fId,
   fICQ,
   fInfo: string;
  fParent: TfrmUserInfo;
  procedure PostData;
  procedure DoExecute; override;
  constructor Create(ParentH: TfrmUserInfo; Id: string; ProxyAuth, ProxyAddr, ProxyPort: string);
 end;
 
 TChirInfo = packed record
  cNick: string;
  cFoto: string;
  cEmail: string;
  cWeb: string;
  cICQ: string;
  cName: string;
  cSity: string;
  cInfo: string;
 end;
 
 TValue = record
  Tag: string;
  Value: string;
 end;
 
 TChirThread = class(TSockMsgThread)
  fName: string;
  fParent: TfrmUserInfo;
  ChirInfo: TChirInfo;
  procedure PostData;
  procedure DoExecute; override;
  constructor Create(ParentH: TfrmUserInfo; UserName: string; ProxyAuth, ProxyAddr, ProxyPort: string);
 end;
 
 PArchiveData = ^TArchiveData;
 TArchiveData = record
  Data: Pointer;
 end;
 
implementation

uses
 castle_utils,
 main,
 Math;

{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////

procedure TCHIRThread.PostData;
begin
 with fParent do
  begin
   Timer.Enabled := False;
   Label2.Caption := LC1;
   Label2.Font.Color := clWindowText;
   btnRefresh.Enabled := True;
   ShowChirInfo(fName);
  end;
end;

procedure TCHIRThread.DoExecute;
var
 person: string;
 fotoName: string;
 foto: string;
 zStream: TFileStream;
 
 function GetTag: TValue;
 var
  i, z: Integer;
 begin
  i := Pos('#', person);
  z := Pos(':', person);
  Result.Tag := copy(person, i + 1, z - 2);
  Delete(person, i, z);
  i := Pos('#', person);
  if i = 0 then i := length(person) + 2;
  Result.Value := Trim(copy(person, 1, i - 2));
  Delete(person, 1, i - 1);
 end;
 
 procedure ParceUserData;
 var
  Rec: TValue;
 begin
  while pos('#', person) > 0 do
   begin
    Rec := GetTag;
    if Rec.Tag = 'NICK' then ChirInfo.cNick := Rec.Value else
     if Rec.Tag = 'FOTO' then ChirInfo.cFoto := Rec.Value else
      if Rec.Tag = 'MAIL' then ChirInfo.cEmail := Rec.Value else
       if Rec.Tag = 'URL' then ChirInfo.cWeb := Rec.Value else
        if Rec.Tag = 'ICQ' then ChirInfo.cICQ := Rec.Value else
         if Rec.Tag = 'NAME' then ChirInfo.cName := Rec.Value else
          if Rec.Tag = 'CITY' then ChirInfo.cSity := Rec.Value else
           if Rec.Tag = 'TEXT' then ChirInfo.cInfo := (Rec.Value);
   end;
 end;
 
begin
 person := GetPage('GET', 'http://chat.irk.ru/gallery/person/' + fName + '.txt', '', '', '');
 if (Pos('200 OK', person) > 0) and (DirectoryExists(LocalDir + '\chir\') or CreateDir(LocalDir + '\chir\')) then
  begin
   person := CutHTTP(person);

   ParceUserData;

   try
    zStream := TFileStream.Create(LocalDir + '\chir\' + fName + '.dat', fmCreate or fmOpenWrite);

    zStream.Write(BinaryHeader, BinaryHeaderLength);

    WriteStr(zStream, ChirInfo.cNick);
    WriteStr(zStream, ChirInfo.cEmail);
    WriteStr(zStream, ChirInfo.cWeb);
    WriteStr(zStream, ChirInfo.cICQ);
    WriteStr(zStream, ChirInfo.cName);
    WriteStr(zStream, ChirInfo.cSity);
    WriteStr(zStream, ChirInfo.cInfo);

    FreeAndNil(zStream);
   except
   end;

   fotoName := ChirInfo.cFoto;

   if not FileExists(LocalDir + '\chir\' + fName + '.jpg') then
    begin
     foto := GetPage('GET', 'http://chat.irk.ru/gallery/foto/' + fotoName, '', '', '');
     if (Pos('200 OK', foto) > 0) then
      begin
       foto := CutHTTP(foto);
       StringToFile(foto, LocalDir + '\chir\' + fName + '.jpg');
      end;
    end;
  end;
 Synchronize(PostData);
end;

constructor TCHIRThread.Create(ParentH: TfrmUserInfo; UserName: string; ProxyAuth, ProxyAddr, ProxyPort: string);
begin
 fName := WebNames.GetLink(UserName);
 fParent := ParentH;
 inherited Create(fParent.Handle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmUserInfo.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
 with Params do
  begin
   ExStyle := ExStyle or WS_EX_APPWINDOW;
  end;
end;

procedure TfrmUserInfo.FormClose(Sender: TObject;
 var Action: TCloseAction);
begin
 if Assigned(InfoThread) then
  begin
   InfoThread.Terminate;
   InfoThread.WaitFor;
   FreeAndNil(InfoThread);
  end;
 User.InfoForm := nil;
 Action := caFree;
end;

procedure TfrmUserInfo.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmUserInfo.btnSaveClick(Sender: TObject);
begin
 if User <> nil then
  with TChatUser(User) do
   begin
    ICQ := eICQ.Text;
    Info := eInfo.Text;
    Comment := eMemo.Text;
    DefNickColor := eNickColor.Text;
    DefTextColor := eTextColor.Text;
    RecvText := cbRecvText.Checked;
   end;
 Close;
end;

procedure TfrmUserInfo.TimerTimer(Sender: TObject);

 function GetCChars(Count: Integer): string;
 var
  gg: Integer;
 begin
  for gg := 0 to Count do
   Result := Result + '.';
 end;
 
var
 tdot: string;
begin
 if t = 1 then Inc(x, -10) else Inc(x, 10);
 if x = 255 then t := 1;
 if x = 20 then t := 2;
 
 if y = 1 then Inc(z, -1) else Inc(z);
 if z = 15 then y := 1;
 if z = 0 then y := 2;
 
 Label2.Font.Color := RGB(x, x, x);
 tdot := GetCChars(z);
 Label2.Caption := tdot + LC + tdot;
end;

procedure TInfoThread.PostData;
begin
 with fParent do
  begin
   eICQ.Text := fICQ;
   eInfo.Text := fInfo;
   Timer.Enabled := False;
   Label2.Caption := LC1;
   Label2.Font.Color := clWindowText;
   btnRefresh.Enabled := True;
  end;
end;

procedure TInfoThread.DoExecute;
var
 s, icq, info: string;
 i: Integer;
begin
 s := GetPage('GET', ChatHost + '/cgi-bin/castle_if/tools/info.pl?action=show_user&user=' + fId, '', '', '');
 // StringToFile(s, ProfileDir + '\UserInfo.svs');
 i := Pos('UIN:</b> ', s);
 Delete(s, 1, i + 8);
 i := Pos('<br>', s);
 icq := Copy(s, 1, i - 1);
 i := Pos('Info:</b> ', s);
 Delete(s, 1, i + 9);
 i := Pos('</p>', s);
 info := Copy(s, 1, i - 2);
 while Pos('  ', info) > 0 do
  info := StringReplace(info, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
 info := StringReplace(info, #$0A, '', [rfReplaceAll, rfIgnoreCase]);
 
 if Length(icq) < 1 then icq := '(неизвестно)';
 if Length(info) < 1 then info := '(неизвестно)';
 
 fICQ := icq;
 fInfo := info;
 Synchronize(PostData);
 Terminate;
end;

constructor TInfoThread.Create(ParentH: TfrmUserInfo; Id: string; ProxyAuth, ProxyAddr, ProxyPort: string);
begin
 fId := Id;
 fParent := ParentH;
 inherited Create(fParent.Handle, ChatVersion, ProxyAuth, ProxyAddr, ProxyPort);
end;

procedure TfrmUserInfo.btnRefreshClick(Sender: TObject);
begin
 btnRefresh.Enabled := False;
 Label2.Caption := LC;
 z := 0;
 y := z;
 x := y;
 t := 2;
 y := t;
 Timer.Enabled := True;
 if PageControl.ActivePageIndex = 0 then
  InfoThread := TInfoThread.Create(Self, User.id, ChatThread.Proxy_Auth, ChatThread.Proxy_Addr, ChatThread.Proxy_Port) else
  if PageControl.ActivePageIndex = 4 then
   ChirThread := TChirThread.Create(Self, User.UserName, ChatThread.Proxy_Auth, ChatThread.Proxy_Addr, ChatThread.Proxy_Port) else
end;

procedure TfrmUserInfo.FormKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 case Key of
  vk_escape: Close;
  vk_f5: btnRefreshClick(Sender);
  vk_f2: btnSaveClick(Sender);
 end;
end;

procedure TfrmUserInfo.UrlStrMouseEnter(Sender: TObject);
begin
 if TLabel(Sender).Enabled then
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TfrmUserInfo.UrlStrMouseLeave(Sender: TObject);
begin
 if TLabel(Sender).Enabled then
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TfrmUserInfo.FormCreate(Sender: TObject);
begin
 historyParced := False;
end;

procedure TfrmUserInfo.ParceHistory;
var
 tmpList: TList;
 i: Integer;
 Node: PVirtualNode;
 Data: PArchiveData;
begin
 tmpList := TList.Create;
 ChatLog.GetMessagetFor(tmpList, TChatUser(User).UserName);
 
 for i := 0 to tmpList.Count - 1 do
  if (i + 1 < tmpList.Count - 1) then
   if (TChatText(tmpList[i]).TextType = ttBegin) and (TChatText(tmpList[i]).TextType = TChatText(tmpList[i + 1]).TextType) then
    tmpList.Delete(i);
 
 lvHistory.NodeDataSize := SizeOf(Pointer);
 
 for i := 0 to tmpList.Count - 1 do
  with TChatText(tmpList[i]) do
   begin
    Node := lvHistory.AddChild(nil);
    Data := lvHistory.GetNodeData(Node);
    Data.Data := tmpList[i];
    Application.ProcessMessages;
   end;
 FreeAndNil(tmpList);
 historyParced := True;
end;

procedure TfrmUserInfo.PageControlChange(Sender: TObject);
begin
 if not historyParced then
  if PageControl.ActivePageIndex = 3 then
   begin
    lvHistory.BeginUpdate;
    ParceHistory;
    lvHistory.EndUpdate;
   end;
 if (PageControl.ActivePageIndex = 0) or (PageControl.ActivePageIndex = 4) then
  btnRefresh.Enabled := True else
  btnRefresh.Enabled := False;
end;

procedure TfrmUserInfo.lvHistoryInfoTip(Sender: TObject; Item: TListItem;
 var InfoTip: string);
begin
 with TChatText(Item.Data) do
  InfoTip :=
   'От:  ' + FromNick + #13#10 +
   'Для: ' + ToNick + #13#10 +
   'Дата:' + DateTimeToStr(fDate);
end;

procedure TfrmUserInfo.FormShow(Sender: TObject);
var
 ff: string;
begin
 ff := ExtractFilePath(ParamStr(0)) + 'avatars\' + TChatUser(User).Id + '.gif';
 if FileExists(ff) then
  with TGIFImage.Create do
   try
    LoadFromFile(ff);
    Transparent := True;
    Image1.Picture.Bitmap.Assign(Bitmap);
    Free;
   except
    Free;
   end;
 if not WebNames.InArray(User.UserName) then chat_irk_ru.TabVisible := False;
end;

procedure TfrmUserInfo.lvHistoryGetText(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
 var CellText: WideString);
var
 Data: PArchiveData;
begin
 Data := Sender.GetNodeData(Node);
 case Column of
  0: CellText := TChatText(Data.Data).FromNick;
  1: CellText := TChatText(Data.Data).ToNick;
  2: CellText := TChatText(Data.Data).Text;
 end;
end;

procedure TfrmUserInfo.lvHistoryPaintText(Sender: TBaseVirtualTree;
 const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
 TextType: TVSTTextType);
var
 Data: PArchiveData;
begin
 
 Data := Sender.GetNodeData(Node);
 
 case TChatText(Data.Data).TextType of
  ttPrivate:
   begin
    TargetCanvas.Font.Style := [fsBold];
    TargetCanvas.Font.Color := clRed;
   end;
  ttStrajIn,
   ttStrajOut:
   begin
    TargetCanvas.Font.Style := [fsUnderline];
    TargetCanvas.Font.Color := clGray;
   end;
  ttBegin: TargetCanvas.Font.Color := clBlue;
  ttChat:
   if TChatText(Data.Data).ToNick = ChatUserName then TargetCanvas.Font.Color := clRed else
    if TChatText(Data.Data).FromNick = ChatUserName then TargetCanvas.Font.Color := clNavy;
 end;
 
end;

procedure TfrmUserInfo.chat_irk_ruShow(Sender: TObject);
begin
 ShowChirInfo(WebNames.GetLink(User.UserName));
end;

procedure TfrmUserInfo.ShowChirInfo(UserName: string);
var
 zStream: TFileStream;
 s: string;
begin
 if FileExists(LocalDir + '\chir\' + UserName + '.jpg') then
  ch_image.Picture.LoadFromFile(LocalDir + '\chir\' + UserName + '.jpg');
 
 if FileExists(LocalDir + '\chir\' + UserName + '.dat') then
  try
   zStream := TFileStream.Create(LocalDir + '\chir\' + UserName + '.dat', fmOpenRead);

   SetLength(s, BinaryHeaderLength);

   zStream.Read(s[1], BinaryHeaderLength);

   if s = BinaryHeader then
    begin
     eNick.Text := ReadStr(zStream);
     eEmail.Text := ReadStr(zStream);
     eWeb.Text := ReadStr(zStream);
     eCICQ.Text := ReadStr(zStream);
     eName.Text := ReadStr(zStream);
     eSity.Text := ReadStr(zStream);
     mInfo.Text := ReadStr(zStream);
    end;
   FreeAndNil(zStream);
  except
  end;
end;

procedure TfrmUserInfo.eEmailDblClick(Sender: TObject);
begin
 ShellExecute(0, 'open', PChar('mailto:' + eEmail.Text), '', '', SW_SHOWNORMAL);
end;

procedure TfrmUserInfo.eWebDblClick(Sender: TObject);
begin
 ShellExecute(0, 'open', PChar(eWeb.Text), '', '', SW_SHOWNORMAL);
end;

end.

