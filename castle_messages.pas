unit castle_messages;

interface

uses
 Windows,
 Messages,
 SysUtils,
 Variants,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,
 OleCtrls,
 SHDocVw_TLB,
 EmbeddedWB,
 ExtCtrls,
 StdCtrls,
 mshtml;

const
 PM_CheckMessages = $9000 + 1;
 
type
 TfrmMessages = class(TForm)
  Panel1: TPanel;
  cbUsers: TComboBox;
  k_send: TImage;
  eMess: TEdit;
  WBPrivate: TEmbeddedWB;
  k_obn: TImage;
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  function WBPrivateShowContextMenu(const dwID: Cardinal;
   const ppt: PPoint; const pcmdtReserved: IInterface;
   const pdispReserved: IDispatch): HRESULT;
  procedure WBPrivateDocumentComplete(ASender: TObject;
   const pDisp: IDispatch; var URL: OleVariant);
  procedure k_sendClick(Sender: TObject);
  procedure eMessKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure k_obnClick(Sender: TObject);
  procedure WndProc(var Msg: TMessage); override;
 private
  { Private declarations }
 public
  fParentWnd: THandle;
 end;
 
implementation

uses
 castle_interface,
 castle_utils,
 main;

{$R *.dfm}

// PM_ChechMessages

procedure TfrmMessages.WndProc(var Msg: TMessage);
begin
 if Msg.Msg = PM_CheckMessages then
  begin
   if Assigned(ChatUsers) then
    begin
     ChatUsers.ChatUsers.Sort;
     cbUsers.Items.Assign(ChatUsers.ChatUsers);
    end;
   WBPrivate.Go('res://' + makePath(paramstr(0)) + '/private');
  end else
  inherited;
end;

procedure TfrmMessages.FormCreate(Sender: TObject);
begin
 k_send.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_enter');
 k_obn.Picture.Bitmap.LoadFromResourceName(HInstance, 'k_obn');
 
 if Assigned(ChatUsers) then
  begin
   ChatUsers.ChatUsers.Sort;
   cbUsers.Items.Assign(ChatUsers.ChatUsers);
  end;
 WBPrivate.Go('res://' + makePath(paramstr(0)) + '/private');
end;

procedure TfrmMessages.FormShow(Sender: TObject);
begin
 ReadFormState(RegKey + '\Сообщения', Self);
end;

procedure TfrmMessages.FormClose(Sender: TObject;
 var Action: TCloseAction);
begin
 SaveFormState(RegKey + '\Сообщения', Self);
 Action := caHide;
end;

function TfrmMessages.WBPrivateShowContextMenu(const dwID: Cardinal;
 const ppt: PPoint; const pcmdtReserved: IInterface;
 const pdispReserved: IDispatch): HRESULT;
begin
 frmCastle.pmChat.PopupComponent := WBPrivate;
 frmCastle.pmChat.Popup(ppt.X, ppt.Y);
 result := S_OK;
end;

procedure TfrmMessages.WBPrivateDocumentComplete(ASender: TObject;
 const pDisp: IDispatch; var URL: OleVariant);
var
 i: Integer;
 s: string;
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
begin
 if pos('/private', URL) > 0 then
  begin
   s := ReadReg(RegKey, 'WBArchive_Style', '???');
   for i := 0 to frmCastle.miChatStyle.Count - 1 do
    if frmCastle.miChatStyle.Items[i].Caption = s then
     begin
      frmCastle.pmChat.PopupComponent := WBPrivate;
      frmCastle.miChatStyle.Items[i].OnClick(frmCastle.miChatStyle.Items[i]);
     end;
   frDoc := WBPrivate.DefaultInterface;
   frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);

   if Assigned(PrivateMessages) then
    HTMLTable(oHTML_Doc.all.item('private', varEmpty)).innerHTML := RawToHTML(PrivateMessages.Messages, True);
  end;
end;

procedure TfrmMessages.k_sendClick(Sender: TObject);
begin
 if Assigned(PrivateMessages) then
  begin
   PrivateMessages.PostMessage(UP_SendThisMessage, StrToBuf(eMess.Text), StrToBuf(cbUsers.Text));
   eMess.Text := '';
  end else
  EMsg('Странная ошибка, не стартован TPrivateThread, такого быть не должно');
end;

procedure TfrmMessages.eMessKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 if Key = VK_RETURN then k_sendClick(Sender);
end;

procedure TfrmMessages.k_obnClick(Sender: TObject);
begin
 PrivateMessages.PostMessage(UP_CheckNewMessage, 0, 0);
end;

end.

