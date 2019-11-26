*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST017
*&---------------------------------------------------------------------*
*& ALV 演習問題１
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST017.

*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*

TYPES:
  BEGIN OF TYP_W_MARD,
    MATNR TYPE MARA-MATNR,             "品目コード
    WERKS TYPE MARD-WERKS,             "プラント
    LGORT TYPE MARD-LGORT,             "保管場所
    LVORM TYPE MARD-LVORM,             "削除フラグ
    LABST TYPE MARD-LABST,             "利用可能評価在庫
    INSME TYPE MARD-INSME,             "品質検査中在庫
  END   OF TYP_W_MARD,

  TYP_T_MARD TYPE STANDARD TABLE OF TYP_W_MARD.

TYPE-POOLS:
  SLIS.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*

DATA:
* データ取得用
  GW_MARD      TYPE TYP_W_MARD,          "構造
  GIT_MARD     TYPE TYP_T_MARD,          "内部テーブル
* フィールドカタログ用
  GIT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV, "フィールドカタログ
  GW_FIELDCAT  TYPE SLIS_FIELDCAT_ALV.   "フィールドカタログ

*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*

  CLEAR:
    GIT_MARD.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*

  PERFORM DB_SEL_DATA.                   "MARDとMARAからデータ取得
  PERFORM MDL_GET_FIELDCAT.              "フィールドカタログ取得
  PERFORM MDL_OUTPUT_ALV.                "ALV表示

*&---------------------------------------------------------------------*
*& FORM DB_SEL_DATA
*&---------------------------------------------------------------------*
* MARDとMARAからデータ取得
*----------------------------------------------------------------------*
  FORM DB_SEL_DATA.

    SELECT
      MARA~MATNR,                        "品目コード
      MARD~WERKS,                        "プラント
      MARD~LGORT,                        "保管場所
      MARD~LVORM,                        "削除フラグ
      MARD~LABST,                        "利用可能評価在庫
      MARD~INSME                         "品質検査中在庫
    INTO TABLE
      @GIT_MARD
    FROM
      MARD
    INNER JOIN
      MARA
    ON
      MARD~MATNR =  MARA~MATNR.

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
*       I_STRUCTURE_NAME             = 'MARD'
*       I_CLIENT_NEVER_DISPLAY       = 'X'
*       I_INCLNAME                   =
*       I_BYPASSING_BUFFER           =
*       I_BUFFER_ACTIVE              =
      CHANGING
        CT_FIELDCAT                 = GIT_FIELDCAT
     EXCEPTIONS
       INCONSISTENT_INTERFACE       = 1
       PROGRAM_ERROR                = 2
       OTHERS                       = 3
                .
    IF SY-SUBRC <> 0.
*     失敗時、エラーメッセージ出力
      MESSAGE E002(ZTEST1) WITH TEXT-002.
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
*       I_INTERFACE_CHECK                 = ' '
*       I_BYPASSING_BUFFER                = ' '
*       I_BUFFER_ACTIVE                   = ' '
       I_CALLBACK_PROGRAM                = SY-REPID
*       I_CALLBACK_PF_STATUS_SET          = ' '
*       I_CALLBACK_USER_COMMAND           = ' '
*       I_CALLBACK_TOP_OF_PAGE            = ' '
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME                  =
*       I_BACKGROUND_ID                   = ' '
*       I_GRID_TITLE                      =
*       I_GRID_SETTINGS                   =
*       IS_LAYOUT                         =
       IT_FIELDCAT                       = GIT_FIELDCAT
*       IT_EXCLUDING                      =
*       IT_SPECIAL_GROUPS                 =
*       IT_SORT                           =
*       IT_FILTER                         =
*       IS_SEL_HIDE                       =
*       I_DEFAULT                         = 'X'
*       I_SAVE                            = ' '
*       IS_VARIANT                        =
*       IT_EVENTS                         =
*       IT_EVENT_EXIT                     =
*       IS_PRINT                          =
*       IS_REPREP_ID                      =
*       I_SCREEN_START_COLUMN             = 0
*       I_SCREEN_START_LINE               = 0
*       I_SCREEN_END_COLUMN               = 0
*       I_SCREEN_END_LINE                 = 0
*       I_HTML_HEIGHT_TOP                 = 0
*       I_HTML_HEIGHT_END                 = 0
*       IT_ALV_GRAPHICS                   =
*       IT_HYPERLINK                      =
*       IT_ADD_FIELDCAT                   =
*       IT_EXCEPT_QINFO                   =
*       IR_SALV_FULLSCREEN_ADAPTER        =
*     IMPORTING
*       E_EXIT_CAUSED_BY_CALLER           =
*       ES_EXIT_CAUSED_BY_USER            =
      TABLES
        T_OUTTAB                          = GIT_MARD
     EXCEPTIONS
       PROGRAM_ERROR                     = 1
              .
    IF SY-SUBRC <> 0.
*     失敗時、エラーメッセージ出力
      MESSAGE E002(ZTEST1) WITH TEXT-003.
    ENDIF.

  ENDFORM.
