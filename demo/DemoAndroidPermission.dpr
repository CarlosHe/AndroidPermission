program DemoAndroidPermission;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
