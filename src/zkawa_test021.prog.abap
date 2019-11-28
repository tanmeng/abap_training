*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST017
*&---------------------------------------------------------------------*
*& ALV 演習問題１
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST021.

INCLUDE:
  ZKAWA_TEST21D01,                       "データ定義
  ZKAWA_TEST21S01,                       "選択画面定義
  ZKAWA_TEST21F01.                       "サブルーチン

*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.

  PERFORM F_CLEAR_DATA.                  "データ初期化

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM DB_SEL_DATA.                   "MARDとMARAからデータ取得
  PERFORM F_SET_HEAD.                    "ALVヘッダー編集
  PERFORM F_SET_LAYOUT.                  "ALVレイアウト編集
  PERFORM MDL_GET_FIELDCAT.              "フィールドカタログ取得
  PERFORM MDL_OUTPUT_ALV.                "ALV表示
