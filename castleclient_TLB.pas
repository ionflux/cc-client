unit castleclient_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 30.03.2004 3:32:18 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\programming\work\castleclient\castleclient.tlb (1)
// LIBID: {F02C6AE1-2B06-4A11-B8EB-1D2714528528}
// LCID: 0
// Helpfile: 
// HelpString: castleclient Library
// DepndLst: 
//   (1) v2.0 stdole, (D:\WINNT\System32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  castleclientMajorVersion = 1;
  castleclientMinorVersion = 0;

  LIBID_castleclient: TGUID = '{F02C6AE1-2B06-4A11-B8EB-1D2714528528}';

  IID_ICastleClient: TGUID = '{0360C667-4317-49AE-921B-23CB16FE0376}';
  CLASS_TCastleClient: TGUID = '{1C06EEEE-B5AA-49FF-A486-B050C498F054}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICastleClient = interface;
  ICastleClientDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TCastleClient = ICastleClient;


// *********************************************************************//
// Interface: ICastleClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0360C667-4317-49AE-921B-23CB16FE0376}
// *********************************************************************//
  ICastleClient = interface(IDispatch)
    ['{0360C667-4317-49AE-921B-23CB16FE0376}']
    procedure Set_DoLogin(Param1: OleVariant); safecall;
    function Get_GetLogin: OleVariant; safecall;
    function Get_GetProxyAddr: OleVariant; safecall;
    function Get_GetProxyPort: OleVariant; safecall;
    procedure Set_SetSmile(Param1: OleVariant); safecall;
    procedure Set_SetNick(Param1: OleVariant); safecall;
    procedure Set_SetPrivateName(Param1: OleVariant); safecall;
    procedure Set_DoConfig(Param1: OleVariant); safecall;
    procedure Set_GetNickInfo(Param1: OleVariant); safecall;
    function Get_GetProxyUser: OleVariant; safecall;
    function Get_GetProxyPass: OleVariant; safecall;
    function Get_SaveChatLogin: WordBool; safecall;
    function Get_SaveProxyLogin: WordBool; safecall;
    function Get_GetPass: OleVariant; safecall;
    function Get_GetUseProxy: WordBool; safecall;
    function Get_GetUseProxyAuth: WordBool; safecall;
    procedure Set_SetRoom(Param1: OleVariant); safecall;
    procedure Set_IncRoom(Param1: Integer); safecall;
    procedure Set_ShowMail(Param1: OleVariant); safecall;
    procedure Set_UlockChat(Param1: OleVariant); safecall;
    property DoLogin: OleVariant write Set_DoLogin;
    property GetLogin: OleVariant read Get_GetLogin;
    property GetProxyAddr: OleVariant read Get_GetProxyAddr;
    property GetProxyPort: OleVariant read Get_GetProxyPort;
    property SetSmile: OleVariant write Set_SetSmile;
    property SetNick: OleVariant write Set_SetNick;
    property SetPrivateName: OleVariant write Set_SetPrivateName;
    property DoConfig: OleVariant write Set_DoConfig;
    property GetNickInfo: OleVariant write Set_GetNickInfo;
    property GetProxyUser: OleVariant read Get_GetProxyUser;
    property GetProxyPass: OleVariant read Get_GetProxyPass;
    property SaveChatLogin: WordBool read Get_SaveChatLogin;
    property SaveProxyLogin: WordBool read Get_SaveProxyLogin;
    property GetPass: OleVariant read Get_GetPass;
    property GetUseProxy: WordBool read Get_GetUseProxy;
    property GetUseProxyAuth: WordBool read Get_GetUseProxyAuth;
    property SetRoom: OleVariant write Set_SetRoom;
    property IncRoom: Integer write Set_IncRoom;
    property ShowMail: OleVariant write Set_ShowMail;
    property UlockChat: OleVariant write Set_UlockChat;
  end;

// *********************************************************************//
// DispIntf:  ICastleClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0360C667-4317-49AE-921B-23CB16FE0376}
// *********************************************************************//
  ICastleClientDisp = dispinterface
    ['{0360C667-4317-49AE-921B-23CB16FE0376}']
    property DoLogin: OleVariant writeonly dispid 201;
    property GetLogin: OleVariant readonly dispid 202;
    property GetProxyAddr: OleVariant readonly dispid 203;
    property GetProxyPort: OleVariant readonly dispid 204;
    property SetSmile: OleVariant writeonly dispid 205;
    property SetNick: OleVariant writeonly dispid 206;
    property SetPrivateName: OleVariant writeonly dispid 207;
    property DoConfig: OleVariant writeonly dispid 208;
    property GetNickInfo: OleVariant writeonly dispid 210;
    property GetProxyUser: OleVariant readonly dispid 209;
    property GetProxyPass: OleVariant readonly dispid 211;
    property SaveChatLogin: WordBool readonly dispid 212;
    property SaveProxyLogin: WordBool readonly dispid 213;
    property GetPass: OleVariant readonly dispid 214;
    property GetUseProxy: WordBool readonly dispid 215;
    property GetUseProxyAuth: WordBool readonly dispid 216;
    property SetRoom: OleVariant writeonly dispid 217;
    property IncRoom: Integer writeonly dispid 218;
    property ShowMail: OleVariant writeonly dispid 219;
    property UlockChat: OleVariant writeonly dispid 220;
  end;

// *********************************************************************//
// The Class CoTCastleClient provides a Create and CreateRemote method to          
// create instances of the default interface ICastleClient exposed by              
// the CoClass TCastleClient. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTCastleClient = class
    class function Create: ICastleClient;
    class function CreateRemote(const MachineName: string): ICastleClient;
  end;

implementation

uses ComObj;

class function CoTCastleClient.Create: ICastleClient;
begin
  Result := CreateComObject(CLASS_TCastleClient) as ICastleClient;
end;

class function CoTCastleClient.CreateRemote(const MachineName: string): ICastleClient;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TCastleClient) as ICastleClient;
end;

end.
