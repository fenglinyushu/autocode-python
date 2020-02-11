program Demo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  WWChart in 'WWChart.pas',
  XMLFlowChartUnit in 'XMLFlowChartUnit.pas',
  XMLNSChartUnit in 'XMLNSChartUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
