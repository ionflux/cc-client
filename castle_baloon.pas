unit castle_baloon;

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
 ExtCtrls;

type
 TfrmBaloon = class(TForm)
  Timer: TTimer;
    lText: TMemo;
  procedure Image2Click(Sender: TObject);
  procedure TimerTimer(Sender: TObject);
  procedure FormPaint(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure CreateParams(var Params: TCreateParams); override;
 private
  { Private declarations }
 public
  { Public declarations }
 end;
 
implementation

uses castle_interface;

{$R *.dfm}

procedure TfrmBaloon.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
 with Params do
  begin
   ExStyle := ExStyle or WS_EX_APPWINDOW;
  end;
end;

procedure TfrmBaloon.Image2Click(Sender: TObject);
begin
 close;
end;

procedure TfrmBaloon.TimerTimer(Sender: TObject);
begin
 Close;
end;

procedure TfrmBaloon.FormPaint(Sender: TObject);
begin
 Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TfrmBaloon.FormCreate(Sender: TObject);
begin
 Timer.Interval := Config.Value_Int['BaloonTimer'];
 Timer.Enabled := True;
end;

procedure TfrmBaloon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
end;

end.

