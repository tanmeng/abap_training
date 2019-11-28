*&---------------------------------------------------------------------*
*& Include          ZDINGTEST025D01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&　DATA
*&---------------------------------------------------------------------*

DATA:
  BEGIN OF GIT_MARD OCCURS 0,
    MATNR LIKE MARD-MATNR,   "品目コード
    WERKS LIKE MARD-WERKS,   "ブランド
    LGORT LIKE MARD-LGORT,   "保管場所
    LVORM LIKE MARD-LVORM,   "削除フラグ
    LABST LIKE MARD-LABST,   "利用可能評価在庫
    INSME LIKE MARD-INSME,   "品質検査中在庫
    MEINS LIKE MARA-MEINS,    "単位
  END   OF GIT_MARD,

*  GW_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
  GIT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
  GW_COMMENTARY  TYPE SLIS_LISTHEADER,
  GIT_COMMENTARY TYPE SLIS_T_LISTHEADER,
  GW_LAYOUT      TYPE SLIS_LAYOUT_ALV.
