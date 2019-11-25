*&---------------------------------------------------------------------*
*& Include          ZKAWA_TESTD02
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*

TYPES:
  BEGIN OF TYP_W_ZKAWA1,
    MANDT TYPE ZKAWA_TEST1-MANDT,              "クライアント
    MATNR TYPE ZKAWA_TEST1-MATNR,              "品目コード
    TEXT  TYPE ZKAWA_TEST1-Z1KAWA_TEXT,        "品目テキスト
    SUU   TYPE ZKAWA_TEST1-Z1KAWA_SUU,         "数量
    TANI  TYPE ZKAWA_TEST1-Z1KAWA_TANI,        "単位
    AMT   TYPE ZKAWA_TEST1-Z1KAWA_AMT,         "金額
    MONT  TYPE ZKAWA_TEST1-Z1KAWA_MONT,        "月
    DATE  TYPE ZKAWA_TEST1-Z1KAWA_DATE,        "登録日
    BNAME TYPE ZKAWA_TEST1-BNAME,              "ユーザー
    SPLD  TYPE ZKAWA_TEST1-SPLD,               "デバイス
  END   OF TYP_W_ZKAWA1.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*

DATA:
  GW_ZKAWA1 TYPE TYP_W_ZKAWA1.                 "構造
