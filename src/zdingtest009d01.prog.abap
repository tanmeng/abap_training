*&---------------------------------------------------------------------*
*& Include          ZDINGTEST009D01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& TYPES
*&---------------------------------------------------------------------*
TYPES:
  BEGIN OF TYP_MARA,            "品目マスタ
    MATNR TYPE  MARA-MATNR,     "品目コード
    ERSDA TYPE  MARA-ERSDA,     "登録日付
    ERNAM TYPE  MARA-ERNAM,     "オブジェクト登録者名
    LAEDA TYPE  MARA-LAEDA,     "最終変更日付
    AENAM TYPE  MARA-AENAM,     "オブジェクトの変更者名

  END OF TYP_MARA,

* 品目マスタ出力内部テーブル
  TYP_IT_MARA  TYPE STANDARD TABLE OF TYP_MARA.



*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*
DATA:
  GIT_MARA TYPE TYP_IT_MARA,    "品目の内部テーブル
  GW_MARA  TYPE TYP_MARA,
  GV_COUNT TYPE SY-DBCNT.
