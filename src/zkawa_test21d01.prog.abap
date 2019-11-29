*&---------------------------------------------------------------------*
*& Include          ZKAWA_TEST21D01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*
TYPE-POOLS:
  SLIS.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*
DATA:

* 品目の保管場所データ
  BEGIN OF GIT_MARD OCCURS 0,
    MATNR LIKE MARD-MATNR,                  "品目コード
    WERKS LIKE MARD-WERKS,                  "プラント
    LGORT LIKE MARD-LGORT,                  "保管場所
    LVORM LIKE MARD-LVORM,                  "削除フラグ
    LABST LIKE MARD-LABST,                  "利用可能評価在庫
    INSME LIKE MARD-INSME,                  "品質検査中在庫
    MEINS LIKE MARA-MEINS,                  "基本数量単位
  END   OF GIT_MARD,

* フィールドカタログ用
  GIT_FIELDCAT   TYPE SLIS_T_FIELDCAT_ALV,  "フィールドカタログ

* ヘッダー用
  GIT_COMMENTARY TYPE SLIS_T_LISTHEADER,    "ヘッダー用内部テーブル
  GW_COMMENTARY  TYPE SLIS_LISTHEADER,      "ヘッダー用構造

* レイアウト用
  GW_LAYOUT      TYPE SLIS_LAYOUT_ALV.      "レイアウト用構造
