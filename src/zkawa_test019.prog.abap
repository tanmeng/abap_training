*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST017
*&---------------------------------------------------------------------*
*& ALV 演習問題１
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST019.

*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*

TYPE-POOLS:
  SLIS.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*

DATA:
  BEGIN OF GIT_MARD OCCURS 0,
    MATNR LIKE MARD-MATNR,             "品目コード
    WERKS LIKE MARD-WERKS,             "プラント
    LGORT LIKE MARD-LGORT,             "保管場所
    LVORM LIKE MARD-LVORM,             "削除フラグ
    LABST LIKE MARD-LABST,             "利用可能評価在庫
    INSME LIKE MARD-INSME,             "品質検査中在庫
    MEINS LIKE MARA-MEINS,             "基本数量単位
  END   OF GIT_MARD,

* フィールドカタログ用
  GW_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV. "フィールドカタログ

*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*

  CLEAR:
    GIT_MARD,
    GW_FIELDCAT.

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
      MARD~MATNR,                        "品目コード
      MARD~WERKS,                        "プラント
      MARD~LGORT,                        "保管場所
      MARD~LVORM,                        "削除フラグ
      MARD~LABST,                        "利用可能評価在庫
      MARD~INSME,                        "品質検査中在庫
      MARA~MEINS
    FROM
      MARD
    INNER JOIN
      MARA
    ON
      MARD~MATNR =  MARA~MATNR
    INTO TABLE
      @GIT_MARD.

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
        CT_FIELDCAT                 = GW_FIELDCAT
     EXCEPTIONS
       INCONSISTENT_INTERFACE       = 1
       PROGRAM_ERROR                = 2
       OTHERS                       = 3.

    IF SY-SUBRC <> 0.
*     失敗時、エラーメッセージ出力
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
       IT_FIELDCAT                       = GW_FIELDCAT
      TABLES
        T_OUTTAB                         = GIT_MARD
     EXCEPTIONS
       PROGRAM_ERROR                     = 1
         OTHERS                          = 2.

    IF SY-SUBRC <> 0.
*     失敗時、エラーメッセージ出力
      MESSAGE E002(ZTEST1) WITH TEXT-003.
      STOP.
    ENDIF.

  ENDFORM.
