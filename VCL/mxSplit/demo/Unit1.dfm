object Form1: TForm1
  Left = 233
  Top = 123
  Width = 725
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mxClickSplitter1: TmxClickSplitter
    Left = 0
    Top = 113
    Width = 709
    Height = 6
    Cursor = crVSplit
    Align = alTop
    Version = 'Version 1.0'
  end
  object mxClickSplitter2: TmxClickSplitter
    Left = 185
    Top = 119
    Width = 6
    Height = 342
    Cursor = crHSplit
    Version = 'Version 1.0'
  end
  object Panel1: TPanel
    Left = 0
    Top = 119
    Width = 185
    Height = 342
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel_Left'
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 191
    Top = 119
    Width = 518
    Height = 342
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel_Client'
    Color = clMedGray
    ParentBackground = False
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 709
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel_Top'
    Color = clYellow
    ParentBackground = False
    TabOrder = 2
  end
end
