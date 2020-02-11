unit NodeSearch;

interface

uses
     SysRecords,
     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm_Search = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button_OK: TButton;
    Button_Cancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox_Mode: TComboBox;
    gbSearchOptions: TGroupBox;
    CheckBox_CaseSensitive: TCheckBox;
    CheckBox_WholeWords: TCheckBox;
    CheckBox_CaptionOnly: TCheckBox;
    CheckBox_RegularExpression: TCheckBox;
    RadioGroup_Direction: TRadioGroup;
    ComboBox_Keyword: TComboBox;
    RadioGroup_Scope: TRadioGroup;
    procedure Button_OKClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
     SearchOption   : TSearchOption;
  end;

var
  Form_Search: TForm_Search;

implementation

{$R *.dfm}

procedure TForm_Search.Button_OKClick(Sender: TObject);
begin
     SearchOption.AtOnce      := True;
     SearchOption.Keyword     := ComboBox_Keyword.Text;
     SearchOption.Mode        := ComboBox_Mode.ItemIndex;
     SearchOption.ForwardDirection := RadioGroup_Direction.ItemIndex=0;
     SearchOption.FromCursor       := RadioGroup_Scope.ItemIndex=0;
     SearchOption.CaseSensitivity  := CheckBox_CaseSensitive.Checked;
     SearchOption.WholeWord        := CheckBox_WholeWords.Checked;
     SearchOption.CaptionOnly      := CheckBox_CaptionOnly.Checked;
     SearchOption.RegularExpression:= CheckBox_RegularExpression.Checked;
     SearchOption.FindInFiles      := PageControl1.ActivePageIndex=1;
     Close;

end;

procedure TForm_Search.Button_CancelClick(Sender: TObject);
begin
     SearchOption.AtOnce      := False;
     Close;
end;

end.
