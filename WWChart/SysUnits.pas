unit SysUnits;

interface

uses
     //
     SysConsts,SysRecords,SysVars,
     //
     GDIPAPI,
     //
     XMLDoc,XMLIntf, Types,ComCtrls,
     Math,Graphics,SysUtils,Dialogs,windows,Classes,ExtCtrls;


function  ModeToImageIndex(Mode:Integer):Integer;
function  InModes(Source:Integer;Ints:array of Integer):Boolean;
function  ColorToGp(C:TColor):Integer;
function  RTtoStr(RT,LanguageID:Integer):String;
function  FoundNodeByID(xFile:TXMLDocument;ID:Integer):IXMLNode; //在XML节点中查找属性ID为指定值的节点
function  GetFileFromDsp(sDsp:String):TStringDynArray;           //从VC的Dsp文件中得到工程的文件列表
function  GetXMLNodeFromTreeNode(XML:TXMLDocument;Node:TTreeNode):IXMLNode;       //从树节点，得到相应的XML节点
procedure SetNodeStatus(Node:TTreeNode;xnCur:IXMLNode);          //将树节点的开合状态信息写到XML节点中

implementation

procedure SetNodeStatus(Node:TTreeNode;xnCur:IXMLNode);
var
     I    : Integer;
begin
     xnCur.Attributes['Expanded']  := Node.Expanded;
     for I:=0 to Node.Count-1 do begin
          SetNodeStatus(Node.Item[I],xnCur.ChildNodes[I]);
     end;
end;


function  GetXMLNodeFromTreeNode(XML:TXMLDocument;Node:TTreeNode):IXMLNode;
var
     iIDs      : array of Integer; //用于保存Index序列
     //
     I,J,iHigh : Integer;
begin
     //默认
     Result    := nil;

     //得到Index序列
     SetLength(iIDs,0);
     while Node.Level>0 do begin
          SetLength(iIDs,Length(iIDs)+1);
          iIDs[High(iIDs)]    := Node.Index;
          //
          Node := Node.Parent;
     end;

     //得到节点
     Result    := XML.DocumentElement;
     for I:=High(iIDs) downto 0 do begin
          Result    := Result.ChildNodes[iIDs[I]];
     end;


end;

function  FoundNodeByID(xFile:TXMLDocument;ID:Integer):IXMLNode;
var
     xCur      : IXMLNode;
begin
     xCur := xFile.DocumentElement;

     //
     if ID=-1 then begin
          Result    := xCur;
          Exit;
     end;

     while xCur.Attributes['ID']<>ID do begin
          if xCur.ChildNodes.Count>0 then begin
               xCur     := xCur.ChildNodes[0];    //如果有子节点，则为第一子节点
          end else begin
               if xCur.ParentNode=nil then begin
                    Break;
               end;

               if xCur<>xCur.ParentNode.ChildNodes.Last then begin
                    xCur := xCur.NextSibling;
               end else begin
                    while True do begin
                         xCur     := xCur.ParentNode;

                         if xCur.ParentNode=nil then begin
                              Break;
                         end;

                         if xCur<>xCur.ParentNode.ChildNodes.Last then begin
                              xCur := xCur.NextSibling;
                              Break;
                         end;
                    end;
               end;
          end;
     end;
     //
     Result    := xCur;
end;


function  ModeToImageIndex(Mode:Integer):Integer;
begin
     Result    := -1;
     Case Mode of
          -1 : begin
               Result    := 0;
          end;
          rtFunc : begin
               Result    := 1;
          end;
          rtFor_Body,rtWhile_Body,rtRepeat_Body : begin
               Result    := 2;
          end;
          rtIF : begin
               Result    := 3;
          end;
          rtIF_Yes : begin
               Result    := 4;
          end;
          rtIF_ElseBody : begin
               Result    := 5;
          end;
          rtBlock_Code : begin
               Result    := 6;
          end;
          rtFor : begin
               Result    := 7;
          end;
          rtCase : begin
               Result    := 8;
          end;
          rtCase_Item : begin
               Result    := 9;
          end;
          rtCase_Default : begin
               Result    := 10;
          end;
          rtRepeat : begin
               Result    := 11;
          end;
          rtWhile : begin
               Result    := 12;
          end;
          rtTry : begin
               Result    := 13;
          end;
          rtTry_Except,rtTry_Except_Body : begin
               Result    := 14;
          end;
          rtTry_Finally : begin
               Result    := 15;
          end;
          rtBlock_With, rtTry_Body : begin
               Result    := 16;
          end;
          //
          rtJUMP_Break : begin
               Result    := 17;
          end;
          rtJUMP_Continue : begin
               Result    := 18;
          end;
          rtJUMP_Exit : begin
               Result    := 19;
          end;

     end;
end;

function  InModes(Source:Integer;Ints:array of Integer):Boolean;
var
     I    : Integer;
begin
     Result    := False;
     for I:=0 to High(Ints) do begin
          if Source=Ints[I] then begin
               Result    := True;
               break;
          end;
     end;
end;
function  ColorToGp(C:TColor):Integer;
begin
     C    := ColorToRGB(C);
     Result    := MakeColor(255,GetRValue(C),GetGValue(C),GetBValue(C));
