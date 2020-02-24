unit InputRegCode;

interface

uses
     SysVars,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ShellAPI;

type
  TForm_InputRegCode = class(TForm)
    Label1: TLabel;
    Edit_RegName: TEdit;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;          
    Button_OK: TButton;
    Memo_RegCode: TMemo;
    Button_OrderNow: TButton;
    Label3: TLabel;
    Timer: TTimer;
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_OrderNowClick(Sender: TObject);
    procedure Edit_RegNameChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
  private
     iLast     : Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_InputRegCode: TForm_InputRegCode;

implementation

uses
     Main;

{$R *.dfm}

procedure TForm_InputRegCode.Button_CancelClick(Sender: TObject);
begin
     Close;
end;

procedure TForm_InputRegCode.Button_OKClick(Sender: TObject);
begin
     Close;
end;

procedure TForm_InputRegCode.Button_OrderNowClick(Sender: TObject);
begin
     ShellExecute(Handle,'open',Pchar(gsOrderPage),'','',SW_SHOWDEFAULT);
end;

procedure TForm_InputRegCode.Edit_RegNameChange(Sender: TObject);
begin
     Button_OK.Enabled   := (Trim(Edit_RegName.Text)<>'')and(Trim(Memo_RegCode.Text)<>'');
     Timer.Enabled  := False;
     Button_OK.Caption   := '&OK';
end;

procedure TForm_InputRegCode.FormShow(Sender: TObject);
begin
     iLast     := 8;
     Timer.Interval := 1000;
     Timer.Enabled  := True;
end;

procedure TForm_InputRegCode.TimerTimer(Sender: TObject);
begin
     Button_OK.Caption   := '&OK   '+IntToStr(iLast);
     Dec(iLast);
     if iLast=-1 then begin
          Tag  := 1;
          Close;
     end;
end;

end.
