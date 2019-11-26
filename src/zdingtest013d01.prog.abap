*&---------------------------------------------------------------------*
*& Include          ZDINGTEST013D01
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
    BWKEY TYPE MBEW-BWKEY,  "評価レベル
    STPRS TYPE MBEW-STPRS,  "標準原価
  END   OF TYP_MARA.

*&---------------------------------------------------------------------*
*&DATA
*&---------------------------------------------------------------------*

DATA:
  GW_MABW  TYPE TYP_MARA,   "構造定義
  GIT_MABW TYPE STANDARD TABLE OF TYP_MARA,
  GV_VALUE TYPE T001-WAERS. "通貨コード
