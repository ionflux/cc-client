unit castle_setup_main;

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
 StdCtrls,
 castle_setup;

type
 TfrmCastle_setup_main = class(TFrameSetup)
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  Label9: TLabel;
  Label10: TLabel;
  cbHTML: TCheckBox;
  eRefTime: TEdit;
  eRefUsers: TEdit;
  cbHTMLTime: TCheckBox;
  eMCount: TEdit;
  cbPlaySounds: TCheckBox;
  ePriv: TEdit;
  eMaxLogCount: TEdit;
  eMaxLogDays: TEdit;
    cbNewMail: TCheckBox;
  procedure cbHTMLClick(Sender: TObject);
 private
  { Private declarations }
 public
  procedure InitParams; override;
  procedure SaveParams; override;
 end;
 
implementation

uses
 castle_interface,
 castle_utils;

{$R *.dfm}

procedure TfrmCastle_setup_main.InitParams;
begin
 eRefTime.Text := Config.Value_Str['RefreshChatTime'];
 eRefUsers.Text := Config.Value_Str['RefreshUsersTime'];
 ePriv.Text := Config.Value_Str['RefreshPrivateTime'];
 eMCount.Text := Config.Value_Str['MaxMessagesCount'];
 cbHTML.Checked := Config.Value_Bool['SaveLogToHTML'];
 cbHTMLTime.Checked := Config.Value_Bool['AddTimeInHtmlLog'];
 cbPlaySounds.Checked := Config.Value_Bool['PlaySounds'];
 eMaxLogCount.Text := Config.Value_Str['MaxLogMessages'];
 eMaxLogDays.Text := Config.Value_Str['MaxLogDays'];
 cbNewMail.Checked := Config.Value_Bool['ShowNewMail'];
end;

procedure TfrmCastle_setup_main.SaveParams;
begin
 if (StrToIntDef(eRefTime.Text, 10) > 9) and (StrToIntDef(eRefTime.Text, 10) < 321) then
  if (StrToIntDef(eRefUsers.Text, 10) > 9) and (StrToIntDef(eRefUsers.Text, 10) < 321) then
   if (StrToIntDef(eMCount.Text, 10) > 9) and (StrToIntDef(eMCount.Text, 10) < 321) then
    if (StrToIntDef(ePriv.Text, 10) > 59) and (StrToIntDef(ePriv.Text, 10) < 1201) then
     if (StrToIntDef(eMaxLogDays.Text, 14) > 1) and (StrToIntDef(eMaxLogDays.Text, 14) < 357) then
      if (StrToIntDef(eMaxLogCount.Text, 40) > 1) and (StrToIntDef(eMaxLogCount.Text, 14) < 100000) then
       begin
        Config.Value_Str['RefreshChatTime'] := eRefTime.Text;
        Config.Value_Str['RefreshUsersTime'] := eRefUsers.Text;
        Config.Value_Str['RefreshPrivateTime'] := ePriv.Text;
        Config.Value_Str['MaxMessagesCount'] := eMCount.Text;
        Config.Value_Bool['SaveLogToHTML'] := cbHTML.Checked;
        Config.Value_Bool['AddTimeInHtmlLog'] := cbHTMLTime.Checked;
        Config.Value_Bool['PlaySounds'] := cbPlaySounds.Checked;
        Config.Value_Str['MaxLogMessages'] := eMaxLogCount.Text;
        Config.Value_Str['MaxLogDays'] := eMaxLogDays.Text;
        Config.Value_Bool['ShowNewMail'] := cbNewMail.Checked;
       end else
      EMsg('Максимальное количество сообщений в логе должно быть от 50 до 99999') else
     EMsg('Максимальная дата сообщения в логе должна быть от 1 до 356') else
    EMsg('Время обновления личных сообщений должно быть в пределе от 60 до 1200') else
   EMsg('Количество сообщений должно быть в пределе от 10 до 100') else
  EMsg('Время обновления пользователей должно быть в пределе от 10 до 320') else
  EMsg('Время обновления чата должно быть в пределе от 10 до 320');
end;

procedure TfrmCastle_setup_main.cbHTMLClick(Sender: TObject);
begin
 cbHTMLTime.Enabled := TCheckBox(Sender).Checked;
 cbHTMLTime.Checked := TCheckBox(Sender).Checked;
end;

end.
