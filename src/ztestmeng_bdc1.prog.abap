*&---------------------------------------------------------------------*
* PROGRAM ID : ZTESTMENG_BDC1
* CREATE     : 2019/12/05
* AUTHOR     : WANG MENG
* SYSTEM     : オンラインプログラム
* DESCRIPTION: 仕入れ先登録_BDC(バッチインプットキュー演習問題1)
* TYPE       : ONLINE
* VERSION    : 0.1
* MODIFIED BY: WANG MENG 2019/12/05
* 新規
*&---------------------------------------------------------------------*
REPORT ZTESTMENG_BDC1.

*----------------------------------------------------------------------*
*       定数定義
*----------------------------------------------------------------------*
CONSTANTS:
  CNS_KTOKK_002      TYPE  BDCDATA-FVAL VALUE 'SUPL',          "勘定グループ
  CNS_ANRED_003      TYPE  BDCDATA-FVAL VALUE '王萌',          "敬称
  CNS_NAME1_004      TYPE  BDCDATA-FVAL VALUE 'テスト仕入先萌',"名称
  CNS_SORTL_005      TYPE  BDCDATA-FVAL VALUE 'テスト',        "検索語句
  CNS_ORT01_006      TYPE  BDCDATA-FVAL VALUE 'テスト',        "市区町村
  CNS_PSTLZ_007      TYPE  BDCDATA-FVAL VALUE '111-1111',      "郵便番号
  CNS_LAND1_008      TYPE  BDCDATA-FVAL VALUE 'JP',            "国コード
  CNS_SPRAS_009      TYPE  BDCDATA-FVAL VALUE 'JA',            "言語キー
  CNS_J_1KFREPRE_010 TYPE  BDCDATA-FVAL VALUE 'BSOL',          "代表
  CNS_BRSCH_011      TYPE  BDCDATA-FVAL VALUE '0001',          "産業分類
  CNS_UPMODE         TYPE  BDCDATA-FVAL VALUE 'S'.             "更新モード

*----------------------------------------------------------------------*
*       テーブル定義
*----------------------------------------------------------------------*
TABLES: T100.

*----------------------------------------------------------------------*
*       内部テーブル定義
*----------------------------------------------------------------------*
DATA:
*       BATCHINPUTDATA OF SINGLE TRANSACTION
  T_BDC TYPE TABLE OF BDCDATA WITH HEADER LINE, "BDC テーブル
*       MESSAGES OF CALL TRANSACTION
  MESSTAB TYPE STANDARD TABLE OF BDCMSGCOLL.    "メッセージテーブル

*----------------------------------------------------------------------*
*       ワークエリア定義                                               *
*----------------------------------------------------------------------*
DATA :
  H_BDC LIKE LINE OF T_BDC.                     "TBC ワークエリア

*----------------------------------------------------------------------*
*       パラメータ定義
*----------------------------------------------------------------------*
PARAMETERS:
  P_LIFNR     TYPE LIFNR OBLIGATORY,           "仕入先コード
  P_MODE      TYPE C DEFAULT 'N',              "処理モード
  P_HDATE     TYPE D DEFAULT '20191205'.       "HOLDDATE

*----------------------------------------------------------------------*
*       メイン処理
*----------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM BDC_OPEN.      "バッチインプットキューのオープン処理
  PERFORM BDC_SCREEN.    "画面上でのデータの溜め込み
  PERFORM BDC_INSERT.    "バッチインプットキューへのデータの書き込み処理
  PERFORM BDC_END.       "バッチインプットキューのクローズ処理

*---------------------------------------------------------------------*
*バッチインプットキューのオープン
*---------------------------------------------------------------------*
FORM BDC_OPEN.

  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      CLIENT = SY-MANDT
      GROUP = 'ZZTEST03'                       "セッション名
      HOLDDATE = P_HDATE                       "ロック日付
      KEEP = ABAP_ON                           "処理済みログに残す
      USER = SY-UNAME.                         "ユーザ

    IF SY-SUBRC NE 0.

      WRITE :/ 'BDC OPEN ERROR.CODE=', SY-SUBRC.

      STOP.

    ENDIF.

