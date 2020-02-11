unit WWChart;

interface

uses
     //
     XMLFlowChartUnit,
     XMLNSChartUnit,
     SysRecords,
     SysConsts,
     
     //
     XMLDoc,XMLIntf, Graphics,
     SysUtils, Classes, Controls;

type
     TWWChartMode = (cmFlowChart, cmNSChart);


     TWWChart = class(TCustomControl)
     private
          XML : TXMLDocument; //用于保存所有节点信息
          FocusedNode : IXMLNode;
          FChartMode: TWWChartMode;
          FSpaceVert: Word;
          FBaseHeight: Word;
          FSpaceHorz: Word;
          FBaseWidth: Word;
          FSelectedColor: TColor;
          FIFColor: TColor;
          FLineColor: TColor;
          FScale: Single;
          FFont: TFont;
          procedure SetChartMode(const Value: TWWChartMode);
          procedure SetBaseHeight(const Value: Word);
          procedure SetBaseWidth(const Value: Word);
          procedure SetSpaceHorz(const Value: Word);
          procedure SetSpaceVert(const Value: Word);
          procedure SetIFColor(const Value: TColor);
          procedure SetLineColor(const Value: TColor);
          procedure SetSelectedColor(const Value: TColor);
          procedure SetScale(const Value: Single);
          procedure SetFont(const Value: TFont);  //当前XML节点
     protected
          procedure Paint; override;

     public
          constructor Create(AOwner: TComponent);override;
          destructor Destory;
          procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
          procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
          procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
          procedure LoadFromFile(FileName:string);
          procedure SaveToFile(FileName:string);
     published
          property ChartMode : TWWChartMode read FChartMode write SetChartMode;
          property BaseWidth : Word read FBaseWidth write SetBaseWidth default 50;
          property BaseHeight : Word read FBaseHeight write SetBaseHeight default 30;
          property SpaceHorz : Word read FSpaceHorz write SetSpaceHorz default 20;
          property SpaceVert : Word read FSpaceVert write SetSpaceVert default 20;
          property LineColor : TColor read FLineColor write SetLineColor default clBlack;
          property IFColor : TColor read FIFColor write SetIFColor default clLime;
          property SelectedColor : TColor read FSelectedColor write SetSelectedColor default clAqua;
          property Scale : Single read FScale write SetScale;
          property Font:TFont read FFont write SetFont; 
     end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('WestWind', [TWWChart]);
end;

{ TWWChart }

constructor TWWChart.Create(AOwner: TComponent);
var
     xnRoot    : IXMLNode;
     xnNew     : IXMLNode;
begin
     inherited;

     //默认ChartMode
     FChartMode     := cmFlowChart;
     FBaseWidth     := 50;
     FBaseHeight    := 30;
     FSpaceVert     := 20;
     FSpaceHorz     := 20;
     FLineColor     := clBlack;
     FIFColor       := clLime;
     FSelectedColor := clAqua;
     FScale         := 1;

     //
     FFont     := TFont.Create;
     FFont.Name     := 'MS Sans Serif';
     FFont.Size     := 10;

     //创建XML对象
     XML  := TXMLDocument.Create(self);
     XML.Active     := True;
     XML.Version    := '1.0';
     XML.Encoding   := 'UTF-8';


     //
     xnRoot    := XML.AddChild('Root');
     xnNew     := xnRoot.AddChild('RT_CODE');
     xnNew.Attributes['Mode'] := rtBlock_Code;
     xnNew.Attributes['Expanded']  := True;

     //
end;

destructor TWWChart.Destory;
begin
     //释放XML
     if XML<>nil then begin
          XML.Destroy;
     end;

end;

procedure TWWChart.LoadFromFile(FileName: string);
begin
     //
     XML.LoadFromFile(FileName);
end;

procedure TWWChart.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     inherited;

end;

procedure TWWChart.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
     inherited;

end;

procedure TWWChart.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     inherited;

end;

procedure TWWChart.Paint;
var
     rConfig   : TWWConfig;
begin
     inherited;
     //
     rConfig.BaseWidth   := FBaseWidth;
     rConfig.BaseHeight  := FBaseHeight;
     rConfig.SpaceVert   := FSpaceVert;
     rConfig.SpaceHorz   := FSpaceHorz;
     rConfig.LineColor   := FLineColor;
     rConfig.IFColor     := FIFColor;
     rConfig.Scale       := FScale;
     rConfig.FontName    := FFont.Name;
     rConfig.FontSize    := FFont.Size;
     rConfig.FontColor   := FFont.Color;

     //
     if FChartMode=cmFlowchart then begin
          DrawXmlToFlowChart(XML.DocumentElement.ChildNodes[0],Canvas,rConfig);
     end else begin
          DrawXmlToNSChart(XML.DocumentElement.ChildNodes[0],Canvas,rConfig);
     end;

end;

procedure TWWChart.SaveToFile(FileName: string);
begin
     XML.SaveToFile(FileName);
end;

procedure TWWChart.SetBaseHeight(const Value: Word);
begin
     FBaseHeight := Value;
end;

procedure TWWChart.SetBaseWidth(const Value: Word);
begin
     FBaseWidth := Value;
end;

procedure TWWChart.SetChartMode(const Value: TWWChartMode);
begin
     FChartMode := Value;
end;

procedure TWWChart.SetFont(const Value: TFont);
begin
  FFont := Value;
end;

procedure TWWChart.SetIFColor(const Value: TColor);
begin
  FIFColor := Value;
end;

procedure TWWChart.SetLineColor(const Value: TColor);
begin
  FLineColor := Value;
end;

procedure TWWChart.SetScale(const Value: Single);
begin
  FScale := Value;
end;

procedure TWWChart.SetSelectedColor(const Value: TColor);
begin
  FSelectedColor := Value;
end;

procedure TWWChart.SetSpaceHorz(const Value: Word);
begin
  FSpaceHorz := Value;
end;

procedure TWWChart.SetSpaceVert(const Value: Word);
begin
  FSpaceVert := Value;
end;

end.
