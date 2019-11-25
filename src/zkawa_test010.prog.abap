*----------------------------------------------------------------------*
* Report ZKAWA_TEST010
*----------------------------------------------------------------------*
* 演習問題12:DB検索(MAX)
*----------------------------------------------------------------------*
REPORT ZKAWA_TEST010.

*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*

TYPES:
  BEGIN OF TYP_MBEW,
    BWKEY TYPE MBEW-BWKEY,               "評価レベル
    STPRS TYPE MBEW-STPRS,               "標準原価
  END   OF TYP_MBEW.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*

DATA:
  GW_MBEW  TYPE TYP_MBEW.                "構造定義

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*

  CLEAR:
    GW_MBEW.

* 評価レベルごとの標準原価MAX値を取得
  SELECT
    BWKEY                                "評価レベル
    MAX( STPRS )                         "標準原価
  FROM
    MBEW
  INTO
    GW_MBEW
  GROUP BY
    BWKEY.

*   取得したデータを出力
    WRITE:
      /  GW_MBEW-BWKEY,                  "評価レベル
      20 GW_MBEW-STPRS CURRENCY 'JPY'.   "標準原価、通貨'JPY'を参照

  ENDSELECT.

*----------------------------------------------------------------------*
TOP-OF-PAGE.
*----------------------------------------------------------------------*
* ヘッダ出力
  WRITE:
    /  TEXT-001,                         "評価レベル
    20 TEXT-002.                         "標準原価

  ULINE.
