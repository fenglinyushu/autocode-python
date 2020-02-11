unit About;

interface

uses
     //
     SysVars,

     //
     Windows, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ExtCtrls, jpeg,ShellAPI,  CheckLst;

type
  TForm_About = class(TForm)
    Label_Name: TLabel;
    Label_Ver: TLabel;
    Bevel1: TBevel;
    OKButton: TButton;
    Label3: TLabel;
    Label_Website: TLabel;
    Label5: TLabel;
    Label_Mail: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure Label_WebsiteClick(Sender: TObject);
    procedure Label_MailClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_About: TForm_About;

implementation

Uses
     Main;

{$R *.DFM}

procedure TForm_About.OKButtonClick(Sender: TObject);
begin
     Close;
end;

procedure TForm_About.Label_WebsiteClick(Sender: TObject);
begin
     ShellExecute(Handle,'open',PChar(gsHomePage),'','',SW_SHOWDEFAULT);
end;

procedure TForm_About.Label_MailClick(Sender: TObject);
begin
     ShellExecute(Handle,'open',PChar('mailto:'+gsMail),'','',SW_SHOWDEFAULT);
end;

procedure TForm_About.FormShow(Sender: TObject);
begin

     //
     Label_Website.Caption    := gsWebSite;
     Label_Mail.Caption       := gsMail;
end;

end.