ENDFORM. "BDC_OPEN

*&---------------------------------------------------------------------*
*&      FORM BDC_SCREEN
*&---------------------------------------------------------------------*
* BDC内部テーブルへのデータの溜め込み処理
*----------------------------------------------------------------------*
FORM BDC_SCREEN.

  REFRESH T_BDC.                        "内部テーブルのクリア
  PERFORM BDC_SCREEN1.                  "画面１上でのデータ溜め込み
  PERFORM BDC_SCREEN2.                  "画面２上でのデータ溜め込み
  PERFORM BDC_SCREEN3.                  "画面３上でのデータ溜め込み
  PERFORM BDC_SCREEN4.                  "OK_CODE

ENDFORM. " BDC_SCREEN

*&---------------------------------------------------------------------*
*&      FORM BDC_SCREEN1
*&---------------------------------------------------------------------*
*       画面１上でのデータ溜め込み
*----------------------------------------------------------------------*
FORM BDC_SCREEN1.

*-----SCREEN NO.1（次ページの画面参照）
  PERFORM BDC_DYNPRO  USING 'SAPMF02K' '0100'.           "画面番号
  PERFORM BDC_FIELD   USING 'BDC_OKCODE' '/00'.          "ENTER
  PERFORM BDC_FIELD   USING 'RF02K-LIFNR' P_LIFNR.       "仕入先コード
  PERFORM BDC_FIELD   USING 'RF02K-KTOKK' CNS_KTOKK_002. "勘定グループ

ENDFORM. " BDC_SCREEN1

*&---------------------------------------------------------------------*
*&      FORM BDC_SCREEN2
*&---------------------------------------------------------------------*
*       画面２上でのデータ溜め込み
*----------------------------------------------------------------------*
FORM BDC_SCREEN2.

*-----SCREEN NO.2（次ページの画面参照）
  PERFORM BDC_DYNPRO   USING 'SAPMF02K' '0110'.          "画面番号
  PERFORM BDC_FIELD    USING 'BDC_OKCODE' '=VW'.         "OKCODE
  PERFORM BDC_FIELD    USING 'LFA1-ANRED' CNS_ANRED_003. "敬称
  PERFORM BDC_FIELD    USING 'LFA1-NAME1' CNS_NAME1_004. "名称
  PERFORM BDC_FIELD    USING 'LFA1-SORTL' CNS_SORTL_005. "検索語句
  PERFORM BDC_FIELD    USING 'LFA1-ORT01' CNS_ORT01_006. "市区町村
  PERFORM BDC_FIELD    USING 'LFA1-PSTLZ' CNS_PSTLZ_007. "郵便番号
  PERFORM BDC_FIELD    USING 'LFA1-LAND1' CNS_LAND1_008. "国コード
  PERFORM BDC_FIELD    USING 'LFA1-SPRAS' CNS_SPRAS_009. "言語キー

ENDFORM. " BDC_SCREEN2

*&---------------------------------------------------------------------*
*&      FORM BDC_SCREEN3
*&---------------------------------------------------------------------*
*       画面３上でのデータ溜め込み
*----------------------------------------------------------------------*
FORM BDC_SCREEN3.

*-----SCREEN NO.3（次ページの画面参照）
  PERFORM BDC_DYNPRO USING 'SAPMF02K' '0120'.                   "画面番号
  PERFORM BDC_FIELD  USING 'BDC_OKCODE' '=VW'.                  "OKCODE
  PERFORM BDC_FIELD  USING 'LFA1-J_1KFREPRE' CNS_J_1KFREPRE_010."代表者氏名
  PERFORM BDC_FIELD  USING 'LFA1-BRSCH' CNS_BRSCH_011.          "産業分類

ENDFORM. " BDC_SCREEN3

*&---------------------------------------------------------------------*
*&      FORM BDC_SCREEN4
*&---------------------------------------------------------------------*
*       OK_CODE
*----------------------------------------------------------------------*
FORM BDC_SCREEN4.

*-----SCREEN NO.4
  PERFORM BDC_DYNPRO USING 'SAPMF02K' '0130'.                  "画面番号
  PERFORM BDC_FIELD  USING 'BDC_OKCODE' '=UPDA'.               "OKCODE

