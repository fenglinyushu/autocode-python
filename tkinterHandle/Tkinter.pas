unit Tkinter;

interface

uses
     //
     SysVars,

     //
     teUnit,
     tkUnit,

     //
     JsonDataObjects,
     Handles,
     FloatSpinEdit,

     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ComObj,
     Dialogs, ExtCtrls, StdCtrls, ComCtrls, ImgList, ToolWin, System.ImageList, Vcl.Buttons,
     Vcl.Samples.Spin, mxClickSplitter, dxGDIPlusClasses;

type
  TForm_Tkinter = class(TForm)
    FontDialog: TFontDialog;
    ImageList: TImageList;
    OpenDialog: TOpenDialog;
    Panel_Client: TPanel;
    Panel_Form: TPanel;
    Panel_FormTitle: TPanel;
    Label_Caption: TLabel;
    SpeedButton_FormClose: TSpeedButton;
    SpeedButton_Min: TSpeedButton;
    SpeedButton_Max: TSpeedButton;
    Panel_FormClient: TPanel;
    Panel_Right: TPanel;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton_Select: TToolButton;
    ToolButton_Label: TToolButton;
    ToolButton_Button: TToolButton;
    ToolButton_Checkbutton: TToolButton;
    ToolButton_Radiobutton: TToolButton;
    ToolButton_Entry: TToolButton;
    ToolButton_Listbox: TToolButton;
    ToolButton_Text: TToolButton;
    ToolButton_Scale: TToolButton;
    ToolButton1: TToolButton;
    ToolButton_Delete: TToolButton;
    ToolButton4: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    mxClickSplitter1: TmxClickSplitter;
    Image_Icon: TImage;
    Memo1: TMemo;
    StretchHandle: TStretchHandle;
    procedure Label_CaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Label_CaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ToolButton_DeleteClick(Sender: TObject);
    procedure ToolButton_CancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel_FormClientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;  X, Y: Integer);
    procedure ToolButton_SelectClick(Sender: TObject);
    procedure StretchHandleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure StretchHandleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
     PythonCode : string;
     gjoWindow : TJsonObject;
     procedure ControlMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
     procedure ShowComponentInfo(ACtrl:TControl);
     procedure SelectComponent(APanel:TPanel);
     procedure OnPropertyChange(Sender:TObject);
     procedure SetCompOnChange;
  end;

var
  Form_Tkinter: TForm_Tkinter;

function  CreateGUIDName:string;

implementation

{$R *.dfm}

procedure TForm_TKinter.SetCompOnChange;
var
     iCtrl     : Integer;
     oPanel    : TPanel;
     oControl  : TControl;
     sClass    : TClass;
begin
     for iCtrl := 0 to Panel_Right.ControlCount-1 do begin
          oPanel    := TPanel(Panel_Right.Controls[iCtrl]);
          oControl  := oPanel.Controls[1];
          //
          sClass    := oControl.ClassType;
          if (sClass = TEdit) or (sClass = TSpinEdit) or (sClass = TFloatSpinEdit) or (sClass = TMemo) or (sClass = TColorBox) then begin
               TEdit(oControl).OnChange := OnPropertyChange;
          end else  if (sClass = TCheckBox) then begin
               TCheckBox(oControl).OnClick := OnPropertyChange;
          end;
     end;
end;


function CreateGUIDName:string;
begin
     Result    := CreateClassID;
     Delete(Result,1,1);
     Delete(Result,Length(Result),1);
     Result    := 'A'+StringReplace(Result,'-','',[rfReplaceAll]);
end;


procedure TForm_TKinter.Button1Click(Sender: TObject);
var
     iItem     : Integer;
     joModule  : TJsonObject;
begin

end;

procedure TForm_TKinter.ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     iItem     : Integer;
begin
     //
     StretchHandle.Detach;
     StretchHandle.Attach(TControl(Sender));


     //
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          if gjoWindow.A['items'][iItem].S['guid'] = TControl(Sender).Name then begin
               teShowNodeProperty(gjoWindow.A['items'][iItem],Panel_Right);
               //
               SetCompOnChange;
               //
               Break;
          end;
     end;

end;


