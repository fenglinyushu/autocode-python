unit mxClickSplitter;
{
 Version 0.6:

 Version 0.7
      

}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
  cVersion = 'Version 1.0';
  cMinHandledSize = 6;

type
  NaturalNumber = 1..High(Integer);

  TCanResizeEvent = procedure(Sender: TObject; var NewSize: Integer;
    var Accept: Boolean) of object;

  TResizeStyle = (rsNone, rsLine, rsUpdate, rsPattern);
  THandleAlign = (haLeft, haCenter, haRight);
  TClickOrientation = (coLeft, coRight, coUp, coDown);
  TDirection = (diLeft, diRight, diUp, diDown);

  TmxClickSplitter = class(TGraphicControl)
  private
    ctop, cbottom,
    cleft, cright: Integer;
    MouseX, MouseY: Integer;
    bmLeft, bmRight, bmUp, bmDown: TBitmap;
    ctrl1, ctrl2: TControl;
    FOldControlSize: Integer;

    FSplitCursor: TCursor;
    FActiveControl: TWinControl;
    FHandled: Boolean;
    FHandleSize: NaturalNumber;
    FHandleAlign: THandleAlign;
    FBrush: TBrush;
    FControl: TControl;
    FDownPos: TPoint;
    FLineDC: HDC;
    FLineVisible: Boolean;
    FMinSize: NaturalNumber;
    FMaxSize: Integer;
    FNewSize: Integer;
    FOldKeyDown: TKeyEvent;
    FOldSize: Integer;
    FPrevBrush: HBrush;
    FResizeStyle: TResizeStyle;
    FSplit: Integer;

    FOnCanResize: TCanResizeEvent;
    FOnMoved: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    FClickOrientation: TClickOrientation;
    FVersion: string;
    procedure AllocateLineDC;
    procedure CalcSplitSize(X, Y: Integer; var NewSize, Split: Integer);
    procedure DrawLine;
    function FindControl(aDirection: TDirection): TControl;
    procedure FocusKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ReleaseLineDC;
    procedure SetHandled(Value: Boolean);
    procedure UpdateControlSize;
    procedure UpdateSize(X, Y: Integer);
    procedure SetClickOrientation(const Value: TClickOrientation);
    function GetAlign: TAlign;
    procedure SetAlign(const Value: TAlign);
    procedure SetHandleSize(const Value: NaturalNumber);
    procedure SetHandleAlign(const Value: THandleAlign);
    procedure SetVersion(Value: string);
    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(Value: Integer);
    function GetHeight: Integer;
  protected
    function CanResize(var NewSize: Integer): Boolean; {reintroduce; }virtual;
    function DoCanResize(var NewSize: Integer): Boolean; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
    procedure RequestAlign; {$IFDEF VER120}override;{$ENDIF}
    procedure StopSizing; dynamic;

    function MouseInHandle: Boolean;

    // protected -> no one has to know
    property ClickOrientation: TClickOrientation read FClickOrientation write SetClickOrientation;
    property ResizeStyle: TResizeStyle read FResizeStyle write FResizeStyle default rsPattern;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
  published
    property Align: TAlign read GetAlign write SetAlign default alLeft;
    property Handled: Boolean read FHandled write SetHandled default True;
    property HandleSize: NaturalNumber read FHandleSize write SetHandleSize default 80;
    property HandleAlign: THandleAlign read FHandleAlign write SetHandleAlign default haCenter;
    property Color;
{$IFDEF VER120}
    property Constraints;
{$ENDIF}    
    property MinSize: NaturalNumber read FMinSize write FMinSize default 30;
    property ParentColor;
    property Visible;
    property Width: Integer read GetWidth write SetWidth;

    property OnCanResize: TCanResizeEvent read FOnCanResize write FOnCanResize;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Version: string read FVersion write SetVersion;
    property Height: Integer read GetHeight write SetHeight;
  end;

procedure Register;

implementation

{$R mxClickSplitter.res}
{$R *.dcr}

type
  TWinControlAccess = class(TWinControl);

