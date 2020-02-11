unit ExportWord;

interface

uses
     //自编模块
     SysRecords,SysConsts,SysVars,SysUnits,

     //系统
     XMLDoc,XMLIntf,
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs,OleServer, WordXP,ActiveX,

     //第三方控件
     GDIPAPI,GDIPOBJ;

type
  TForm_ExportWord = class(TForm)
  private
     WD : TWordDocument;
     CurConfig : TWWConfig;
     Anchor : OleVariant;
     procedure SetLastText(Text:String);
     //1 绘制多点曲线
     procedure DrawPoints(Pts:array of double);
     //2 绘制箭头
     procedure DrawArrow(iX,iY:Single;bDown:Boolean);
     //3 绘制菱形框,iX,iY为上顶点坐标
     procedure DrawDiamond(iX,iY:Single;Text:String);
     //4 绘制一般块
     procedure DrawBlock(iX,iY:Single;Text:String;Collapsed:Boolean);
     //5 绘制半圆弧方框
     procedure DrawRoundRect(iX,iY:Single;Text:String);
     //6 绘制TRY的各种形状 (iX,iY为上边中心点坐标，Text为文本,Mode为类型,0:TRY,1:EXCEPT/FINALLY,3.END)
     procedure DrawTry(iX,iY:Single;Text:String;Collapsed:Boolean;Mode:Integer);
     //7 绘制代码块
     procedure DrawCodeBlock(iX,iY,iW,iH:Single;Text:String);

     //NS框
     procedure NSDrawBlock(iX,iY,iW,iH:Single;Text:String;Collapsed:Boolean);
     //添加文本
     procedure DrawString(S:String;Rect:TGPRectF);
     //添加文本
     procedure DrawText(S:String;X,Y,W,H:Single);

     //去除最后一个形状的颜色
     procedure ClearLastColor;
  public
     procedure ExportToWord(  Node:IXMLNode;FileName:String;Config:TWWConfig);
     procedure ExportNSToWord(Node:IXMLNode;FileName:String;Config:TWWConfig);
  end;

var
     Form_ExportWord: TForm_ExportWord;

implementation

uses Main;

{$R *.dfm}


{ TForm_ExportWord }

procedure TForm_ExportWord.DrawArrow(iX, iY: Single; bDown: Boolean);
begin
    if bDown then begin
         iY   := iY+iDeltaY/2;
         DrawPoints([iX,iY,  iX-iDeltaX,iY-iDeltaY,  iX+iDeltaX,iY-iDeltaY,  iX,iY,  iX,iY-iDeltaY]);
    end else begin
         iY   := iY-iDeltaY/2;
         DrawPoints([iX,iY,  iX-iDeltaX,iY+iDeltaY,  iX+iDeltaX,iY+iDeltaY,  iX,iY,  iX,iY+iDeltaY]);
    end;

end;

procedure TForm_ExportWord.DrawBlock(iX, iY: Single; Text: String;
  Collapsed: Boolean);
var
     BW,BH     : Single;
     iID       : Integer;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     //
     if Collapsed then begin
          iID  := 65;
     end else begin
          iID  := 61;
     end;
     with WD.Shapes.AddShape(iID,iX-BW,iY,BW*2,BH,Anchor) do begin
          TextFrame.TextRange.Font.Color     := CurConfig.FontColor;
          TextFrame.TextRange.Font.Size      := CurConfig.FontSize*CurConfig.Scale*0.8;
          TextFrame.TextRange.Font.Name      := CurConfig.FontName;
          //TextFrame.TextRange.Font.Bold      := 1;
          TextFrame.TextRange.Text           := Text;
          TextFrame.MarginLeft               := 0;
          TextFrame.MarginTop                := 0;
          TextFrame.MarginRight              := 0;
          TextFrame.MarginBottom             := 0;
          TextFrame.TextRange.Paragraphs.Format.Alignment   := wdAlignParagraphCenter;
     end;

end;

procedure TForm_ExportWord.DrawDiamond(iX, iY: Single; Text: String);
var
     BW,BH     : Single;
     I         : Integer;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     //
     with WD.Shapes.AddShape(63,iX-BW,iY,BW*2,BH*2,Anchor) do begin
          TextFrame.TextRange.Font.Color     := CurConfig.FontColor;
          TextFrame.TextRange.Font.Size      := CurConfig.FontSize*CurConfig.Scale*0.8;
          TextFrame.TextRange.Font.Name      := CurConfig.FontName;
          //TextFrame.TextRange.Font.Bold      := 1;
          TextFrame.TextRange.Text           := Text;
          TextFrame.MarginLeft               := 0;
          TextFrame.MarginTop                := 0;
          TextFrame.MarginRight              := 0;
          TextFrame.MarginBottom             := 0;

          TextFrame.TextRange.Paragraphs.Format.Alignment   := wdAlignParagraphCenter;
     end;
