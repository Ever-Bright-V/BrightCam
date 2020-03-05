unit MSec2Time;

interface

uses
  Winapi.Windows, System.SysUtils;

function MSecToHMSmS(OMSec: dword; FormatCode: word): string; overload;

function MSecToHMSmS(OMSec: dword; FormatCode: word; var Day: DWORD; var Hour: dWord; var Min: dWord; var Sec: DWORD; var MSec: DWORD): string; overload;

implementation

function MSecToHMSmS(OMSec: dword; FormatCode: word): string;
var
  Day, Sec, Min, Hour: dWord;
  OSec: dWord;
  NMin: dWord;
  MSec: DWORD;
begin
  OSec := OMSec div 1000;
  Sec := OSec mod 60;
  NMin := OSec div 60;
  Min := NMin mod 60;
  Hour := NMin div 60;
  MSec := OMSec mod 1000;
  if FormatCode = 0 then      // 小时 无毫秒
  begin
    Result := Format('%4.2d:%.2d:%.2d', [Hour, Min, Sec]);   // 最大值 1192多小时
  end;
  if FormatCode = 1 then      //小时 有毫秒
  begin
    Result := Format('%4.2d:%.2d:%.2d:%3.3d', [Hour, Min, Sec, MSec])
  end;
  if FormatCode = 2 then      // 天-小时-无毫秒
  begin
    Day := Hour div 24;
    Hour := Hour mod 24;
    Result := Format('+%d %.2d:%.2d:%.2d', [Day, Hour, Min, Sec]);
  end;
  if FormatCode = 3 then      // 天-小时-毫秒
  begin
    Day := Hour div 24;
    Hour := Hour mod 24;
    Result := Format('+%d %.2d:%.2d:%.2d:%3.3d', [Day, Hour, Min, Sec, MSec]);
  end;
end;

function MSecToHMSmS(OMSec: dword; FormatCode: word; var Day: DWORD; var Hour: dWord; var Min: dWord; var Sec: DWORD; var MSec: DWORD): string;
var
  OSec: dWord;
  NMin: dWord;
begin
  OSec := OMSec div 1000;
  Sec := OSec mod 60;
  NMin := OSec div 60;
  Min := NMin mod 60;
  Hour := NMin div 60;
  MSec := OMSec mod 1000;
  Day := 0;
  if FormatCode = 0 then
  begin
    Result := Format('%4.2d:%.2d:%.2d', [Hour, Min, Sec]);   // 最大值 1192多小时
  end;
  if FormatCode = 1 then
  begin
    Result := Format('%4.2d:%.2d:%.2d:%3.3d', [Hour, Min, Sec, MSec])
  end;
  if FormatCode = 2 then      // 天-小时-无毫秒
  begin
    Day := Hour div 24;
    Hour := Hour mod 24;
    Result := Format('+%d %.2d:%.2d:%.2d', [Day, Hour, Min, Sec]);
  end;
  if FormatCode = 3 then      // 天-小时-毫秒
  begin
    Day := Hour div 24;
    Hour := Hour mod 24;
    Result := Format('+%d %.2d:%.2d:%.2d:%3.3d', [Day, Hour, Min, Sec, MSec]);
  end;
end;

end.

