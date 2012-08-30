unit castle_setup;

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
 ExtCtrls,
 ComCtrls,
 StdCtrls,
 ImgList,
 VirtualTrees;

type
 TFrameSetup = class(TForm)
  procedure InitParams; virtual;
  procedure SaveParams; virtual;
 end;
 
 TFrameSetupClass = class of TFrameSetup;
 
 TfrmSetup = class(TForm)
  Panel1: TPanel;
  btnCancel: TButton;
  btnSave: TButton;
  Bevel1: TBevel;
  vstConfigs: TVirtualStringTree;
  pForm: TPanel;
  ImageList: TImageList;
  procedure btnCancelClick(Sender: TObject);
  procedure btnSaveClick(Sender: TObject);
  procedure vstConfigsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  procedure FormCreate(Sender: TObject);
  procedure vstConfigsGetImageIndex(Sender: TBaseVirtualTree;
   Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
   var Ghosted: Boolean; var ImageIndex: Integer);
  procedure vstConfigsChange(Sender: TBaseVirtualTree;
   Node: PVirtualNode);
 private
  ss: TFrameSetup;
  procedure AddPage(PClass: TFrameSetupClass; Desc: string; ImageIndex: Integer);
  procedure ShowPage(PClass: TFrameSetupClass);
 public
 end;
 
 PRecFrameSetup = ^TRecFrameSetup;
 TRecFrameSetup = record
  Desc: string;
  Frame: TFrameSetupClass;
  ImageIndex: Integer;
 end;
 
implementation

uses
 castle_utils,
 castle_setup_main,
 castle_setup_sounds,
 castle_setup_css;

{$R *.dfm}

procedure TfrmSetup.btnCancelClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure TFrameSetup.InitParams;
begin
end;

procedure TFrameSetup.SaveParams;
begin
end;

procedure TfrmSetup.AddPage(PClass: TFrameSetupClass; Desc: string; ImageIndex: Integer);
var
 Data: PRecFrameSetup;
begin
 vstConfigs.NodeDataSize := SiZeOf(TRecFrameSetup);
 
 Data := vstConfigs.GetNodeData(vstConfigs.AddChild(nil));
 Data.Desc := Desc;
 Data.Frame := PClass;
 Data.ImageIndex := ImageIndex;
 
end;

procedure TfrmSetup.btnSaveClick(Sender: TObject);
begin
 if Assigned(ss) then ss.SaveParams;
end;

procedure TfrmSetup.vstConfigsGetText(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
 var CellText: WideString);
var
 Data: PRecFrameSetup;
begin
 Data := Sender.GetNodeData(Node);
 CellText := Data.Desc;
end;

procedure TfrmSetup.FormCreate(Sender: TObject);
begin
 AddPage(TfrmCastle_setup_main, 'Основные', 0);
 AddPage(TfrmCastle_setup_sounds, 'Звуки', 1);
 // AddPage(TfrmCastle_setup_css, 'Стили', 2);

 vstConfigs.Selected[vstConfigs.GetFirst] := true;

end;

procedure TfrmSetup.vstConfigsGetImageIndex(Sender: TBaseVirtualTree;
 Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
 var Ghosted: Boolean; var ImageIndex: Integer);
var
 Data: PRecFrameSetup;
begin
 Data := Sender.GetNodeData(Node);
 ImageIndex := Data.ImageIndex;
end;

procedure TfrmSetup.ShowPage(PClass: TFrameSetupClass);
begin
 ss := PClass.Create(Self);
 with ss do
  begin
   InitParams;
   BorderStyle := bsNone;
   Parent := pForm;
   Align := alClient;
   Show;
  end;
end;

procedure TfrmSetup.vstConfigsChange(Sender: TBaseVirtualTree;
 Node: PVirtualNode);
var
 Data: PRecFrameSetup;
begin
 if Assigned(ss) then
  begin
   // ss.SaveParams;
   FreeAndNil(ss);
  end;
 Data := vstConfigs.GetNodeData(vstConfigs.GetFirstSelected);
 if Data <> nil then
  ShowPage(Data.Frame);
end;

end.

