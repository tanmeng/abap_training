*&---------------------------------------------------------------------*
*& Report ZDINGTEST024
*&---------------------------------------------------------------------*
*&　ALV 演習問題１
*&---------------------------------------------------------------------*
REPORT ZDINGTEST024.

*&---------------------------------------------------------------------*
*&　DATA
*&---------------------------------------------------------------------*

DATA:
  BEGIN OF GIT_MARD OCCURS 0,
    MATNR LIKE MARD-MATNR,   "品目コード
    WERKS LIKE MARD-WERKS,   "ブランド
    LGORT LIKE MARD-LGORT,   "保管場所
    LVORM LIKE MARD-LVORM,   "削除フラグ
    LABST LIKE MARD-LABST,   "利用可能評価在庫
    INSME LIKE MARD-INSME,   "品質検査中在庫
    MEINS LIKE MARA-MEINS,    "単位
  END   OF GIT_MARD,

  GW_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
  GIT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

*&---------------------------------------------------------------------*
*&　MARD.MARAテーブルから内部テーブルに格納
*&---------------------------------------------------------------------*

  SELECT
    MARD~MATNR,
    MARD~WERKS,
    MARD~LGORT,
    MARD~LVORM,
    MARD~LABST,
    MARD~INSME,
    MARA~MEINS
  FROM
    MARD
  INNER JOIN
    MARA
  ON
    MARD~MATNR = MARA~MATNR
  INTO TABLE
    @GIT_MARD.

*&---------------------------------------------------------------------*
*&　カタログ情報取得
*&---------------------------------------------------------------------*

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
EXPORTING
   I_PROGRAM_NAME               = SY-REPID
   I_INTERNAL_TABNAME           = 'GIT_MARD'
*   I_STRUCTURE_NAME             =
*   I_CLIENT_NEVER_DISPLAY       = 'X'
   I_INCLNAME                   = SY-REPID
*   I_BYPASSING_BUFFER           =
*   I_BUFFER_ACTIVE              =
  CHANGING
    CT_FIELDCAT                  = GIT_FIELDCAT
 EXCEPTIONS
   INCONSISTENT_INTERFACE       = 1
   PROGRAM_ERROR                = 2
   OTHERS                       = 3
          .

*&---------------------------------------------------------------------*
*&　画面表示
*&---------------------------------------------------------------------*

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*       I_INTERFACE_CHECK                 = ' '
*       I_BYPASSING_BUFFER                = ' '
*       I_BUFFER_ACTIVE                   = ' '
*       I_CALLBACK_PROGRAM                = ' '
*       I_CALLBACK_PF_STATUS_SET          = ' '
*       I_CALLBACK_USER_COMMAND           = ' '
*       I_CALLBACK_TOP_OF_PAGE            = ' '
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*      I_STRUCTURE_NAME                  =
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
       OTHERS                            = 2
              .
IF SY-SUBRC <> 0.
  MESSAGE E002(ZDTEST01).
ENDIF.
