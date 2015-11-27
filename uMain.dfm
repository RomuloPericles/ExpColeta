object Form1: TForm1
  Left = 192
  Top = 125
  Caption = 'Form1'
  ClientHeight = 524
  ClientWidth = 963
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TSpeedButton
    Left = 160
    Top = 280
    Width = 23
    Height = 25
    OnClick = btn1Click
  end
  object OpenDialog1: TOpenDialog
    Left = 312
    Top = 88
  end
end