end;

function RTtoStr(RT,LanguageID:Integer):String;
begin
     Result    := '';
     case RT of
          -1 : begin
               Result    := 'FILE';
          end;
          rtIF : begin
               Result    := 'IF';
          end;
          rtIF_Yes : begin
               Result    := 'YES';
          end;
          rtIF_Expr : begin
               Result    := 'IF_EXPR';
          end;
          rtIF_Else : begin
               Result    := 'ELSE';
          end;
          rtIF_ElseBody : begin
               Result    := 'NO';
          end;
          rtFor : begin
               Result    := 'FOR';
          end;
          rtFor_Body,rtWhile_Body,rtRepeat_Body : begin
               Result    := 'Circle';
          end;
          rtWhile : begin
               Result    := 'WHILE';
          end;
          rtWHILE_Expr : begin
               Result    := 'WHILE_Expr';
          end;
          rtCase : begin
               Result    := 'SWITCH';
          end;
          rtCase_Item : begin
               Result    := 'Case_Item';
          end;
          rtCase_Default : begin
               Result    := 'Case_Default';
          end;
          rtRepeat : begin
               Result    := 'DO-WHILE';
          end;
          rtTRY : begin
               Result    := 'TRY';
          end;
          rtTry_Body : begin
               Result    := 'TRY-BODY';
          end;
          rtTry_Except : begin
               Result    := 'CATCH';
          end;
          rtTry_Finally : begin
               Result    := 'FINALLY';
          end;
          rtBlock_Code : begin
               Result    := 'Code';
          end;
          rtJUMP_Break : begin
               Result    := 'Break';
          end;
          rtJUMP_Continue : begin
               Result    := 'Continue';
          end;
          rtJUMP_Exit : begin
               Result    := 'Return';
          end;
          rtJUMP_Goto : begin
               Result    := 'Goto';
          end;
          rtFunc : begin
               Result    := 'Function'
          end;

     else
          Result    := 'UNDEF '+IntToStr(RT);
     end;
{
          end;//end of loC

          loDelphi : begin
               case RT of
                    rtIF : begin
                         Result    := 'IF';
                    end;
                    rtIF_Yes : begin
                         Result    := 'YES';
                    end;
                    rtIF_Expr : begin
                         Result    := 'IF_EXPR';
                    end;
                    rtIF_Else : begin
                         Result    := 'ELSE';
                    end;
                    rtIF_ElseBody : begin
                         Result    := 'NO';
                    end;
                    rtFor : begin
                         Result    := 'FOR';
                    end;
                    rtFor_Body,rtWhile_Body,rtRepeat_Body : begin
                         Result    := 'Circle';
                    end;
                    rtWhile : begin
                         Result    := 'WHILE';
                    end;
                    rtBlock_With : begin
                         Result    := 'WITH';
                    end;
                    rtCase : begin
                         Result    := 'CASE';
                    end;
                    rtCase_Item : begin
                         Result    := 'Case_Item';
                    end;
                    rtCase_Default : begin
                         Result    := 'Case_Default';
                    end;
                    rtRepeat : begin
                         Result    := 'REPEAT-UNTIL';
                    end;
                    rtTRY : begin
                         Result    := 'TRY';
                    end;
                    rtTry_Except : begin
                         Result    := 'CATCH';
                    end;
                    rtTry_Finally : begin
                         Result    := 'FINALLY';
                    end;
                    rtBlock_Code : begin
                         Result    := 'Code';
                    end;
                    rtJUMP_Break : begin
                         Result    := 'Break';
                    end;
                    rtJUMP_Continue : begin
                         Result    := 'Continue';
                    end;
                    rtJUMP_Exit : begin
                         Result    := 'Exit';
                    end;
                    rtJUMP_Goto : begin
                         Result    := 'Goto';
                    end;
               else
                    Result    := 'UNDEF'+IntToStr(RT);
               end;
          end;//end of case item

     end;
}
end;

function  GetFileFromDsp(sDsp:String):TStringDynArray; //从VC的Dsp文件中得到工程的文件列表
var
     sDir      : string;
     slTmp     : TStringList;
     I         : Integer;
     sLn       : string;
     sExt      : string;
begin
     //默认返回值
     SetLength(Result,0);

     //如果文件不存在，则退出
     if not FileExists(sDsp) then begin
          Exit;
     end;

     //
     try
          //
          slTmp     := TStringList.Create;
          slTmp.LoadFromFile(sDsp);
          sDir := ExtractFilePath(sDsp);     //得到目录
          ChDir(sDir);

          //逐行查找文件
          for I:=0 to slTmp.Count-1 do begin
               sLn  := slTmp[I];
               if Copy(sLn,1,7)='SOURCE=' then begin
                    Delete(sLn,1,7);
                    if FileExists(sDir+sLn) then begin
                         sExt := LowerCase(ExtractFileExt(sDir+sLn));
                         if (sExt='.c')or(sExt='.cpp') then begin
                              //
                              SetLength(Result,Length(Result)+1);
                              Result[High(Result)]     := sDir+sLn;
                         end;
                    end;
               end;
          end;
     finally
          slTmp.Destroy;
     end;

end;

end.
