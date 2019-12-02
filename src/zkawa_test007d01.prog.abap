*&---------------------------------------------------------------------*
*& Include          ZKAWA_TEST007D01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&　TYPES命令
*&---------------------------------------------------------------------*

TYPES:
* MARA参照構造データ型
  BEGIN OF TYP_MARA,
    MATNR TYPE MARA-MATNR,             "品目コード
    ERNAM TYPE MARA-ERNAM,             "登録者
    BRGEW TYPE MARA-BRGEW,             "総重量
    GEWEI TYPE MARA-GEWEI,             "重量単位
  END OF TYP_MARA,

  TYP_T_MARA TYPE STANDARD TABLE OF TYP_MARA,

* MBEW参照構造データ型
  BEGIN OF TYP_MBEW,
    MATNR TYPE MBEW-MATNR,             "品目コード
    BWKEY TYPE MBEW-BWKEY,             "評価レベル
    STPRS TYPE MBEW-STPRS,             "標準原価
  END OF TYP_MBEW,

  TYP_T_MBEW TYPE STANDARD TABLE OF TYP_MBEW.


*&---------------------------------------------------------------------*
*& データ定義
*&---------------------------------------------------------------------*

DATA:
*MARA型構造＆内部テーブル定義
  GIT_MARA TYPE TYP_T_MARA,            "内部テーブル定義
  LW_MARA  TYPE TYP_MARA,              "作業エリア定義

*MBEW型構造＆内部テーブル定義
  GIT_MBEW TYPE TYP_T_MBEW,            "内部テーブル定義
  LW_MBEW  TYPE TYP_MBEW,              "作業エリア定義

  GV_WAERS TYPE T001-WAERS.            "金額用変数
