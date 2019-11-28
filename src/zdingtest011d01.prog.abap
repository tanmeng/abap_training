*&---------------------------------------------------------------------*
*& Include          ZDINGTEST011D01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&TYPES
*&---------------------------------------------------------------------*
TYPES:
  BEGIN OF TYP_MARA,
    MATNR TYPE MARA-MATNR,  "品目コード
    ERNAM TYPE MARA-ERNAM,  "オブジェクト登録者名
    BRGEW TYPE MARA-BRGEW,  "総重量
    GEWEI TYPE MARA-GEWEI,  "重量単位

  END OF TYP_MARA,

  TYP_T_MARA TYPE STANDARD TABLE OF TYP_MARA,

  BEGIN OF TYP_MBEW,
    MATNR TYPE MBEW-MATNR,  "品目コード
    BWKEY TYPE MBEW-BWKEY,  "評価レベル
    STPRS TYPE MBEW-STPRS,  "標準原価
  END   OF TYP_MBEW,

  TYP_T_MBEW TYPE STANDARD TABLE OF TYP_MBEW.



*&---------------------------------------------------------------------*
*&DATA
*&---------------------------------------------------------------------*

DATA:
  GW_MARA   TYPE TYP_MARA,   "構造定義
  GIT_MARA  TYPE TYP_T_MARA,"内部テーブル定義
  GW_MBEW   TYPE TYP_MBEW,
  GIT_MBEW  TYPE TYP_T_MBEW,
  GV_WAERS  TYPE T001-WAERS."通貨
