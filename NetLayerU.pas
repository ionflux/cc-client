{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R+,S-,T-,U-,V+,W-,X+,Y-,Z1}
// socket helper
{$LONGSTRINGS ON}
{.$OPTIMIZATION OFF}
{$R-}
unit NetLayerU;

interface

uses
   Windows, WinSock, SysUtils;


function SocketCreateWithTimeouts(Linger, Send, Receive: DWORD): DWORD;
  // Linger: seconds, other: milliseconds
function SocketCreate: DWORD;
  // default timeouts: 60 sec, 30 sec, 30 sec
function SocketClose(Socket: DWORD): Boolean;
function SocketConnect(Socket: DWORD; IP: DWORD; Port: Word): Boolean;
function SocketBind(Socket: DWORD; IP: DWORD; Port: Word): Boolean;
function SocketListen(Socket: DWORD): Boolean;
function SocketSend(Socket: DWORD; var Data; DataSize: DWORD): Integer;
  // Result <> 0 - error
function SocketReceive(Socket: DWORD; var Data; DataSize: DWORD): Integer;
  // Result <> 0 - error
function SocketBytesToRead(Socket: DWORD): DWORD;
function SocketAccept(Socket: DWORD; IP: DWORD; Port: Word): DWORD;
function SocketResolveHost(Host: string): DWORD;
function SocketSetDelay(Socket: DWORD; on: Boolean): Boolean;
function SocketCanRead(Socket: DWORD): Integer;
  // Result: < 0 - error, = 0 - idling, > 0 - have data
function SocketCanWrite(Socket: DWORD): Integer;
  // same as CanRead

function SocketGetHostName(IP: DWORD): string;

// startup & cleanup will be called automatically
function SocketsStartup: Boolean;
procedure SocketsCleanup;

// just for fun
function IPToStr(IP: DWORD): string;
function StrToIP(S: string): DWORD;


implementation


function SocketCreateWithTimeouts(Linger, Send, Receive: DWORD): DWORD;
// Linger - in seconds!
var
   Ling: packed array[0..1] of Word;
begin
   Result := WinSock.socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
   if (Result = DWORD(INVALID_SOCKET)) then
      Result := 0
   else
   begin
      if (Linger <> 0) then Ling[0] := 1 else Ling[0] := 0;
      Ling[1] := Linger;
      WinSock.setsockopt(Result, SOL_SOCKET, SO_LINGER, @Ling, 4);

      if (Send <> 0) then
         WinSock.setsockopt(Result, SOL_SOCKET, SO_SNDTIMEO, @Send, 4);

      if (Receive <> 0) then
         WinSock.setsockopt(Result, SOL_SOCKET, SO_RCVTIMEO, @Receive, 4);

      Receive := 16;
      WinSock.setsockopt(Result, SOL_SOCKET, SO_RCVBUF, @Receive, 4);
   end;
end;

function SocketCreate: DWORD;
begin
   Result := SocketCreateWithTimeouts(60, 30000, 30000);
end;

function SocketClose(Socket: DWORD): Boolean;
begin
   if (Socket <> 0) then
      Result := (WinSock.closesocket(Socket) = 0)
   else
      Result := True;
end;

function SocketConnect(Socket: DWORD; IP: DWORD; Port: Word): Boolean;
var
   SA: TSockAddrIn;
begin
   SA.sin_family := AF_INET;
   SA.sin_addr.S_addr := IP;
   SA.sin_port := htons(Port);
   Result := (WinSock.connect(Socket, SA, SizeOf(SA)) = 0);
end;

function SocketBind(Socket: DWORD; IP: DWORD; Port: Word): Boolean;
var
   SA: TSockAddr;
begin
   SA.sin_family := AF_INET;
   SA.sin_addr.S_addr := IP;
   SA.sin_port := htons(Port);
   Result := (WinSock.bind(Socket, SA, SizeOf(SA)) = 0);
end;

function SocketListen(Socket: DWORD): Boolean;
begin
   Result := (WinSock.listen(Socket, SOMAXCONN) = 0);
end;

// returns error code

function SocketSend(Socket: DWORD; var Data; DataSize: DWORD): Integer;
var
   P: PChar;
   Sd: DWORD;
begin
   P := @Data;
   while (DataSize > 0) do
   begin
      Sd := WinSock.send(Socket, P^, DataSize, 0);
      if (Sd = DWORD(SOCKET_ERROR)) then
      begin
         Result := WSAGetLastError;
         if (Result = 0) then Result := -1;
         exit;
      end;
      if (Sd = 0) then begin Result := -100; exit; end;
      Inc(P, Sd);
      Dec(DataSize, Sd);
   end;
   Result := 0;
end;

// returns error code

function SocketReceive(Socket: DWORD; var Data; DataSize: DWORD): Integer;
var
   P: PChar;
   Rv: DWORD;
