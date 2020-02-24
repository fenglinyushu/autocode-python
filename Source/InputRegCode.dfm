object Form_InputRegCode: TForm_InputRegCode
  Left = 473
  Top = 234
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Register'
  ClientHeight = 230
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 14
    Top = 76
    Width = 36
    Height = 15
    AutoSize = False
    Caption = 'Name'
  end
  object Label3: TLabel
    Left = 16
    Top = 8
    Width = 343
    Height = 45
    Caption = 
      '      Thank you for using Flowchart To Code. Please purchase a l' +
      'icense for life-time use! After registering, this reminded secti' +
      'on will disappear.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 14
    Top = 124
    Width = 67
    Height = 19
    AutoSize = False
    Caption = 'RegCode'
  end
  object Edit_RegName: TEdit
    Left = 8
    Top = 96
    Width = 369
    Height = 23
    ImeName = #26497#21697#20116#31508#36755#20837#27861'5.0'
    TabOrder = 0
    OnChange = Edit_RegNameChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 189
    Width = 394
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 152
      Top = 0
      Width = 242
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button_OK: TButton
        Left = 152
        Top = 8
        Width = 75
        Height = 25
        Caption = '&OK'
        Enabled = False
        TabOrder = 0
        OnClick = Button_OKClick
      end
    end
    object Button_OrderNow: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Order Now!'
      TabOrder = 1
    end
  end
  object Memo_RegCode: TMemo
    Left = 8
    Top = 144
    Width = 369
    Height = 33
    ImeName = #26497#21697#20116#31508#36755#20837#27861'5.0'
    TabOrder = 2
    OnChange = Edit_RegNameChange
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 160
    Top = 56
  end
end
