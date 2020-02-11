object Form_CodeShow: TForm_CodeShow
  Left = 328
  Top = 212
  Width = 696
  Height = 480
  Caption = 'Form_CodeShow'
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
  object SynEdit: TSynEdit
    Left = 0
    Top = 29
    Width = 688
    Height = 417
    Cursor = crIBeam
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Terminal'
    Gutter.Font.Style = []
    Highlighter = SynPasSyn
    Lines.Strings = (
      'SynEdit')
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 688
    Height = 29
    Caption = 'ToolBar1'
    Images = MainForm.ImageList_ToolBar
    Indent = 10
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 10
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 34
    end
  end
  object SynCppSyn: TSynCppSyn
    DefaultFilter = 'C++ Files (*.c,*.cpp,*.h,*.hpp)|*.c;*.cpp;*.h;*.hpp'
    Left = 144
    Top = 104
  end
  object SynPasSyn: TSynPasSyn
    Left = 144
    Top = 216
  end
  object SynPHPSyn: TSynPHPSyn
    DefaultFilter = 
      'PHP Files (*.php,*.php3,*.phtml,*.inc)|*.php;*.php3;*.phtml;*.in' +
      'c'
    Left = 144
    Top = 160
  end
  object SynJavaSyn: TSynJavaSyn
    DefaultFilter = 'Java Files (*.java)|*.java'
    Left = 144
    Top = 48
  end
  object SynVBSyn: TSynVBSyn
    DefaultFilter = 'Visual Basic Files (*.bas)|*.bas'
    Left = 144
    Top = 272
  end
  object SynJScriptSyn: TSynJScriptSyn
    DefaultFilter = 'Javascript Files (*.js)|*.js'
    Left = 144
    Top = 328
  end
  object SynPerlSyn: TSynPerlSyn
    DefaultFilter = 'Perl Files (*.pl,*.pm,*.cgi)|*.pl;*.pm;*.cgi'
    Left = 232
    Top = 48
  end
end
