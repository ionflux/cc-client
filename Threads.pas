unit Threads;

interface

uses
 Windows,
 Dialogs,
 SysUtils,
 Classes,
 Messages,
 NetLayerU,
 castle_utils;

const
 BASE64_TABLE: string =
 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
 FILL_CHAR = '=';
 US_Message = $5000 + 1;
 
type
 
 TSynchronize = procedure(Method: TThreadMethod) of object;
 
 TAdvThread = class(TThread)
 protected
  procedure Execute; override;
  procedure DoExecute; virtual;
  procedure HandleException(E: Exception); virtual;
 end;
 
 TMsgThread = class(TAdvThread)
 protected
  procedure DoExecute; override;
  procedure HandleMessage(var Msg: TMsg); virtual;
  procedure CreateMessageQueue;

 public
  StopEvent: THandle;

  constructor Create(S: Boolean);
  destructor Destroy; override;

  procedure PostMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
  procedure StopThread; virtual;
  procedure CheckMessages;

  property Terminated;
 end;
 
 TSockMsgThread = class(TMsgThread)
 protected
  fWasSocketError: Boolean;
  fUserAgent,
   fProxyAuth,
   fProxyAddr,
   fProxyPort: string;
  fParentHandle: THandle;
  fIpHostS: string;
  fIpHostD: DWORD;
  procedure EncodeUnit(const AIn1, AIn2, AIn3: Byte; var VOut: Cardinal);
  function ProxyConnection: string;
  function ProxyCache: string;
  function BasicAuthStr: string;
  function HTTPBuildRequest(RequestType, URL, Cookies, Content: string): string;
  function Encode64(const Src: string): string;
 public
  property Proxy_Auth: string read fProxyAuth write fProxyAuth;
  property Proxy_Addr: string read fProxyAddr write fProxyAddr;
  property Proxy_Port: string read fProxyPort write fProxyPort;
  procedure DoMainLog(msg: string);
  property ParentHandle: THandle read fParentHandle;
  procedure OnStatus(Msg: string);
  function GetProxyIP(Host: string): DWORD;
  function ProxyRead(Req, StopStr: string): string;
  function GetPage(RequestType, URL, Cookies, Content, StopStr: string): string;
  function HEncode(const S: string): string;
  constructor Create(Parent: THandle; UserAgent, ProxyAuth, ProxyAddr, ProxyPort: string);
 end;
 
 TLocker = class
 private
  hEvent: THandle;

 public
  constructor Create;
  destructor Destroy; override;

  procedure Lock;
  procedure UnLock;
 end;
 
procedure WaitSignaled(E: THandle);

implementation

uses castle_interface;

procedure TAdvThread.Execute;
begin
 try
  DoExecute;
 except
  on E: Exception do
   HandleException(E);
 end;
end;

procedure TAdvThread.DoExecute;
begin
end;

procedure TAdvThread.HandleException(E: Exception);
begin
end;

constructor TMsgThread.Create(S: Boolean);
begin
 inherited Create(S);
 
 StopEvent := CreateEvent(nil, True, False, '');
end;

destructor TMsgThread.Destroy;
begin
 inherited Destroy;
 CloseHandle(StopEvent);
end;

procedure TMsgThread.CheckMessages;
var
 Msg: TMsg;
begin
 while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
  HandleMessage(Msg);
end;

procedure TMsgThread.DoExecute;
begin
 CreateMessageQueue;
 
 while MsgWaitForMultipleObjects(1, StopEvent, False, INFINITE, QS_ALLINPUT) <> WAIT_OBJECT_0 do
  CheckMessages;
end;

procedure TMsgThread.HandleMessage(var Msg: TMsg);
begin
 DispatchMessage(Msg);
end;

procedure TMsgThread.PostMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
 PostThreadMessage(ThreadID, Msg, wParam, lParam);
end;

procedure TMsgThread.CreateMessageQueue;
var
 Msg: TMsg;
begin
 PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
end;

procedure TMsgThread.StopThread;
begin
 Terminate;
 SetEvent(StopEvent);
end;

constructor TLocker.Create;
begin
 inherited Create;
 
 hEvent := CreateEvent(nil, False, True, '');
end;

destructor TLocker.Destroy;
begin
 CloseHandle(hEvent);
 inherited Destroy;
end;

procedure TLocker.Lock;
begin
 WaitSignaled(hEvent);
end;

procedure TLocker.UnLock;
begin
 SetEvent(hEvent);
end;

procedure ProcessMessage;
var
 Handled: Boolean;
 Msg: TMsg;
begin
 if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
   if Msg.Message <> WM_QUIT then
    begin
     Handled := False;
     if not Handled then
      begin
       TranslateMessage(Msg);
       DispatchMessage(Msg);
      end;
    end;
  end;
end;

procedure WaitSignaled(E: THandle);
begin
 if GetCurrentThreadID = MainThreadID then
  begin
   if WaitForSingleObject(E, 0) <> WAIT_OBJECT_0 then
    repeat
     ProcessMessage;
    until MsgWaitForMultipleObjects(1, E, False, INFINITE, QS_ALLINPUT) = WAIT_OBJECT_0;
  end
 else
  WaitForSingleObject(E, INFINITE);
