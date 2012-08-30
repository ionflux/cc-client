unit castle_utils;

interface

uses
 Windows,
 Classes,
 mshtml,
 EmbeddedWB,
 SHDocVw_TLB,
 Forms;

const
 ruscharsNick = 'êåõàğîñÊÅÕÀĞÎÑ';
 engcharsNick = 'kexapocKEXAPOC';
 ruschars     = 'éöóêåíãøùçõúôûâàïğîëäæıÿ÷ñìèòüáşÉÖÓÊÅÍÃØÙÇÕÚÔÛÂÀÏĞÎËÄÆİß×ÑÌÈÒÜÁŞ';
 engchars     = 'qwertyuiop[]asdfghjkl;''zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>';
 
type
 TSearchCallBack = procedure(FileDir, FileName: string);
 
function FileToString(FileName: string): string;
procedure StringToFile(InStr, FileName: string);
procedure PlayWav(sName: string);
function makePath(instr: string): string;
procedure EMsg(Msg: string = ''; mCaption: string = '');
function StrToBuf(const S: string): Integer;
function BufToStr(BufI: Integer; FreeM: Boolean = True): string;
procedure SearchFiles(Dir, Mask: string; FCB: TSearchCallBack);
//
function ReadReg(RegKey, Name, Default: string): string;
procedure WriteReg(RegKey, Name, Value: string);
//
procedure WriteStr(var Stream: TFileStream; StrN: string);
function ReadStr(var Stream: TFileStream): string;
//
procedure SaveFormState(Where: string; Form: TForm);
procedure ReadFormState(From: string; Form: TForm);
//
function ReplaceCharsIn(InName: string): string;
function ReplaceCharsOut(InName: string): string;
function ReplaceCharsLatToRus(InStr: string): string;
//
function SearchBack(Sub: Char; Where: String): integer;
//
procedure ReplaceHTML(Where: TEmbeddedWB; idTag, HTML: string);
function CutHTTP(InStr: string): string;
//

implementation

uses
 SysUtils,
 mmsystem,
 Registry;

function FileToString(FileName: string): string;
var
 TS: TStringList;
begin
 TS := TStringList.Create;
 TS.LoadFromFile(FileName);
 Result := TS.Text;
 FreeAndNil(TS);
end;

procedure StringToFile(InStr, FileName: string);
var
 tf: TFileStream;
begin
 try
  tf := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  tf.Write(InStr[1], Length(InStr));
  FreeAndNil(tf);
 except
 end;
end;

procedure EMsg(Msg: string = ''; mCaption: string = '');
var
 mbp: tagMsgBoxParamsA;
begin
 if Length(mCaption) < 1 then mCaption := 'Çàìîê "ÈÔ"';
 
 mbp.cbSize := sizeof(mbp);
 
 if Assigned(Screen.ActiveForm) then mbp.hwndOwner := Screen.ActiveForm.Handle else
  if Assigned(Application.MainForm) then mbp.hwndOwner := Application.MainForm.Handle else
   mbp.hwndOwner := 0;
 
 mbp.lpszText := PChar(Msg);
 mbp.lpszCaption := PChar(mCaption);
 mbp.hInstance := hInstance;
 mbp.dwStyle := MB_OK or MB_APPLMODAL or MB_USERICON;
 mbp.lpszIcon := MAKEINTRESOURCE(9993);
 MessageBoxIndirect(mbp);
end;

procedure PlayWav(sName: string);
begin
 // s := ExtractFileDir(ParamStr(0)) + '\sounds\' + sname + '.wav';
 if FileExists(sName) then
  PlaySound(PChar(sName), 0, SND_FILENAME or SND_ASYNC)
end;

function makePath(instr: string): string;
var
 pths: string;
 i: integer;
begin
 
 pths := pths + instr[1];
 pths := pths + instr[2];
 
 for i := 3 to Length(instr) do
  begin
   if instr[i] = '\' then pths := pths + '\' else
    if instr[i] = ':' then pths := pths + ':' else
     if instr[i] = ' ' then pths := pths + '%' + IntToHex(ord(instr[i]), 2) else
      if (instr[i] = '#') then pths := pths + '%' + IntToHex(ord(instr[i]), 2) else
       if instr[i] <> #0 then pths := pths + instr[i];
  end;
 result := pths;
end;

function StrToBuf(const S: string): Integer;
var
 Buf: PChar;
 L: Integer;
begin
 L := Length(S);
 GetMem(Buf, 4 + L);
 Move(L, Buf[0], 4);
 if (L > 0) then Move(S[1], Buf[4], L);
 Result := Integer(Buf);
end;

function BufToStr(BufI: Integer; FreeM: Boolean = True): string;
var
 Buf: PChar;
 L: Integer;
