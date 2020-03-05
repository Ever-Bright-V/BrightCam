program BrightCam;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MSec2Time in 'MSec2Time.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
