unit XMLNSChartUnit;

interface

uses
     //自编模块
     SysRecords,SysConsts,SysUnits,SysVars,

     //第三方控件
     GDIPAPI,GDIPOBJ,

     //系统自带
     XMLDoc,XMLIntf,
     Forms,Math,Graphics,SysUtils,Dialogs,windows,Classes,ExtCtrls;


//==============================绘制NS图函数======================================================//
//Node : 当前节点
//Image : 输出的图片
//Config : 配置信息
function  DrawXmlToNSChart(Node:IXMLNode;Image:TImage;Config:TWWConfig):Integer;



implementation



function  DrawXmlToNSChart(Node:IXMLNode;Image:TImage;Config:TWWConfig):Integer;
type
     TNodeWHE = record
          W,H,E     : Integer;
     end;
var
     I,J,K     : Integer;
     iLevel    : Integer;
     iRight    : Single;     //用于记录Case中上一子块的右边界值
     iMaxLevel : Integer;     //最深层次
     iMinLevel : Integer;     //最浅层次
     xnChild   : IXMLNode;
     xnExtra   : IXMLNode;
     xnNode    : IXMLNode;
     //
     rData     : PBlockInfo;
     rChild    : PBlockInfo;
     rExtra    : PBlockInfo;
     BW,BH     : Single;
     SH,SV     : Single;
     iMaxE     : Integer;
     iMaxH     : Integer;
     iPos      : Integer;
     X,Y,W,H,E : Single;
     iImageW   : Integer;     //流程图图片宽度
     iImageH   : Integer;     //流程图图片高度
     sTxt      : String;
     slTmp     : TStringList;
     //
     iTop      : Single;
     sText     : String;
     sInit     : String;
     sJudge    : String;
     sNext     : String;

     //
     iTmp      : Single;
     bTmp      : Boolean;
     sTmp      : String;

     //
     oPen      : TGPPen;
     oGraph    : TGPGraphics;
     oBrush    : TGPSolidBrush;
     oFontBrh  : TGPSolidBrush;
     oFont     : TGPFont;
     oFontB    : TGPFont;
     oFormat   : TGPStringFormat;
     oPath     : TGPGraphicsPath;
