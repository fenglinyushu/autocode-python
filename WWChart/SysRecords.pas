unit SysRecords;

interface

uses
     Types,Classes,Graphics;

type
     //保留字/关键字
     TWWWord = packed record
          Mode      : SmallInt;         //类型
          BegPos    : LongInt;          //起始位置
          EndPos    : LongInt;          //结束位置
          LinkID    : LongInt;          //相关联的Word位置
     end;
     TWWWords = array of TWWWord;


     //程序块
     TWWBlock = packed record
          Mode      : SmallInt;         //类型
          BegPos    : LongInt;          //起始位置
          EndPos    : LongInt;          //结束位置
          Parent    : Integer;          //父节点ID
          ChildIDs  : TIntegerDynArray; //子块ID数组
          Status    : Integer;          //状态, 0:展开,1:合拢
          BegMode   : Integer;
          EndMode   : Integer;
          LastMode  : Integer;          //最后一个词(除注释)的类型
          //LostBeg   : Integer;
          //LostEnd   : integer;
     end;
     TWWBlocks = array of TWWBlock;

     //绘图的基本设置
     TWWConfig = record
          Language       : Byte;        //语言
          Indent         : Byte;        //缩进
          RightMargin    : Word;
          //
          BaseWidth      : Integer;     //基本宽度
          BaseHeight     : Integer;     //基本高度
          AutoSize       : Boolean;     //是否自动扩大
          MaxWidth       : Integer;     //最大宽度
          MaxHeight      : Integer;     //最大高度
          SpaceVert      : Integer;     //纵向间距
          SpaceHorz      : Integer;     //横向间距
          FontName       : String;
          FontSize       : Byte;
          FontColor      : TColor;
          LineColor      : TColor;
          FillColor      : TColor;
          IFColor        : TColor;
          TryColor       : TColor;
          SelectColor    : TColor;
          Scale          : Single;      //缩放,默认为-1
          ShowDetailCode : Boolean;     //显示详细代码,默认为True
          //
          ChartType      : Byte;        //0:FlowChart, 1: NSChart
          AddCaption     : Boolean;     //生成代码时自动将Caption增加为注释
          AddComment     : Boolean;     //生成代码时自动增加注释
     end;


     TWWCode = record
          Mode      : Integer;
          Exts      : String;           //后缀名列表,用逗号分开,比如:"c,cpp"

     end;
     //
     PBlockInfo = ^TBlockInfo;
     TBlockInfo = packed record
          FileName  : WideString;  //文件名称, 主要用于交差引用
          //
          Text      : WideString;  //显示文本
          ID        : Integer;     //生成Blocks时Index
          BegEndID  : Integer;     //如果父类,Begin...end的ID,则大于0,否则为-1
          LastMode  : Integer;     //结尾的类型(除注释),用于粘贴/新建结构
          Mode      : SmallInt;    //节点类型
          BegPos    : Integer;     //起始位置
          EndPos    : Integer;     //结束位置
          ExtraBeg  : Integer;     //保存额外的起始位置, 用于删除函数时使用
          ExtraEnd  : Integer;     //
          Status    : Byte;        //节点状态, 目前用于显示展开代码
          //流程图参数
          X,Y,W,H,E : Single;      //X,Y位置,W,H大小,E向左额外的边距
     end;
     TSearchOption = record
          Keyword             : String;
          AtOnce              : Boolean;
          Mode                : Integer;
          FindInFiles         : Boolean;
          ForwardDirection    : Boolean;
          FromCursor          : Boolean;
          CaseSensitivity     : Boolean;
          WholeWord           : Boolean;
          CaptionOnly         : Boolean;
          RegularExpression   : Boolean;
     end;
     TBlockCopyMode = record
          Source    : Byte;   //0:表示原样复制,1:复制到Block_Set
          AddMode   : Byte;   //0:表示Next, 1: Before,  2: LastChild, 3.Prev of LastChild
                              //4: RootAppend, 5: FunctionAppend
     end;


implementation

end.
 