constructor TmxClickSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alLeft;
  Width := 6;
  Cursor := crHSplit;
  FHandled := True;
  FHandleSize := 80;
  FHandleAlign := haCenter;
  FMinSize := 30;
  FResizeStyle := rsPattern;
  FOldSize := -1;
  FVersion := cVersion;

  bmLeft     := TBitmap.Create;
  bmRight    := TBitmap.Create;
  bmUp       := TBitmap.Create;
  bmDown     := TBitmap.Create;

  bmLeft.LoadFromResourceName(HInstance, 'UPCLICK_LEFT');
  bmRight.LoadFromResourceName(HInstance, 'UPCLICK_RIGHT');
  bmUp.LoadFromResourceName(HInstance, 'UPCLICK_UP');
  bmDown.LoadFromResourceName(HInstance, 'UPCLICK_DOWN');
end;

destructor TmxClickSplitter.Destroy;
begin
  FBrush.Free;
  bmLeft.Free;
  bmRight.Free;
  bmUp.Free;
  bmDown.Free;
  inherited Destroy;
end;

procedure TmxClickSplitter.AllocateLineDC;
begin
  FLineDC := GetDCEx(Parent.Handle, 0, DCX_CACHE or DCX_CLIPSIBLINGS
    or DCX_LOCKWINDOWUPDATE);
  {if ResizeStyle = rsPattern then
  begin
    if FBrush = nil then
    begin
      FBrush := TBrush.Create;
     // FBrush.Bitmap := AllocPatternBitmap(clBlack, clWhite);
    end;
    FPrevBrush := SelectObject(FLineDC, FBrush.Handle);
  end;}
end;

procedure TmxClickSplitter.DrawLine;
var
  P: TPoint;
begin
  FLineVisible := not FLineVisible;
  P := Point(Left, Top);
  if Align in [alLeft, alRight] then
    P.X := Left + FSplit else
    P.Y := Top + FSplit;
  with P do PatBlt(FLineDC, X, Y, Width, Height, PATINVERT);
end;

procedure TmxClickSplitter.ReleaseLineDC;
begin
  if FPrevBrush <> 0 then
    SelectObject(FLineDC, FPrevBrush);
  ReleaseDC(Parent.Handle, FLineDC);
  if FBrush <> nil then
  begin
    FBrush.Free;
    FBrush := nil;
  end;
end;

function TmxClickSplitter.FindControl(aDirection: TDirection): TControl;
var
  P: TPoint;
  I: Integer;
  R: TRect;
begin
  Result := nil;
  P := Point(Left, Top);
  case aDirection of
    diLeft   : Dec(p.x);
    diRight  : Inc(p.x, Width);
    diUp     : Dec(p.y);
    diDown   : Inc(p.y, Height);
  end;
{  case Align of
    alLeft: Dec(P.X);
    alRight: Inc(P.X, Width);
    alTop: Dec(P.Y);
    alBottom: Inc(P.Y, Height);
  else
    Exit;
  end;}
  for I := 0 to Parent.ControlCount - 1 do
  begin
    Result := Parent.Controls[I];
    if Result.Visible and Result.Enabled then
    begin
      R := Result.BoundsRect;
      if (R.Right - R.Left) = 0 then
        if Align in [alTop, alLeft] then
          Dec(R.Left)
        else
          Inc(R.Right);
      if (R.Bottom - R.Top) = 0 then
        if Align in [alTop, alLeft] then
          Dec(R.Top)
        else
          Inc(R.Bottom);
      if PtInRect(R, P) then Exit;
    end;
  end;
  Result := nil;
end;

procedure TmxClickSplitter.RequestAlign;
begin
{$IFDEF VER120}
  inherited RequestAlign;
{$ENDIF}
  if (Cursor <> crVSplit) and (Cursor <> crHSplit) then Exit;
  if Align in [alBottom, alTop] then
    Cursor := crVSplit
  else
    Cursor := crHSplit;
end;

procedure TmxClickSplitter.Paint;
const
  XorColor = $00FFD8CE;
var
     R         : TRect;
     I,iTmp    : Integer;
     iStep     : Integer;
     iCount    : Integer;
