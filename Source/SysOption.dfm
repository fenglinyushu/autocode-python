object Form_Options: TForm_Options
  Left = 295
  Top = 140
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 8
  Caption = 'Options'
  ClientHeight = 471
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 582
    Height = 430
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Options'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 574
        Height = 400
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object Label30: TLabel
          Left = 8
          Top = 18
          Width = 120
          Height = 15
          AutoSize = False
          Caption = 'Base Width :'
        end
        object Label31: TLabel
          Left = 8
          Top = 42
          Width = 120
          Height = 15
          AutoSize = False
          Caption = 'Base Height :'
        end
        object Label32: TLabel
          Left = 8
          Top = 66
          Width = 120
          Height = 15
          AutoSize = False
          Caption = 'Horizontal Spacing :'
        end
        object Label33: TLabel
          Left = 8
          Top = 90
          Width = 120
          Height = 15
          AutoSize = False
          Caption = 'Vertical Spacing :'
        end
        object Label36: TLabel
          Left = 8
          Top = 162
          Width = 49
          Height = 15
          Caption = 'IF Color :'
        end
        object Label34: TLabel
          Left = 8
          Top = 138
          Width = 63
          Height = 15
          Caption = 'Line Color :'
        end
        object Label38: TLabel
          Left = 8
          Top = 186
          Width = 87
          Height = 15
          Caption = 'Selected Color :'
        end
        object Label1: TLabel
          Left = 8
          Top = 258
          Width = 63
          Height = 15
          Caption = 'Font Color :'
        end
        object Label2: TLabel
          Left = 8
          Top = 282
          Width = 73
          Height = 15
          AutoSize = False
          Caption = 'Font Size :'
        end
        object Bevel1: TBevel
          Left = 7
          Top = 124
          Width = 216
          Height = 8
          Shape = bsTopLine
        end
        object Bevel2: TBevel
          Left = 7
          Top = 216
          Width = 216
          Height = 8
          Shape = bsTopLine
        end
        object Label3: TLabel
          Left = 8
          Top = 234
          Width = 73
          Height = 15
          AutoSize = False
          Caption = 'Font Name :'
        end
        object Bevel3: TBevel
          Left = 7
          Top = 312
          Width = 216
          Height = 8
          Shape = bsTopLine
        end
        object Label4: TLabel
          Left = 8
          Top = 323
          Width = 120
          Height = 15
          AutoSize = False
          Caption = 'Indent'
        end
        object Panel_Demo: TPanel
          Left = 240
          Top = 1
          Width = 333
          Height = 398
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object PageControl2: TPageControl
            Left = 0
            Top = 0
            Width = 333
            Height = 398
            ActivePage = TabSheet2
            Align = alClient
            TabOrder = 0
            object TabSheet2: TTabSheet
              Caption = 'Flow Chart'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object Image: TImage
                Left = 0
                Top = 0
                Width = 325
                Height = 368
                Align = alClient
              end
            end
          end
        end
        object CheckBox_AddCaption: TCheckBox
          Left = 8
          Top = 348
          Width = 201
          Height = 17
          Caption = 'Generate with Node Caption'
          TabOrder = 1
        end
        object CheckBox_AddComment: TCheckBox
          Left = 8
          Top = 372
          Width = 201
          Height = 17
          Caption = 'Generate with Node Comment'
          TabOrder = 2
        end
      end
    end
  end
  object Panel_Bottom: TPanel
    Left = 0
    Top = 430
    Width = 582
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel_BottomRight: TPanel
      Left = 340
      Top = 0
      Width = 242
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button_OK: TButton
        Left = 64
        Top = 8
        Width = 75
        Height = 25
        Caption = '&OK'
        TabOrder = 0
        OnClick = Button_OKClick
      end
      object Button_Cancel: TButton
        Left = 144
        Top = 8
        Width = 75
        Height = 25
        Caption = '&Cancel'
        TabOrder = 1
        OnClick = Button_CancelClick
      end
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Default'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
