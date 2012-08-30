unit castle_help;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, OleCtrls, SHDocVw_TLB, EmbeddedWB;

type
 TfrmHelp = class(TForm)
  WBHelp: TEmbeddedWB;
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure FormShow(Sender: TObject);
 private
    { Private declarations }
 public
    { Public declarations }
 end;
 
procedure OpenHelp(page: string);

implementation

uses castle_utils;

{$R *.dfm}

procedure OpenHelp(page: string);
var
 path: string;
begin
 with TfrmHelp.Create(Screen.ActiveForm) do
  begin
   path := ExtractFilePath(ParamStr(0));
   WBHelp.Navigate('mk:@MSITStore:' + path + '\castleclient.chm::\' + page + '.htm');
  end;
end;

procedure TfrmHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveFormState('Помощь', Self);
 Action := caFree;
end;

procedure TfrmHelp.FormShow(Sender: TObject);
begin
 ReadFormState('Помощь', Self);
end;

end.
