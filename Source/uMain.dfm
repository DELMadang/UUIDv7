object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'UUIDv7 Test'
  ClientHeight = 113
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object eUUID: TEdit
    Left = 18
    Top = 32
    Width = 529
    Height = 23
    TabOrder = 0
  end
  object btnGenerate: TButton
    Left = 472
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Generate'
    TabOrder = 1
    OnClick = btnGenerateClick
  end
end
