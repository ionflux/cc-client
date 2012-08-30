unit castle_setup_sounds;

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
 castle_setup,
 Dialogs,
 StdCtrls,
 ImgList,
 Buttons;

type
 TfrmCastle_setup_sounds = class(TFrameSetup)
  Edit1: TEdit;
  Label1: TLabel;
  SpeedButton1: TSpeedButton;
  SpeedButton2: TSpeedButton;
  ImageList1: TImageList;
  Edit2: TEdit;
  Label2: TLabel;
  SpeedButton3: TSpeedButton;
  SpeedButton4: TSpeedButton;
  Edit3: TEdit;
  Label3: TLabel;
  SpeedButton5: TSpeedButton;
  SpeedButton6: TSpeedButton;
  Label4: TLabel;
  SpeedButton7: TSpeedButton;
  SpeedButton8: TSpeedButton;
  Label5: TLabel;
  SpeedButton9: TSpeedButton;
  SpeedButton10: TSpeedButton;
  Label6: TLabel;
  SpeedButton11: TSpeedButton;
  SpeedButton12: TSpeedButton;
  Edit4: TEdit;
  Edit5: TEdit;
  Edit6: TEdit;
  Label7: TLabel;
  SpeedButton13: TSpeedButton;
  SpeedButton14: TSpeedButton;
  Label8: TLabel;
  SpeedButton15: TSpeedButton;
  SpeedButton16: TSpeedButton;
  Edit7: TEdit;
  Edit8: TEdit;
  OpenDialog: TOpenDialog;
  procedure FormCreate(Sender: TObject);
  procedure SpeedButton2Click(Sender: TObject);
  procedure SpeedButton1Click(Sender: TObject);
 private
  { Private declarations }
 public
  procedure InitParams; override;
  procedure SaveParams; override;
 end;
 
implementation

uses castle_utils,
 castle_interface;

{$R *.dfm}

procedure TfrmCastle_setup_sounds.InitParams;
begin
 edit1.Text := Config.Value_Str['Sound_Message'];
 edit2.Text := Config.Value_Str['Sound_Private'];
 edit3.Text := Config.Value_Str['Sound_Mail'];
 edit4.Text := Config.Value_Str['Sound_Online'];
 edit5.Text := Config.Value_Str['Sound_Offline'];
 edit6.Text := Config.Value_Str['Sound_Login'];
 edit7.Text := Config.Value_Str['Sound_Admin'];
 edit8.Text := Config.Value_Str['Sound_Problem'];
end;

procedure TfrmCastle_setup_sounds.SaveParams;
begin
 Config.Value_Str['Sound_Message'] := edit1.Text;
 Config.Value_Str['Sound_Private'] := edit2.Text;
 Config.Value_Str['Sound_Mail'] := edit3.Text;
 Config.Value_Str['Sound_Online'] := edit4.Text;
 Config.Value_Str['Sound_Offline'] := edit5.Text;
 Config.Value_Str['Sound_Login'] := edit6.Text;
 Config.Value_Str['Sound_Admin'] := edit7.Text;
 Config.Value_Str['Sound_Problem'] := edit8.Text;
end;

procedure TfrmCastle_setup_sounds.FormCreate(Sender: TObject);
var
 i: Integer;
begin
 for i := 0 to ComponentCount - 1 do
  if Components[i] is TSpeedButton then
   begin
    case TSpeedButton(Components[i]).caption[1] of
     't': ImageList1.GetBitmap(0, TSpeedButton(Components[i]).Glyph);
     'p': ImageList1.GetBitmap(1, TSpeedButton(Components[i]).Glyph);
    end;
    TSpeedButton(Components[i]).caption := '';
   end;
end;

procedure TfrmCastle_setup_sounds.SpeedButton2Click(Sender: TObject);
var
 com: TComponent;
begin
 com := FindComponent('Edit' + IntToStr(TSpeedButton(Sender).Tag));
 
 if Assigned(com) then
  PlayWav(TEdit(com).Text);
end;

procedure TfrmCastle_setup_sounds.SpeedButton1Click(Sender: TObject);
var
 com: TComponent;
begin
 com := FindComponent('Edit' + IntToStr(TSpeedButton(Sender).Tag));
 if Assigned(com) then
  begin
   OpenDialog.FileName := TEdit(com).Text;

   if OpenDialog.Execute then
    TEdit(com).Text := OpenDialog.FileName;
  end;
end;

end.

