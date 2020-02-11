unit XMLPascal;

interface

uses
     XMLGenCodeRecords,
     SysConsts,
     //
     XMLDoc,XMLIntf,
     Classes,SysUtils;


//根据XML节点生成PASCAL代码
function GenXMLToPascal(xdXML:TXMLDocument;Option:TGenOption):string;

implementation

function GenNodeToCode(Node:IXMLNode;Option:TGenOption):string;
var
     slDM      : TStringList;
     slChild   : TStringList;
     I,J       : Integer;
     sIndent   : string;
     sCaption  : string;      //节点的Caption属性，但去除了其中的换行信息
     procedure AddChildCodeWithIndent(II:Integer);
     var
          JJ   : Integer;
     begin
          //添加子代码
          slChild   := TStringList.Create;
          slChild.Text   := GenNodeToCode(Node.ChildNodes[II],Option);
          //
          for JJ:=0 to slChild.Count-1 do begin
               slDM.Add(sIndent+slChild[JJ]);
          end;
          //
          slChild.Destroy;
     end;
     procedure AddChildCodeWithoutIndent(II:Integer);
     var
          JJ   : Integer;
     begin
          //添加子代码
          slChild   := TStringList.Create;
          slChild.Text   := GenNodeToCode(Node.ChildNodes[II],Option);
          //
          for JJ:=0 to slChild.Count-1 do begin
               slDM.Add(slChild[JJ]);
          end;
          //
          slChild.Destroy;
     end;
     procedure AddSpaceLine;
     begin
          if (slDM.Count>10)and(slDM[slDM.Count-1]<>'') then begin
               slDM.Add('');
          end;
     end;
begin
     if Node.HasAttribute('Enabled') then begin
          if not Node.Attributes['Enabled'] then begin
               Result    := '';
               Exit;
          end;
     end;

     //得到缩进字符串
     if (Option.Indent=0)or(Option.Indent>12) then begin
          Option.Indent  := 5;
     end;
     sIndent   := '';
     for I:=0 to Option.Indent-1 do begin
          sIndent   := sIndent+' ';
     end;

     //创建代码对象
     slDM := TStringList.Create;

     //得到sCaption
     sCaption  := Node.Attributes['Caption'];
     sCaption  := StringReplace(sCaption,#10,'',[rfReplaceAll]);
     sCaption  := Trim(StringReplace(sCaption,#13,'',[rfReplaceAll]));



     //添加名称作为注释的一部分
     if Option.AddCaption then begin
          if sCaption<>'' then begin
               slDM.Add('//'+sCaption);
          end;
     end;
     //添加注释
     if Option.AddComment then begin
          if Node.HasAttribute('Comment') then begin
               if Node.Attributes['Comment']<>'' then begin
                    slDM.Add('//'+Node.Attributes['Comment']);
               end;
          end;
     end;

     //生成代码
     case Node.Attributes['Mode'] of
          rtFile : begin

               //添加当前节点代码
               slDM.Add(Node.Attributes['Source']);
               slDM.Add('');

               //添加子代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
          end;
          rtFunc : begin

               //添加当前节点代码
               slDM.Add(Node.Attributes['Source']);
               slDM.Add('begin');

               //添加子代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithIndent(I);
               end;
               slDM.Add('end;');
               //
               if slDM[slDM.Count-1]<>'' then begin
                    slDM.Add('');
               end;
          end;

          rtBlock_Code,rtJump_Break,rtJump_Continue,rtJump_Exit : begin

               //添加当前节点代码
               slDM.Add(Trim(Node.Attributes['Source']));

               //
               AddSpaceLine;
          end;

          rtBlock_Set : begin
               slDM.Add('//[SET_BEGIN]'+Trim(Node.Attributes['Caption'])+'--------------------');
               //添加子代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
               //
               slDM.Add('//[SET_END]  '+Trim(Node.Attributes['Caption'])+'--------------------');
               AddSpaceLine;
          end;
          rtBlock_Body : begin
               //添加子代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
               //
               AddSpaceLine;
          end;

          rtIF : begin

               //添加当前节点代码
               slDM.Add('if '+trim(Node.Attributes['Source'])+' then begin');

               //添加YES子节点代码
               AddChildCodeWithIndent(0);

               //添加中间处理代码
               slDM.Add('end else begin');

               //添加ELSE子节点代码
               AddChildCodeWithIndent(1);

               //添加结束代码
               slDM.Add('end;  //end of IF ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtIF_Yes,rtIF_Else : begin
               //添加子代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
          end;

          rtFOR : begin
               //添加当前节点代码
               slDM.Add('for '+Trim(Node.Attributes['Source'])+' do begin');

               //添加子节点代码
               AddChildCodeWithIndent(0);

               //添加结束代码
               slDM.Add('end;  //end of FOR ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtWhile : begin
               //添加当前节点代码
               slDM.Add('while '+Trim(Node.Attributes['Source'])+' do begin');

               //添加子节点代码
               AddChildCodeWithIndent(0);

               //添加结束代码
               slDM.Add('end;  //end of WHILE ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtREPEAT : begin
               //添加当前节点代码
               slDM.Add('repeat');

               //添加子节点代码
               AddChildCodeWithIndent(0);

               //添加结束代码
               slDM.Add('until '+Trim(Node.Attributes['Source']));

               //
               AddSpaceLine;
          end;

          rtCASE : begin
               //添加当前节点代码
               slDM.Add('case '+Trim(Node.Attributes['Source'])+' of');

               //添加子节点代码(非default部分)
               for I:=0 to Node.ChildNodes.Count-2 do begin
                    AddChildCodeWithIndent(I);
               end;

               //
               slDM.Add('else');

               //添加default节点
               AddChildCodeWithIndent(Node.ChildNodes.Count-1);

               //添加结束代码
               slDM.Add('end;  //end of CASE ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtCase_Item : begin
               //添加当前节点代码
               slDM.Add(Trim(Node.Attributes['Source'])+' : begin');

               //添加子节点代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithIndent(I);
               end;

               //添加结束代码
               slDM.Add('end;  //end of CASE ITEM ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtCase_Default : begin

               //添加子节点代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;

               //
               AddSpaceLine;
          end;

          rtTRY : begin

               //添加当前节点代码
               slDM.Add('try ');

               //添加子节点代码
               AddChildCodeWithIndent(0);
               slDM.Add(Node.ChildNodes[1].Attributes['Source']);
               AddChildCodeWithIndent(1);

               //添加结束代码
               slDM.Add('end;  //end of TRY ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtTRY_Except : begin

               //添加子节点代码
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
               //
               AddSpaceLine;
          end;
     end;
     //slDM.Add('');  //空一行
     //
     Result    := slDM.Text;
     //
     slDM.Destroy;
end;

function GenXMLToPascal(xdXML:TXMLDocument;Option:TGenOption):string;
begin
     //无论如何，根节点是可有的
     xdXML.DocumentElement.Attributes['Enabled']  := True;
     Result    := GenNodeToCode(xdXML.DocumentElement,Option);
end;

end.
