*&---------------------------------------------------------------------*
*& Include          ZDINGTEST026F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& FORM SEL_DATA
*&---------------------------------------------------------------------*
*& MARDとMARAテーブルから内部テーブルに格納
*&---------------------------------------------------------------------*
FORM F_SEL_DATA.
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
    MARD~LGORT = @P_LGORT        "保管場所
  INTO TABLE
    @GIT_MARD.
ENDFORM.

*&---------------------------------------------------------------------*
*& FORM SET_HEAD
*&---------------------------------------------------------------------*
*&　*ヘッダー編集
*&---------------------------------------------------------------------*

FORM F_SET_HEAD.
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
*& FORM F_ALV_HEAD
*&---------------------------------------------------------------------*
*&　ヘッダー表示
*&---------------------------------------------------------------------*
FORM F_ALV_HEAD.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY       = GIT_COMMENTARY.

ENDFORM.


*&---------------------------------------------------------------------*
*& FORM F_SET_LAYOUT
*&---------------------------------------------------------------------*
*&　ヘッダー表示
*&---------------------------------------------------------------------*
FORM F_SET-LAYOUT.

  GW_LAYOUT-ZEBRA              = 'X'.                  "一行ごとに網がけ
  GW_LAYOUT-COLWIDTH_OPTIMIZE  = 'X'.                  "列の最適化
  GW_LAYOUT-WINDOW_TITLEBAR     = 'ALV TITLE(LAYOUT)'. "画面タイトル

ENDFORM.


*&---------------------------------------------------------------------*
*& FORM MDL_GET_FIELDCAT
*&---------------------------------------------------------------------*
*&　カタログ情報取得
*&---------------------------------------------------------------------*
FORM F_MDL_GET_FIELDCAT.
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
  MESSAGE E002(ZDTEST01).
ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& F_ALV_PF_STATUS
*&---------------------------------------------------------------------*
*&　ステータス設定
*&------------------------------------------------------------------


FORM F_ALV_PF_STATUS
USING
  I_EXTAB
TYPE
  SLIS_T_EXTAB.
SET PF-STATUS
  'M9000'
EXCLUDING
  I_EXTAB.
ENDFORM.


*&---------------------------------------------------------------------*
*& F_ALV_USER_COMMAND
*&---------------------------------------------------------------------*
*&　Addon ボタン押下
*&------------------------------------------------------------------
FORM F_ALV_USER_COMMAND
  USING
    R_UCOMM     LIKE SY-UCOMM
    RS_SELFIELD TYPE SLIS_SELFIELD.
  CASE R_UCOMM.
    WHEN 'ADDON'.
      LEAVE TO LIST-PROCESSING.
      SET PF-STATUS 'PRINT'.
      LOOP AT GIT_MARD.
        WRITE :
        / GIT_MARD-MATNR.
      ENDLOOP.
      WHEN '&IC1'.
        READ TABLE GIT_MARD INDEX RS_SELFIELD-TABINDEX .
        SET PARAMETER ID 'MAT' FIELD GIT_MARD-MATNR.
        CALL TRANSACTION 'MMBE' AND SKIP FIRST SCREEN.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*& FORM MDL_OUTPUT_ALV
*&---------------------------------------------------------------------*
*&　画面表示
*&---------------------------------------------------------------------*
FORM F_MDL_OUTPUT_ALV.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM                = SY-REPID
      I_CALLBACK_TOP_OF_PAGE            = 'F_ALV_HEAD'
      IS_LAYOUT                         = GW_LAYOUT
      IT_FIELDCAT                       = GIT_FIELDCAT
      I_CALLBACK_PF_STATUS_SET          = 'F_ALV_PF_STATUS'
      I_CALLBACK_USER_COMMAND           = 'F_ALV_USER_COMMAND'
    TABLES
      T_OUTTAB                          = GIT_MARD
    EXCEPTIONS
      PROGRAM_ERROR                     = 1
      OTHERS                            = 2.
IF SY-SUBRC <> 0.
  MESSAGE E002(ZDTEST01).
ENDIF.
ENDFORM.
