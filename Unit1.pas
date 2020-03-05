unit Unit1;

interface

uses
  Msec2time, Winapi.ShellAPI, System.IniFiles, Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxSkinsDefaultPainters, dxBar, cxClasses,
  System.ImageList, Vcl.ImgList, dxBarExtItems, cxLabel, cxBarEditItem,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxCameraControl,
  cxContainer, cxEdit, dxGDIPlusClasses, cxImage, Vcl.ExtCtrls, cxCheckBox,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    ImageList1: TImageList;
    dxCameraControl1: TdxCameraControl;
    cxImage1: TcxImage;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    cxImage2: TcxImage;
    Timer4: TTimer;
    SaveDialog1: TSaveDialog;
    butt: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarSpinEdit1: TdxBarSpinEdit;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    cxBarEditItem2: TcxBarEditItem;
    dxBarEdit1: TdxBarEdit;
    dxBarButton14: TdxBarButton;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    Timer5: TTimer;
    procedure dxCameraControl1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxImage1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dxBarButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dxBarButton3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure dxBarButton6Click(Sender: TObject);
    procedure dxBarButton5Click(Sender: TObject);
    procedure dxBarButton9Click(Sender: TObject);
    procedure dxBarButton11Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure dxBarButton12Click(Sender: TObject);
    procedure dxBarButton10Click(Sender: TObject);
    procedure dxBarButton7Click(Sender: TObject);
    procedure dxBarButton8Click(Sender: TObject);
    procedure dxBarButton14Click(Sender: TObject);
    procedure dxBarEdit1Click(Sender: TObject);
    procedure buttBeforeMerge(Sender, ChildBarManager: TdxBarManager; AddItems: Boolean);
    procedure dxBarButton13Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dxBarButton15Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dxBarButton16Click(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
  private
    { Private declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  TopMostFlag: Boolean;
  ExtendFlag: Boolean;
  RootPath: string;
  CamSafeFlag: Boolean;
  CanRecordFlag: Boolean;

var
  Myini: TIniFile;
  Section: string;
  ImagePath: string;
  VideoPath: string;

var
  StartRec: DWORD;
  StopRec: DWORD;

function OpreateFileName(OldPath: string): string;

implementation

{$R *.dfm}

{ TForm1 }
procedure Delay(MiliSec: DWORD);  //延时函数
var
  isStart, isStop: DWORD;
begin
  isStart := GetTickCount;
  repeat
    isStop := GetTickCount;
    Application.ProcessMessages;
  until (isStop - isStart) >= MiliSec;
end;

procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  BorderStyle := bsNone;
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_STATICEDGE;
  Params.Style := Params.Style or WS_SIZEBOX;
end;

procedure TForm1.cxImage1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TForm1.dxBarButton10Click(Sender: TObject);
var
  NowIndex: Integer;
begin
  NowIndex := dxCameraControl1.ResolutionIndex;
  Form1.Width := dxCameraControl1.Resolutions[NowIndex].cx + 2;
  form1.Height := dxCameraControl1.Resolutions[NowIndex].cy + 2;
end;

procedure TForm1.dxBarButton11Click(Sender: TObject);
begin
  if not TopMostFlag then
  begin
    TopMostFlag := not TopMostFlag;
    SetWindowPos(Self.Handle, HWND_TOPMOST, Self.Left, Self.Top, Self.Width, Self.Height, SWP_SHOWWINDOW);
  end
  else
  begin
    SetWindowPos(Self.Handle, HWND_BOTTOM, Self.Left, Self.Top, Self.Width, Self.Height, SWP_SHOWWINDOW);
    TopMostFlag := not TopMostFlag;
  end;
end;

procedure TForm1.dxBarButton12Click(Sender: TObject);
begin
  dxCameraControl1.Stop;
  Form1.Close;
  Application.Terminate;
end;

procedure TForm1.dxBarButton13Click(Sender: TObject);
begin
  if not ExtendFlag then
  begin
    dxBarEdit1.Visible := ivNever;
    dxBarButton14.Visible := ivNever;
   // dxBarButton16.Visible := ivNever;
    dxBarButton13.ButtonStyle := bsChecked;
  end
  else
  begin
    dxBarEdit1.Visible := ivAlways;
    dxBarButton14.Visible := ivAlways;
    //dxBarButton16.Visible := ivAlways;
    dxBarButton13.ButtonStyle := bsDefault;
  end;
  Extendflag := not extendflag;
end;

procedure TForm1.dxBarButton14Click(Sender: TObject);
begin
  SaveDialog1.Title := '视频路径';
  SaveDialog1.Filter := '视频文件(*.avi)|*.avi';  //设置保存文件的扩展名
  SaveDialog1.DefaultExt := '.avi';
  if SaveDialog1.Execute then
  begin
    dxBarEdit1.Text := '';
    dxBarEdit1.Text := SaveDialog1.FileName;
  end;
  SaveDialog1.Title := '图片路径';
  SaveDialog1.Filter := '图片文件(*.bmp)|*.bmp';  //设置保存文件的扩展名
  SaveDialog1.DefaultExt := '.bmp';
  SaveDialog1.FileName := '';
  if SaveDialog1.Execute then
  begin
    dxBarEdit1.Text := dxBarEdit1.Text + ',' + SaveDialog1.FileName;
  end;
end;

procedure TForm1.dxBarButton15Click(Sender: TObject);
begin
  dxBarManager1Bar1.Visible := False;
end;

procedure TForm1.dxBarButton16Click(Sender: TObject);
var
  OperateString: TStringList;
  BmpBasePath: string;
  AviBasePath: string;
  FinalPath: string;
begin
  OperateString := TStringList.Create;
  OperateString.CommaText := dxBarEdit1.Text;
  AviBasePath := OperateString[0];
  BmpBasePath := OperateString[1];
  ShellExecute(Handle, 'open', 'Explorer.exe', PChar(ExtractFilePath(AviBasePath)), nil, SW_NORMAL);
  ShellExecute(Handle, 'open', 'Explorer.exe', PChar(ExtractFilePath(BmpBasePath)), nil, SW_NORMAL);
  OperateString.Destroy;
end;

procedure TForm1.dxBarButton2Click(Sender: TObject);
begin
  dxCameraControl1.Play;
  if dxCameraControl1.State = ccsNoDevice then
  begin
    ShowMessage('无摄像头！');
  end
  else
  begin
    Timer1.Enabled := True;
    Timer3.Enabled := False;
  //dxBarButton2.ImageIndex:=3;
    if CamSafeFlag then
    begin
      dxBarButton3.Enabled := True;
      dxBarButton5.Enabled := True;
      dxBarButton6.Enabled := True;
      dxBarButton7.Enabled := True;
    //dxBarButton8.Enabled := True;
      dxBarButton9.Enabled := True;
      dxBarButton10.Enabled := True;
    end;
    CamSafeFlag := not CamSafeFlag;
    dxBarButton2.Enabled := False;
  end;

end;

procedure TForm1.dxBarButton3Click(Sender: TObject);
begin
  Timer3.Enabled := True;
  dxCameraControl1.Stop;
  Timer2.Enabled := True;
  if not CamSafeFlag then
  begin
    dxBarButton2.Enabled := True;
    dxBarButton5.Enabled := false;
    dxBarButton6.Enabled := false;
    dxBarButton7.Enabled := false;
    dxBarButton8.Enabled := false;
    dxBarButton9.Enabled := false;
    dxBarButton10.Enabled := false;
  end;
  CamSafeFlag := not CamSafeFlag;
  dxBarButton3.Enabled := False;
end;

procedure TForm1.dxBarButton5Click(Sender: TObject);
begin
  dxCameraControl1.Play;
  dxBarButton7.Enabled := true;
  dxBarButton9.Enabled := true;
end;

procedure TForm1.dxBarButton6Click(Sender: TObject);
begin
  dxCameraControl1.Pause;
  //暂停时，截图录像功能不可以完成
  dxBarButton7.Enabled := False;
  dxBarButton8.Enabled := False;
  dxBarButton9.Enabled := False;
end;

procedure TForm1.dxBarButton7Click(Sender: TObject);
var
  OperateString: TStringList;
  BasePath: string;
  FinalPath: string;
begin
  OperateString := TStringList.Create;
  OperateString.CommaText := dxBarEdit1.Text;
  BasePath := OperateString[0];
  OperateString.Destroy;
  FinalPath := OpreateFileName(BasePath);
  dxCameraManager.StartRecording(dxCameraControl1.DeviceIndex, FinalPath);
  dxBarButton3.Enabled := False;
  dxBarButton6.Enabled := False;
  dxBarButton5.Enabled := False;
  dxBarButton7.Enabled := False;
  dxBarButton8.Enabled := True;
  // 计时设置
  StartRec := GetTickCount;
  Timer5.Enabled := True;
end;

procedure TForm1.dxBarButton8Click(Sender: TObject);
begin
  Timer5.Enabled := False;  // 先取消计时,后停，这样 部分处理 时间不会 被看见家计时了
  StartRec := 0;
  dxCameraManager.StopRecording(dxCameraControl1.DeviceIndex);
  dxBarButton7.Enabled := True;
  dxBarButton3.Enabled := True;
  dxBarButton6.Enabled := True;
  dxBarButton5.Enabled := True;
  dxBarButton9.Enabled := True;
  dxBarButton8.Enabled := False;
  //StopRec:=GetTickCount;
end;

procedure TForm1.dxBarButton9Click(Sender: TObject);
var
  OperateString: TStringList;
  BasePath: string;
  FinalPath: string;
begin
  OperateString := TStringList.Create;
  OperateString.CommaText := dxBarEdit1.Text;
  BasePath := OperateString[1];
  OperateString.Destroy;
  FinalPath := OpreateFileName(BasePath);
  //FinalPath:=DateToStr(now)+' '+TimeToStr(Now)+' '+BasePath; //封装的不合路径要求
  //处理时间信息
  {Present := Now;
  DecodeDate(Present, Year, Month, Day);  //获取  日期的 每个元素
  DecodeTime(Present, Hour, Min, Sec, MSec);   // 获取 时间  的 每个 元素
  TimeString := Format('%d-%d-%d %d&%d&%d&%d', [Year, Month, Day, Hour, Min, Sec, MSec]);
  // finalpath
  FinalPath := ExtractFilePath(BasePath) + TimeString + ' ' + ExtractFileName(BasePath); }
  Timer4.Enabled := True;
  dxCameraControl1.Capture;
  cxImage2.Picture.Assign(dxCameraControl1.CapturedBitmap);
  // 发散 多种储存方式
  cxImage2.Picture.SaveToFile(FinalPath);
  cxImage2.Visible := True;
  Delay(2000);  //悬停时间
  cxImage2.Visible := False;
  Timer4.Enabled := False;

end;

function OpreateFileName(OldPath: string): string;
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  TimeString: string;
begin
  Present := Now;
  DecodeDate(Present, Year, Month, Day);  //获取  日期的 每个元素
  DecodeTime(Present, Hour, Min, Sec, MSec);   // 获取 时间  的 每个 元素
  TimeString := Format('%d-%d-%d %d&%d&%d&%d', [Year, Month, Day, Hour, Min, Sec, MSec]);
  Result := ExtractFilePath(OldPath) + TimeString + ' ' + ExtractFileName(OldPath);
end;

procedure TForm1.dxBarEdit1Click(Sender: TObject);
begin
  //dxBarEdit1.Enabled:=True;   //enable时不响应
 // dxBarEdit1.ReadOnly:=False;    // 不能响应
end;

procedure TForm1.buttBeforeMerge(Sender, ChildBarManager: TdxBarManager; AddItems: Boolean);
begin
  ShowMessage('sdsdsd');
end;

procedure TForm1.dxCameraControl1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(Self.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  LTep: TGUID;
  sGUID: string;
begin
  CreateGUID(LTep);
  sGUID := GUIDToString(LTep);
  RootPath := ExtractFileDir(ParamStr(0));
  Myini := TIniFile.Create(RootPath + '\Data\ini\BrightCam.ini');
  Section := 'AboutPath';
  dxBarEdit1.Text := Myini.ReadString(Section, 'OutputPath', RootPath + '\OutPut\video\' + sGUID + '.avi,' + RootPath + '\OutPut\image\' + sGUID + 'x.bmp');
  ExtendFlag := true;
  Timer1.Enabled := False;
  TopMostFlag := False;
  cxImage2.Left := dxCameraControl1.Left;
  cxImage2.Top := dxCameraControl1.Top + dxCameraControl1.Height - cximage2.height;
  LTep.Empty;
  sGUID := '';
  CamSafeFlag := True;
  //dxCameraControl1.Canvas.TextOut(30, 20, 'Test');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  dxCameraControl1.Stop;
  Myini.WriteString(Section, 'OutputPath', dxBarEdit1.Text);
  Myini.Destroy;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then   // enter     弹出面板
  begin
    dxBarManager1Bar1.Visible := True;
  end;
  if Key = 8 then    //backspace    关闭面板
  begin
    dxBarManager1Bar1.Visible := False;
  end;
  if (ssCtrl in Shift) and (Key = 49) and (dxBarButton2.Enabled = True) then    //开启摄像头 Ctrl+1
  begin
    dxBarButton2.Click;
  end;
  if (ssCtrl in Shift) and (Key = 50) and (dxBarButton3.Enabled = true) then    //关闭摄像头 Ctrl+12
  begin
    dxBarButton3.Click;
  end;
  if (ssCtrl in Shift) and (Key = 51) and (dxBarButton6.Enabled = true) then    //暂停摄像头 F3
  begin
    dxBarButton6.Click;
  end;
  if (ssCtrl in Shift) and (Key = 52) and (dxBarButton5.Enabled = true) then    //继续摄像头 F4
  begin
    dxBarButton5.Click;
  end;
  if (ssCtrl in Shift) and (Key = 53) and (dxBarButton9.Enabled = true) then    //截图 F5
  begin
    if ssAlt in Shift then
    begin
      dxBarButton14.Click;
      dxBarButton9.Click;
    end
    else
    begin
      dxBarButton9.Click;
    end;
  end;
  if (ssCtrl in Shift) and (Key = 54) and (dxBarButton7.Enabled = true) then   //开始录制  F6
  begin
    if ssAlt in Shift then
    begin
      dxBarButton14.Click;
      dxBarButton7.Click;
    end
    else
    begin
      dxBarButton7.Click;
    end;
  end;
  if (ssCtrl in Shift) and (Key = 55) and (dxBarButton8.Enabled = true) then     //停止录制  F7
  begin
    dxBarButton8.Click;
  end;
  if (ssCtrl in Shift) and (Key = 56) and (dxBarButton10.Enabled = true) then    //最佳分辨律  F8
  begin
    dxBarButton10.Click;
  end;
  if (ssCtrl in Shift) and (Key = 57) and (dxBarButton11.Enabled = true) then    //置顶
  begin
    dxBarButton11.Click;
  end;
  if (ssCtrl in Shift) and (Key = 48) and (dxBarButton13.Enabled = true) then    //设置       ctrl+0
  begin
    dxBarButton13.Click;
  end;
  if (ssCtrl in Shift) and (Key = 189) and (dxBarButton14.Enabled = true) and (dxBarButton14.Visible = ivAlways) then   //路径    ctrl+-
  begin
    dxBarButton14.Click;
  end;
  if (ssCtrl in Shift) and (Key = 187) and (dxBarButton16.Enabled = true) then   //打开路径 ctrl+=
  begin
    dxBarButton16.Click;
  end;
  if (ssAlt in Shift) and (ssCtrl in Shift) and (Key = 8) and (dxBarButton12.Enabled = true) then  //关闭  ctrl+alt+backspace
  begin
    dxBarButton12.Click;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if dxCameraControl1.State = ccsRunning then
  begin
    cxImage1.Picture.LoadFromFile(rootpath + '\Data\images\jpg\logo.jpg');
    cxImage1.Visible := False;
    Timer1.Enabled := False;
  end;
  if dxCameraControl1.State = ccsInitializing then
  begin
    cxImage1.Picture.LoadFromFile(rootpath + '\Data\images\gif\logo.gif');
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if dxCameraControl1.State = ccsRunning then
  begin
    //cxImage1.Picture.LoadFromFile('J:\Codes\Delphi-code\dxbar+dxcamera\images\482w\资源 124.png');
  end;
  if dxCameraControl1.State = ccsInitializing then
  begin
    cxImage1.Visible := True;
    Timer2.Enabled := False;
    cxImage1.Picture.LoadFromFile(rootpath + '\Data\images\gif\logo.gif');
  end;
  if dxCameraControl1.State = ccsInactive then
  begin
    cxImage1.Visible := True;
    Timer2.Enabled := False;
    cxImage1.Picture.LoadFromFile(rootpath + '\Data\images\jpg\logo.jpg');
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  cxImage1.Width := dxCameraControl1.Width;
  cxImage1.height := dxCameraControl1.Height;
  cxImage1.Left := dxCameraControl1.Left;
  cxImage1.top := dxCameraControl1.top;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
  cxImage2.Left := dxCameraControl1.Left;
  cxImage2.Top := dxCameraControl1.Top + dxCameraControl1.Height - cximage2.height;
end;

procedure TForm1.Timer5Timer(Sender: TObject);   // 录像提示信息（canvas 画图）
var
  D: Integer;
  Str: string;
  X: Integer;
  Y: Integer;
  Dit: Integer;
  RecTime: DWORD;
begin
  RecTime := GetTickCount - StartRec;
  Str := 'REC ' + MSecToHMSmS(RecTime, 0);
  X := 30;
  Y := 20;
  Dit := 2;
  with dxCameraControl1.Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := clRed;
    Font.Color := clRed;
    TextOut(X, Y, Str);
  end;
  D := dxCameraControl1.Canvas.TextHeight(Str);
  dxCameraControl1.Canvas.Ellipse(X - D - Dit + 2, Y + 2, X - Dit - 2, Y + D - 2);
end;

end.