begin
     //得到区域
     R := ClientRect;

     //设计画笔
     with Canvas do begin
          Pen.Color      := Color;
          Pen.Style      := psSolid;
          Brush.Color    := Color;
          Pen.Mode       := pmCopy;
          FillRect(ClientRect);
          Pen.Color      := clBtnShadow;
     end;

     //计算ctop,cbottom
     if Align in [alLeft, alRight] then begin
          case HandleAlign of
               haLeft   : begin
                    ctop := 2;
                    cbottom := ctop + HandleSize;
               end;
               haCenter : begin
                    ctop := (Height div 2) - (HandleSize div 2);
                    cbottom := ctop + HandleSize;
               end;
               haRight  : begin
                    ctop := Height - HandleSize - 2;
                    cbottom := ctop + HandleSize;
               end;
         end;
     end else begin
         case HandleAlign of
               haLeft   : begin
                    cleft := 2;
                    cright := cleft + HandleSize;
               end;
               haCenter : begin
                    cleft := (Width div 2) - (HandleSize div 2);
                    cright := cleft + HandleSize;
               end;
               haRight  : begin
                    cleft := Width - HandleSize - 2;
                    cright := cleft + HandleSize;
               end;
         end;
     end;

     if Handled then begin
          case ClickOrientation of
               coUp,
               coDown  : begin
                     with Canvas do begin
                          Pen.Color := clBtnHighlight;
                          //我改进后的效果
                          Pen.Color     := clGradientActiveCaption;
                          Brush.Style   := bsSolid;
                          Brush.Color   := Pen.Color;
                          iStep    := 10;
                          iCount   := FHandleSize div iStep;
                          for I:=1 to iCount-1 do begin
                              Ellipse(cLeft+I*iStep,1,cLeft+I*iStep+4,5);
                          end;
                     end;
               end;
               coLeft,
               coRight : begin

                     with Canvas do begin
                          //我改进后的效果
                          Pen.Color     := clGradientActiveCaption;
                          Brush.Style   := bsSolid;
                          Brush.Color   := Pen.Color;
                          iStep    := 10;
                          iCount   := FHandleSize div iStep;
                          for I:=1 to iCount-1 do begin
                              Ellipse(1,ctop+I*iStep-1,5,ctop+I*iStep+3);
                          end;
                     end;
               end;
          end;
     end;

     if csDesigning in ComponentState then begin
          with Canvas do begin
               Pen.Style := psDot;
               Pen.Mode := pmXor;
               Pen.Color := XorColor;
               Brush.Style := bsClear;
               Rectangle(0, 0, ClientWidth, ClientHeight);
          end;
     end;
     
     if Assigned(FOnPaint) then FOnPaint(Self);
end;

function TmxClickSplitter.DoCanResize(var NewSize: Integer): Boolean;
begin
  Result := CanResize(NewSize);
  if Result and (NewSize <= MinSize) then
    NewSize := MinSize;// MT this was the bug in the TSplitter component in Delphi 4 (NewSize := 0)
end;

function TmxClickSplitter.CanResize(var NewSize: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnCanResize) then FOnCanResize(Self, NewSize, Result);
end;

procedure TmxClickSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    case Align of
      alLeft   : FControl := ctrl1;
      alRight  : FControl := ctrl2;
      alTop    : FControl := ctrl1;
      alBottom : FControl := ctrl2;
    end;
    FDownPos := Point(X, Y);
    if Assigned(FControl) then
    begin
      if Align in [alLeft, alRight] then
      begin
        FMaxSize := Parent.ClientWidth - FMinSize;
        for I := 0 to Parent.ControlCount - 1 do
          with Parent.Controls[I] do
            if Align in [alLeft, alRight] then Dec(FMaxSize, Width);
        Inc(FMaxSize, FControl.Width);
      end
      else
      begin
        FMaxSize := Parent.ClientHeight - FMinSize;
        for I := 0 to Parent.ControlCount - 1 do
          with Parent.Controls[I] do
            if Align in [alTop, alBottom] then Dec(FMaxSize, Height);
        Inc(FMaxSize, FControl.Height);
      end;
      UpdateSize(X, Y);
      AllocateLineDC;
      with ValidParentForm(Self) do
        if ActiveControl <> nil then
        begin
          FActiveControl := ActiveControl;
          FOldKeyDown := TWinControlAccess(FActiveControl).OnKeyDown;
          TWinControlAccess(FActiveControl).OnKeyDown := FocusKeyDown;
        end;
      if ResizeStyle in [rsLine, rsPattern] then DrawLine;
    end;
  end;
