unit ACBaseUnits;

interface

uses
     //
     SysConsts,

     //
     XMLDoc,XMLIntf,SysUtils,ComCtrls;

function  GetXMLNodeFromTreeNode(XML:TXMLDocument;Node:TTreeNode):IXMLNode;       //从树节点，得到相应的XML节点
function  InModes(Source:Integer;Ints:array of Integer):Boolean;
function  GetTreeNodeFromXMLNode(TV:TTreeView;Node:IXMLNode):TTreeNode;


implementation

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





function  GetTreeNodeFromXMLNode(TV:TTreeView;Node:IXMLNode):TTreeNode;
var
     iIDs      : array of Integer; //用于保存Index序列
     //
     I,J,iHigh : Integer;
     xnPar     : IXMLNode;
     iIndex    : Integer;
begin
     try
          //默认
          Result    := nil;

          //得到Index序列
          SetLength(iIDs,0);
          while Node.ParentNode<>nil do begin
               //
               xnPar     := Node.ParentNode;

               //
               if xnPar = nil then begin
                    Break;
               end;

               //得到当前节点在父节点的Index
               iIndex    := 0;
               for I:=0 to xnPar.ChildNodes.Count-1 do begin
                    if xnPar.ChildNodes[I]=Node then begin
                         iIndex    := I;
                         Break;
                    end;
               end;

               //保存到数组
               SetLength(iIDs,Length(iIDs)+1);
               iIDs[High(iIDs)]    := iIndex;

               //
               Node := Node.ParentNode;
          end;

          //得到节点
          Result    := TV.Items[0];
          for I:=High(iIDs)-1 downto 0 do begin
               Result    := Result.Item[iIDs[I]];
          end;
     except

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


end.
