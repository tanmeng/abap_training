*&---------------------------------------------------------------------*
*& Report ZDINGTEST025
*&---------------------------------------------------------------------*
*&　ALV 演習問題２
*&---------------------------------------------------------------------*
REPORT ZDINGTEST025.

INCLUDE:
  ZDINGTEST025D01,            "データ定義
  ZDINGTEST025S01,            "画面定義
  ZDINGTEST025F01.            "ルーチン定義


START-OF-SELECTION.


  PERFORM SEL_DATA.           "MARD.MARAテーブルから内部テーブルに格納
  PERFORM SET_HEAD.           "ALVヘッダー編集
  PERFORM SET-LAYOUT.         "レイアウト
  PERFORM F_GET_FIELDCAT.     "カタログ情報取得
  PERFORM F_OUTPUT_ALV.       "画面表示
