*&---------------------------------------------------------------------*
*& Include          ZKAWA_TEST21F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM F_CLEAR_DATA
*&---------------------------------------------------------------------*
* データ初期化
*----------------------------------------------------------------------*
FORM F_CLEAR_DATA.

  CLEAR:
    GIT_MARD,                          "MARD用内部テーブル
    GIT_FIELDCAT,                      "フィールドカタログ用内部テーブル
    GIT_COMMENTARY,                    "ヘッダー用内部テーブル
    GW_COMMENTARY,                     "ヘッダー用構造
    GW_LAYOUT.                         "レイアウト用構造

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM DB_SEL_DATA
*&---------------------------------------------------------------------*
* MARDとMARAからデータ取得
*----------------------------------------------------------------------*
FORM DB_SEL_DATA.

  SELECT
    MARD~MATNR,                        "品目コード
    MARD~WERKS,                        "プラント
    MARD~LGORT,                        "保管場所
    MARD~LVORM,                        "削除フラグ
    MARD~LABST,                        "利用可能評価在庫
    MARD~INSME,                        "品質検査中在庫
    MARA~MEINS                         "基本数量単位
  FROM
    MARD
  INNER JOIN
    MARA
  ON
    MARD~MATNR = MARA~MATNR
  WHERE
    MARD~LGORT = @P_LGORT
  INTO TABLE
    @GIT_MARD.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_SET_HEAD
*&---------------------------------------------------------------------*
* ALVヘッダー編集
*----------------------------------------------------------------------*
FORM F_SET_HEAD.

* 見出し
  GW_COMMENTARY-TYP    =  'H'.
  GW_COMMENTARY-KEY    =  ''.
  GW_COMMENTARY-INFO   =  '品目明細'.

  APPEND:
    GW_COMMENTARY TO GIT_COMMENTARY.

* 項目＆値
  GW_COMMENTARY-TYP    =  'S'.
  GW_COMMENTARY-KEY    =  '倉庫'.
  GW_COMMENTARY-INFO   =  P_LGORT.

  APPEND:
    GW_COMMENTARY TO GIT_COMMENTARY.

* インフォメーション
  GW_COMMENTARY-TYP    =  'A'.
  GW_COMMENTARY-KEY    =  ''.
  GW_COMMENTARY-INFO   =  'Enterpriseで作成'.

  APPEND:
    GW_COMMENTARY TO GIT_COMMENTARY.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM MDL_ALV_HEAD
*&---------------------------------------------------------------------*
* ALVヘッダー出力用FORM作成
*----------------------------------------------------------------------*
FORM MDL_ALV_HEAD.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = GIT_COMMENTARY.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM MDL_ALV_HEAD
*&---------------------------------------------------------------------*
* ALVレイアウト編集
*----------------------------------------------------------------------*
FORM F_SET_LAYOUT.

  GW_LAYOUT-ZEBRA             = 'X'.                  "一行ごとに網がけ
  GW_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.                  "列の最適化
  GW_LAYOUT-WINDOW_TITLEBAR   = 'ALV TITLE (LAYOUT)'. "画面タイトル

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM MDL_GET_FIELDCAT
*&---------------------------------------------------------------------*
* フィールドカタログ取得
*----------------------------------------------------------------------*
FORM MDL_GET_FIELDCAT.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      I_PROGRAM_NAME               = SY-REPID
      I_INTERNAL_TABNAME           = 'GIT_MARD'
      I_INCLNAME                   = SY-REPID
    CHANGING
      CT_FIELDCAT                  = GIT_FIELDCAT
    EXCEPTIONS
      INCONSISTENT_INTERFACE       = 1
      PROGRAM_ERROR                = 2
      OTHERS                       = 3.

  IF SY-SUBRC <> 0.
*   失敗時、エラーメッセージ出力
    MESSAGE E002(ZTEST1) WITH TEXT-002.
    STOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM MDL_OUTPUT_ALV
*&---------------------------------------------------------------------*
* ALV表示
*----------------------------------------------------------------------*
FORM MDL_OUTPUT_ALV.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM                = SY-REPID
      IT_FIELDCAT                       = GIT_FIELDCAT
      I_CALLBACK_TOP_OF_PAGE            = 'MDL_ALV_HEAD'
      IS_LAYOUT                         = GW_LAYOUT
    TABLES
      T_OUTTAB                          = GIT_MARD
    EXCEPTIONS
      PROGRAM_ERROR                     = 1
      OTHERS                            = 2.

  IF SY-SUBRC <> 0.
*   失敗時、エラーメッセージ出力
    MESSAGE E002(ZTEST1) WITH TEXT-003.
    STOP.
  ENDIF.

ENDFORM.
