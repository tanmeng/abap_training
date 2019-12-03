*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST023
*&---------------------------------------------------------------------*
*& 演習問題１：バッチインプットキュー
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST023.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*
DATA:
  GIT_BDC LIKE BDCDATA OCCURS 0 WITH HEADER LINE, "BDCDAT型内部テーブル
  LW_BDC  LIKE LINE OF GIT_BDC.                   "作業エリア

*----------------------------------------------------------------------*
* 選択画面定義
*----------------------------------------------------------------------*
PARAMETERS:
  P_LIFNR LIKE LFA1-LIFNR.                        "仕入先コード

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM F_CALL_BDC_OPEN.                        "バッチインプットキューのオープン
  PERFORM F_SET_BDC_SCREEN.                       "BDCDATAへのデータの溜め込み
  PERFORM F_CALL_BDC_INSERT.                      "データの書き込み処理
  PERFORM F_CALL_BDC_CLOSE.                       "バッチインプットキューのクローズ

*&---------------------------------------------------------------------*
*& FORM F_CALL_BDC_OPEN
*&---------------------------------------------------------------------*
* バッチインプットキューのオープン
*----------------------------------------------------------------------*
  FORM F_CALL_BDC_OPEN.

    CALL FUNCTION 'BDC_OPEN_GROUP'
      EXPORTING
        CLIENT                    = SY-MANDT
*         DEST                    = FILLER8
        GROUP                     = SY-UNAME
        HOLDDATE                  = SY-DATUM
        KEEP                      = 'X'
        USER                      = SY-UNAME
*       RECORD                    = FILLER1
*       PROG                      = SY-CPROG
*       DCPFM                     = '%'
*       DATFM                     = '%'
*     IMPORTING
*       QID                       =
*     EXCEPTIONS
*       CLIENT_INVALID            = 1
*       DESTINATION_INVALID       = 2
*       GROUP_INVALID             = 3
*       GROUP_IS_LOCKED           = 4
*       HOLDDATE_INVALID          = 5
*       INTERNAL_ERROR            = 6
*       QUEUE_ERROR               = 7
*       RUNNING                   = 8
*       SYSTEM_LOCK_ERROR         = 9
*       USER_INVALID              = 10
*       OTHERS                    = 11
              .

*   汎用モジュール実行の判定
    IF SY-SUBRC <> 0.

*   　失敗の場合、エラーメッセージ出力し選択画面に戻る
      MESSAGE W002(ZTEST1) WITH 'BDC_OPEN_GROUP' DISPLAY LIKE 'E'.
      LEAVE TO LIST-PROCESSING.

    ELSE.

*     成功の場合、処理続行

    ENDIF.

  ENDFORM.                                      "FORM F_CALL_BDC_OPEN

*&---------------------------------------------------------------------*
*& FORM F_SET_BDC_SCREEN
*&---------------------------------------------------------------------*
* BDCDATAへのデータの溜め込み
*----------------------------------------------------------------------*
  FORM F_SET_BDC_SCREEN.

    REFRESH:
      GIT_BDC.

*   仕入先：一般データ
    PERFORM F_SET_BDC_DYNPRO USING 'SAPLBUS_LOCATOR' '3000'.
    PERFORM F_SET_BDC_FIELD  USING 'GV_VENDOR' 'P_LIFNR'.             "仕入先コード

*   住所
    PERFORM F_SET_BDC_FIELD  USING 'BUS000FLDS-TITLE_MEDI' '会社'.    "敬称
    PERFORM F_SET_BDC_FIELD  USING 'BUT000-NAME_ORG1' 'TEST'.         "名称
    PERFORM F_SET_BDC_FIELD  USING 'BUS000FLDS-BU_SORT1_TXT' 'TEST'.  "検索語句
    PERFORM F_SET_BDC_FIELD  USING 'ADDR1_DATA-POST_CODE1' '111-1111'."郵便番号
    PERFORM F_SET_BDC_FIELD  USING 'ADDR1_DATA-CITY1' 'TEST'.         "市区町村
    PERFORM F_SET_BDC_FIELD  USING 'ADDR1_DATA-COUNTRY' 'JP'.         "国コード
    PERFORM F_SET_BDC_FIELD  USING 'ADDR1_DATA-TIME_ZONE' 'JAPAN'.    "タイムゾーン
    PERFORM F_SET_BDC_FIELD  USING 'ADDR1_DATA-LANGU' '日本語'.       "言語キー

