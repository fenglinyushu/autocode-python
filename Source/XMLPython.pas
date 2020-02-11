unit XMLPython;

interface

uses
     XMLGenCodeRecords,
     SysConsts,
     //
     XMLDoc,XMLIntf,
     Classes,SysUtils;


//����XML�ڵ�����C/Cpp����
function GenXMLToPython(xdXML:TXMLDocument;Option:TGenOption):string;

implementation

function GenNodeToCode(Node:IXMLNode;Option:TGenOption):string;
var
     slDM      : TStringList;
     slChild   : TStringList;
     I,J       : Integer;
     sIndent   : string;
     sCaption  : string;      //�ڵ��Caption���ԣ���ȥ�������еĻ�����Ϣ
     //
     xnElse    : IXMLNode;
     xnParent  : IXMLNode;

     procedure AddChildCodeWithIndent(II:Integer);
     var
          JJ   : Integer;
     begin
          //�����Ӵ���
          slChild   := TStringList.Create;
          slChild.Text   := GenNodeToCode(Node.ChildNodes[II],Option);
          //
          if slChild.Count = 0 then begin
               slDM.Add(sIndent+'pass');
          end else begin
               for JJ:=0 to slChild.Count-1 do begin
                    slDM.Add(sIndent+slChild[JJ]);
               end;
          end;
          //
          slChild.Destroy;
     end;
     procedure AddChildCodeWithoutIndent(II:Integer);
     var
          JJ   : Integer;
     begin
          //�����Ӵ���
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
     //�����ǰ�ڵ㲻ʹ�ܣ������ɴ���
     if Node.HasAttribute('Enabled') then begin
          if not Node.Attributes['Enabled'] then begin
               Result    := '';
               Exit;
          end;
     end;

     //�õ������ַ���
     if (Option.Indent=0)or(Option.Indent>12) then begin
          Option.Indent  := 5;
     end;
     sIndent   := '';
     for I:=0 to Option.Indent-1 do begin
          sIndent   := sIndent+' ';
     end;

     //�����������
     slDM := TStringList.Create;

     //�õ�sCaption
     sCaption  := Node.Attributes['Caption'];
     sCaption  := StringReplace(sCaption,#10,'',[rfReplaceAll]);
     sCaption  := Trim(StringReplace(sCaption,#13,'',[rfReplaceAll]));

     //����������Ϊע�͵�һ����
     if Option.AddCaption then begin
          if sCaption<>'' then begin
               slDM.Add('# '+sCaption);
          end;
     end;
     //����ע��
     if Option.AddComment then begin
          if Node.HasAttribute('Comment') then begin
               if Node.Attributes['Comment']<>'' then begin
                    slDM.Add('# '+Node.Attributes['Comment']);
               end;
          end;
     end;

     //���ɴ���
     case Node.Attributes['Mode'] of
          rtFile : begin

               //���ӵ�ǰ�ڵ����
               slDM.Add('');

               //�����Ӵ���
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
          end;
          rtFunc : begin

               //���ӵ�ǰ�ڵ����
               slDM.Add('def '+Node.Attributes['Caption']+':');

               //�����Ӵ���
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithIndent(I);
               end;
               //
               if slDM[slDM.Count-1]<>'' then begin
                    slDM.Add('');
               end;
          end;
          rtClass : begin

               //���ӵ�ǰ�ڵ����
               slDM.Add('class '+Node.Attributes['Caption']+':');

               //�����Ӵ���
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithIndent(I);
               end;
               //
               if slDM[slDM.Count-1]<>'' then begin
                    slDM.Add('');
               end;
          end;

          rtBlock_Code,rtJump_Break,rtJump_Continue,rtJump_Exit : begin

               //���ӵ�ǰ�ڵ����
               slDM.Add(Node.Attributes['Source']);

               //
               AddSpaceLine;
          end;

          rtBlock_Set,rtBlock_Body : begin
               //�����Ӵ���
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
               //
               AddSpaceLine;
          end;

          rtIF : begin
               //���ӵ�ǰ�ڵ����
               slDM.Add('if '+Node.Attributes['Source']+':');

               //
               AddChildCodeWithIndent(0);

               //�����ӽڵ����
               for I:=1 to Node.ChildNodes.Count-1 do begin
                    if Node.ChildNodes[I].Attributes['Mode'] = rtIF_ElseIf then begin
                         slDM.Add('elif '+Node.ChildNodes[I].Attributes['Source']+':');
                    end else begin
                         slDM.Add('else:');
                    end;

                    AddChildCodeWithIndent(I);
               end;

               {
               //����ELSE����
               xnElse    := Node.ChildNodes[1];
               if xnElse.ChildNodes.Count>0 then begin
                    if (xnElse.ChildNodes.Count=1) and (xnElse.ChildNodes[0].Attributes['Mode']=rtIF) then begin
                         slDM.Add('elif '+xnElse.ChildNodes[0].Attributes['Source']+':');

                         //����ELSE�ӽڵ����
                         AddChildCodeWithIndent(1);
                    end else begin
                         slDM.Add('else:');

                         //����ELSE�ӽڵ����
                         AddChildCodeWithIndent(1);
                    end;
               end;
               }

               //
               AddSpaceLine;
          end;

          rtIF_Yes,rtIF_Else,rtIF_ElseIF : begin
               //�����Ӵ���
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
          end;

          rtFOR : begin

               //���ӵ�ǰ�ڵ����
               slDM.Add('for '+Node.Attributes['Source']+':');

               //�����ӽڵ����
               AddChildCodeWithIndent(0);

               //
               AddSpaceLine;
          end;

          rtWhile : begin
               //���ӵ�ǰ�ڵ����
               slDM.Add('while '+Node.Attributes['Source']+':');

               //�����ӽڵ����
               AddChildCodeWithIndent(0);

               //
               AddSpaceLine;
          end;

          rtREPEAT : begin
               //���ӵ�ǰ�ڵ����
               slDM.Add('do');
               slDM.Add('{');

               //�����ӽڵ����
               AddChildCodeWithIndent(0);

               //���ӽ�������
               slDM.Add('} while ('+Node.Attributes['Source']+');');

               //
               AddSpaceLine;
          end;

          rtCASE : begin
               //���ӵ�ǰ�ڵ����
               slDM.Add('switch ('+Node.Attributes['Source']+')');
               slDM.Add('{');

               //�����ӽڵ����(��default����)
               for I:=0 to Node.ChildNodes.Count-2 do begin
                    AddChildCodeWithIndent(I);
               end;

               //
               slDM.Add(sIndent+'default :');

               //����default�ڵ�
               AddChildCodeWithIndent(Node.ChildNodes.Count-1);

               //���ӽ�������
               slDM.Add('};  //end of switch ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtCase_Item : begin
               //���ӵ�ǰ�ڵ����
               slDM.Add('case '+Node.Attributes['Source']+' : ');
               slDM.Add('{');

               //�����ӽڵ����
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithIndent(I);
               end;

               //���ӽ�������
               slDM.Add('};  //end of CASE ITEM ['+sCaption+']');

               //
               AddSpaceLine;
          end;

          rtCase_Default : begin

               //�����ӽڵ����
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithIndent(I);
               end;

               //
               AddSpaceLine;
          end;

          rtTRY : begin

               //���ӵ�ǰ�ڵ����
               slDM.Add('try: ');

               //�����ӽڵ����
               AddChildCodeWithIndent(0);

               //except
               for I := 1 to Node.ChildNodes.Count-2 do begin
                    slDM.Add('except '+Node.ChildNodes[I].Attributes['Source']+':');
                    AddChildCodeWithIndent(I);
               end;

               //
               slDM.Add('else: ');
               AddChildCodeWithIndent(Node.ChildNodes.Count-1);

               //
               AddSpaceLine;
          end;

          rtTRY_Except : begin

               //�����ӽڵ����
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
               //
               AddSpaceLine;
          end;

          rtTRY_Else : begin

               //�����ӽڵ����
               for I:=0 to Node.ChildNodes.Count-1 do begin
                    AddChildCodeWithoutIndent(I);
               end;
               //
               AddSpaceLine;
          end;
     end;
     //slDM.Add('');  //��һ��
     //
     Result    := slDM.Text;
     //
     slDM.Destroy;
end;

function GenXMLToPython(xdXML:TXMLDocument;Option:TGenOption):string;
begin
     //������Σ����ڵ��ǿ��е�
     xdXML.DocumentElement.Attributes['Enabled']  := True;
     Result    := GenNodeToCode(xdXML.DocumentElement,Option);
end;

end.