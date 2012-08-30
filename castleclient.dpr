program castleclient;

uses
  Forms,
  castle_archive in 'castle_archive.pas' {frmArchive},
  castle_help in 'castle_help.pas' {frmHelp},
  castle_interface in 'castle_interface.pas',
  castle_messages in 'castle_messages.pas' {frmMessages},
  castle_setup in 'castle_setup.pas' {frmSetup},
  castle_userinfo in 'castle_userinfo.pas' {frmUserInfo},
  castle_utils in 'castle_utils.pas',
  castleclient_TLB in 'castleclient_TLB.pas',
  Crypt32 in 'Crypt32.pas',
  main in 'main.pas' {frmCastle},
  Threads in 'Threads.pas',
  NetLayerU in 'NetLayerU.pas',
  castle_ot_chat in 'castle_ot_chat.pas' {frmChatWith},
  castle_baloon in 'castle_baloon.pas' {frmBaloon},
  ToDO in 'ToDO.pas',
  castle_setup_main in 'castle_setup_main.pas' {frmCastle_setup_main},
  castle_setup_sounds in 'castle_setup_sounds.pas' {frmCastle_setup_sounds},
  castle_setup_css in 'castle_setup_css.pas' {frmCastle_setup_css},
  CSS_Colors in 'CSS_Colors.pas';

{$R *.TLB}

{$R *.res}

begin
 Application.Initialize;
 Application.Title := 'Замок "ИФ"';
 Application.CreateForm(TfrmCastle, frmCastle);
 Application.Run;
end.

