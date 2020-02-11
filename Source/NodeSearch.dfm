object Form_Search: TForm_Search
  Left = 379
  Top = 175
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  BorderWidth = 8
  ClientHeight = 292
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 251
    Width = 346
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 104
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
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 346
    Height = 251
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Find '
    end
    object TabSheet2: TTabSheet
      Caption = 'Find in Files'
      ImageIndex = 1
    end
  end
  object Panel3: TPanel
    Left = 2
    Top = 23
    Width = 341
    Height = 224
    BevelOuter = bvNone
    Color = 16579836
    ParentBackground = False
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 43
      Width = 27
      Height = 13
      Caption = 'Mode'
    end
    object Label2: TLabel
      Left = 8
      Top = 12
      Width = 52
      Height = 13
      Caption = '&Search for:'
    end
    object ComboBox_Mode: TComboBox
      Left = 72
      Top = 40
      Width = 257
      Height = 21
      AutoComplete = False
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'All          '
      Items.Strings = (
        'All          '
        'Set          '
        'CircleSet    '
        'IF           '
        'Yes          '
        'NO           '
        'Code         '
        'For          '
        'Case         '
        'CaseItem     '
        'CaseDefault  '
        'While        '
        'Repeat       '
        'Try          '
        'Except       '
        'Finally      '
        'TryBody      '
        'break        '
        'continue     '
        'Exit         '
        'File         '
        'Function     ')
    end
    object gbSearchOptions: TGroupBox
      Left = 8
      Top = 72
      Width = 154
      Height = 137
      Caption = 'Options'
      TabOrder = 1
      object CheckBox_CaseSensitive: TCheckBox
        Left = 8
        Top = 17
        Width = 140
        Height = 17
        Caption = 'C&ase sensitivity'
        TabOrder = 0
      end
      object CheckBox_WholeWords: TCheckBox
        Left = 8
        Top = 39
        Width = 140
        Height = 17
        Caption = '&Whole words only'
        TabOrder = 1
      end
      object CheckBox_CaptionOnly: TCheckBox
        Left = 8
        Top = 61
        Width = 140
        Height = 17
        Caption = 'Caption only'
        TabOrder = 2
      end
      object CheckBox_RegularExpression: TCheckBox
        Left = 8
        Top = 80
        Width = 140
        Height = 17
        Caption = '&Regular expression'
        TabOrder = 3
      end
    end
    object RadioGroup_Direction: TRadioGroup
      Left = 170
      Top = 72
      Width = 154
      Height = 65
      Caption = 'Direction'
      ItemIndex = 0
      Items.Strings = (
        '&Forward'
        '&Backward')
      TabOrder = 2
    end
    object ComboBox_Keyword: TComboBox
      Left = 72
      Top = 8
      Width = 257
      Height = 21
      AutoComplete = False
      ItemHeight = 13
      TabOrder = 3
    end
    object RadioGroup_Scope: TRadioGroup
      Left = 170
      Top = 144
      Width = 154
      Height = 65
      Caption = 'Scope'
      ItemIndex = 0
      Items.Strings = (
        '&From cursor'
        '&Entire scope')
      TabOrder = 4
    end
  end
end
