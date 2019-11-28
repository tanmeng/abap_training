*----------------------------------------------------------------------*
* Report ZDINGTEST013
*----------------------------------------------------------------------*
* 【汎用モジュール】
* 演習問題２：汎用モジュールの組み込み
*----------------------------------------------------------------------*
REPORT ZKAWA_TEST015.

*----------------------------------------------------------------------*
* TYPE定義
*----------------------------------------------------------------------*

TYPES:

* 一般商品データ
  TYP_W_MARA TYPE MARA,
  TYP_T_MARA TYPE STANDARD TABLE OF TYP_W_MARA.

*----------------------------------------------------------------------*
* DATA定義
*----------------------------------------------------------------------*

DATA:
  GIT_MARA TYPE TYP_T_MARA,            "内部テーブル
  WA_MARA  TYPE TYP_W_MARA,            "作業エリア
  LV_COUNT TYPE P.                     "取得件数

*----------------------------------------------------------------------*
* 選択画面定義
*----------------------------------------------------------------------*

PARAMETERS:
  P_ERNAM TYPE MARA-ERNAM OBLIGATORY.  "登録者

*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*

INITIALIZATION.

  CLEAR:
    GIT_MARA,                          "内部テーブル
    WA_MARA,                           "作業エリア
    LV_COUNT.                          "取得件数

*----------------------------------------------------------------------*
* START-OF-SELECTION.
*----------------------------------------------------------------------*

START-OF-SELECTION.

* テーブルMARAを読み、取得件数を取得する
  CALL FUNCTION 'Z_KAWA_FUNC01'
    EXPORTING
      CREATE  = P_ERNAM
    IMPORTING
      COUNT   = LV_COUNT
    TABLES
      HINMOKU = GIT_MARA
    EXCEPTIONS
      NOTFND  = 1
      OTHERS  = 2.

  IF SY-SUBRC <> 0.

* 失敗時、エラーメッセージ表示
    MESSAGE S101(ZTEST1) DISPLAY LIKE 'E'.
    LEAVE TO LIST-PROCESSING.

  ELSE.

* 成功時、取得データを出力
    LOOP AT GIT_MARA INTO WA_MARA.
      WRITE:
        /  WA_MARA-MATNR,              "品目コード
        30 WA_MARA-ERSDA.              "登録日
    ENDLOOP.

  ENDIF.

*----------------------------------------------------------------------*
* TOP-OF-PAGE
*----------------------------------------------------------------------*

TOP-OF-PAGE.

* ヘッダー出力
  WRITE:
    /  TEXT-001 &&':',P_ERNAM,         "登録者
       TEXT-002 &&':',LV_COUNT &&'件'. "件数

  SKIP.

  WRITE:
    /  TEXT-003,                       "品目コード
    30 TEXT-004.                       "登録日

  ULINE.
