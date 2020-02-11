unit XMLUnits;

interface

uses
     XMLDoc,XMLIntf,Classes,
     Dialogs,Variants;

procedure CopyXMLNode(Source,Dest:IXMLNode); //递归复制XML节点

procedure CopyXMLNodeFromText(Dest:IXMLNode;Text:WideString);   //从源节点的Text中得到目标节点的属性和子节点

function  GetXMLNodeIndex(Node:IXMLNode):Integer; //取得节点Index

implementation

procedure CopyXMLNodeFromText(Dest:IXMLNode;Text:WideString);   //从源节点的Text中得到目标节点的属性和子节点
var
     xdXML     : IXMLDocument;
     ssText    : TStringStream;
begin
     //生成XML
     ssText    := TStringStream.Create(Text);
     xdXML     := TXMLDocument.Create(nil);
     xdXML.Active   := True;
     xdXML.LoadFromStream(ssText);
     ssText.Destroy;

     //复制节点
     CopyXMLNode(xdXML.DocumentElement,Dest);

     //
     xdXML     := nil;

end;

function  GetXMLNodeIndex(Node:IXMLNode):Integer; //取得节点Index
var
     I    : Integer;
begin
     Result    := -1;
     for I:=0 to Node.ParentNode.ChildNodes.Count-1 do begin
          if Node.ParentNode.ChildNodes[I]=Node then begin
               Result    := I;
               Break;
          end;
     end;
end;


procedure CopyXMLNode(Source,Dest:IXMLNode); //递归复制XML节点
var
     I,J       : Integer;
     xnNew     : IXMLNode;
     sName     : string;
     sValue    : string;
begin

     //复制属性
     for I:=0 to Source.AttributeNodes.Count-1 do begin
          sName     := Source.AttributeNodes[I].NodeName;
          if Source.AttributeNodes[I].NodeValue=null then begin
               sValue    := '';
          end else begin
               sValue    := Source.AttributeNodes[I].NodeValue;
          end;
          Dest.Attributes[sName]   := sValue;
     end;


     //复制子节点
     for I:=0 to Source.ChildNodes.Count-1 do begin
          xnNew     := Dest.AddChild(Source.ChildNodes[I].NodeName);
          CopyXMLNode(Source.ChildNodes[I],Dest.ChildNodes[I]);
     end;
end;

end.
