{$apptype console}
program Crypt;

uses Crypt32, SysUtils, Classes, castle_utils;

const
 infile  = '.\chat.irk.ru\nicks';
 outfile = 'webnames.dat';

var fin: TStringList;
    fout: TFileStream;
    s: string;
    i: Integer;

begin
 fin := TStringList.Create;
 fin.LoadFromFile(infile);
 fout := TFileStream.Create(outfile, fmCreate or fmOpenWrite);
 i := fin.Count;
 fout.Write(i, SizeOf(integer));
 for i := 0 to fin.Count - 1 do
  begin
   s := fin[i];
   WriteStr(fout, Encrypt(ReplaceCharsIn(Copy(s, 1, Pos(':', s) -1)), StartKey, MultKey, AddKey));
   WriteStr(fout, Encrypt(Copy(s, Pos(':', s) + 1, Length(s)), StartKey, MultKey, AddKey));
  end;
 FreeAndNil(fout);
 FreeAndNil(fin);
end.