end;

procedure TmxClickSplitter.UpdateControlSize;
begin
  if FNewSize <> FOldSize then
  begin
    case Align of
      alLeft: begin
                FControl.Width := FNewSize;
                Left := FControl.Width + 1;
              end;
      alTop: begin
               FControl.Height := FNewSize;
               Top := FControl.Height + 1;
             end;
      alRight:
        begin
          Parent.DisableAlign;
          try
            FControl.Left := FControl.Left + (FControl.Width - FNewSize);
            FControl.Width := FNewSize;
          finally
            Parent.EnableAlign;
          end;
          {$IFNDEF VER120}
          if FControl.Width <> 0
          then begin
                 Left := FControl.Left;
                 FControl.Left := Left + 1;
               end;
          {$ENDIF}
        end;
      alBottom:
        begin
          Parent.DisableAlign;
          try
            FControl.Top := FControl.Top + (FControl.Height - FNewSize);
            FControl.Height := FNewSize;
          finally
            Parent.EnableAlign;
          end;
          {$IFNDEF VER120}
          if FControl.Height <> 0
          then begin
                 Top := FControl.Top;
                 FControl.Top := Top + 1;
               end;
          {$ENDIF}
        end;
    end;
    Update;
    if Assigned(FOnMoved) then FOnMoved(Self);
    if FOldSize = 0
    then case Align of
           alLeft    : ClickOrientation := coLeft;
           alBottom  : ClickOrientation := coDown;
           alRight   : ClickOrientation := coRight;
           alTop     : ClickOrientation := coUp;
         end;
    FOldSize := FNewSize;
  end;
end;

procedure TmxClickSplitter.CalcSplitSize(X, Y: Integer; var NewSize, Split: Integer);
var
  S: Integer;
begin
  if Align in [alLeft, alRight] then
    Split := X - FDownPos.X
  else
    Split := Y - FDownPos.Y;
  S := 0;
  case Align of
    alLeft: S := FControl.Width + Split;
    alRight: S := FControl.Width - Split;
    alTop: S := FControl.Height + Split;
    alBottom: S := FControl.Height - Split;
  end;
  NewSize := S;
  if S < FMinSize then
    NewSize := FMinSize
  else if S > FMaxSize then
    NewSize := FMaxSize;
  if S <> NewSize then
  begin
    if Align in [alRight, alBottom] then
      S := S - NewSize else
      S := NewSize - S;
    Inc(Split, S);
  end;
end;

procedure TmxClickSplitter.UpdateSize(X, Y: Integer);
begin
  CalcSplitSize(X, Y, FNewSize, FSplit);
end;

procedure TmxClickSplitter.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewSize, Split: Integer;
begin
  inherited;
  if MouseInHandle
  then Cursor := crDefault
  else Cursor := FSplitCursor;
  MouseX := x;
  MouseY := y;
  if (ssLeft in Shift) and Assigned(FControl) then
  begin
    CalcSplitSize(X, Y, NewSize, Split);
    if DoCanResize(NewSize) then
    begin
      if ResizeStyle in [rsLine, rsPattern] then DrawLine;
      FNewSize := NewSize;
      FSplit := Split;
      if ResizeStyle = rsUpdate then UpdateControlSize;
      if ResizeStyle in [rsLine, rsPattern] then DrawLine;
    end;
  end;
end;

procedure TmxClickSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Assigned(FControl) then
  begin
    if ResizeStyle in [rsLine, rsPattern] then DrawLine;
    if MouseInHandle
    then begin
           if FOldSize = -1 // first time
           then begin
                  FNewSize := 0;
                  if ClickOrientation in [coUp, coDown]
                  then FOldControlSize := FControl.Height
                  else FOldControlSize := FControl.Width;
                end
           else if FOldSize > 0
                then begin
                       FNewSize := 0;//
                       FOldControlSize := FOldSize;
                     end
                else begin
                       FNewSize := FOldControlSize;
                     end;
           case ClickOrientation of
             coUp    : ClickOrientation := coDown;
             coDown  : ClickOrientation := coUp;
             coLeft  : ClickOrientation := coRight;
             coRight : ClickOrientation := coLeft;
           end;
         end;
    UpdateControlSize;
    StopSizing;
  end;
