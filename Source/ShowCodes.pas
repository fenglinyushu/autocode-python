unit ShowCodes;

interface

uses
     Main,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, SynEdit, SynHighlighterPerl,
  SynHighlighterJScript, SynHighlighterVB, SynHighlighterJava,
  SynHighlighterPHP, SynHighlighterPas, SynEditHighlighter,
  SynHighlighterCpp;

type
  TForm_CodeShow = class(TForm)
    SynEdit: TSynEdit;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    SynCppSyn: TSynCppSyn;
    SynPasSyn: TSynPasSyn;
    SynPHPSyn: TSynPHPSyn;
    SynJavaSyn: TSynJavaSyn;
    SynVBSyn: TSynVBSyn;
    SynJScriptSyn: TSynJScriptSyn;
    SynPerlSyn: TSynPerlSyn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CodeShow: TForm_CodeShow;

implementation



{$R *.dfm}

end.
