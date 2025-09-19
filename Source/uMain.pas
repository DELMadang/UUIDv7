unit uMain;

interface

uses
  System.SysUtils,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  FBC.UUIDv7;

type
  TfrmMain = class(TForm)
    eUUID: TEdit;
    btnGenerate: TButton;
    procedure btnGenerateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnGenerateClick(Sender: TObject);
begin
  eUUID.Text := TUUIDv7.GenerateAsString;
end;

end.
