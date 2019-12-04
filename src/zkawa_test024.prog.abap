*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST023
*&---------------------------------------------------------------------*
*& 演習問題2:CALL TRANSACTION
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST024.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*
DATA:

* 内部テーブル定義
  GIT_BDC         TYPE TABLE OF BDCDATA    WITH HEADER LINE, "BDCDATA
  GIT_MESSAGE     TYPE TABLE OF BDCMSGCOLL WITH HEADER LINE, "メッセージ

* ワークエリア定義
  LW_BDC          LIKE LINE  OF GIT_BDC,                      "BDCDATA
  LW_MESSAGE      LIKE LINE  OF GIT_MESSAGE,                  "メッセージ

* 変数定義
  LV_MESSAGE(200) TYPE          C.                            "メッセージ

*----------------------------------------------------------------------*
* 選択画面定義
*----------------------------------------------------------------------*
PARAMETERS:
  P_LIFNR   TYPE LFA1-LIFNR OBLIGATORY,           "仕入先コード
  P_MODE(1) TYPE C DEFAULT 'N'.                   "実行モード

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM F_SET_BDC_SCREEN.                       "BDCDATAへのデータの溜め込み
  PERFORM F_CALL_TRAN.                            "CALL TRANSACTION処理
  PERFORM F_CALL_TB_MESSAGE.                      "メッセージ処理

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
*& FORM F_CALL_TRAN
*&---------------------------------------------------------------------*
* CALL TRANSACTION処理
*----------------------------------------------------------------------*
  FORM F_CALL_TRAN.

    CLEAR:
      LV_MESSAGE.

    CALL TRANSACTION 'BP'
      USING
        GIT_BDC
      MODE
        P_MODE
      UPDATE
        'S'
      MESSAGES INTO
        GIT_MESSAGE.

*   CALL TRANSACTION実行処理判定
    IF SY-SUBRC = 0.

*     成功の場合、メッセージ出力
      MESSAGE I004(ZTEST1).
      STOP.

    ELSE.

*     失敗の場合

    ENDIF.

  ENDFORM.                                        "F_CALL_TRAN

*&---------------------------------------------------------------------*
*& FORM F_CALL_TB_MESSAGE
*&---------------------------------------------------------------------*
* メッセージ処理
*----------------------------------------------------------------------*
  FORM F_CALL_TB_MESSAGE.

    CALL FUNCTION 'TB_MESSAGE_BUILD_TEXT'
      EXPORTING
        LANGU = SY-LANGU
        MSGID = SY-MSGID
        MSGNO = SY-MSGNO
        MSGV1 = SY-MSGV1
        MSGV2 = SY-MSGV2
        MSGV3 = SY-MSGV3
        MSGV4 = SY-MSGV4
      IMPORTING
        TEXT  = LV_MESSAGE.

    WRITE:
      / LV_MESSAGE.                               "メッセージ出力

  ENDFORM.                                        "F_CALL_TB_MESSAGE.