begin
 Buf := PChar(BufI);
 Move(Buf[0], L, 4);
 SetLength(Result, L);
 if (L > 0) then Move(Buf[4], Result[1], L);
 if FreeM then FreeMem(Buf);
end;

procedure SearchFiles(Dir, Mask: string; FCB: TSearchCallBack);
var
 fs: TSearchRec;
begin
 if FindFirst(Dir + Mask, faAnyFile, fs) = 0 then
  repeat
   FCB(Dir, fs.Name);
  until FindNext(fs) <> 0;
 FindClose(fs);
end;

function ReadReg(RegKey, Name, Default: string): string;
begin
 with TRegistry.Create do
  begin
   RootKey := HKEY_CURRENT_USER;
   if OpenKey(RegKey, True) then
    if ValueExists(Name) then
     Result := ReadString(Name) else
     Result := Default;
   Free;
  end;
end;

procedure WriteReg(RegKey, Name, Value: string);
begin
 with TRegistry.Create do
  begin
   RootKey := HKEY_CURRENT_USER;
   if OpenKey(RegKey, True) then WriteString(Name, Value);
   Free;
  end;
end;

procedure WriteStr(var Stream: TFileStream; StrN: string);
var
 i: Word;
begin
 i := length(StrN);
 Stream.Write(i, SizeOf(Word));
 Stream.Write(StrN[1], i);
end;

function ReadStr(var Stream: TFileStream): string;
var
 i: Word;
begin
 SetLength(Result, 0);
 Stream.Read(i, SizeOf(Word));
 SetLength(Result, i);
 Stream.Read(Result[1], i);
end;

procedure SaveFormState(Where: string; Form: TForm);
begin
 with TRegistry.Create do
  begin
   RootKey := HKEY_CURRENT_USER;
   if OpenKey(Where, True) then
    begin
     WriteInteger('WindowState', Integer(Form.WindowState));
     case Form.WindowState of
      wsNormal:
       begin
        WriteInteger('Height', Form.Height);
        WriteInteger('Width', Form.Width);
        WriteInteger('Top', Form.Top);
        WriteInteger('Left', Form.Left);
       end;
      wsMinimized, wsMaximized:
       begin
        if ValueExists('Height') then DeleteValue('Height');
        if ValueExists('Width') then DeleteValue('Width');
        if ValueExists('Top') then DeleteValue('Top');
        if ValueExists('Left') then DeleteValue('Left');
       end;
     end;
    end
  end;
end;

procedure ReadFormState(From: string; Form: TForm);
begin
 with TRegistry.Create do
  begin
   RootKey := HKEY_CURRENT_USER;
   if OpenKey(From, True) then
    begin
     if ValueExists('Height') then Form.Height := ReadInteger('Height');
     if ValueExists('Width') then Form.Width := ReadInteger('Width');
     if ValueExists('Top') then Form.Top := ReadInteger('Top');
     if ValueExists('Left') then Form.Left := ReadInteger('Left');
     if ValueExists('WindowState') then Form.WindowState := TWindowState(ReadInteger('WindowState'));
    end;
  end
end;

function ReplaceCharsIn(InName: string): string;
var
 i: Integer;
begin
 Result := InName;
 for i := 1 to 14 do Result := StringReplace(Result, ruscharsNick[i], engcharsNick[i], [rfReplaceAll]);
end;

function ReplaceCharsOut(InName: string): string;
var
 z, i: Integer;
begin
 Result := InName;
 for z := 1 to Length(InName) do
  if ord(InName[z]) > 192 then
   begin
    for i := 1 to 14 do Result := StringReplace(Result, engcharsNick[i], ruscharsNick[i], [rfReplaceAll]);
    Break;
   end;
end;

function ReplaceCharsLatToRus(InStr: string): string;
var
 i: Integer;
begin
 Result := InStr;
 for i := 1 to 65 do Result := StringReplace(Result, engchars[i], ruschars[i], [rfReplaceAll]);
end;

function SearchBack(Sub: Char; Where: String): integer;
var i: integer;
begin
 Result := 0;
 for i:=Length(Where) downto 1 do
  if Where[i]=Sub then
   begin
    Result := i;
    Exit;
   end;
end;

procedure ReplaceHTML(Where: TEmbeddedWB; idTag, HTML: string);
var
 oHTML_Doc: IHTMLDocument2;
 frDoc: Iwebbrowser2;
begin
 frDoc := Where.DefaultInterface;
 frDoc.Document.QueryInterface(IHTMLDocument2, oHTML_Doc);
 try
  HTMLTable(oHTML_Doc.all.item(idTag, varEmpty)).innerHTML := HTML;
 except
  on E: Exception do EMsg('Îøèáêà çàìåíû òåêñòà: ' + idTag);
 end;
end;

function CutHTTP(InStr: string): string;
begin
 Delete(InStr, 1, Pos(#10#10, InStr) + 1);
 Result := InStr;
end;

end.