procedure TForm_TKinter.Label_CaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
     oControl  : TControl;
     oPanel         : TPanel;
begin

     ReleaseCapture;
     oControl  := TControl(Sender);
     if (x>0)and(x<oControl.Width-1) then begin
          if (y>0)and(y<oControl.Height-1) then oControl.Parent.Parent.Perform(WM_SysCommand,$F012,0);
     end;

end;

procedure TForm_TKinter.Label_CaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
     oControl  : TControl;
begin
     if Sender = Panel_FormClient then begin
          Exit;
     end;
     if Sender = Panel_FormTitle then begin
          Exit;
     end;

     oControl  := TControl(Sender);
     if (x>3)and(x<oControl.Width-3) then begin
          if (y>3)and(y<oControl.Height-3) then oControl.Parent.Parent.Cursor:=crArrow;
     end;
end;

procedure TForm_TKinter.OnPropertyChange(Sender: TObject);
var
     iItem     : Integer;
     iCtrl     : Integer;
     joNode    : TJsonObject;
     oControl  : TControl;
begin
     //找到相应的JSON
     joNode    := nil;
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          if gjoWindow.A['items'][iItem].S['guid'] = Panel_Right.Hint then begin
               joNode    :=  gjoWindow.A['items'][iItem];
               Break;
          end;
     end;
     if joNode = nil then begin
          Exit;
     end;


     //
     if Sender.ClassType = TSpeedButton then begin
          if FontDialog.Execute then begin
               TSpeedButton(Sender).Font     := FontDialog.Font;
          end;
     end;

     //
     teSaveNodeProperty(joNode,Panel_Right);

     //更新控件
     oControl  := nil;
     for iCtrl := 0 to Panel_FormClient.ControlCount-1 do begin
          if Panel_FormClient.Controls[iCtrl].Name = Panel_Right.Hint then begin
               oControl  := Panel_FormClient.Controls[iCtrl];
               Break;
          end;
     end;

     //
     tkUpdateComponent(oControl,joNode);

     //StretchHandle.Detach;
     //StretchHandle.Attach(oControl);
     Panel_FormClient.Repaint;

     Memo1.Lines.Text    := gjoWindow.ToJSON(False);
end;

procedure TForm_TKinter.Panel_FormClientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     joNode    : TJsonObject;
     //
     oLabel         : TLabel;
     oCheckbutton   : TCheckBox;
     oRadiobutton   : TRadioButton;
     oButton        : TButton;
     oEntry         : TEdit;
     oListBox       : TListBox;
     oText          : TMemo;
     oScale         : TProgressBar;