*   仕入先：税データ
    PERFORM F_SET_BDC_FIELD  USING 'GS_LFA1-KTOCK' 'LIEF'.            "勘定グループ
    PERFORM F_SET_BDC_FIELD  USING 'GS_LFA1-J_1KFTIND' '0001'.        "産業タイプ
    PERFORM F_SET_BDC_FIELD  USING 'GS_LFA1-J_1KFREPRE' 'BSOL'.       "代表者
    PERFORM F_SET_BDC_FIELD  USING 'BDC_OKCODE' '=BUS_MAIN_BACK'.

  ENDFORM.                                       "F_SET_BDC_SCREEN1

*&---------------------------------------------------------------------*
*& F_SET_BDC_DYNPRO
*&---------------------------------------------------------------------*
*　プログラム名とディンプロ番号の設定処理
*----------------------------------------------------------------------*
  FORM F_SET_BDC_DYNPRO
    USING
      U_V_PROGRAM
      U_V_DYNPRO.

    CLEAR:
      LW_BDC,
      GIT_BDC.

    LW_BDC-PROGRAM  = U_V_PROGRAM.
    LW_BDC-DYNPRO   = U_V_DYNPRO.
    LW_BDC-DYNBEGIN = 'X'.

    APPEND LW_BDC TO GIT_BDC.

  ENDFORM.                                        "F_SET_BDC_DYNPRO

*&---------------------------------------------------------------------*
*& F_SET_BDC_FIELD
*&---------------------------------------------------------------------*
*　移送項目の設定処理
*----------------------------------------------------------------------*
  FORM F_SET_BDC_FIELD
    USING
      U_V_FNAM
      U_V_FVAL.

    CLEAR:
      LW_BDC,
      GIT_BDC.

    LW_BDC-FNAM = U_V_FNAM.
    LW_BDC-FVAL = U_V_FVAL.

    APPEND LW_BDC TO GIT_BDC.

  ENDFORM.                                        "F_SET_BDC_FIELD

*&---------------------------------------------------------------------*
*& FORM F_CALL_BDC_INSERT
*&---------------------------------------------------------------------*
* バッチインプットキューへのデータの書き込み処理
*----------------------------------------------------------------------*
  FORM F_CALL_BDC_INSERT.

    CALL FUNCTION 'BDC_INSERT'
      EXPORTING
        TCODE                   = 'BP'
*        POST_LOCAL             = NOVBLOCAL
*        PRINTING               = NOPRINT
*        SIMUBATCH              = ' '
*        CTUPARAMS              = ' '
      TABLES
         DYNPROTAB              = GIT_BDC
*      EXCEPTIONS
*        INTERNAL_ERROR         = 1
*        NOT_OPEN               = 2
*        QUEUE_ERROR            = 3
*        TCODE_INVALID          = 4
*        PRINTING_INVALID       = 5
*        POSTING_INVALID        = 6
*        OTHERS                 = 7
               .

*   汎用モジュール実行の判定
    IF SY-SUBRC <> 0.

*     失敗の場合、エラーメッセージ出力し終了
      MESSAGE W002(ZTEST1) WITH 'BDC_INSERT' DISPLAY LIKE 'E'.
      LEAVE TO LIST-PROCESSING.

    ELSE.

*     成功の場合,処理続行

    ENDIF.

  ENDFORM.                                        "F_CALL_BDC_INSERT

*&---------------------------------------------------------------------*
*& FORM F_CALL_BDC_CLOSE
*&---------------------------------------------------------------------*
* バッチインプットキューのクローズ処理
*----------------------------------------------------------------------*
  FORM F_CALL_BDC_CLOSE.

    CALL FUNCTION 'BDC_CLOSE_GROUP'
*     EXCEPTIONS
*       NOT_OPEN          = 1
*       QUEUE_ERROR       = 2
*       OTHERS            = 3
              .

*   汎用モジュール実行の判定
    IF SY-SUBRC <> 0.

*     失敗の場合、エラーメッセージ出力し選択画面に戻る
      MESSAGE W002(ZTEST1) WITH 'BDC_CLOSE_GROUP' DISPLAY LIKE 'E'.
      LEAVE TO LIST-PROCESSING.

    ELSE.

*     成功の場合,メッセージ出力
      MESSAGE S003(ZTEST1) WITH 'セッションを作成しました'.

    ENDIF.

  ENDFORM.                                        "F_CALL_BDC_CLOSE
