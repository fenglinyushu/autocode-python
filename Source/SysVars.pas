unit SysVars;
{
本单元包含系统全部的全局变量
}

//{$DEFINE ISOEM}

interface

uses
     //自编模块
     SysRecords,SysConsts,
     XMLGenCodeRecords,

     //
     JsonDataObjects,

     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, ImgList, ToolWin,
     Math, Spin, IniFiles, Grids, ExtDlgs,  Menus;
type
     //当前打开的文件结构
     TWWFile = record
          Name      : String;                     //当前程序的文件名,不含路径名
          Path      : String;                     //文件目录名,含最后的\
          CodeType  : Integer;                    //0:C,1:Pascal
          Changed   : Boolean;                    //文件是否已更改
          FuncNames : array of string;            //当前文件的简洁函数名列表
          FileTime  : TDateTime;
     end;
var
     //----------------------------基本变量-------------------------------------------------------//
     gsMainDir      : string;      //系统的初始运行目录


     //----------------------------程序块---------------------------------------------------------//
     grFiles        : array of TWWFile;                   //打开的文件数组
     giCurCodeType  : Integer;
     //grBlocks       : TWWBlocks;   //所有程序块数组
     giOldBlockID   : Integer=-1;  //保存上次的程序块数组

     //----------------------------编辑器设置-----------------------------------------------------//
     giTabStops     : Integer=5;   //代码缩进量
     giRightMargin  : Integer=80;  //代码右边界显示位置

     //----------------------------流程图设置-----------------------------------------------------//
     giColor_Line   : TColor;      //流程图中线和颜色
     giColor_If     : TColor;      //判断框的颜色
     giColor_Fill   : TColor;      //框的填充颜色
     giColor_Try    : TColor;      //Try框的颜色
     giColor_Select : TColor;      //选择时的颜色
     giColor_Font   : TColor;      //字体颜色
     giColor_Flow   : TColor=clGreen;   //动态流程的颜色
     giFontName     : String='Small Fonts';  //字体名称
     giFontSize     : Byte=6;      //字体大小,默认为6
     giBaseWidth    : Integer=60;  //基本框的宽度的一半(为了便于绘图控制)
     giBaseHeight   : Integer=20;  //基本框的高度
     giSpaceH       : Integer=10;  //横向间隔
     giSpaceV       : Integer=20;  //纵向间隔
     giImgWidth     : Integer=200; //流程图的原始宽和高,主要用于流程图缩放
     giImgHeight    : Integer=200;

     grConfig       : TWWConfig;   //绘制流程图的设置
     grOption       : TGenOption;

     //
     giMaxWidth     : Integer=4000;//图片最大宽度，用于解决内存不足的问题
     giMaxHeight    : Integer=8000;//图片最大高度

     gbRegistered   : Boolean=True;

     //
     gjoProject     : TJsonObject;
     gjoModules     : TJsonObject;
     gjoChartRoot   : TJsonObject;
     //
     gsProjectName  : string = '';

     //
     gbShowDetailCode    : Boolean = False;
     gbModified          : Boolean = False;  //文件是否已被修改



const
     gsName         : string = 'AutoCode - Python';
     gsHomePage     : String = 'http://www.web0000.com';
     gsMail         : String = 'fenglinyushu@163.com';

 
implementation



end.