begin
     if ToolBar1.Hint <> 'select' then begin
          //添加JSON
          joNode    := teAddJsonModule(gjoWindow,-1,ToolBar1.Hint);      //ToolBar1.Hint保存为当前按下的TK类型
          joNode.I['left']    := X;
          joNode.I['top']     := Y;

          //
          joNode.S['guid']    := CreateGUIDName;

          //
          if joNode.S['name'] = 'tk_label' then begin
               //
               oLabel              := TLabel.Create(self);
               oLabel.Parent       := Panel_FormClient;
               oLabel.Name         := joNode.S['guid'];
               oLabel.AutoSize     := False;
               oLabel.Left         := joNode.I['left'];
               oLabel.Top          := joNode.I['top'];
               oLabel.Width        := joNode.I['width'];
               oLabel.Height       := joNode.I['height'];
               teJsonToFont(oLabel.Font,joNode.O['font']);
               oLabel.Color        := teArrayToColor(joNode.A['color']);
               oLabel.Caption      := joNode.S['caption'];
               //
               if joNode.S['anchor'] = 'e' then begin  //"e","w","n","s","ne","se","sw","sn","center"
                    oLabel.Alignment    := taRightJustify;
                    oLabel.Layout       := tlCenter;
               end else if joNode.S['anchor'] = 'ne' then begin
                    oLabel.Alignment    := taRightJustify;
                    oLabel.Layout       := tlTop;
               end else if joNode.S['anchor'] = 'se' then begin
                    oLabel.Alignment    := taRightJustify;
                    oLabel.Layout       := tlBottom;
               end else if joNode.S['anchor'] = 'w' then begin
                    oLabel.Alignment    := taLeftJustify;
                    oLabel.Layout       := tlCenter;
               end else if joNode.S['anchor'] = 'nw' then begin
                    oLabel.Alignment    := taLeftJustify;
                    oLabel.Layout       := tlTop;
               end else if joNode.S['anchor'] = 'sw' then begin
                    oLabel.Alignment    := taLeftJustify;
                    oLabel.Layout       := tlBottom;
               end else if joNode.S['anchor'] = 'center' then begin
                    oLabel.Alignment    := taCenter;
                    oLabel.Layout       := tlCenter;
               end;
               //
               oLabel.OnMouseDown  := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oLabel);

               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_button' then begin
               //
               oButton             := TButton.Create(self);
               oButton.Parent      := Panel_FormClient;
               oButton.Name        := joNode.S['guid'];
               oButton.Left        := joNode.I['left'];
               oButton.Top         := joNode.I['top'];
               oButton.Width       := joNode.I['width'];
               oButton.Height      := joNode.I['height'];
               oButton.Caption     := joNode.S['caption'];
               teJsonToFont(oButton.Font,joNode.O['font']);

               oButton.OnMouseDown := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oButton);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_check' then begin
               oCheckbutton             := TCheckBox.Create(Panel_FormClient);
               oCheckbutton.Parent      := Panel_FormClient;
               oCheckbutton.Caption     := joNode.S['caption'];
               oCheckbutton.Tag         := 1;
               //
               oCheckbutton.OnMouseDown := ControlMouseDown;

               //
               oCheckButton.Name         := joNode.S['guid'];
               oCheckButton.Left         := joNode.I['left'];
               oCheckButton.Top          := joNode.I['top'];
               oCheckButton.Width        := joNode.I['width'];
               oCheckButton.Height       := joNode.I['height'];
               teJsonToFont(oCheckButton.Font,joNode.O['font']);
               oCheckButton.Color        := teArrayToColor(joNode.A['color']);

               //
               oCheckButton.OnMouseDown  := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oCheckbutton);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_radio' then begin
               oRadiobutton             := TRadioButton.Create(Panel_FormClient);
               oRadiobutton.Parent      := Panel_FormClient;
               oRadiobutton.Caption     := joNode.S['caption'];
               oRadiobutton.Tag         := 1;

               //
               oRadioButton.Name         := joNode.S['guid'];
               oRadioButton.Left         := joNode.I['left'];
               oRadioButton.Top          := joNode.I['top'];
               oRadioButton.Width        := joNode.I['width'];
               oRadioButton.Height       := joNode.I['height'];
               teJsonToFont(oRadioButton.Font,joNode.O['font']);
               oRadioButton.Color        := teArrayToColor(joNode.A['color']);

               //
               oRadioButton.OnMouseDown  := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oRadiobutton);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_entry' then begin
               oEntry              := TEdit.Create(Panel_FormClient);
               oEntry.Parent       := Panel_FormClient;
               oEntry.Text         := joNode.S['caption'];
               oEntry.Tag          := 1;

               //
               oEntry.Name         := joNode.S['guid'];
               oEntry.Left         := joNode.I['left'];
               oEntry.Top          := joNode.I['top'];
               oEntry.Width        := joNode.I['width'];
               oEntry.Height       := joNode.I['height'];
               teJsonToFont(oEntry.Font,joNode.O['font']);

               //
               oEntry.OnMouseDown  := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oEntry);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_listbox' then begin
               oListBox         := TListBox.Create(Panel_FormClient);
               oListBox.Parent  := Panel_FormClient;
               oListBox.Items.Text := 'Python';
               oListBox.Items.Add('Delphi');
               oListBox.Items.Add('Java');
               oListBox.Items.Add('JavaScript');
               oListBox.Tag        := 1;

               //
               oListBox.Name         := joNode.S['guid'];
               oListBox.Left         := joNode.I['left'];
               oListBox.Top          := joNode.I['top'];
               oListBox.Width        := joNode.I['width'];
               oListBox.Height       := joNode.I['height'];
               teJsonToFont(oListBox.Font,joNode.O['font']);

               //
               oListBox.OnMouseDown  := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oListBox);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_text' then begin
               oText               := TMemo.Create(Panel_FormClient);
               oText.Parent        := Panel_FormClient;
               oText.Text          := joNode.S['caption'];
               oText.Tag           := 1;

               //
               oText.Name         := joNode.S['guid'];
               oText.Left         := joNode.I['left'];
               oText.Top          := joNode.I['top'];
               oText.Width        := joNode.I['width'];
               oText.Height       := joNode.I['height'];
               teJsonToFont(oText.Font,joNode.O['font']);

               //
               oText.OnMouseDown  := ControlMouseDown;

               //
               StretchHandle.Detach;
               StretchHandle.Attach(oText);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end else if joNode.S['name'] = 'tk_scale' then begin
               oScale              := TProgressBar.Create(Panel_FormClient);
               oScale.Parent       := Panel_FormClient;
               oScale.Position     := 30;
               oScale.Tag          := 1;

               //
               oScale.Name         := joNode.S['guid'];
               oScale.Left         := joNode.I['left'];
               oScale.Top          := joNode.I['top'];
               oScale.Width        := joNode.I['width'];
               oScale.Height       := joNode.I['height'];

               //
               oScale.OnMouseDown  := ControlMouseDown;
 
               //
               StretchHandle.Detach;
               StretchHandle.Attach(oScale);
               //
               teShowNodeProperty(joNode,Panel_Right);
               //
               SetCompOnChange;
          end;


          //
          ToolButton_Select.Down   := True;
          ToolBar1.Hint  := 'select';

     end;
