unit CSS_Colors;

interface

uses Classes;

function FillColors: TStringList;

implementation

function FillColors: TStringList;
begin
 Result := TStringList.Create;
 Result.AddObject('AliceBlue', TObject($F0F8FF));
 Result.AddObject('AntiqueWhite', TObject($FAEBD7));
 Result.AddObject('Aqua', TObject($00FFFF));
 Result.AddObject('Aquamarine', TObject($7FFFD4));
 Result.AddObject('Azure', TObject($F0FFFF));
 Result.AddObject('Beige', TObject($F5F5DC));
 Result.AddObject('Bisque', TObject($FFE4C4));
 Result.AddObject('Black', TObject($000000));
 Result.AddObject('BlanchedAlmond', TObject($FFEBCD));
 Result.AddObject('Blue', TObject($0000FF));
 Result.AddObject('BlueViolet', TObject($8A2BE2));
 Result.AddObject('Brown', TObject($A52A2A));
 Result.AddObject('BurlyWood', TObject($DEB887));
 Result.AddObject('CadetBlue', TObject($5F9EA0));
 Result.AddObject('Chartreuse', TObject($7FFF00));
 Result.AddObject('Chocolate', TObject($D2691E));
 Result.AddObject('Coral', TObject($FF7F50));
 Result.AddObject('CornflowerBlue', TObject($6495ED));
 Result.AddObject('Cornsilk', TObject($FFF8DC));
 Result.AddObject('Crimson', TObject($DC143C));
 Result.AddObject('Cyan', TObject($00FFFF));
 Result.AddObject('DarkBlue', TObject($00008B));
 Result.AddObject('DarkCyan', TObject($008B8B));
 Result.AddObject('DarkGoldenRod', TObject($B8860B));
 Result.AddObject('DarkGray', TObject($A9A9A9));
 Result.AddObject('DarkGreen', TObject($006400));
 Result.AddObject('DarkKhaki', TObject($BDB76B));
 Result.AddObject('DarkMagenta', TObject($8B008B));
 Result.AddObject('DarkOliveGreen', TObject($556B2F));
 Result.AddObject('Darkorange', TObject($FF8C00));
 Result.AddObject('DarkOrchid', TObject($9932CC));
 Result.AddObject('DarkRed', TObject($8B0000));
 Result.AddObject('DarkSalmon', TObject($E9967A));
 Result.AddObject('DarkSeaGreen', TObject($8FBC8F));
 Result.AddObject('DarkSlateBlue', TObject($483D8B));
 Result.AddObject('DarkSlateGray', TObject($2F4F4F));
 Result.AddObject('DarkTurquoise', TObject($00CED1));
 Result.AddObject('DarkViolet', TObject($9400D3));
 Result.AddObject('DeepPink', TObject($FF1493));
 Result.AddObject('DeepSkyBlue', TObject($00BFFF));
 Result.AddObject('DimGray', TObject($696969));
 Result.AddObject('DodgerBlue', TObject($1E90FF));
 Result.AddObject('Feldspar', TObject($D19275));
 Result.AddObject('FireBrick', TObject($B22222));
 Result.AddObject('FloralWhite', TObject($FFFAF0));
 Result.AddObject('ForestGreen', TObject($228B22));
 Result.AddObject('Fuchsia', TObject($FF00FF));
 Result.AddObject('Gainsboro', TObject($DCDCDC));
 Result.AddObject('GhostWhite', TObject($F8F8FF));
 Result.AddObject('Gold', TObject($FFD700));
 Result.AddObject('GoldenRod', TObject($DAA520));
 Result.AddObject('Gray', TObject($808080));
 Result.AddObject('Green', TObject($008000));
 Result.AddObject('GreenYellow', TObject($ADFF2F));
 Result.AddObject('HoneyDew', TObject($F0FFF0));
 Result.AddObject('HotPink', TObject($FF69B4));
 Result.AddObject('IndianRed', TObject($CD5C5C));
 Result.AddObject('Indigo', TObject($4B0082));
 Result.AddObject('Ivory', TObject($FFFFF0));
 Result.AddObject('Khaki', TObject($F0E68C));
 Result.AddObject('Lavender', TObject($E6E6FA));
 Result.AddObject('LavenderBlush', TObject($FFF0F5));
 Result.AddObject('LawnGreen', TObject($7CFC00));
 Result.AddObject('LemonChiffon', TObject($FFFACD));
 Result.AddObject('LightBlue', TObject($ADD8E6));
 Result.AddObject('LightCoral', TObject($F08080));
 Result.AddObject('LightCyan', TObject($E0FFFF));
 Result.AddObject('LightGoldenRodYellow', TObject($FAFAD2));
 Result.AddObject('LightGrey', TObject($D3D3D3));
 Result.AddObject('LightGreen', TObject($90EE90));
 Result.AddObject('LightPink', TObject($FFB6C1));
 Result.AddObject('LightSalmon', TObject($FFA07A));
 Result.AddObject('LightSeaGreen', TObject($20B2AA));
 Result.AddObject('LightSkyBlue', TObject($87CEFA));
 Result.AddObject('LightSlateBlue', TObject($8470FF));
 Result.AddObject('LightSlateGray', TObject($778899));
 Result.AddObject('LightSteelBlue', TObject($B0C4DE));
 Result.AddObject('LightYellow', TObject($FFFFE0));
 Result.AddObject('Lime', TObject($00FF00));
 Result.AddObject('LimeGreen', TObject($32CD32));
 Result.AddObject('Linen', TObject($FAF0E6));
 Result.AddObject('Magenta', TObject($FF00FF));
 Result.AddObject('Maroon', TObject($800000));
 Result.AddObject('MediumAquaMarine', TObject($66CDAA));
 Result.AddObject('MediumBlue', TObject($0000CD));
 Result.AddObject('MediumOrchid', TObject($BA55D3));
 Result.AddObject('MediumPurple', TObject($9370D8));
 Result.AddObject('MediumSeaGreen', TObject($3CB371));
 Result.AddObject('MediumSlateBlue', TObject($7B68EE));
 Result.AddObject('MediumSpringGreen', TObject($00FA9A));
 Result.AddObject('MediumTurquoise', TObject($48D1CC));
 Result.AddObject('MediumVioletRed', TObject($C71585));
 Result.AddObject('MidnightBlue', TObject($191970));
 Result.AddObject('MintCream', TObject($F5FFFA));
 Result.AddObject('MistyRose', TObject($FFE4E1));
 Result.AddObject('Moccasin', TObject($FFE4B5));
 Result.AddObject('NavajoWhite', TObject($FFDEAD));
 Result.AddObject('Navy', TObject($000080));
 Result.AddObject('OldLace', TObject($FDF5E6));
 Result.AddObject('Olive', TObject($808000));
 Result.AddObject('OliveDrab', TObject($6B8E23));
 Result.AddObject('Orange', TObject($FFA500));
 Result.AddObject('OrangeRed', TObject($FF4500));
 Result.AddObject('Orchid', TObject($DA70D6));
 Result.AddObject('PaleGoldenRod', TObject($EEE8AA));
 Result.AddObject('PaleGreen', TObject($98FB98));
 Result.AddObject('PaleTurquoise', TObject($AFEEEE));
 Result.AddObject('PaleVioletRed', TObject($D87093));
 Result.AddObject('PapayaWhip', TObject($FFEFD5));
 Result.AddObject('PeachPuff', TObject($FFDAB9));
 Result.AddObject('Peru', TObject($CD853F));
 Result.AddObject('Pink', TObject($FFC0CB));
 Result.AddObject('Plum', TObject($DDA0DD));
 Result.AddObject('PowderBlue', TObject($B0E0E6));
 Result.AddObject('Purple', TObject($800080));
 Result.AddObject('Red', TObject($FF0000));
 Result.AddObject('RosyBrown', TObject($BC8F8F));
 Result.AddObject('RoyalBlue', TObject($4169E1));
 Result.AddObject('SaddleBrown', TObject($8B4513));
 Result.AddObject('Salmon', TObject($FA8072));
 Result.AddObject('SandyBrown', TObject($F4A460));
 Result.AddObject('SeaGreen', TObject($2E8B57));
 Result.AddObject('SeaShell', TObject($FFF5EE));
 Result.AddObject('Sienna', TObject($A0522D));
 Result.AddObject('Silver', TObject($C0C0C0));
 Result.AddObject('SkyBlue', TObject($87CEEB));
 Result.AddObject('SlateBlue', TObject($6A5ACD));
 Result.AddObject('SlateGray', TObject($708090));
 Result.AddObject('Snow', TObject($FFFAFA));
 Result.AddObject('SpringGreen', TObject($00FF7F));
 Result.AddObject('SteelBlue', TObject($4682B4));
 Result.AddObject('Tan', TObject($D2B48C));
 Result.AddObject('Teal', TObject($008080));
 Result.AddObject('Thistle', TObject($D8BFD8));
 Result.AddObject('Tomato', TObject($FF6347));
 Result.AddObject('Turquoise', TObject($40E0D0));
 Result.AddObject('Violet', TObject($EE82EE));
 Result.AddObject('VioletRed', TObject($D02090));
 Result.AddObject('Wheat', TObject($F5DEB3));
 Result.AddObject('White', TObject($FFFFFF));
 Result.AddObject('WhiteSmoke', TObject($F5F5F5));
 Result.AddObject('Yellow', TObject($FFFF00));
 Result.AddObject('YellowGreen', TObject($9ACD32));
end;

end.

