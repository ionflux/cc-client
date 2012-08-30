unit VersionInfo;

interface

uses Windows,
 Forms,
 SysUtils;

function GetVersionInfo: string;
function GetVersion: string;
function GetBuildTime: TDateTime;

implementation
//==================================================================================================

function GetVersionInfo: string;
var
 VerText: PChar;
 InfoSize, Wnd, VerSize: DWORD;
 VerBuf: Pointer;
begin
 Result := '-.-.-.-';
 InfoSize := GetFileVersionInfoSize(PChar(Application.ExeName), Wnd);
 if InfoSize <> 0 then begin
   GetMem(VerBuf, InfoSize);
   try
    if GetFileVersionInfo(PChar(Application.ExeName), Wnd, InfoSize, VerBuf) then
     if VerQueryValue(VerBuf, '\StringFileInfo\040904E4\FileVersion', Pointer(VerText), VerSize) then
      Result := StrPas(VerText);
   finally
    FreeMem(VerBuf);
   end;
  end;
end;
//==================================================================================================

function GetBuildTime: TDateTime;
type
 UShort = Word;
 TImageDosHeader = packed record
  e_magic: UShort; // магическое число
  e_cblp: UShort; // количество байт на последней странице файла
  e_cp: UShort; // количество страниц вфайле
  e_crlc: UShort; // Relocations
  e_cparhdr: UShort; // размер заголовка в параграфах
  e_minalloc: UShort; // Minimum extra paragraphsneeded
  e_maxalloc: UShort; // Maximum extra paragraphsneeded
  e_ss: UShort; // начальное( относительное ) значение регистра SS
  e_sp: UShort; // начальное значениерегистра SP
  e_csum: UShort; // контрольная сумма
  e_ip: UShort; // начальное значение регистра IP
  e_cs: UShort; // начальное( относительное ) значение регистра CS
  e_lfarlc: UShort; // адрес в файле на таблицу переадресации
  e_ovno: UShort; // количество оверлеев
  e_res: array[0..3] of UShort; // Зарезервировано
  e_oemid: UShort; // OEM identifier (for e_oeminfo)
  e_oeminfo: UShort; // OEM information; e_oemid specific
  e_res2: array[0..9] of UShort; // Зарезервировано
  e_lfanew: LongInt; // адрес в файле нового .exeзаголовка
 end;
 
 TImageResourceDirectory = packed record
  Characteristics: DWord;
  TimeDateStamp: DWord;
  MajorVersion: Word;
  MinorVersion: Word;
  NumberOfNamedEntries: Word;
  NumberOfIdEntries: Word;
    //  IMAGE_RESOURCE_DIRECTORY_ENTRY DirectoryEntries[];
 end;
 PImageResourceDirectory = ^TImageResourceDirectory;
 
var
 hExeFile: HFile;
 ImageDosHeader: TImageDosHeader;
 Signature: Cardinal;
 ImageFileHeader: TImageFileHeader;
 ImageOptionalHeader: TImageOptionalHeader;
 ImageSectionHeader: TImageSectionHeader;
 ImageResourceDirectory: TImageResourceDirectory;
 Temp: Cardinal;
 i: Integer;
begin
 hExeFile := CreateFile(PChar(ParamStr(0)), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
 try
  ReadFile(hExeFile, ImageDosHeader, SizeOf(ImageDosHeader), Temp, nil);
  SetFilePointer(hExeFile, ImageDosHeader.e_lfanew, nil, FILE_BEGIN);
  ReadFile(hExeFile, Signature, SizeOf(Signature), Temp, nil);
  ReadFile(hExeFile, ImageFileHeader, SizeOf(ImageFileHeader), Temp, nil);
  ReadFile(hExeFile, ImageOptionalHeader, SizeOf(ImageOptionalHeader), Temp, nil);
  for i := 0 to ImageFileHeader.NumberOfSections - 1 do
   begin
    ReadFile(hExeFile, ImageSectionHeader, SizeOf(ImageSectionHeader), Temp, nil);
    if StrComp(@ImageSectionHeader.Name, '.rsrc') = 0 then Break;
   end;
  SetFilePointer(hExeFile, ImageSectionHeader.PointerToRawData, nil, FILE_BEGIN);
  ReadFile(hExeFile, ImageResourceDirectory, SizeOf(ImageResourceDirectory), Temp, nil);
 finally
  FileClose(hExeFile);
 end;
 
 Result := FileDateToDateTime(ImageResourceDirectory.TimeDateStamp);
end;
//==================================================================================================

function GetVersion: string;
begin
 Result := 'v ' + GetVersionInfo + #13#10'build date ' + DateToStr(GetBuildTime);
end;
//==================================================================================================
end.