end;



procedure TForm_TKinter.FormCreate(Sender: TObject);
begin
     gjoWindow := TJsonObject.Create;
     //
     gjoWindow.S['name']      := 'tk_window';
     gjoWindow.S['caption']   := 'tkinter window';
     gjoWindow.I['left']      := 100;
     gjoWindow.I['top']       := 100;
     gjoWindow.I['width']     := 500;
     gjoWindow.I['height']    := 300;
     gjoWindow.A['color'].FromUtf8JSON('[240,240,240]');
     //
     gjoWindow.S['guid']      := CreateGUIDName;
     //
     gjoWindow.A['items']     := TJsonArray.Create;


     //
     if gjoModules = nil then begin
          gjoModules     := TJsonObject.Create;
          gjoModules.LoadFromFile('modules.json');
     end;
end;




procedure TForm_TKinter.FormShow(Sender: TObject);
var
     iTab      : Integer;
     iItem     : Integer;
     joItem    : TJsonObject;

begin

     //
     with Panel_Form do begin
          Left      := gjoWindow.I['left'];
          Top       := gjoWindow.I['top'];
          Width     := gjoWindow.I['width'];
          Height    := gjoWindow.I['height']+38;
          //
          Label_Caption.Caption    := gjoWindow.S['caption'];
          Panel_FormClient.Color   := teArrayToColor(gjoWindow.A['color']);
     end;

     //
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          joItem    := gjoWindow.A['items'][iItem];

     end;

     //默认选择窗体
     Label_Caption.OnMouseDown(Label_Caption,mbLeft, [], 10, 10);
end;

procedure TForm_TKinter.SelectComponent(APanel: TPanel);
var
     iCtrl     : Integer;
     oPanel    : TPanel;
begin
     //Exit;
     //
     for iCtrl := 0 to Panel_FormClient.ControlCount-1 do begin
          oPanel    := TPanel(Panel_FormClient.Controls[iCtrl]);
          if oPanel <> APanel then begin
               oPanel.Color        := clBtnFace;
          end;
     end;
     APanel.Color   := clMedGray;
end;

procedure TForm_TKinter.ShowComponentInfo(ACtrl: TControl);
var
     oPanel         : TPanel;
     //
     oLabel         : TPanel;
     oCheckbutton   : TCheckBox;
     oRadiobutton   : TRadioButton;
     oButton        : TButton;
     oEntry         : TEdit;
     oListBox       : TListBox;
     oText          : TMemo;
     oScale         : TProgressBar;

     //
     joNode         : TJsonObject;
     joModule       : TJsonObject;