const
     iDeltaX = 1.5;
     iDeltaY = 6;

     //输入各点坐标,绘制折线
     procedure DrawPoints(Pts:array of Single);
     var
          I,iCount  : Integer;
          rPath     : TGPGraphicsPath;
          rGPPts    : array[0..99] of TGPPointF;
     begin
          //得到点数
          iCount    := Length(Pts) div 2;
          //设置点坐标
          for I:=0 to iCount-1 do begin
               rGPPts[I].X    := Pts[I*2];
               rGPPts[I].Y    := Pts[I*2+1];
          end;
          //生成路径
          rPath     := TGPGraphicsPath.Create;
          rPath.AddLines(PGPPointF(@rGPPts[0]),iCount);
          //绘制
          oGraph.DrawPath(oPen,rPath);
          //释放退出
          rPath.destroy;

     end; //end of DrawPoints

     //绘制向上或向上箭头(iX,iY为中心点坐标)
     procedure DrawArrow(iX,iY:Single;bDown:Boolean);
     begin
          if bDown then begin
               iY   := iY+iDeltaY/2;
               DrawPoints([iX-iDeltaX,iY-iDeltaY,  iX,iY,  iX+iDeltaX,iY-iDeltaY,  iX-iDeltaX,iY-iDeltaY]);
          end else begin
               iY   := iY-iDeltaY/2;
               DrawPoints([iX-iDeltaX,iY+iDeltaY,  iX,iY,  iX+iDeltaX,iY+iDeltaY,  iX-iDeltaX,iY+iDeltaY]);
          end;
     end; //end of DrawArrow


     //绘制一般方框(iX,iY为左上角坐标，iW,iH为宽和高, Text为文本,Collaped为是否合拢块标志)
     procedure DrawBlock(iX,iY,iW,iH:Single;Text:String;Collapsed:Boolean);
     begin
          DrawPoints([X,Y,  X+iW,Y,  X+iW,Y+iH,  X,Y+iH,  X,Y]);
          oGraph.DrawString(Text,-1,oFont,MakeRect(X*1.0,Y,iW,iH),oFormat,oFontBrh);
          if Collapsed then begin
               //两侧的竖线
               //DrawPoints([X+5,Y,  X+5,Y+iH]);
               //DrawPoints([X+iW-5,Y,  X+iW-5,Y+BH]);
          end;
     end;

     //绘制起始标志,双半圆弧+方框(iX,iY为上边中心点坐标，Text为文本)
     procedure DrawRoundRect(iX,iY:Single;Text:String);
     begin
          iTmp := Round(BW*2/3);    //半宽,宽度的一半
          oPath.CloseAllFigures;
          oPath.AddLine(X-iTmp+1,Y,  X+iTmp-1,Y);
          oPath.AddArc(X+iTmp-BH/2,Y,BH,BH,-90,180);
          oPath.AddLine(X-iTmp+1,Y+BH,  X+iTmp-1,Y+BH);
          oPath.AddArc(X-iTmp-BH/2,Y,BH,BH,90,180);
          oGraph.DrawPath(oPen,oPath);
          oGraph.DrawString(Text,-1,oFontB,MakeRect(X-BW,Y,BW*2,BH),oFormat,oFontBrh);
     end;
     procedure GetGPTextWH(Text:string;
               Font:TGPFont;FontFormat:TGPStringFormat;
               FontFamily:TGPFontFamily;
               var Width:Single;var Height:Single);
     var
          oPath   : TGPGraphicsPath;
          oRect   : TGPPointF;
          strFormat    : TGPStringFormat;
          rcBound      : TGPRectF;
     begin
          oPath     := TGPGraphicsPath.Create;
          strFormat := TGPStringFormat.Create();
          oPath.AddString(Text,-1,
                    FontFamily,
                    font.GetStyle(),
                    font.GetSize(),
                    oRect,strFormat);
          oPath.GetBounds(rcBound);

          //
          Width     := rcBound.Width;
          Height    := rcBound.Height;
     end;
     function GetGPTextWidth(Text:string):Single;
     var
          W,H       : Single;
          oFF       : TGPFontFamily;
          oFormat   : TGPStringFormat;
     begin
          oFormat   := TGPStringFormat.Create();
          oFF       := TGPFontFamily.Create;
          oFont.GetFamily(oFF);//oFF       := TGPFontFamily.Create(Config.FontName);

          GetGPTextWH(Text,oFont,oFormat,oFF,W,H);
          Result    := W;
          oFormat.Destroy;
          oFF.Destroy;
     end;
     function GetGPTextHeight(Text:string):Single;
     var
          W,H       : Single;
          oFF       : TGPFontFamily;
          oFormat   : TGPStringFormat;
     begin
          oFormat   := TGPStringFormat.Create();
          oFF       := TGPFontFamily.Create;
          oFont.GetFamily(oFF);//oFF       := TGPFontFamily.Create(Config.FontName);
          GetGPTextWH(Text,oFont,oFormat,oFF,W,H);
          Result    := H;
          oFormat.Destroy;
          oFF.Destroy;
     end;
     

     procedure SetNodePosition(Node:IXMLNode);
     var
          II,JJ     : Integer;
     begin
          //如果该节点合拢,则不必要分析其子节点的位置
          if not Node.Attributes['Expanded'] then begin
               Exit;
          end;
          
          //<根据当前节点的类型计算子节点位置
          case Node.Attributes['Mode'] of
               rtIF : begin
                    //YES块
                    xnChild   := Node.ChildNodes[0];
                    xnChild.Attributes['X']  := Node.Attributes['X'];
                    xnChild.Attributes['Y']  := Node.Attributes['Y']+BH;

                    //NO块
                    xnExtra   := Node.ChildNodes[1];
                    xnExtra.Attributes['X']  := Node.Attributes['X'] +0 + xnChild.Attributes['W'];
                    xnExtra.Attributes['Y']  := xnChild.Attributes['Y'];


                    //复核子块大小
                    xnChild.Attributes['H']  := Node.Attributes['H']-BH;
                    xnExtra.Attributes['H']  := xnChild.Attributes['H'];
                    xnExtra.Attributes['W']  := Node.Attributes['W']+0-xnChild.Attributes['W'];
               end; //end mode

               rtFor : begin
                    //子块
                    xnChild   := Node.ChildNodes[0];
                    xnChild.Attributes['X']  := Node.Attributes['X'];
                    xnChild.Attributes['Y']  := Node.Attributes['Y']+ BH;

                    //复核子块大小
                    xnChild.Attributes['W']  := Node.Attributes['W']-SH;
                    xnChild.Attributes['H']  := Node.Attributes['H']-BH
               end; //end mode

               rtWhile : begin
                    //子块
                    xnChild    := Node.ChildNodes[0];
                    xnChild.Attributes['X']  := Node.Attributes['X']+SH;
                    xnChild.Attributes['Y']  := Node.Attributes['Y']+ BH;

                    //复核子块大小
                    xnChild.Attributes['W']  := Node.Attributes['W']-SH;
                    xnChild.Attributes['H']  := Node.Attributes['H']-BH;
               end; //end mode

               rtRepeat : begin
                    //子块
                    xnChild    := Node.ChildNodes[0];
                    xnChild.Attributes['X']  := Node.Attributes['X'];
                    xnChild.Attributes['Y']  := Node.Attributes['Y'];

                    //复核子块大小
                    xnChild.Attributes['W']  := Node.Attributes['W']-SH;
                    xnChild.Attributes['H']  := Node.Attributes['H']-BH
               end; //end mode

               rtCase : begin
                    iRight    := 0;
                    for JJ:=0 to Node.ChildNodes.Count-1 do begin
                         //得到子块节点
                         if JJ=0 then begin
                              xnChild    := Node.ChildNodes[0];
                              //
                              xnChild.Attributes['X']  := Node.Attributes['X'];
                              xnChild.Attributes['Y']  := Node.Attributes['Y']+BH;

                              //得到当前子块右边界值,用于计算下一子块的位置
                              iRight    := xnChild.Attributes['X']+0+xnChild.Attributes['W'];

                              //复核子块大小
                              xnChild.Attributes['H']  := Node.Attributes['H']-BH;
                         end else begin
                              xnChild    := Node.ChildNodes[JJ];
                              //
                              xnChild.Attributes['X']  := iRight;
                              xnChild.Attributes['Y']  := Node.Attributes['Y']+BH;

                              //得到当前子块右边界值,用于计算下一子块的位置
                              iRight    := xnChild.Attributes['X']+0+xnChild.Attributes['W'];
                              //复核子块大小
                              xnChild.Attributes['H']  := Node.Attributes['H']-BH;
                         end;
                         //复核子块大小
                         if JJ=Node.ChildNodes.Count-1 then begin
                              xnChild.Attributes['W']  := Node.Attributes['X']+0+Node.Attributes['W']-xnChild.Attributes['X'];
                         end;
                    end;
               end; //end mode

               rtCase_Item,rtCase_Default : begin
                    iTop := BH;
                    for JJ:=0 to Node.ChildNodes.Count-1 do begin
                         xnChild   := Node.ChildNodes[JJ];
                         //
                         xnChild.Attributes['X']  := Node.Attributes['X'];
                         xnChild.Attributes['Y']  := Node.Attributes['Y']+iTop;
                         //
                         iTop := iTop+xnChild.Attributes['H'];

                         //复核子块大小
                         xnChild.Attributes['W']  := Node.Attributes['W'];
                         if J=Node.ChildNodes.Count-1 then begin
                              xnChild.Attributes['H']  := Node.Attributes['Y']+0+Node.Attributes['H']-xnChild.Attributes['Y'];
                         end;
                    end;
               end; //end mode

               rtTry : begin
                    iTop := 0;
                    for JJ:=0 to Node.ChildNodes.Count-1 do begin
                         if JJ=0 then begin
                              xnChild    := Node.ChildNodes[JJ];
                              //
                              xnChild.Attributes['X']  := Node.Attributes['X']+SH;
                              xnChild.Attributes['Y']  := Node.Attributes['Y']+BH;
                              //
                              iTop := xnChild.Attributes['Y']+0+xnChild.Attributes['H'];
                         end else begin
                              xnChild    := Node.ChildNodes[JJ];
                              //
                              xnChild.Attributes['X']  := Node.Attributes['X']+SH;
                              xnChild.Attributes['Y']  := iTop;
                              //
                              iTop := xnChild.Attributes['Y']+0+xnChild.Attributes['H'];
                         end;
                         //复核子块大小
                         xnChild.Attributes['W']  := Node.Attributes['W']-SH;
                         if JJ=Node.ChildNodes.Count-1 then begin
                              xnChild.Attributes['H']  := Node.Attributes['Y']+0+Node.Attributes['H']-xnChild.Attributes['Y'];
                         end;
                    end;
               end; //end mode

               rtTry_Except,rtTry_Finally : begin
                    iTop := BH;
                    for JJ:=0 to Node.ChildNodes.Count-1 do begin
                         xnChild   := Node.ChildNodes[JJ];
                         //
                         xnChild.Attributes['X']  := Node.Attributes['X'];
                         xnChild.Attributes['Y']  := Node.Attributes['Y']+iTop;
                         //
                         iTop := iTop+xnChild.Attributes['H'];

                         //复核子块大小
                         xnChild.Attributes['W']  := Node.Attributes['W'];
                         if JJ=Node.ChildNodes.Count-1 then begin
                              xnChild.Attributes['H']  := Node.Attributes['Y']+0+Node.Attributes['H']-xnChild.Attributes['Y'];
                         end;
                    end;
               end; //end mode
          else
               iTop := 0;
               for JJ:=0 to Node.ChildNodes.Count-1 do begin
                    xnChild    := Node.ChildNodes[JJ];
                    //
                    xnChild.Attributes['X']  := Node.Attributes['X'];
                    xnChild.Attributes['Y']  := Node.Attributes['Y']+iTop;

                    //
                    iTop := iTop+xnChild.Attributes['H'];

                    //复核子块大小
                    if JJ=Node.ChildNodes.Count-1 then begin
                         xnChild.Attributes['H']  := Node.Attributes['Y']+0+Node.Attributes['H']-xnChild.Attributes['Y'];
                    end;
                    xnChild.Attributes['W']  := Node.Attributes['W'];

               end;


          end;


          //递归计算子节点的子节点位置
          for II:=0 to Node.ChildNodes.Count-1 do begin
               SetNodePosition(Node.ChildNodes[II]);
          end;
     end;
     function GetNodeWHE(Node:IXMLNode):TNodeWHE;
     var
          iiCode    : Integer;
          KK        : Integer;
          xnFirst   : IXMLNode;
          xnNext    : IXMLNode;
          xnChild   : IXMLNode;
          xnExtra   : IXMLNode;
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
          end;

          //默认值
          Result.W  := -1;
          Result.H  := -1;
          Result.E  := -1;

          //处理简单模块
          if (Node.ChildNodes.Count=0)and
               (not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally])) then
          begin
               if Node.Attributes['Mode']=rtBlock_Code then begin
                    //处理代码
                    if (Node.Attributes['ShowDetailCode']=2)or((grConfig.ShowDetailCode=False) and (Node.Attributes['ShowDetailCode']<>1)) then begin
                         Node.Attributes['W']     := BW*2;
                         Node.Attributes['H']     := BH;
                    end else begin
                         //<处理代码
                         slTmp     := TStringList.Create;
                         slTmp.Text     := Node.Attributes['Text'];
                         Node.Attributes['W']   := BW*2;
                         for iiCode:=0 to slTmp.Count-1 do begin
                              slTmp[iiCode]   := Trim(slTmp[iiCode]);
                              Node.Attributes['W']   := Max(Node.Attributes['W'],GetGPTextWidth(slTmp[iiCode]+'A   A'));
                         end;
                         //删除最后一行空行
                         if slTmp.Count>0 then begin
                              if slTmp[slTmp.Count-1]='' then begin
                                   slTmp.Delete(slTmp.Count-1);
                              end;
                         end;
                         //保存到变量
                         sText     := slTmp.Text;
                         iiCode     := slTmp.Count;
                         Node.Attributes['Text']  := slTmp.Text;
                         //
                         slTmp.Destroy;
                         //>


                         //计算长宽
                         Node.Attributes['H']   := Max(BH,GetGPTextHeight(Node.Attributes['Text']+#13+'AA'+#13+'AA'))+Sv;
                         //Node.Attributes['E']   := 0;
                         //取整
                         Node.Attributes['W']     := Round(Node.Attributes['W']);
                         Node.Attributes['H']     := Round(Node.Attributes['H']);
                    end;
               end else begin
                    Node.Attributes['W']     := BW*2;
                    Node.Attributes['H']     := BH;
               end;
          end else if (not (Node.Attributes['Expanded']))and (not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally])) then begin
               Node.Attributes['W']     := BW*2;
               Node.Attributes['H']     := BH;
          end else begin
               if Node.HasChildNodes then begin
                    xnChild   := Node.ChildNodes[0];
                    rChild    := GetNodeWHE(xnChild);
               end;
               //根据父块类型得到父块的W,H,E
               case Node.Attributes['Mode'] of
                    //<IF
                    rtIF : begin
                         xnExtra   := Node.ChildNodes[1];
                         rExtra    := GetNodeWHE(xnExtra);
                         //
                         Node.Attributes['W']     := rChild.W+rExtra.W;
                         Node.Attributes['H']     := Max(rChild.H, rExtra.H)+BH;
                    end;//IF>

                    //<For
                    rtFor : begin
                         Node.Attributes['W']     := rChild.W + SH;
                         Node.Attributes['H']     := rChild.H + BH;
                    end;
                    //For>

                    //<While
                    rtWhile : begin
                         Node.Attributes['W']     := rChild.W + SH;
                         Node.Attributes['H']     := rChild.H + BH;
                    end;
                    //While>

                    //<Repeat
                    rtRepeat : begin
                         Node.Attributes['W']     := rChild.W + SH;
                         Node.Attributes['H']     := rChild.H + BH;
                    end;
                    //Repeat>

                    //<Case
                    rtCase : begin
                         //对分支语句是否展开分开进行处理
                         for KK:=0 to Node.ChildNodes.Count-1 do begin
                              if KK=0 then begin
                                   xnChild   := Node.ChildNodes[0];
                                   rChild    := GetNodeWHE(xnChild);
                                   //
                                   Node.Attributes['W']     := rChild.W;
                                   Node.Attributes['H']     := rChild.H+BH;
                              end else begin
                                   xnChild   := Node.ChildNodes[KK];
                                   rChild    := GetNodeWHE(xnChild);
                                   //
                                   Node.Attributes['W']   := Node.Attributes['W']+rChild.W;
                                   Node.Attributes['H']   := Max(Node.Attributes['H'],rChild.H+BH);
                              end;
                         end;
                    end;
                    //Case>

                    //<rtCase_Item,rtCase_Default
                    rtCase_Item,rtCase_Default : begin
                         if (Node.HasChildNodes)and(Node.Attributes['Expanded']) then begin
                              if Node.Attributes['Expanded'] then begin
                                   for KK:=0 to Node.ChildNodes.Count-1 do begin
                                        if KK=0 then begin
                                             xnChild   := Node.ChildNodes[0];
                                             rChild    := GetNodeWHE(xnChild);
                                             Node.Attributes['W']   := rChild.W;
                                             Node.Attributes['H']   := rChild.H+BH;
                                        end else begin
                                             xnChild   := Node.ChildNodes[KK];
                                             rChild    := GetNodeWHE(xnChild);
                                             //
                                             Node.Attributes['W']   := Max(Node.Attributes['W'],rChild.W);
                                             Node.Attributes['H']   := Node.Attributes['H']+rChild.H;
                                        end;
                                   end;
                              end else begin //合拢状态
                                   Node.Attributes['W']   := BW*2;
                                   Node.Attributes['H']   := BH;
                              end;
                         end else begin //无子块
                              Node.Attributes['W']   := BW*2;
                              Node.Attributes['H']   := BH;
                         end;
                    end;
                    //rtCase_Item,rtCase_Default>

                    //<Try
                    rtTry : begin
                         for KK:=0 to Node.ChildNodes.Count-1 do begin
                              if KK=0 then begin
                                   xnChild   := Node.ChildNodes[0];
                                   rChild    := GetNodeWHE(xnChild);
                                   Node.Attributes['W']   := rChild.W+SH;
                                   Node.Attributes['H']   := rChild.H+BH;
                              end else begin
                                   xnChild   := Node.ChildNodes[KK];
                                   rChild    := GetNodeWHE(xnChild);
                                   //
                                   Node.Attributes['W']   := Max(Node.Attributes['W'],rChild.W+SH);
                                   Node.Attributes['H']   := Node.Attributes['H']+rChild.H;
                              end;
                         end;
                    end;
                    //Try>

                    //<Try_Except,Try_Finally
                    rtTry_Except,rtTry_Finally : begin
                         if Node.Attributes['Expanded'] then begin
                              for KK:=0 to Node.ChildNodes.Count-1 do begin
                                   if KK=0 then begin
                                        xnChild   := Node.ChildNodes[0];
                                        rChild    := GetNodeWHE(xnChild);
                                        Node.Attributes['W']   := rChild.W;
                                        Node.Attributes['H']   := rChild.H+BH;
                                   end else begin
                                        xnChild   := Node.ChildNodes[KK];
                                        rChild    := GetNodeWHE(xnChild);
                                        //
                                        Node.Attributes['W']   := Max(Node.Attributes['W'],rChild.W);
                                        Node.Attributes['H']   := Node.Attributes['H']+rChild.H;
                                   end;
                              end;
                         end else begin
                              Node.Attributes['W']   := BW*2;
                              Node.Attributes['H']   := BH*2;
                         end;
                    end;
                    //Try_Except,Try_Finally>


               else
                    //
                    for KK:=0 to Node.ChildNodes.Count-1 do begin
                         if KK=0 then begin
                              xnChild   := Node.ChildNodes[0];
                              rChild    := GetNodeWHE(xnChild);
                              Node.Attributes['W']   := rChild.W;
                              Node.Attributes['H']   := rChild.H;
                         end else begin
                              xnChild   := Node.ChildNodes[KK];
                              rChild    := GetNodeWHE(xnChild);
                              //
                              Node.Attributes['W']   := Max(Node.Attributes['W'],rChild.W);
                              Node.Attributes['H']   := Node.Attributes['H']+rChild.H;
                         end;
                    end;
               end; //end of case
          end;

          //
          Node.Attributes['E']     := 0;
          Result.W  := Node.Attributes['W'];
          Result.H  := Node.Attributes['H'];
          Result.E  := Node.Attributes['E'];
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
          sTxt := RTtoStr(Node.Attributes['Mode']);

          //<绘制子节点数为0的节点和合拢的节点
          if (Node.ChildNodes.Count=0) then begin
               //处理无子块节点(不包括跳转及分支)
               if (Node.Attributes['Mode']=rtBlock_Code)
                         and((Node.Attributes['ShowDetailCode']=1)or(grConfig.ShowDetailCode and (Node.Attributes['ShowDetailCode']<>2))) then begin
                    //节点(矩形)
                    DrawBlock(X,Y,W,H,Node.Attributes['Text'],False);
                    //
                    Exit;
               end else begin
                    if not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally]) then begin
                         //节点(矩形)
                         DrawBlock(X,Y,W,H,sTxt,False);
                         //
                         Exit;
                    end;
               end;
          end else if (not Node.Attributes['Expanded']) then begin
               //处理合拢的节点(不包括分支)
               if not InModes(Node.Attributes['Mode'],[rtCase_Item,rtCase_Default,rtTry_Except,rtTry_Finally]) then begin
                    //合拢节点(矩形)
                    DrawBlock(X,Y,W,H,sTxt,False);
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
                    oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,rChild.W*2,BH),oFormat,oFontBrh);
               end;

               //
               rtFOR : begin
                    //多段折线
                    DrawPoints([X,Y+H,  X,Y,  X+W,Y,  X+W,Y+H,  X+W-SH,Y+H]);
                    //写文字
                    oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               //
               rtWhile : begin
                    //多段折线
                    DrawPoints([X+SH,Y+H,  X,Y+H,  X,Y,  X+W,Y,  X+W,Y+BH]);
                    //写文字
                    oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               //
               rtRepeat : begin
                    //多段折线
                    DrawPoints([X+W-SH,Y,  X+W,Y,  X+W,Y+H,  X,Y+H,  X,Y+H-H]);
                    //写文字
                    oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y+H-BH,W,BH),oFormat,oFontBrh);
               end;

               //
               rtCase : begin
                    //方框
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+BH,  X,Y+BH,  X,Y]);
                    //两端斜线
                    DrawPoints([X,Y,  X+BH,Y+BH]);
                    DrawPoints([X+W,Y,  X+W-BH,Y+BH]);
                    //写文字
                    oGraph.DrawString(sTxt+' '+Node.Attributes['Name'],-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               rtCase_Item,rtCase_Default : begin
                    //多段折线
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+BH,  X,Y+BH,  X,Y]);
                    //含子块的框
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+H,  X,Y+H,  X,Y]);
                    //写文字
                    oGraph.DrawString(Node.Attributes['Name'],-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;

               //
               rtTry : begin
                    //多段折线
                    DrawPoints([X,Y,  X+W,Y,  X+W,Y+H,  X,Y+H,  X,Y]);
                    //写文字
                    oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
               end;
               //
               rtTry_Except,rtTry_Finally : begin
                    //多段折线
                    DrawPoints([X+W,Y,  X+W,Y+BH]);
                    //含子块的框
                    DrawPoints([X,Y+BH,  X+W,Y+BH,  X+W,Y+H,  X,Y+H,  X,Y+BH]);
                    //写文字
                    oGraph.DrawString(sTxt,-1,oFontB,MakeRect(X,Y,W,BH),oFormat,oFontBrh);
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



begin
     Result    := 0;

     //<得到流程图设置
     BW   := Config.BaseWidth*Config.Scale;
     BH   := Config.BaseHeight*Config.Scale;
     SH   := Config.SpaceHorz*Config.Scale;
     SV   := Config.SpaceVert*Config.Scale;
     oFont     := TGPFont.Create(Config.FontName, Config.FontSize*Config.Scale, FontStyleRegular, UnitPixel);
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

     //-----------------------------------计算各模块的大小----------------------------------------//
     //计算前先清除原来的WHE
     ClearNodeWHE(Node);
     //用递归来计算各模块的大小
     GetNodeWHE(Node);    

     //-----------------------------------计算各模块的位置----------------------------------------//
     //从第一个开始, 以当前块为父块, 计算当前块各子块的位置
     xnNode    := Node;
     xnNode.Attributes['X']   := SH;
     xnNode.Attributes['Y']   := BH+SV*2;
     SetNodePosition(xnNode);      //递归计算各模块的位置

     //绘制流程图的准备工作
     iImageW   := Round(Node.Attributes['W']+SH*2);
     iImageH   := Round(Node.Attributes['H']+Sv*2+2*(BH+SV));
     //
     Image.Width    := iImageW;
     Image.Height   := iImageH;
     Image.Picture.Bitmap.Width      := iImageW;
     Image.Picture.Bitmap.Height     := iImageH;
     Image.Picture.Assign(nil);

     //生成各种GDI+对象
     oGraph    := TGPGraphics.Create(Image.Canvas.Handle);
     oPen      := TGPPen.Create(ColorToGP(Config.LineColor),1);
     oFont     := TGPFont.Create(Config.FontName, Config.FontSize*Config.Scale, FontStyleRegular, UnitPixel);
     oFontB    := TGPFont.Create(Config.FontName, Config.FontSize*Config.Scale, FontStyleBold, UnitPixel);
     oFontBrh  := TGPSolidBrush.Create(ColorToGP(Config.FontColor));
     oBrush    := TGPSolidBrush.Create(ColorToGP(Config.FillColor));
     oPath     := TGPGraphicsPath.Create();
     oFormat   := TGPStringFormat.Create;
     oFormat.SetAlignment(StringAlignmentCenter);
     oFormat.SetLineAlignment(StringAlignmentCenter);
     //设置反失真
     oGraph.SetSmoothingMode(SmoothingModeAntiAlias);
     oGraph.SetTextRenderingHint(TextRenderingHintAntiAlias);



     //-----------------------绘制NS图(此后的代码应能共享)----------------------------------------//
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
     
end;



end.