begin
   P := @Data;
   while (DataSize > 0) do
   begin
      Rv := WinSock.recv(Socket, P^, DataSize, 0);
      if (Rv = DWORD(SOCKET_ERROR)) then
      begin
         Result := WSAGetLastError;
         if (Result = 0) then Result := -1;
         exit;
      end;
      if (Rv = 0) then begin Result := -100; exit; end;
      Inc(P, Rv);
      Dec(DataSize, Rv);
   end;
   Result := 0;
end;

function SocketBytesToRead(Socket: DWORD): DWORD;
var
   Rd: u_long;
begin
   if (ioctlsocket(Socket, $4004667F, Rd) = SOCKET_ERROR) then
      Result := DWORD(-1)
   else
      Result := Rd;
end;

function SocketAccept(Socket: DWORD; IP: DWORD; Port: Word): DWORD;
var
   SA: TSockAddrIn;
   Len: DWORD;
begin
   SA.sin_family := AF_INET;
   SA.sin_addr.S_addr := IP;
   SA.sin_port := htons(Port);
   Len := SizeOf(SA);
   Result := WinSock.accept(Socket, @SA, @Len);
   if (Result = DWORD(INVALID_SOCKET)) then Result := 0;
end;

function SocketResolveHost(Host: string): DWORD;
var
   HE: PHostEnt;
   P: PChar;
begin
   Result := StrToIP(Host);
   if (Result = DWORD(INADDR_NONE)) then
   begin
      HE := gethostbyname(PChar(Host));
      if (HE = nil) then
         Result := DWORD(INADDR_NONE)
      else
      begin
         P := HE.h_addr_list^;
         Move(P^, Result, 4);
      end;
   end;
end;

function SocketGetHostName(IP: DWORD): string;
var
   HE: PHostEnt;
begin
   if (IP = DWORD(INADDR_ANY)) then
      Result := '[INADDR_ANY]'
   else
      if (IP = DWORD(INADDR_NONE)) then
         Result := ''
      else
      begin
         HE := gethostbyaddr(@IP, 4, PF_INET);
         if (HE <> nil) then
            Result := HE.h_name
         else
            Result := '';
      end;
end;

function SocketSetDelay(Socket: DWORD; on: Boolean): Boolean;
var
   OB: Integer;
begin
   if on then OB := 1 else OB := 0;
   Result := (setsockopt(Socket, IPPROTO_TCP, TCP_NODELAY, @OB, 4) = 0);
end;

function SocketCanRead(Socket: DWORD): Integer;
// -1 - error, 0 - no, 1 - yes
var
   OneSS: packed record Count: UINT; Num: TSocket; end;
   TV: TTimeVal;
begin
   OneSS.Count := 1;
   OneSS.Num := Socket;
   TV.tv_sec := 0;
   TV.tv_usec := 0;
   Result := select(0, PFDSet(@OneSS), nil, nil, @TV);
   if (Result = SOCKET_ERROR) then Result := -1 else
      if (Result <> 0) then Result := 1;
end;

function SocketCanWrite(Socket: DWORD): Integer;
// -1 - error, 0 - no, 1 - yes
var
   OneSS: packed record Count: UINT; Num: TSocket; end;
   TV: TTimeVal;
begin
   OneSS.Count := 1;
   OneSS.Num := Socket;
   TV.tv_sec := 0;
   TV.tv_usec := 0;
   Result := select(0, nil, PFDSet(@OneSS), nil, @TV);
   if (Result = SOCKET_ERROR) then Result := -1 else
      if (Result <> 0) then Result := 1;
end;

function SocketsStartup: Boolean;
var
   WSAData: TWSAData;
begin
   Result := (WSAStartup($0101, WSAData) = 0);
end;

procedure SocketsCleanup;
begin
   WSACleanup;
end;


function B2S(B: Byte): string;
begin
   Str(B, Result);
end;

function IPToStr(IP: DWORD): string;
var
   IPA: array[0..3] of Byte absolute IP;
begin
   if (IP = DWORD(INADDR_NONE)) then
      Result := 'none'
   else
      Result := B2S(IPA[0]) + '.' + B2S(IPA[1]) + '.' +
         B2S(IPA[2]) + '.' + B2S(IPA[3]);
end;

function GetTillDot(var S: string): Integer;
var
   P: Integer;
begin
   P := Pos('.', S);
   if (P = 0) then P := Length(S) + 1;
   Result := StrToIntDef(Copy(S, 1, P - 1), -1);
   Delete(S, 1, P);
   if (Result < 0) or (Result > 255) then Result := -1;
end;

function StrToIP(S: string): DWORD;
var
   IPA: array[0..3] of Byte absolute Result;
   F, C: Integer;
begin
   for F := 0 to 3 do
   begin
      C := GetTillDot(S);
      if (C < 0) then
      begin
         Result := DWORD(INADDR_NONE);
         exit;
      end;
      IPA[F] := C;
   end;
end;


initialization
   SocketsStartup;
finalization
   SocketsCleanup;
end.

