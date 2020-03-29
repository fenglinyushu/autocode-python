unit sysRecords;

interface

uses
     Types,Graphics;

type
     PFCBlock = ^TFCBlock;
     TFCBlock = packed record
          ID        : Integer;
          PID       : Integer;
          Index     : SmallInt;
          Mode      : SmallInt;
          Level     : SmallInt;
          Enabled   : Boolean;
          Name      : String;
          Item0     : String;
          Item1     : String;
     end;
     TDFCOption = record
          Mode      : Byte;        //0:流程图,1:NS图
          BW        : Byte;        //最小流程框的宽度一半
          BH        : Byte;        //最小流程框的高度
          SV        : Byte;        //纵向间距
          SH        : Byte;        //横向间隔
          WholeExpr : Boolean;     //IF等表达式是否显示全部字符
          Commented : Boolean;     //是否显示注释
          CodeMode  : Byte;        //0:单行,1:五行,2:全代码
     end;
     TDFCNode = record
          X,Y       : Integer;
          Width     : Integer;
          Height    : Integer;
          Offset    : Integer;
          Text      : String;      //
          Comment   : String;      //注释
     end;

     TProjOption = record
          Language  : Integer;
          Compile   : Integer;
          Bat       : Integer;
          Comment   : Integer;
          Indent    : Integer;
     end;
     TNodeChange = record
          AbsID     : Integer;
          Text      : String;
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
     TFavoriteNode = record
          DataID    : Integer;
          Comment   : String;
     end;
     //绘图的基本设置
     TWWConfig = record
          Language       : Byte;        //语言
          TabStops       : Byte;
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
     end;
     TACSearchOption = record
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
     

implementation

end.