ENDFORM. "BDC_SCREEN4

**&---------------------------------------------------------------------*
**&      FORM BDC_CALL
**&---------------------------------------------------------------------*
**       CALL-TRANSACTION
**----------------------------------------------------------------------*
*FORM BDC_CALL.
*
*  CALL TRANSACTION 'XK01' USING  BDCDATA        "トランザクションコード
*                          MODE   P_MODE         "処理モード
*                          UPDATE CNS_UPMODE.    "更新モード（同期更新）
*
*  IF SY-SUBRC EQ 0.
*
*    WRITE: / TEXT-001.                          "O K ! !
*
*  ELSE.
*
*    WRITE: / TEXT-002.                          "N G ! !
*
*  ENDIF.
*
*ENDFORM. "BDC_CALL

**&---------------------------------------------------------------------*
**&        FORM SELECT
**&---------------------------------------------------------------------*
**         メッセージ
**----------------------------------------------------------------------*
*FORM SELECT.
*
*  SELECT SINGLE *
*         FROM   T100
*         WHERE  SPRSL = SY-LANGU              "言語キー
*         AND    ARBGB = SY-MSGID              "アプリケーションエリア
*         AND    MSGNR = SY-MSGNO.             "メッセージ番号
*
*  IF SY-SUBRC <> 0.
*
*    WRITE:/ 'T100-TEXT=',T100-TEXT,           "メッセージテキスト
*          / 'SY-MSGV1 =',SY-MSGV1,            "メッセージ変数1
*          / 'SY-MSGV2 =',SY-MSGV2,            "メッセージ変数2
*          / 'SY-MSGV3 =',SY-MSGV3,            "メッセージ変数3
*          / 'SY-MSGV4 =',SY-MSGV4.            "メッセージ変数4
*
*  ENDIF.
*
*ENDFORM. " SELECT

*----------------------------------------------------------------------*
*        BDC_DYNPRO                                                    *
*----------------------------------------------------------------------*
*プログラム名とディンプロ番号の設定処理
*---------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM
                      DYNPRO.

* ヘッドラインクリア
  CLEAR: H_BDC, T_BDC.

  H_BDC-PROGRAM  = PROGRAM.                 "BDC モジュールプール
  H_BDC-DYNPRO   = DYNPRO.                  "BDC Dynpro 番号
  H_BDC-DYNBEGIN = 'X'.                     "BDC Dynpro 開始

  APPEND H_BDC TO T_BDC.                    "BDC テーブル

ENDFORM.                   "BDC_DYNPRO

*----------------------------------------------------------------------*
*        INSERT FIELD                                                  *
*----------------------------------------------------------------------*
*        移送項目の設定処理
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.

*   ヘッドラインクリア
    CLEAR: H_BDC, T_BDC.

    H_BDC-FNAM = FNAM.                      "項目名
    H_BDC-FVAL = FVAL.                      "BDC 項目値

    APPEND H_BDC TO T_BDC.                  "BDC テーブル

ENDFORM.                    "BDC_FIELD

*---------------------------------------------------------------------*
*バッチインプットキューへのデータの書き込み処理
*---------------------------------------------------------------------*
FORM BDC_INSERT.
  CALL FUNCTION 'BDC_INSERT'
    EXPORTING
 	    TCODE = 'XK01'
  TABLES
      DYNPROTAB = T_BDC.

  IF SY-SUBRC <> 0.

    WRITE :/ 'BDC_INSERT RETURN CODE ERROR',SY-SUBRC.

  ENDIF.

ENDFORM.                    "BDC_INSERT

*---------------------------------------------------------------------*
*バッチインプットキューのクローズ処理
*---------------------------------------------------------------------*
FORM BDC_END.
  CALL FUNCTION 'BDC_CLOSE_GROUP'.

  IF SY-SUBRC NE 0.

    WRITE :/ 'BDC OPEN ERROR .CODE=',SY-SUBRC.

  ELSE.

     MESSAGE s196(z1) WITH 'セッションを作成しました'.

  ENDIF.

ENDFORM.                   "BDC_END
