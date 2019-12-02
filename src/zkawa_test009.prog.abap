*----------------------------------------------------------------------*
* Report ZKAWA_TEST004
*----------------------------------------------------------------------*
* 演習問題11:DB検索(INNER JOIN）
*----------------------------------------------------------------------*
REPORT ZKAWA_TEST009 LINE-SIZE 150.

*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*

TYPES:

* 一般商品データと品目評価
  BEGIN OF TYP_MARA,
    MATNR TYPE MARA-MATNR,                "品目コード
    ERNAM TYPE MARA-ERNAM,                "登録者
    BRGEW TYPE MARA-BRGEW,                "総重量
    GEWEI TYPE MARA-GEWEI,                "重量単位
    BWKEY TYPE MBEW-BWKEY,                "評価レベル
    STPRS TYPE MBEW-STPRS,                "標準原価
    BWTAR TYPE MBEW-BWTAR,                "評価タイプ
  END OF TYP_MARA.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*

DATA:
  GW_MARA  TYPE TYP_MARA,                 "構造定義
  GV_WAERS TYPE T001-WAERS.               "金額用変数

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  CLEAR:
    GW_MARA.

*データ抽出
  SELECT
    MARA~MATNR,                           "品目コード
    MARA~ERNAM,                           "登録者
    MARA~BRGEW,                           "総重量
    MARA~GEWEI,                           "重量単位
    MBEW~BWKEY,                           "評価レベル
    MBEW~STPRS,                           "標準原価
    MBEW~BWTAR                            "評価タイプ
  INTO
    @GW_MARA
  FROM
    MARA
  INNER JOIN
    MBEW
  ON
    MARA~MATNR = MBEW~MATNR.

  IF SY-SUBRC = 0.

*   MARA,MBEWからデータ取得成功の場合,通貨コード取得
    SELECT SINGLE
      WAERS                               "通貨コード
    FROM
      T001
    INTO
      GV_WAERS
    WHERE
      BUKRS = '1010'.

    IF SY-SUBRC = 0.

*     T001-WAERS取得成功の場合、帳票出力表示
      WRITE:
        /   GW_MARA-MATNR,                    "品目コード
        25  GW_MARA-ERNAM,                    "登録者
        40  GW_MARA-BRGEW UNIT GW_MARA-GEWEI, "総重量
        75  GW_MARA-GEWEI,                    "重量単位
        100 GW_MARA-BWKEY,                    "評価レベル
        125 GW_MARA-STPRS CURRENCY GV_WAERS.  "標準原価

    ELSE.

*     T001-WAERS取得失敗の場合

    ENDIF.

  ELSE.

*   MARA,MBEWからデータ取得失敗の場合

  ENDIF.

  ENDSELECT.

*----------------------------------------------------------------------*
* TOP-OF-PAGE
*----------------------------------------------------------------------*
TOP-OF-PAGE.

* ヘッダ出力
  WRITE:
    /   TEXT-001,                         "品目コード
    25  TEXT-002,                         "登録者
    50  TEXT-003,                         "総重量
    75  TEXT-004,                         "重量単位
    100 TEXT-005,                         "評価レベル
    125 TEXT-006.                         "標準原価

  ULINE.
