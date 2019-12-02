*----------------------------------------------------------------------*
* Report ZKAWA_TEST004
*----------------------------------------------------------------------*
* 演習問題10:DB検索(２つのテーブル検索）
*----------------------------------------------------------------------*
REPORT ZKAWA_TEST007 LINE-SIZE 150.

INCLUDE:
  ZKAWA_TEST007D01,                    "データ定義
  ZKAWA_TEST007F01.                    "サブルーチン

*---------------------------------------------------------------------*
* START-OF-SELECTION
*---------------------------------------------------------------------*
START-OF-SELECTION.

* MARAから必要な項目を取得し、内部テーブルGIT_MARAに溜め込む
  PERFORM DB_SEL_MARA.

* GIT_MARAをFOR ALL ENTRYSに指定、
* MBEWから必要な項目を取得し、内部テーブルGIT_MBEWに溜め込む
* T001から通貨コードを取得
  PERFORM DB_SEL_MBEW.

* 内部テーブルGIT_MBEWを帳票出力する
* MARAの情報はGIT_MARAをバイナリサーチして取得する
  PERFORM F_PRC_WRITE.

*----------------------------------------------------------------------*
* TOP-OF-PAGE
*----------------------------------------------------------------------*
TOP-OF-PAGE.

* ヘッダ出力
  WRITE:
    /   TEXT-001,                      "品目コード
    25  TEXT-002,                      "登録者
    50  TEXT-003,                      "総重量
    75  TEXT-004,                      "重量単位
    100 TEXT-005,                      "評価レベル
    125 TEXT-006.                      "標準原価

  ULINE.