end;

procedure TForm_ExportWord.DrawPoints(Pts: array of double);
var
     BW,BH     : Single;
     I,iCount  : Integer;
     sa        : PSafeArray;
     vPoint    : OleVariant;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     //
     //生成PSafeArray
     iCount    := Length(Pts) div 2;
     vPoint    := VarArrayCreate([0,iCount-1,0,1],VT_R4);
     for I:=0 to iCount-1 do begin
          vPoint[I,0]    := Pts[I*2];
          vPoint[I,1]    := Pts[I*2+1];
     end;
     //sa   := PSafeArray(TVarData(vPoint).VArray);

     //绘制曲线
     WD.Shapes.AddPolyline(vPoint,Anchor);
     //DC.Document.Pages[1].DrawPolyline(sa);

end;

procedure TForm_ExportWord.DrawRoundRect(iX, iY: Single; Text: String);
var
     BW,BH     : Single;
     I         : Integer;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     //
     with WD.Shapes.AddShape(69,iX-BW/2,iY,BW,BH,Anchor) do begin
          TextFrame.TextRange.Font.Color     := CurConfig.FontColor;
          TextFrame.TextRange.Font.Size      := CurConfig.FontSize*CurConfig.Scale*0.8;
          TextFrame.TextRange.Font.Name      := CurConfig.FontName;
          TextFrame.TextRange.Font.Bold      := 1;
          TextFrame.TextRange.Text           := Text;
          TextFrame.MarginLeft               := 0;
          TextFrame.MarginTop                := 0;
          TextFrame.MarginRight              := 0;
          TextFrame.MarginBottom             := 0;
          TextFrame.TextRange.Paragraphs.Format.Alignment   := wdAlignParagraphCenter;
     end;
     //   Selection.ParagraphFormat.Alignment = wdAlignParagraphCenter
end;

procedure TForm_ExportWord.DrawTry(iX, iY: Single; Text: String;
  Collapsed: Boolean; Mode: Integer);
var
     BW,BH     : Single;
     SH,SV     : Single;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     SV   := CurConfig.SpaceVert*CurConfig.Scale;
     SH   := CurConfig.SpaceHorz*CurConfig.Scale;
     //
     case mode of
          0 : begin
               //绘制Try
               DrawPoints([iX-BW,iY,  iX+BW,iY,  iX+BW-BH,iY+BH,  iX-BW,iY+BH,  iX-BW,iY]);
               //
               SetLastText(Text);
               //下接线
               DrawPoints([iX,iY+BH,  iX,iY+BH+SV]);
          end;
          1 : begin
               //绘制except/finally
               DrawPoints([iX-BW,iY,  iX+BW-BH,iY,  iX+BW-BH-BH/2,iY+BH/2,  iX+BW-BH,iY+BH,  iX-BW,iY+BH,  iX-BW,iY]);
               //
               SetLastText(Text);
               //
               if Collapsed then begin
                    //左侧的竖线
                    DrawPoints([iX-BW+5,iY,  iX-BW+5,iY+BH]);
               end;
               //下接线
               DrawPoints([iX,iY+BH,  iX,iY+BH+SV]);
          end;
          2 : begin
               //绘制end of Try
               DrawPoints([iX-BW,iY,  iX+BW-BH,iY,  iX+BW,iY+BH,  iX-BW,iY+BH,  iX-BW,iY]);
               //
               SetLastText(Text);
               //下接线
               DrawPoints([iX,iY+BH,  iX,iY+BH+SV]);
          end;
     end;
end;

procedure TForm_ExportWord.ExportToWord(Node:IXMLNode;FileName:String;Config:TWWConfig);
type
     TNodeWHE = record
          W,H,E     : Integer;
     end;