end;

procedure TSockMsgThread.DoMainLog(msg: string);
begin
 SendMessage(fParentHandle, UL_LogMessage, 0, StrToBuf(msg));
end;

procedure TSockMsgThread.OnStatus(Msg: string);
begin
 DoMainLog(msg);
end;

function TSockMsgThread.GetProxyIP(Host: string): DWORD;
var
 F: Integer;
 PA: string;
begin
 if fIpHostS <> Host then
  begin
   if (fProxyAddr <> '') then
    begin
     OnStatus('resolving IP (proxy) [' + fProxyAddr + ']');
     F := Pos(':', fProxyAddr);
     if (F = 0) then F := Length(fProxyAddr) + 1;
     PA := System.Copy(fProxyAddr, 1, F - 1);
     OnStatus('resolving IP (proxy only) [' + PA + ']');
     Result := SocketResolveHost(PA);
    end
   else
    begin
     OnStatus('resolving IP (' + Host + ')');
     Result := SocketResolveHost(Host);
    end;
   //    fIpHostS := Host;
   //    fIpHostD := Result;
   OnStatus('IP resolved: [' + IPToStr(Result) + ']');
  end
 else
  Result := fIpHostD;
end;

function TSockMsgThread.ProxyRead(Req, StopStr: string): string;
var
 SrvSock, IP: DWORD;
 R, Len: Integer;
 Host, S: string;
