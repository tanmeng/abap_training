*&---------------------------------------------------------------------*
*& Include          ZKAWA_TESTS01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* 選択画面定義
*----------------------------------------------------------------------*

PARAMETERS:
  P_MATNR TYPE ZKAWA_TEST1-MATNR       OBLIGATORY,   "品目コード
  P_TEXT  TYPE ZKAWA_TEST1-Z1KAWA_TEXT OBLIGATORY,   "品目テキスト
  P_SUU   TYPE ZKAWA_TEST1-Z1KAWA_SUU  OBLIGATORY,   "数量
  P_TANI  TYPE ZKAWA_TEST1-Z1KAWA_TANI OBLIGATORY,   "単位
  P_AMT   TYPE ZKAWA_TEST1-Z1KAWA_AMT  OBLIGATORY,   "金額
  P_MONT  TYPE ZKAWA_TEST1-Z1KAWA_MONT OBLIGATORY,   "月
  P_DATE  TYPE ZKAWA_TEST1-Z1KAWA_DATE OBLIGATORY,   "登録日
  P_BNAME TYPE ZKAWA_TEST1-BNAME       OBLIGATORY,   "ユーザー
  P_SPLD  TYPE ZKAWA_TEST1-SPLD        OBLIGATORY.   "デバイス