var
     I,J            : Integer;
     BW,BH,SH,SV    : Single;
     X,Y,W,H,E      : Single;
     xnChild        : IXMLNode;
     xnExtra        : IXMLNode;
     bTmp           : Boolean;
     iTmp           : Single;
     vName          : OleVariant;
     //
     procedure DrawNodeFlowchart(Node:IXMLNode);
     var
          II,JJ     : Integer;
     begin
          //赋给简单变量以便于书写
          X    := Node.Attributes['X'];
          Y    := Node.Attributes['Y'];
          E    := Node.Attributes['E'];
          W    := Node.Attributes['W'];
          H    := Node.Attributes['H'];

          //
          if Node.Attributes['W']=-1 then begin
               Exit;
          end;

          //<绘制子节点数为0的节点和合拢的节点
          if (Node.ChildNodes.Count=0) then begin
               //处理无子块节点(不包括跳转及分支)
               if (Node.Attributes['Mode']=rtBlock_Code)
                         and((Node.Attributes['ShowDetailCode']=1)or(grConfig.ShowDetailCode and (Node.Attributes['ShowDetailCode']<>2))) then begin
                    //节点(矩形)
                    DrawCodeBlock(X,Y,W,H-SV,Node.Attributes['Text']);
                    //下接线
                    DrawPoints([X,Y+H-SV,  X,Y+H]);
                    //
                    Exit;
               end else if not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally]) then begin
                    if InModes(_M(Node),[rtIF_Else,rtIF_Elseif]) then begin

                         //下接线
                         DrawPoints([X,Y,  X,Y+BH+SV]);
                         //
                         Exit;
                    end else begin
                         //节点(矩形)
                         DrawBlock(X,Y,GetNodeText(Node),False);
                         //下接线
                         DrawPoints([X,Y+BH,  X,Y+BH+SV]);
                         //
                         Exit;
                    end;
               end;
          end else if (Node.Attributes['Expanded']=False) then begin
               //处理合拢的节点(不包括分支)
               if not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally]) then begin
                    //合拢节点(矩形)
                    DrawBlock(X,Y,RTtoStr(Node.Attributes['Mode']),False);
                    //下接线
                    DrawPoints([X,Y+BH,  X,Y+BH+SV]);
                    //
                    Exit;
               end;
          end;
          //>


          //
          case Node.Attributes['Mode'] of
               //
               rtIF : begin
                    //菱形框
                    DrawDiamond(X,Y,Format('%s',[GetNodeText(Node)]));
                    DrawPoints([X,Y+BH*2,  X,Y+BH*2+SV]); //向下线
                    //菱形框向右延伸线
                    xnChild   := Node.ChildNodes[0];
                    if _M(Node.ChildNodes[1]) = rtIF_ElseIf then begin
                         DrawPoints([_X(xnChild)+BW,Y+BH,  _EL(xnChild.NextSibling),Y+BH]);
                    end else begin
                         DrawPoints([_X(xnChild)+BW,Y+BH,  _X(xnChild.NextSibling),Y+BH]);
                    end;

                    //
                    for JJ:=1 to Node.ChildNodes.Count-1 do begin
                         xnChild   := Node.ChildNodes[JJ];
                         if _M(xnChild) = rtIF_ElseIf then begin
                              //菱形框
                              DrawDiamond(_X(xnChild),_Y(xnChild)-BH*2-SV,GetNodeText(xnChild));
                              DrawPoints([_X(xnChild),_Y(xnChild)-SV,_X(xnChild),_Y(xnChild)]); //菱形框向下线
                              DrawPoints([_X(xnChild)+BW,_Y(xnChild)-SV-BH,_EL(xnChild.NextSibling),_Y(xnChild)-SV-BH]);  //菱形框向右延伸线

                         end else begin
                              DrawPoints([_L(xnChild),_Y(xnChild)-SV-BH,_X(xnChild),_Y(xnChild)-SV-BH]);  //接上模块菱形框向右延伸线
                              DrawPoints([_X(xnChild),_Y(xnChild)-SV-BH,_X(xnChild),_Y(xnChild)]); //无菱形框向下线
                         end;
                              DrawPoints([_X(xnChild),_B(xnChild),_X(xnChild),_EB(xnChild.ParentNode)]); //模块下面的下接线
                    end;

                    //横向多模块下接线
                    DrawPoints([X,Y+H-SV,_X(Node.ChildNodes.Last),Y+H-SV]);
                    //YES块的下接线
                    DrawPoints([X,_B(Node.ChildNodes.First),  X,Y+H]);
               end;

               //
               rtFOR : begin
                    //菱形框
                    DrawPoints([X-BW,Y,  X+W-BW-Sh-BH,Y,  X+W-BW-Sh,Y+BH/2,  X+W-BW-Sh-BH,Y+BH,  X-BW,Y+BH,  X-BW,Y]);
                    DrawText(Format('for %s',[Node.Attributes['Caption']]),X-BW,Y,W-Sh-BH/2,BH);
                    DrawPoints([X,Y+BH,  X,Y+BH+SV]);
                    //得到子块
                    xnChild   := Node.ChildNodes.First;
                    //退出循环线
                    DrawPoints([X+W-BW-Sh,Y+BH/2,  X+W-BW,Y+BH/2,  X+W-BW,Y+H-SV,  X,Y+H-SV,  X,Y+H]);
                    DrawArrow(X+W-BW,Y+H / 2, True);
                    //继续循环线
                    DrawPoints([X,Y+H-SV*3,  X,Y+H-SV*2,  X-BW-E,Y+H-SV*2,  X-BW-E,Y+BH/2,  X-BW,Y+BH/2]);
                    DrawArrow(X-BW-E,Y+H / 2, False);
               end;

               //
               rtWhile : begin
                    //菱形框
                    DrawDiamond(X,Y+SV,Format('%s',[GetNodeText(Node)]));
                    DrawPoints([X,Y+BH*2+SV,  X,Y+BH*2+SV*2]);
                    //得到子块
                    xnChild   := Node.ChildNodes.First;
                    //退出循环线
                    DrawPoints([X+BW,Y+BH+SV,  X+W-BW,Y+BH+SV,  X+W-BW,Y+H-SV,  X,Y+H-SV,  X,Y+H]);
                    DrawArrow(X+W-BW,Y+H / 2, True);
                    //继续循环线
                    DrawPoints([X,StrToFloat(xnChild.Attributes['Y'])+xnChild.Attributes['H'],
                              X,Y+H-SV*2,  X-BW-E,Y+H-SV*2,  X-BW-E,Y,  X,Y,  X,Y+SV]);
                    DrawArrow(X-BW-E,Y+H / 2, False);
               end;

               //
               rtRepeat : begin
                    //得到子块
                    xnChild   := Node.ChildNodes.First;
                    //菱形框
                    DrawDiamond(X,StrToFloat(xnChild.Attributes['Y'])+xnChild.Attributes['H'],
                              Format('%s',[Node.Attributes['Caption']])); 
                    DrawPoints([X,StrToFloat(xnChild.Attributes['Y'])+xnChild.Attributes['H']+BH*2,
                              X,StrToFloat(xnChild.Attributes['Y'])+xnChild.Attributes['H']+BH*2+SV]);
                    //退出循环线
                    DrawPoints([X+BW,Y+H-SV*3-BH,  X+W-BW,Y+H-SV*3-BH,  X+W-BW,Y+H-SV,  X,Y+H-SV,  X,Y+H]);
                    DrawArrow(X+W-BW,Y+H-SV*2-BH/2, True);
                    //继续循环线
                    DrawPoints([X,Y+H-SV*3,  X,Y+H-SV*2,  X-BW-E,Y+H-SV*2,  X-BW-E,Y,  X,Y,  X,Y+SV]);
                    DrawArrow(X-BW-E,Y+(H-SV*2)/2, False);
               end;

               //
               rtCase : begin
                    //绘制子块
                    bTmp := False; //记录是否绘制了跳转到下一分支的线

                    //
                    for JJ:=0 to Node.ChildNodes.Count-1 do begin
                         //得到相应子块
                         xnChild   := Node.ChildNodes[JJ];

                         //得到子块的信息
                         X    := xnChild.Attributes['X'];
                         Y    := xnChild.Attributes['Y'];
                         E    := xnChild.Attributes['E'];
                         W    := xnChild.Attributes['W'];
                         H    := xnChild.Attributes['H'];

                         //菱形框
                         DrawDiamond(X,Y-BH*2-SV*2,xnChild.Attributes['Caption']);
                         //菱形框下接线
                         DrawPoints([X,Y-SV*2,  X,Y]);

                         //如果上一块跳转到本块, 则需要续画跳转线
                         if bTmp then begin
                              DrawPoints([X,Y-SV,  X-BW-E,Y-SV]);
                         end;
                         //
                         bTmp := False; //记录是否绘制了跳转到下一分支的线

                         //如果非第一分枝, 则绘制与上一块连接线的本块内部分
                         if J>0 then begin
                              DrawPoints([X-BW,Y-BH-SV*2,  X-BW-E,Y-BH-SV*2]);
                         end;
                         
                         //接下一个节点的线(右),及有可能跳转到下一分支的线
                         if JJ<>Node.ChildNodes.Count-1 then begin
                              //右线(只绘制本块中分界部分)
                              DrawPoints([X+BW,Y-BH-SV*2,  X+W-BW+SH*2,Y-BH-SV*2]);

                              if InModes(Config.Language,[loC,loCpp]) then begin
                                   //如果最后一个子块不是跳转, 则绘制一条跳转到下一分支的线(仅画位于本块内的部分)
                                   if Config.Language in [loC,loCpp] then begin
                                        if xnChild.HasChildNodes then begin
                                             xnChild   := xnChild.ChildNodes.Last;
                                             if not InModes(xnChild.Attributes['Mode'],[rtJUMP_Break,rtJUMP_Continue,rtJUMP_Exit,rtJUMP_Goto]) then begin
                                                  DrawPoints([X,Y+H,  X+W-BW+SH,Y+H,  X+W-BW+SH,Y-SV,  X+W-BW+SH*2,Y-SV]);
                                                  bTmp := True;
                                             end;
                                        end else begin
                                             //如果当前分支没有子块,则直接跳转到下一块
                                             DrawPoints([X,Y,  X+W-BW+SH,Y,  X+W-BW+SH,Y-SV,  X+W-BW+SH*2,Y-SV]);
                                             bTmp := True;
                                        end;
                                   end;
                              end;
                         end else begin     //在最后一个子块绘制SWITCH的多分支的统一结束线
                              DrawPoints([X,StrToFloat(Node.Attributes['Y'])+Node.Attributes['H']-SV,
                                        Node.Attributes['X'], StrToFloat(Node.Attributes['Y'])+Node.Attributes['H']-SV,
                                        Node.Attributes['X'], StrToFloat(Node.Attributes['Y'])+Node.Attributes['H']]);
                         end;

                         //如果没有绘制了跳转到下一分支的线,则绘制到当前块的下面与主连接的线
                         if not bTmp then begin
                              DrawPoints([X,Y+H,  X,StrToFloat(Node.Attributes['Y'])+Node.Attributes['H']-SV]);
                         end;

                         //在最底部绘制一个向下箭头
                         DrawArrow(X,Y+H-iDeltaY/2,True);

                    end;

                    //
               end;

               rtCase_Item,rtCase_Default : begin
                    //如果当前子块未展开,则绘制一个
                    if (Node.Attributes['Expanded']=False) then begin
                         if Node.HasChildNodes then begin
                              iTmp := Y;
                              DrawBlock(x,iTmp,'... ...',True);
                              //下接线
                              DrawPoints([X,iTmp+BH,  X,iTmp+BH+SV]);

                         end;
                    end ;
               end;

                    rtTry : begin
                         //绘制Try
                         DrawTry(X,Y,RTtoStr(Node.Attributes['Mode']),True,0);

                         //绘制End of Try
                         //iTmp := Y+H-BH-SV;
                         //DrawTry(X,iTmp,'TRY END',True,2);
                    end;
                    //
                    rtTry_Except,rtTry_Finally,rtTry_Else : begin
                         //绘制
                         DrawTry(X,Y,RTtoStr(Node.Attributes['Mode']),not Node.Attributes['Expanded'],1);
                    end;

          else

          end;
          //递归绘制其子节点
          if Node.Attributes['Expanded'] then begin
               for II:=0 to Node.ChildNodes.Count-1 do begin
                    DrawNodeFlowchart(Node.ChildNodes[II]);
               end;
          end;
     end;
     procedure ClearNodeWHE(Node:IXMLNode);
     var
          II   : Integer;
     begin
          Node.AttributeNodes.Delete('W');
          Node.AttributeNodes.Delete('H');
          Node.AttributeNodes.Delete('E');
          for II:=0 to Node.ChildNodes.Count-1 do begin
               ClearNodeWHE(Node.ChildNodes[II]);
          end;
     end;


     function GetNodeWHE(Node:IXMLNode):TNodeWHE;
     var
          iiCode    : Integer;
          KK        : Integer;
          xnFirst   : IXMLNode;
          xnNext    : IXMLNode;
          rChild    : TNodeWHE;
          rExtra    : TNodeWHE;
     begin
          //如果已计算过,则直接出结果
          if Node.HasAttribute('W') then begin
               Result.W  := Node.Attributes['W'];
               Result.H  := Node.Attributes['H'];
               Result.E  := Node.Attributes['E'];
               //
               Exit;
          end else begin
               ShowMessage('Export to Visio Error when GetNodeWHE !'#13+Node.NodeName);
          end;
     end;
begin
     //<得到流程图设置
     CurConfig := Config;
     BW   := Config.BaseWidth*Config.Scale;
     BH   := Config.BaseHeight*Config.Scale;
     SH   := Config.SpaceHorz*Config.Scale;
     SV   := Config.SpaceVert*Config.Scale;
     if BW=0 then begin
          BW   := 80;
     end;
     if BH=0 then begin
          BH   := 30;
     end;
     if SH=0 then begin
          SH   := 20;
     end;
     if SV=0 then begin
          SV   := 20;
     end;
     //>


     //
     WD   := TWordDocument.Create(self);
     WD.Activate;
     WD.Range.Font.Size := Round(Config.FontSize*Config.Scale);
     //WD.Range.Text := 'AutoFlowChart:Auto generate flowchart from sourcecode!' ;
     //WD.Range.InsertParagraphAfter;
     //WD.Paragraphs.Last.Range.Text := 'website: www.ezprog.com';
     //WD.Range.InsertParagraphAfter;
     //WD.Paragraphs.Last.Range.Text := 'email: support@ezprog.com';
     //WD.Range.InsertParagraphAfter;
     Anchor    := WD.Paragraphs.Last.Range;


     //--------------------------依次绘制流程图(此后的代码应能共享)---------------------------------------------------//
     //递归绘制流程图
     DrawNodeFlowchart(Node);


     //<绘制开始和结束标志
     //起始标志
     X    := Node.Attributes['X'];
     Y    := SV;
     DrawRoundRect(X,Y,'START');
     //下接线
     DrawPoints([X,Y+BH,  X,Y+BH+SV]);
     //结束标志
     X    := Node.Attributes['X'];
     Y    := Round(StrToFloat(Node.Attributes['Y']))+Round(StrToFloat(Node.Attributes['H']));
     DrawRoundRect(X,Y,'END');
     //>

     //>共享结束


     //全选中，然后组合
     //WD.Shapes.SelectAll;
     //WD.Shapes.Application.Selection.ShapeRange.Group;



     //
     vName     := FileName;
     WD.SaveAs2000(vName);
     WD.Close;
     WD.Destroy;
     MessageDlg(#13#13'   ---   Export Word successfully!   ---   '#13#13,mtInformation,[mbOK],0);

end;


procedure TForm_ExportWord.ExportNSToWord(Node:IXMLNode;FileName:String;Config:TWWConfig);
type
     TNodeWHE = record
          W,H,E     : Integer;
     end;
var
     I,J            : Integer;
     BW,BH,SH,SV    : Single;
     X,Y,W,H,E      : Single;
     xnChild        : IXMLNode;
     xnExtra        : IXMLNode;
     bTmp           : Boolean;
     iTmp           : Single;
     vName          : OleVariant;
     sTxt           : String;
     function GetNodeWHE(Node:IXMLNode):TNodeWHE;
     var
          iiCode    : Integer;
          KK        : Integer;
          xnFirst   : IXMLNode;
          xnNext    : IXMLNode;
          rChild    : TNodeWHE;
          rExtra    : TNodeWHE;
     begin
          //如果已计算过,则直接出结果
          if Node.HasAttribute('W') then begin
               Result.W  := Node.Attributes['W'];
               Result.H  := Node.Attributes['H'];
               Result.E  := Node.Attributes['E'];
               //
               Exit;
          end else begin
               ShowMessage('Export to Visio Error when GetNodeWHE !'#13+Node.NodeName);
          end;
     end;
     //
     procedure DrawNodeNSchart(Node:IXMLNode);
     var
          II,JJ     : Integer;
          rChild    : TNodeWHE;
          rExtra    : TNodeWHE;
     begin
          //赋给简单变量以便于书写
          X    := Node.Attributes['X'];
          Y    := Node.Attributes['Y'];
          E    := 0;//Node.Attributes['E'];
          W    := Node.Attributes['W'];
          H    := Node.Attributes['H'];

          //
          if Node.Attributes['W']=-1 then begin
               Exit;
          end;

          //
          if Node.Attributes['Mode']=rtCase_Item then begin
               sTxt := Node.Attributes['Caption'];
          end else begin
               sTxt := RTtoStr(Node.Attributes['Mode']);
          end;

          //<绘制子节点数为0的节点和合拢的节点
          if (Node.ChildNodes.Count=0) then begin
               //处理无子块节点(不包括跳转及分支)
               if (Node.Attributes['Mode']=rtBlock_Code)
                         and((Node.Attributes['ShowDetailCode']=1)or(grConfig.ShowDetailCode and (Node.Attributes['ShowDetailCode']<>2))) then begin
                    //节点(矩形)
                    NSDrawBlock(X,Y,W,H,Node.Attributes['Text'],False);
                    //
                    Exit;
               end else begin
                    if not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally]) then begin
                         //节点(矩形)
                         NSDrawBlock(X,Y,W,H,sTxt,False);
                         //
                         Exit;
                    end;
               end;
          end else if (not Node.Attributes['Expanded']) then begin
               //处理合拢的节点(不包括分支)
               if not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally]) then begin
                    //合拢节点(矩形)
                    NSDrawBlock(X,Y,W,H,sTxt,False);
                    //
                    Exit;
               end;
          end;
          //>

          //
          case Node.Attributes['Mode'] of
               //
               rtIF : begin
                    xnChild   := Node.ChildNodes[0];
                    rChild    := GetNodeWHE(xnChild);
                    //多段折线
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+BH,  X,Y+BH,  X,Y, X+rChild.W,Y+BH, X+W,Y]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,rChild.W*2,BH),oFormat,oFontBrh);
               end;

               //
               rtFOR : begin
                    //多段折线
                    DrawPoints([X,Y+H,  X,Y,  X+W,Y,  X+W,Y+H,  X+W-SH,Y+H]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               //
               rtWhile : begin
                    //多段折线
                    DrawPoints([X+SH,Y+H,  X,Y+H,  X,Y,  X+W,Y,  X+W,Y+BH]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               //
               rtRepeat : begin
                    //多段折线
                    DrawPoints([X+W-SH,Y,  X+W,Y,  X+W,Y+H,  X,Y+H,  X,Y+H-H]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y+H-BH,W,BH),oFormat,oFontBrh);
               end;

               //
               rtCase : begin
                    //方框
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+BH,  X,Y+BH,  X,Y]);
                    //写文字
                    SetLastText(sTxt);
                    //两端斜线
                    DrawPoints([X,Y,  X+BH,Y+BH]);
                    DrawPoints([X+W,Y,  X+W-BH,Y+BH]);
                    //oGraph.DrawString(sTxt+' '+Node.Attributes['Caption'],-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               rtCase_Item,rtCase_Default : begin
                    //多段折线
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+BH,  X,Y+BH,  X,Y]);
                    //含子块的框
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+H,  X,Y+H,  X,Y]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(Node.Attributes['Caption'],-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               //
               rtTry : begin
                    //多段折线
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+H,  X,Y+H,  X,Y]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;
               //
               rtTry_Except,rtTry_Finally : begin
                    //多段折线
                    DrawPoints([X+W,Y,  X+W,Y+BH]);
                    //含子块的框
                    DrawPoints([X,Y+BH,  X+W,Y+BH,  X+W,Y+H,  X,Y+H,  X,Y+BH]);
                    //写文字
                    SetLastText(sTxt);
                    //oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;
          else

          end;
          //>

          //递归绘制其子节点
          if Node.Attributes['Expanded'] then begin
               for II:=0 to Node.ChildNodes.Count-1 do begin
                    DrawNodeNSchart(Node.ChildNodes[II]);
               end;
          end;
     end;