begin
     //
     if ACtrl = nil then begin
          Exit;
     end;

     if (ACtrl = Panel_Form)or(ACtrl = Panel_FormClient)or(ACtrl = Label_Caption) then begin
          //显示gjoWindow的属性
          teShowNodeProperty(gjoWindow,Panel_Right);
          //
          SetCompOnChange;
         //
          Panel_Right.Tag   := -999;
     end else begin
          //
          if ACtrl.Tag < 0 then begin
               oPanel    := TPanel(ACtrl);
          end else begin
               oPanel    := TPanel(ACtrl.Parent);
          end;
          //
          if oPanel = Panel_Client then Exit;



          if oPanel.Tag < 0 then begin
               //得到当前控件对应的JSON
               joNode    := gjoWindow.A['items'][-oPanel.Tag-1];

               //
               teShowNodeProperty(joNode,Panel_Right);
               Panel_Right.Tag   := oPanel.Tag;
               //
               SetCompOnChange;

               //
               SelectComponent(oPanel);
          end;
     end;
end;

procedure TForm_Tkinter.StretchHandleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
     iItem     : Integer;
     joNode    : TJsonObject;
     oControl  : TControl;
begin
     //
     oControl  := TStretchHandle(Sender).Children[0];
     Caption   := Format('shmm L= %d ,T=%d, W=%d, H=%d',[oControl.Left,oControl.Top,oControl.Width,oControl.Height]);
     //找到相应的JSON
     joNode    := nil;
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          if gjoWindow.A['items'][iItem].S['guid'] = oControl.Name then begin
               joNode    :=  gjoWindow.A['items'][iItem];
               Break;
          end;
     end;
     if joNode = nil then begin
          Exit;
     end;

     //更新相应的JSON
     joNode.I['left']    := oControl.Left;
     joNode.I['top']     := oControl.Top;
     joNode.I['width']   := oControl.Width;
     joNode.I['height']  := oControl.Height;



     //更新相应的JSON的属性
     teShowNodeProperty(joNode,Panel_Right);
     //
     SetCompOnChange;

end;

procedure TForm_Tkinter.StretchHandleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     iItem     : Integer;
     joNode    : TJsonObject;
     oControl  : TControl;
begin
     //
     oControl  := TStretchHandle(Sender).Children[0];
     Caption   := Format('shmm L= %d ,T=%d, W=%d, H=%d',[oControl.Left,oControl.Top,oControl.Width,oControl.Height]);
     //找到相应的JSON
     joNode    := nil;
     for iItem := 0 to gjoWindow.A['items'].Count-1 do begin
          if gjoWindow.A['items'][iItem].S['guid'] = oControl.Name then begin
               joNode    :=  gjoWindow.A['items'][iItem];
               Break;
          end;
     end;
     if joNode = nil then begin
          Exit;
     end;

     //更新相应的JSON
     joNode.I['left']    := oControl.Left;
     joNode.I['top']     := oControl.Top;
     joNode.I['width']   := oControl.Width;
     joNode.I['height']  := oControl.Height;



     //更新相应的JSON的属性
     teShowNodeProperty(joNode,Panel_Right);
     //
     SetCompOnChange;
end;

procedure TForm_TKinter.ToolButton_CancelClick(Sender: TObject);
begin
     ModalResult    := mrCancel;
end;

procedure TForm_TKinter.ToolButton_DeleteClick(Sender: TObject);
var
     iCtrl     : Integer;
     oPanel    : TPanel;
begin
     oPanel := nil;
     for iCtrl := 0 to Panel_FormClient.ControlCount-1 do begin
          if TPanel(Panel_FormClient.Controls[iCtrl]).Color <> clBtnFace then begin
               oPanel    := TPanel(Panel_FormClient.Controls[iCtrl]);
               Break;
          end;
     end;

     //
     if oPanel = nil then begin
          Exit;
     end;

     //
     if MessageDlg('Are you sure delete the component ?',mtConfirmation,[mbOK,mbCancel],0)= mrOk then begin
          oPanel.Destroy;
          //select form_window as default
          Label_Caption.OnMouseDown(Label_Caption,mbLeft, [], 10, 10);
     end;

end;

procedure TForm_TKinter.ToolButton_SelectClick(Sender: TObject);
begin
     ToolBar1.Hint  := TToolButton(Sender).Hint;
end;

end.
