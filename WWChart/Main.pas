unit Main;

interface

uses
     //
     WWChart,

     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
var
     rChart    : TWWChart;
begin
     rChart    := TWWChart.Create(self);
     rChart.Parent  := Self;
     rChart.Align   := alClient;
     
     //rChart.ChartMode    := cmNSChart;
     //
     rChart.LoadFromFile('c:\fc.xml');

     

end;

end.