begin

     //<得到流程图设置
     CurConfig := Config;
     BW   := Config.BaseWidth*Config.Scale;
     BH   := Config.BaseHeight*Config.Scale;
     SH   := Config.SpaceHorz*Config.Scale;
     SV   := Config.SpaceVert*Config.Scale;
     if BW=0 then begin
          BW   := 80;
     end;
     if BH=0 then begin
          BH   := 30;
     end;
     if SH=0 then begin
          SH   := 20;
     end;
     if SV=0 then begin
          SV   := 20;
     end;
     //>

     //
     WD   := TWordDocument.Create(self);

     WD.Activate;
     WD.Range.Font.Size := Round(Config.FontSize*Config.Scale);
     //WD.Range.Text := 'AutoFlowChart:Auto generate flowchart from sourcecode!' ;
     //WD.Range.InsertParagraphAfter;
     //WD.Paragraphs.Last.Range.Text := 'website: www.ezprog.com';
     //WD.Range.InsertParagraphAfter;
     //WD.Paragraphs.Last.Range.Text := 'email: support@ezprog.com';
     //WD.Range.InsertParagraphAfter;
     Anchor    := WD.Paragraphs.Last.Range;



     //---------------------------------共享代码--------------------------------------------------//
     //<绘制开始和结束标志
     //起始标志
     X    := Node.Attributes['X']+0+Node.Attributes['W'] / 2;
     Y    := SV;
     DrawRoundRect(X,Y,'START');
     //下接线
     DrawPoints([X,Y+BH,  X,Y+BH+SV]);
     //结束标志
     X    := Node.Attributes['X']+0+Node.Attributes['W'] / 2;
     Y    := Node.Attributes['Y']+0+Node.Attributes['H']+SV;
     //下接线
     DrawPoints([X,Y-SV,  X,Y]);
     DrawRoundRect(X,Y,'END');
     //>

     //递归绘制流程图
     DrawNodeNSchart(Node);
     //共享结束

     //
     vName     := FileName;

     //全部组合
     WD.Shapes.SelectAll;
     WD.Shapes.Application.Selection.ShapeRange.Group;

     //
     WD.SaveAs2000(vName);
     WD.Close;
     WD.Destroy;
     MessageDlg(#13#13'   ---   Export Word successfully!   ---   '#13#13,mtInformation,[mbOK],0);

end;

procedure TForm_ExportWord.SetLastText(Text: String);
var
     iCount    : OleVariant;
     iX,iY     : Single;
     iW,iH     : Single;
begin
     //
     iCount    := WD.Shapes.Count;
     iX   := WD.Shapes.Item(iCount).Left;
     iY   := WD.Shapes.Item(iCount).Top;
     iW   := WD.Shapes.Item(iCount).Width;
     iH   := WD.Shapes.Item(iCount).Height;

     //
     //with WD.Shapes.AddLabel(1,iX,iY,iW,iH,Anchor) do begin
     with WD.Shapes.AddShape(61,iX+1,iY+1,iW-2,iH-2,Anchor) do begin
          Line.Visible   := 0;
          Fill.Transparency   := 0.6;
          TextFrame.TextRange.Font.Color     := CurConfig.FontColor;
          TextFrame.TextRange.Font.Size      := CurConfig.FontSize*CurConfig.Scale*0.8;
          TextFrame.TextRange.Font.Name      := CurConfig.FontName;
          TextFrame.TextRange.Font.Bold      := 1;
          TextFrame.TextRange.Text           := Text;
          TextFrame.MarginLeft               := 0;
          TextFrame.MarginTop                := 0;
          TextFrame.MarginRight              := 0;
          TextFrame.MarginBottom             := 0;
          TextFrame.TextRange.Paragraphs.Format.Alignment   := wdAlignParagraphCenter;
     end;

end;

procedure TForm_ExportWord.NSDrawBlock(iX, iY, iW, iH: Single;Text:String;Collapsed:Boolean);
var
     BW,BH     : Single;
     iID       : Integer;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     //
     iID  := 61;
     with WD.Shapes.AddShape(iID,iX,iY,iW,iH,Anchor) do begin
          TextFrame.TextRange.Font.Color     := CurConfig.FontColor;
          TextFrame.TextRange.Font.Size      := CurConfig.FontSize*CurConfig.Scale*0.8;
          TextFrame.TextRange.Font.Name      := CurConfig.FontName;
          //TextFrame.TextRange.Font.Bold      := 1;
          TextFrame.TextRange.Text           := Text;
          TextFrame.MarginLeft               := 0;
          TextFrame.MarginTop                := 0;
          TextFrame.MarginRight              := 0;
          TextFrame.MarginBottom             := 0;
          TextFrame.TextRange.Paragraphs.Format.Alignment   := wdAlignParagraphCenter;
     end;
end;

procedure TForm_ExportWord.DrawString(S: String; Rect: TGPRectF);
begin
     NSDrawBlock(Rect.X,Rect.Y,Rect.Width,Rect.Height,S,False);
     ClearLastColor;
end;

procedure TForm_ExportWord.ClearLastColor;
var
     iCount    : OleVariant;
begin
     //
     iCount    := WD.Shapes.Count;

     //with WD.Shapes.AddLabel(1,iX,iY,iW,iH,Anchor) do begin
     with WD.Shapes.Item(iCount) do begin
          Line.Visible   := 0;
          Fill.Visible   := 0;
     end;
end;

procedure TForm_ExportWord.DrawText(S: String; X, Y, W, H: Single);
begin
     NSDrawBlock(X,Y,W,H,S,False);
     ClearLastColor;
end;

procedure TForm_ExportWord.DrawCodeBlock(iX, iY, iW, iH: Single; Text: String);
var
     BW,BH,SV  : Single;
     iID       : Integer;
begin
     BW   := CurConfig.BaseWidth*CurConfig.Scale;
     BH   := CurConfig.BaseHeight*CurConfig.Scale;
     SV   := CurConfig.SpaceVert*CurConfig.Scale;
     //
     iID  := 61;
     with WD.Shapes.AddShape(iID,iX-BW,iY,iW,iH,Anchor) do begin
          TextFrame.TextRange.Font.Color     := CurConfig.FontColor;
          TextFrame.TextRange.Font.Size      := CurConfig.FontSize*CurConfig.Scale*0.8;
          TextFrame.TextRange.Font.Name      := CurConfig.FontName;
          //TextFrame.TextRange.Font.Bold      := 1;
          TextFrame.TextRange.Text           := Text;
          TextFrame.MarginLeft               := 5;
          TextFrame.MarginTop                := 0;
          TextFrame.MarginRight              := 0;
          TextFrame.MarginBottom             := 0;
          TextFrame.TextRange.Paragraphs.Format.Alignment   := wdAlignParagraphLeft;
     end;
end;

end.
