*&---------------------------------------------------------------------*
*& Report ZDINGTEST013
*&---------------------------------------------------------------------*
*&演習問題１１：ＤＢ検索（INNER JOIN）
*&---------------------------------------------------------------------*
REPORT ZDINGTEST013.

INCLUDE:
  ZDINGTEST013D01,   "データ定義
  ZDINGTEST013F01.   "ルーチン定義
*TEST

*ヘッダテキスト
TOP-OF-PAGE.

  WRITE:
    /   '品目コード',
    20  '登録者',
    40  '総重量',
    60  '重量単位',
    80  '評価レベル',
    100 '標準原価'.

  ULINE.
*&---------------------------------------------------------------------*
*&START-OF-SELECTION.
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM MAIN_PROC.