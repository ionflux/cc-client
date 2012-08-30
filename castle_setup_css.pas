unit castle_setup_css;

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
 castle_setup,
 StdCtrls,
 Buttons,
 ExtCtrls,
 CSS_Colors, OleCtrls, SHDocVw_TLB, EmbeddedWB;

type
 TfrmCastle_setup_css = class(TFrameSetup)
  ComboBox1: TComboBox;
  Label1: TLabel;
  SpeedButton30: TSpeedButton;
  SpeedButton31: TSpeedButton;
  SpeedButton1: TSpeedButton;
  CheckBox1: TCheckBox;
  SpeedButton2: TSpeedButton;
  CheckBox2: TCheckBox;
  SpeedButton3: TSpeedButton;
  CheckBox3: TCheckBox;
  SpeedButton4: TSpeedButton;
  CheckBox4: TCheckBox;
  SpeedButton5: TSpeedButton;
  CheckBox5: TCheckBox;
  SpeedButton6: TSpeedButton;
  CheckBox6: TCheckBox;
  SpeedButton7: TSpeedButton;
  CheckBox7: TCheckBox;
  SpeedButton8: TSpeedButton;
  CheckBox8: TCheckBox;
  SpeedButton9: TSpeedButton;
  CheckBox9: TCheckBox;
  SpeedButton10: TSpeedButton;
  CheckBox10: TCheckBox;
  SpeedButton11: TSpeedButton;
  CheckBox11: TCheckBox;
    wb_css: TEmbeddedWB;
  procedure ComboBox1Change(Sender: TObject);
 private
  procedure CSS2Panels(StyleIndex: Integer);
 public
  procedure InitParams; override;
  procedure SaveParams; override;
 end;
 
implementation

uses
 castle_utils,
 MSHTML_TLB;

{$R *.dfm}

procedure TfrmCastle_setup_css.CSS2Panels(StyleIndex: Integer);

 procedure ParceCSS(CSSText: string);
 var
  CSS: DispHTMLStyleSheet;
 begin
  CSS := CoHTMLStyleSheet.Create;
  CSS.cssText := CSSText;
 end;
 
 procedure ResetDef;
 var
  i: integer;
 begin
  for i := 0 to ComponentCount - 1 do
   begin
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked := false else
     if Components[i] is TPanel then
      with TPanel(Components[i]) do
       begin
        Font.Name := 'Tahoma';
        Font.Color := clWindowText;
        Color := clBtnFace;
       end;
   end;
 end;
 
var
 css: TStringList;
// s: string;
 i: integer;
begin
 ResetDef;
 
 css := TStringList.Create;
 // css.Text := BufToStr(Integer(ChatStyles.Objects[StyleIndex]), False);
 
 for i := 0 to css.Count - 1 do
  begin
{   s := copy(css[i], 1, pos('{', css[i]));
   if s = 'body' then Style2Panel(1) else
    if s = 'a' then Style2Panel(2) else
     if s = '.AdminName' then Style2Panel(3) else
      if s = '.AdminText' then Style2Panel(4) else
       if s = '.StrajName' then Style2Panel(5) else
        if s = '.StrajText' then Style2Panel(6) else
         if s = '.PrivateName' then Style2Panel(7) else
          if s = '.PrivateText' then Style2Panel(8) else
           if s = '.ChatName' then Style2Panel(9) else
            if s = '.ChatText' then Style2Panel(10) else
             if s = '.OurNick' then Style2Panel(11);
}
  end;
 
 FreeAndNil(css);
end;

procedure TfrmCastle_setup_css.InitParams;
begin
 // ComboBox1.Items.Assign(ChatStyles);
 ComboBox1.ItemIndex := 0;
end;

procedure TfrmCastle_setup_css.SaveParams;
begin
end;

procedure TfrmCastle_setup_css.ComboBox1Change(Sender: TObject);
begin
 CSS2Panels(ComboBox1.ItemIndex);
end;

end.