begin
 fWasSocketError := True;
 Result := '';
 if (Req = '') and (not Terminated) then exit; // пустые запросы - нафиг
 
 // выделяем поле host из запроса
 R := Pos(#10'Host: ', Req);
 if (R <> 0) then
  begin
   Host := Copy(Req, R + 7, 255);
   R := Pos(#10, Host);
   if (R <> 0) then Delete(Host, R, 255);
  end
 else
  Host := 'localhost';
 OnStatus('Host="' + Host + '"');
 
 if Terminated then Exit;
 
 // создали сокет
 SrvSock := SocketCreateWithTimeouts(60, 30 * 1000, 30 * 1000);
 if (SrvSock = 0) then
  begin
   // или не создали %-)
   OnStatus('Error create socket');
   exit;
  end;
 
 if Terminated then
  begin
   SocketClose(SrvSock);
   Exit;
  end;
 
 // приконнектились
 // по правилам тут бы надо точнее проверять ProxyPort, ну да нафиг...
 OnStatus('connecting ');
 if Length(fProxyAddr) > 1 then
  IP := GetProxyIP(fProxyAddr) else
  IP := GetProxyIP(Host);
 OnStatus('ProxyIP=[' + IPToStr(IP) + ']');
 OnStatus('ProxyPort=[' + fProxyPort + ']');
 OnStatus('connecting...');
 if not SocketConnect(SrvSock, IP, StrToIntDef(fProxyPort, 80)) then
  begin
   // или не приконнектились
   SocketClose(SrvSock);
   OnStatus('error, can''t connect to host');
   exit;
  end;
 
 if Terminated then
  begin
   SocketClose(SrvSock);
   Exit;
  end;
 
 // отослали весь запрос скопом (он обычно маленький)
 OnStatus('writing reqest [' + IntToStr(Length(Req)) + ']');
 if (SocketSend(SrvSock, Req[1], Length(Req)) <> 0) then
  begin
   // или не отослали
   SocketClose(SrvSock);
   OnStatus('error, can''t write reqest');
   exit;
  end;
 
 if Terminated then
  begin
   SocketClose(SrvSock);
   Exit;
  end;
 
 OnStatus('reading 0');
 repeat
  R := SocketCanRead(SrvSock);
  // вот тут если R < 0 - то ошибка
  // если R = 0 - ничего в сокете не лежит пока
  // если R > 0 - лежат какие-то байтики
  if (R < 0) then break;

  if (R = 0) then
   Len := 1 // если ничего не лежит - попросим, чтобы положили
  else
   begin
    // проверим, сколько лежит байтиков
    Len := SocketBytesToRead(SrvSock);
    if (Len < 0) then break;
    if (Len = 0) then
     begin
      fWasSocketError := False;
      break;
     end;
   end;
  if (Len > 0) and (not Terminated) then
   begin
    SetLength(S, Len);
    R := SocketReceive(SrvSock, S[1], Len);
    if (R = -1) then break;
    if (R = 0) then
     begin
      Result := Result + S;
      OnStatus('reading ' + IntToStr(Length(Result)) + ' bytes');
      if Pos(StopStr, Result) > 0 then Break; // Если мы нашли то что нам надо, то зачем мучаться дальше?
     end
    else
     OnStatus('waiting ' + IntToStr(Length(Result)));
    // получили вкусность, рассказали сказку
   end;
 until False or Terminated;
 // всё. отмучились.
 SocketClose(SrvSock);
 OnStatus('socket closed - ok ');

 SendMessage(fParentHandle, UC_ReadedBytes, Length(Result), 0);
 
 // приведем всё непотребство (концы строк) (если есть) в юникс-вид

 Result := StringReplace(Result, #13#10, #10, [rfReplaceAll, rfIgnoreCase])
end;

function TSockMsgThread.GetPage(RequestType, URL, Cookies, Content, StopStr: string): string;
var
 ts: string;
begin
 ts := HTTPBuildRequest(RequestType, URL, Cookies, Content);
 Result := ProxyRead(ts, StopStr);
end;

procedure TSockMsgThread.EncodeUnit(const AIn1, AIn2, AIn3: Byte; var VOut: Cardinal);
var
 LUnit: packed record
  case Integer of
   0: (Byte1, Byte2, Byte3, Byte4: Byte);
   1: (Whole: Cardinal);
 end;
begin
 LUnit.Byte1 := ord(BASE64_TABLE[((AIn1 shr 2) and 63) + 1]);
 LUnit.Byte2 := ord(BASE64_TABLE[(((AIn1 shl 4) or (AIn2 shr 4)) and 63) + 1]);
 LUnit.Byte3 := ord(BASE64_TABLE[(((AIn2 shl 2) or (AIn3 shr 6)) and 63) + 1]);
 LUnit.Byte4 := ord(BASE64_TABLE[(Ord(AIn3) and 63) + 1]);
 VOut := LUnit.Whole;
end;

function TSockMsgThread.Encode64(const Src: string): string;
var
 LBuffer: string;
 LSize: Integer;
 LLen: Integer;
 LBufSize: Integer;
 LPos: Integer;
 LIn1, LIn2, LIn3: Byte;
 LUnit: packed record
  case Integer of
   0: (Byte1, Byte2, Byte3, Byte4: Byte);
   1: (Whole: Cardinal);
 end;
begin
 Result := '';
 LIn3 := 0;
 LBufSize := Length(Src);
 if LBufSize = 0 then Exit;
 
 SetLength(Result, ((LBufSize + 2) div 3) * 4);
 LLen := 0;
 LBuffer := Src;
 LPos := 1;
 while (LPos <= LBufSize) do
  begin
   LIn1 := Byte(LBuffer[LPos]);
   Inc(LPos);
   if (LPos <= LBufSize) then
    begin
     LIn2 := Byte(LBuffer[LPos]);
     Inc(LPos);
     if (LPos <= LBufSize) then
      begin
       LIn3 := Byte(LBuffer[LPos]);
       Inc(LPos);
       LSize := 3;
      end
     else
      begin
       LIn3 := 0;
       LSize := 2;
      end;
    end
   else
    begin
     LIn2 := 0;
     LSize := 1;
    end;
   EncodeUnit(LIn1, LIn2, LIn3, LUnit.Whole);
   Move(LUnit, Result[LLen + 1], 4);
   Inc(LLen, 4);
   if (LSize < 3) then
    begin
     Result[LLen] := FILL_CHAR;
     if (LSize = 1) then Result[LLen - 1] := FILL_CHAR;
    end;
  end;
end;

function TSockMsgThread.ProxyConnection: string;
begin
 if (fProxyAddr <> '') then
  Result := 'Referer: http://castle.istu.edu'#10'Proxy-Connection: close'#10
 else
  Result := '';
end;

function TSockMsgThread.ProxyCache: string;
begin
 if (fProxyAddr <> '') then
  Result := 'Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0'#10
 else
  Result := '';
end;

function TSockMsgThread.BasicAuthStr: string;
begin
 if (fProxyAuth <> '') then
  Result := 'Proxy-Authorization: Basic ' + Encode64(fProxyAuth) + #10
 else
  Result := '';
end;

function TSockMsgThread.HTTPBuildRequest(RequestType, URL, Cookies, Content: string): string;
var
 H: string;
begin
 H := URL;
 Delete(H, 1, Pos('://', H) + 2);
 H := Copy(H, 1, Pos('/', H) - 1);
 
 if (Cookies <> '') then Cookies := 'Cookie: ' + Cookies + #10 + 'Cookie2: $Version="1"'#10;

 Result :=
  RequestType + ' ' + URL + ' HTTP/1.0'#10 +
  'User-Agent: ' + fUserAgent + #10 +
  'Host: ' + H + #10 +
  'Accept: */*'#10 +
  'Content-Type: application/x-www-form-urlencoded'#10 +
  BasicAuthStr +  
  // ProxyConnection +
  ProxyCache +
  Cookies +
  'Content-length: ' + IntToStr(Length(Content)) + #10#10 +
  Content;

//  ShowMessage(Result);

//  if RequestType = 'POST' then ShowMessage(Result);
end;

function TSockMsgThread.HEncode(const S: string): string;
var
 F: Integer;
begin
 Result := '';
 for F := 1 to Length(S) do
  Result := Result + '%' + IntToHex(Byte(S[F]), 2);
end;

constructor TSockMsgThread.Create(Parent: THandle; UserAgent, ProxyAuth, ProxyAddr, ProxyPort: string);
begin
 fUserAgent := UserAgent;
 fProxyAuth := ProxyAuth;
 fProxyAddr := ProxyAddr;
 fProxyPort := ProxyPort;
 fParentHandle := Parent;
 inherited Create(False);
end;

end.

