*&---------------------------------------------------------------------*
*& Report ZDINGTEST009
*&---------------------------------------------------------------------*
*&演習問題８：ＤＢ検索（複数レコード）
*&---------------------------------------------------------------------*
REPORT ZDINGTEST009.

  INCLUDE:
    ZDINGTEST009D01,  "データ定義
    ZDINGTEST009F01.  "ルーチン定義


TOP-OF-PAGE.
  WRITE:
    /  '品目コード',
    20 '登録日',
    40 '登録者',
    60 '変更日',
    80 '変更者'.
  ULINE.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM MAIN_PROC.