end;

procedure TmxClickSplitter.FocusKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    StopSizing
  else if Assigned(FOldKeyDown) then
    FOldKeyDown(Sender, Key, Shift);
end;

procedure TmxClickSplitter.SetHandled(Value: Boolean);
begin
  FHandled := Value;
  case Align of
    alLeft, alRight : if Width < cMinHandledSize
                      then Width := cMinHandledSize;
    alBottom, alTop : if Height < cMinHandledSize
                      then Height := cMinHandledSize;
  end;                                      
  RePaint;
end;

procedure TmxClickSplitter.StopSizing;
begin
  if Assigned(FControl) then
  begin
    if FLineVisible then DrawLine;
    FControl := nil;
    ReleaseLineDC;
    if Assigned(FActiveControl) then
    begin
      TWinControlAccess(FActiveControl).OnKeyDown := FOldKeyDown;
      FActiveControl := nil;
    end;
  end;
  if Assigned(FOnMoved) then
    FOnMoved(Self);
end;

procedure TmxClickSplitter.SetClickOrientation(
  const Value: TClickOrientation);
begin
  FClickOrientation := Value;
  Invalidate;
end;

procedure Register;
begin
  RegisterComponents('Maxxua', [TmxClickSplitter]);
end;

procedure TmxClickSplitter.Loaded;
begin
  inherited Loaded;
  FSplitCursor := Cursor;
  if Align in [alLeft, alRight]
  then begin
         ctrl1 := FindControl(diLeft);
         ctrl2 := FindControl(diRight);
       end;
  if Align in [alTop, alBottom]
  then begin
         ctrl1 := FindControl(diUp);
         ctrl2 := FindControl(diDown);
       end;
end;

function TmxClickSplitter.MouseInHandle: Boolean;
begin
  if Align in [alLeft, alRight]
  then Result := Handled and PtInRect(Rect(0, ctop, Width, cbottom), Point(MouseX, MouseY))
  else Result := Handled and PtInRect(Rect(cleft, 0, cright, Height), Point(MouseX, MouseY));
end;

function TmxClickSplitter.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

procedure TmxClickSplitter.SetAlign(const Value: TAlign);
var aValue: TClickOrientation;
begin
  if Value in [alNone, alClient]
  then raise Exception.Create('Value not allowed for ' + ClassName + ' component.');
  inherited Align := Value;
  aValue := coLeft;
  case Align of
    alLeft   : aValue := coLeft;
    alRight  : aValue := coRight;
    alTop    : aValue := coUp;
    alBottom : aValue := coDown;
  end;
  ClickOrientation := aValue;
end;

procedure TmxClickSplitter.SetHandleSize(const Value: NaturalNumber);
begin
  FHandleSize := Value;
  Invalidate;
end;

procedure TmxClickSplitter.SetHandleAlign(const Value: THandleAlign);
begin
  FHandleAlign := Value;
  Invalidate;
end;


procedure TmxClickSplitter.SetVersion(Value: string);
begin
  FVersion := cVersion;
end;

function TmxClickSplitter.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TmxClickSplitter.SetWidth(const Value: Integer);
begin
  if Handled and (Align in [alLeft, alRight]) and (Value < cMinHandledSize)
  then raise Exception.Create('Min. width for a handled TmxClickSplitter component is ' + IntToStr(cMinHandledSize));
  inherited Width := Value;
end;

procedure TmxClickSplitter.SetHeight(Value: Integer);
begin
  if Handled and (Align in [alTop, alBottom]) and (Value < cMinHandledSize)
  then raise Exception.Create('Min. height for a handled TmxClickSplitter component is ' + IntToStr(cMinHandledSize));
  inherited Height := Value;
end;

function TmxClickSplitter.GetHeight: Integer;
begin
  Result := inherited Height;
end;

end.
