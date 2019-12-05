*&---------------------------------------------------------------------*
*& Report ZDINGTEST025
*&---------------------------------------------------------------------*
*&　ALV 演習問題3
*&---------------------------------------------------------------------*
REPORT ZDINGTEST026.

INCLUDE:
  ZDINGTEST026D01,            "データ定義
  ZDINGTEST026S01,            "画面定義
  ZDINGTEST026F01.            "ルーチン定義


START-OF-SELECTION.


  PERFORM F_SEL_DATA.           "MARD.MARAテーブルから内部テーブルに格納
  PERFORM F_SET_HEAD.           "ALVヘッダー編集
  PERFORM F_SET-LAYOUT.         "レイアウト
  PERFORM F_MDL_GET_FIELDCAT.   "カタログ情報取得
  PERFORM F_MDL_OUTPUT_ALV.     "画面表示
