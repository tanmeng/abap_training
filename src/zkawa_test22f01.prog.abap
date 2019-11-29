*&---------------------------------------------------------------------*
*& Include          ZKAWA_TEST22F01
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

ENDFORM.                               "F_CLEAR_DATA

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

ENDFORM.                               "DB_SEL_DATA

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

  APPEND GW_COMMENTARY TO GIT_COMMENTARY.

* 項目＆値
  GW_COMMENTARY-TYP    =  'S'.
  GW_COMMENTARY-KEY    =  '倉庫'.
  GW_COMMENTARY-INFO   =  P_LGORT.

  APPEND GW_COMMENTARY TO GIT_COMMENTARY.

* インフォメーション
  GW_COMMENTARY-TYP    =  'A'.
  GW_COMMENTARY-KEY    =  ''.
  GW_COMMENTARY-INFO   =  'Enterpriseで作成'.

  APPEND GW_COMMENTARY TO GIT_COMMENTARY.

ENDFORM.                               "F_SET_HEAD

*&---------------------------------------------------------------------*
*& FORM F_CALL_REUSE_ALV_COMMENT
*&---------------------------------------------------------------------*
* ALVヘッダー出力用FORM作成
*----------------------------------------------------------------------*
FORM F_CALL_REUSE_ALV_COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = GIT_COMMENTARY.

ENDFORM.                               " F_CALL_REUSE_ALV_COMMENT

*&---------------------------------------------------------------------*
*& FORM MDL_ALV_HEAD
*&---------------------------------------------------------------------*
* ALVレイアウト編集
*----------------------------------------------------------------------*
FORM F_SET_LAYOUT.

  GW_LAYOUT-ZEBRA             = 'X'.                  "一行ごとに網がけ
  GW_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.                  "列の最適化
  GW_LAYOUT-WINDOW_TITLEBAR   = 'ALV TITLE (LAYOUT)'. "画面タイトル

ENDFORM.                               "F_SET_LAYOUT

*&---------------------------------------------------------------------*
*& FORM F_CALL_REUSE_ALV_FIELDCAT
*&---------------------------------------------------------------------*
* フィールドカタログ取得
*----------------------------------------------------------------------*
FORM F_CALL_REUSE_ALV_FIELDCAT.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      I_PROGRAM_NAME         = SY-REPID
      I_INTERNAL_TABNAME     = 'GIT_MARD'
      I_INCLNAME             = SY-REPID
    CHANGING
      CT_FIELDCAT            = GIT_FIELDCAT
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.

  IF SY-SUBRC <> 0.

*   失敗時、エラーメッセージ出力
    MESSAGE E002(ZTEST1) WITH TEXT-002.
    STOP.
  ENDIF.

ENDFORM.                               "F_CALL_REUSE_ALV_FIELDCAT

*&---------------------------------------------------------------------*
*& FORM F_CALL_REUSE_ALV_GRID
*&---------------------------------------------------------------------*
* ALV表示
*----------------------------------------------------------------------*
FORM F_CALL_REUSE_ALV_GRID.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      IT_FIELDCAT              = GIT_FIELDCAT
      I_CALLBACK_TOP_OF_PAGE   = 'F_CALL_REUSE_ALV_COMMENT'
      IS_LAYOUT                = GW_LAYOUT
      I_CALLBACK_PF_STATUS_SET = 'F_SET_PF_STATUS'
      I_CALLBACK_USER_COMMAND  = 'F_SET_USER_COMMAND'
    TABLES
      T_OUTTAB                 = GIT_MARD
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.

  IF SY-SUBRC <> 0.

*   失敗時、エラーメッセージ出力
    MESSAGE E002(ZTEST1) WITH TEXT-003.
    STOP.
  ENDIF.

ENDFORM.                               "F_CALL_REUSE_ALV_GRID

*&---------------------------------------------------------------------*
*& FORM F_SET_PF_STATUS
*&---------------------------------------------------------------------*
* ステータスの設定
*----------------------------------------------------------------------*
FORM F_SET_PF_STATUS
  USING
    U_IT_EXTAB TYPE SLIS_T_EXTAB.

  SET PF-STATUS 'M9000' EXCLUDING U_IT_EXTAB.

ENDFORM.                               "F_SET_PF_STATUS

*&---------------------------------------------------------------------*
*& FORM F_SET_USER_COMMAND
*&---------------------------------------------------------------------*
* ALV出力画面でのコマンドの処理設定
*----------------------------------------------------------------------*
FORM F_SET_USER_COMMAND
  USING
    U_V_UCOMM    LIKE SY-UCOMM
    U_W_SELFIELD TYPE SLIS_SELFIELD.

* ALV出力画面でのコマンドの判定
  CASE U_V_UCOMM.

*   ADDRUNボタン押下時の処理
    WHEN 'ADD_RUN'.
      LEAVE TO LIST-PROCESSING.
      SET PF-STATUS 'M9000'.

      LOOP AT GIT_MARD.
        WRITE:
          / GIT_MARD-MATNR.                           "品目コード
      ENDLOOP.

*   ダブルクリック時の処理
    WHEN '&IC1'.
      READ TABLE GIT_MARD INDEX U_W_SELFIELD-TABINDEX .
      SET PARAMETER ID 'MAT' FIELD GIT_MARD-MATNR.    "品目コード
      CALL TRANSACTION 'MMBE' AND SKIP FIRST SCREEN.  "在庫状況照会

  ENDCASE.

ENDFORM.                               "F_SET_USER_COMMAND
