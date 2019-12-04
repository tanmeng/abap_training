*&---------------------------------------------------------------------*
*& Include          ZDINGTEST025F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM SEL_DATA
*&---------------------------------------------------------------------*
*& MARD.MARAテーブルから内部テーブルに格納
*&---------------------------------------------------------------------*
FORM SEL_DATA.
  SELECT
    MARD~MATNR,   "品目コード
    MARD~WERKS,   "プラント
    MARD~LGORT,   "保管場所
    MARD~LVORM,   "削除フラグ
    MARD~LABST,   "利用可能評価在庫
    MARD~INSME,   "品質検査中在庫
    MARA~MEINS    "単位
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
*& FORM SET_HEAD
*&---------------------------------------------------------------------*
*&　*ヘッダー出力内容
*&---------------------------------------------------------------

FORM SET_HEAD.
* 見出し
  GW_COMMENTARY-TYP  = 'H'.
  GW_COMMENTARY-KEY  = ''.
  GW_COMMENTARY-INFO = '品目明細'.
  APPEND:GW_COMMENTARY TO GIT_COMMENTARY.
* 項目名&値
  GW_COMMENTARY-TYP  = 'S'.
  GW_COMMENTARY-KEY  = '倉庫'.
  GW_COMMENTARY-INFO = P_LGORT.
  APPEND GW_COMMENTARY TO GIT_COMMENTARY.
* インフォメーション
  GW_COMMENTARY-TYP = 'A'.
  GW_COMMENTARY-KEY = ''.
  GW_COMMENTARY-INFO = 'Enterpriseで作成' .
  APPEND GW_COMMENTARY TO GIT_COMMENTARY.
ENDFORM.



*&---------------------------------------------------------------------*
*& FORM ALV_HEAD
*&---------------------------------------------------------------------*
*&　ヘッダーに出力する内容を設定
*&---------------------------------------------------------------------*
FORM ALV_HEAD.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY       = GIT_COMMENTARY.
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM SET_LAYOUT
*&---------------------------------------------------------------------*
*&　レイアウト設定
*&---------------------------------------------------------------------*
FORM SET-LAYOUT.
  GW_LAYOUT-ZEBRA               = 'X'.                  "一行ごとに網がけ
  GW_LAYOUT-COLWIDTH_OPTIMIZE   = 'X'.                  "列の最適化
  GW_LAYOUT-WINDOW_TITLEBAR     = 'ALV TITLE(LAYOUT)'.  "画面タイトル
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM F_GET_FIELDCAT
*&---------------------------------------------------------------------*
*&　カタログ情報取得
*&---------------------------------------------------------------------*
FORM F_GET_FIELDCAT.
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
    OTHERS                         = 3.

IF SY-SUBRC <> 0.
  MESSAGE E002(ZDTEST01).
ENDIF.
ENDFORM.



*&---------------------------------------------------------------------*
*& FORM F_OUTPUT_ALV
*&---------------------------------------------------------------------*
*&　画面表示
*&---------------------------------------------------------------------*
FORM F_OUTPUT_ALV.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM                = SY-REPID
      I_CALLBACK_TOP_OF_PAGE            = 'ALV_HEAD'
      IS_LAYOUT                         = GW_LAYOUT
      IT_FIELDCAT                       = GIT_FIELDCAT
    TABLES
      T_OUTTAB                          = GIT_MARD
    EXCEPTIONS
      PROGRAM_ERROR                     = 1
    OTHERS                              = 2.
IF SY-SUBRC <> 0.
  MESSAGE E002(ZDTEST01).
ENDIF.
ENDFORM.