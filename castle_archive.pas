unit castle_archive;

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
 ComCtrls,
 OleCtrls,
 SHDocVw_TLB,
 EmbeddedWB,
 Menus,
 mshtml,
 ExtCtrls,
 VirtualTrees,
 StdCtrls,
 castle_interface;

type
 TfrmArchive = class(TForm)
  WBArchive: TEmbeddedWB;
  Splitter1: TSplitter;
  Panel1: TPanel;
  vsLogs: TVirtualStringTree;
  cbRooms: TComboBox;
  procedure FormCreate(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  function WBArchiveShowContextMenu(const dwID: Cardinal;
   const ppt: PPoint; const pcmdtReserved: IInterface;
   const pdispReserved: IDispatch): HRESULT;
  procedure FormShow(Sender: TObject);
  procedure WBArchiveDocumentComplete(ASender: TObject;
   const pDisp: IDispatch; var URL: OleVariant);
  procedure lvLogClick(Sender: PChatLogView);
  procedure cbRoomsChange(Sender: TObject);
  procedure vsLogsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
   Column: TColumnIndex; TextType: TVSTTextType;
   var CellText: WideString);
  procedure vsLogsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
  procedure vsLogsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
 private
  { Private declarations }
 public
 end;
 
implementation

uses
 castle_utils,
 main;

{$R *.dfm}

procedure TfrmArchive.FormCreate(Sender: TObject);
begin
 vsLogs.NodeDataSize := SizeOf(TChatLogView);
 cbRooms.Items.Assign(ChatLog.KnowRooms);
 cbRooms.ItemIndex := cbRooms.Items.IndexOf('Основная');
 WBArchive.Go('res://' + makePath(paramstr(0)) + '/archive');
end;

procedure TfrmArchive.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveFormState(RegKey + '\Архив', Self);
 Action := caFree;
end;

function TfrmArchive.WBArchiveShowContextMenu(const dwID: Cardinal;
 const ppt: PPoint; const pcmdtReserved: IInterface;
 const pdispReserved: IDispatch): HRESULT;
begin
 frmCastle.pmChat.PopupComponent := WBArchive;
 frmCastle.pmChat.Popup(ppt.X, ppt.Y);
 result := S_OK;
end;

procedure TfrmArchive.FormShow(Sender: TObject);
begin
 ReadFormState(RegKey + '\Архив', Self);
end;

procedure TfrmArchive.WBArchiveDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
var
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
 s: string;
 i: integer;
begin
 frDoc := WBArchive.DefaultInterface;
 frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
 
 ChatLog.GetLogByPart('Основная', vsLogs);
 vsLogs.Selected[vsLogs.GetFirst] := True;
 
 s := ReadReg(RegKey, 'WBArchive_Style', '???');
 for i := 0 to frmCastle.miChatStyle.Count - 1 do
  if frmCastle.miChatStyle.Items[i].Caption = s then
   begin
    frmCastle.pmChat.PopupComponent := WBArchive;
    frmCastle.miChatStyle.Items[i].OnClick(frmCastle.miChatStyle.Items[i]);
   end;
end;

procedure TfrmArchive.lvLogClick(Sender: PChatLogView);
var
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
begin
 if Assigned(Sender.Messages) then
  begin
   frDoc := WBArchive.DefaultInterface;
   frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
   HTMLTable(oHTML_Doc.all.item('chat', varEmpty)).innerHTML := RawToHTML(Sender.Messages, True);
  end;
end;

procedure TfrmArchive.cbRoomsChange(Sender: TObject);
begin
 ChatLog.GetLogByPart(cbRooms.Items[cbRooms.ItemIndex], vsLogs);
 vsLogs.Selected[vsLogs.GetFirst] := True;
end;

procedure TfrmArchive.vsLogsGetText(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
 var CellText: WideString);
begin
 CellText := PChatLogView(Sender.GetNodeData(Node)).Name;
end;

procedure TfrmArchive.vsLogsFreeNode(Sender: TBaseVirtualTree;
 Node: PVirtualNode);
begin
 FreeAndNil(PChatLogView(Sender.GetNodeData(Node)).Messages);
end;

procedure TfrmArchive.vsLogsChange(Sender: TBaseVirtualTree;
 Node: PVirtualNode);
begin
 if Assigned(Node) then
  if (vsSelected in Node.States) then
   lvLogClick(Sender.GetNodeData(Node));
end;

end.

