unit XMLGenCodeRecords;

interface

type
     TGenOption = record
          AddCaption     : Boolean;     //显示标题为注释
          AddComment     : Boolean;     //显示注释
          WithComment    : Boolean;
          CommentStyle   : Byte;        //0:默认, 1:可回塑样式
          Indent         : Byte;        //代码缩进个数
     end;

implementation

end.
