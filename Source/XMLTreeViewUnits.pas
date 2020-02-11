unit XmlTreeViewUnits;

interface

uses
     //
     SysUnits,
     //
     XMLDoc,XMLIntf,Dialogs,SysUtils,
     ComCtrls;

procedure XmlToTreeView(XML:TXMLDocument;TV:TTreeView);
procedure AddXmlNodeToTV(xnNode:IXMLNode;tnNode:TTreeNode);


implementation

procedure AddXmlNodeToTV(xnNode:IXMLNode;tnNode:TTreeNode);
var
     I         : Integer;
     xnChild   : IXMLNode;
     tnNew     : TTreeNode;
     sText     : string;
begin
     for I:=0 to xnNode.ChildNodes.Count-1 do begin
          //得到XML子节点
          xnChild   := xnNode.ChildNodes[I];
          //
          if not xnChild.HasAttribute('Caption') then begin
               xnChild.Attributes['Caption'] := '';
          end;
          //
          sText     := Trim(xnChild.Attributes['Caption']);
          if sText = '' then begin
               sText     := Trim(xnChild.Attributes['Comment']);
          end;
          if sText = '' then begin
               sText     := Trim(xnChild.Attributes['Source']);
          end;
          if sText = '' then begin
               sText     := RTtoStr(xnChild.Attributes['Mode']);
          end;

          //添加子节点
          tnNew     := TTreeView(tnNode.TreeView).Items.AddChild(tnNode,sText);
          tnNew.ImageIndex    := ModeToImageIndex(xnChild.Attributes['Mode']);
          tnNew.SelectedIndex := tnNew.ImageIndex;
          //tnNew.Data     := Pointer(Integer(xnChild.Attributes['ID']));
          //递归调用
          AddXmlNodeToTV(xnChild,tnNew);
     end;
end;


procedure XmlToTreeView(XML:TXMLDocument;TV:TTreeView);
var
     I    : Integer;
     xNode     : IXMLNode;
begin
     //
     TV.Items.Clear;

     //
     TV.Items.Add(nil,XML.DocumentElement.Attributes['Caption']);
     
     //递归添加节点
     AddXmlNodeToTV(XML.DocumentElement,TV.Items[0]);

end;

end.
