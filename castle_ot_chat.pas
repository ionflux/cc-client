unit castle_ot_chat;

interface

uses
 Windows,
 Messages,
 SysUtils,
 mshtml,
 Variants,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,
 OleCtrls,
 SHDocVw_TLB,
 EmbeddedWB,
 StdCtrls,
 ExtCtrls,
 castle_interface;

const
 CW_FreeUs = $9000 + 1;
 
type
 TfrmChatWith = class(TForm)
  pCTRL: TPanel;
  k_send: TImage;
  k_obn: TImage;
  pSmiles: TPanel;
  WBSmilesP: TEmbeddedWB;
  pHTML: TPanel;
  WBChatP: TEmbeddedWB;
  Timer: TTimer;
  k_send_private: TImage;
    eSendMessage: TComboBox;
  k_lat2rus: TImage;
  procedure FormCreate(Sender: TObject);
  procedure TimerTimer(Sender: TObject);
  procedure CreateParams(var Params: TCreateParams); override;
  procedure WndProc(var Msg: TMessage); override;
  function WBChatPShowContextMenu(const dwID: Cardinal;
   const ppt: PPoint; const pcmdtReserved: IInterface;
   const pdispReserved: IDispatch): HRESULT;
  procedure WBChatPDocumentComplete(ASender: TObject;
   const pDisp: IDispatch; var URL: OleVariant);
  procedure k_obnClick(Sender: TObject);
  procedure k_sendClick(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure eSendMessageKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  function WBChatPGetExternal(out ppDispatch: IDispatch): HRESULT;
  procedure k_send_privateClick(Sender: TObject);
  procedure WBSmilesPDocumentComplete(ASender: TObject;
   const pDisp: IDispatch; var URL: OleVariant);
  procedure k_lat2rusClick(Sender: TObject);
  procedure FocuseEditor;
 public
  fUser: TChatUser;
  fParentWnd: THandle;
  SmilesLoaded: boolean;
  procedure SetUser(UserName: TChatUser);
 end;
 
implementation

uses castle_utils,
 main;

{$R *.dfm}

procedure TfrmChatWith.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
 with Params do
  begin
   ExStyle := ExStyle or WS_EX_APPWINDOW;
  end;
end;

procedure TfrmChatWith.WndProc(var Msg: TMessage);
var
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
begin
 case Msg.Msg of
  TC_SetSmile: eSendMessage.Text := eSendMessage.Text + ' ' + (BufToStr(Msg.WParam));
  UC_ChatFor:
   begin
    while WBChatP.Busy do Application.ProcessMessages;
    frDoc := WBChatP.DefaultInterface;
    frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
    try
     HTMLTable(oHTML_Doc.all.item('chat', varEmpty)).innerHTML := BufToStr(Msg.WParam);
    except
     on E: Exception do WBChatP.Go('res://' + makePath(paramstr(0)) + '/pchat');
    end;
   end;
 else
  inherited;
 end;
end;

procedure TfrmChatWith.FocuseEditor;
begin
 pCTRL.SetFocus;
 with eSendMessage do
  begin
   SetFocus;
   SelStart := Length(Text);
   SelLength := 0;
  end;
end;

procedure TfrmChatWith.FormCreate(Sender: TObject);
begin
 k_send.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_enter');
 k_send_private.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_private');
 k_obn.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_obn');
end;

procedure TfrmChatWith.SetUser(UserName: TChatUser);
begin
 fUser := UserName;
 Caption := Caption + fUser.UserName;
 WBChatP.Go('res://' + makePath(paramstr(0)) + '/pchat');
 WBSmilesP.Go('res://' + makePath(paramstr(0)) + '/smiles');
end;

procedure TfrmChatWith.TimerTimer(Sender: TObject);
begin
 ChatThread.PostMessage(UC_GetChatFor, StrToBuf(fUser.UserName), Self.Handle);
end;

function TfrmChatWith.WBChatPShowContextMenu(const dwID: Cardinal;
 const ppt: PPoint; const pcmdtReserved: IInterface;
 const pdispReserved: IDispatch): HRESULT;
begin
 frmCastle.pmChat.PopupComponent := WBChatP;
 frmCastle.pmChat.Popup(ppt.X, ppt.Y);
 result := S_OK;
end;

procedure TfrmChatWith.WBChatPDocumentComplete(ASender: TObject;
 const pDisp: IDispatch; var URL: OleVariant);
var
 i: Integer;
 s: string;
begin
 if pos('/pchat', URL) > 0 then
  with frmCastle do
   begin
    s := ReadReg(RegKey, 'WBChatP_Style', '???');
    for i := 0 to miChatStyle.Count - 1 do
     if miChatStyle.Items[i].Caption = s then
      begin
       pmChat.PopupComponent := WBChatP;
       miChatStyle.Items[i].OnClick(miChatStyle.Items[i]);
      end;
    TimerTimer(Self);
   end;
end;

procedure TfrmChatWith.k_obnClick(Sender: TObject);
begin
 ChatThread.PostMessage(UC_RefreshChat, 0, 0);
end;

procedure TfrmChatWith.k_sendClick(Sender: TObject);
begin
 if Length(eSendMessage.Text) > 0 then
  begin
   eSendMessage.Items.Add(eSendMessage.Text);
   SayThread.PostMessage(US_SendThis, 0, StrToBuf(fUser.UserName + ', ' + eSendMessage.Text));
   eSendMessage.Text := '';
  end;
end;

procedure TfrmChatWith.FormClose(Sender: TObject;
 var Action: TCloseAction);
begin
 SendMessage(fParentWnd, CW_FreeUs, Integer(Self), 0);
 Action := caFree;
end;

procedure TfrmChatWith.eSendMessageKeyDown(Sender: TObject; var Key: Word;
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
   if (ssCtrl in Shift) then k_send_privateClick(Sender) else k_sendClick(Sender);
  end;
 if (Key = VK_UP) or (Key = VK_DOWN) then Key := 0;
end;

function TfrmChatWith.WBChatPGetExternal(
 out ppDispatch: IDispatch): HRESULT;
var
 MyIDispatch: TTCastleClient;
begin
 MyIDispatch := TTCastleClient.Create;
 MyIDispatch.Window := Self.Handle;
 ppDispatch := MyIDispatch;
 result := S_OK;
end;

procedure TfrmChatWith.k_send_privateClick(Sender: TObject);
begin
 eSendMessage.Items.Add(eSendMessage.Text);
 SayThread.PostMessage(US_SendThisP, StrToBuf(fUser.id), StrToBuf(eSendMessage.Text));
 eSendMessage.Text := '';
end;

procedure TfrmChatWith.WBSmilesPDocumentComplete(ASender: TObject;
 const pDisp: IDispatch; var URL: OleVariant);
var
 ts: TStringList;
begin
 if not SmilesLoaded then
  begin
   ts := TStringList.Create;
   WBSmilesP.SaveToStrings(ts);
   ts.Text := StringReplace(ts.Text, 'path\', makePath(ExtractFilePath(ParamStr(0))), [rfReplaceAll, rfIgnoreCase]);
   WBSmilesP.LoadFromStrings(ts);
   FreeAndNil(ts);
   SmilesLoaded := True;
  end;
end;

procedure TfrmChatWith.k_lat2rusClick(Sender: TObject);
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

end.

