program MoveAndResize;

uses
  Forms,
  Tkinter in 'Tkinter.pas' {Form_Tkinter},
  tkUnit in 'tkUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_Tkinter, Form_Tkinter);
  Application.Run;
end.
