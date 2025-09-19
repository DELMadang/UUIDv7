program UUIDv7;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  FBC.UUIDv7 in 'FBC.UUIDv7.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
