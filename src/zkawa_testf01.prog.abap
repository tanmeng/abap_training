*&---------------------------------------------------------------------*
*& Include          ZKAWA_TESTF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM MDL_CALL_ENQU
*----------------------------------------------------------------------*
* テーブルロック用汎用モジュール呼び出し
*----------------------------------------------------------------------*

FORM MDL_CALL_ENQU.

* テーブルロック汎用モジュール
  CALL FUNCTION 'ENQUEUE_EZKAWA_TEST4'
    EXCEPTIONS
      FOREIGN_LOCK   = 1
      SYSTEM_FAILURE = 2
      OTHERS         = 3.

  IF SY-SUBRC <> 0.
*   失敗時、メッセージ出力
    MESSAGE W106(ZKAWA) DISPLAY LIKE 'E'.
    LEAVE TO LIST-PROCESSING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_SET_DATA
*----------------------------------------------------------------------*
* パラメータで入力した値を構造体に代入
*----------------------------------------------------------------------*

FORM F_SET_DATA.
* データ代入
  MOVE:
    SY-MANDT TO GW_ZKAWA1-MANDT,                 "クライアント
    P_MATNR  TO GW_ZKAWA1-MATNR,                 "品目コード
    P_TEXT   TO GW_ZKAWA1-TEXT,                  "品目テキスト
    P_SUU    TO GW_ZKAWA1-SUU,                   "数量
    P_TANI   TO GW_ZKAWA1-TANI,                  "単位
    P_AMT    TO GW_ZKAWA1-AMT,                   "金額
    P_MONT   TO GW_ZKAWA1-MONT,                  "月
    P_SPLD   TO GW_ZKAWA1-SPLD,                  "登録日
    SY-DATUM TO GW_ZKAWA1-DATE,                  "ユーザー
    SY-UNAME TO GW_ZKAWA1-BNAME.                 "デバイス

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM DB_INS_ZKAWA_TEST1
*----------------------------------------------------------------------*
* 代入した値をDB:ZKAWA_TEST1に登録
*----------------------------------------------------------------------*
FORM DB_INS_ZKAWA_TEST1.

* 代入した値をDBに登録
  INSERT ZKAWA_TEST1 FROM @GW_ZKAWA1.

  IF SY-SUBRC = 0.
*   成功時、コミットしメッセージ出力
    COMMIT WORK.
    MESSAGE S104(ZKAWA).

  ELSE.
*   失敗時、ロールバックしメッセージ出力
    ROLLBACK WORK.
    MESSAGE W106(ZKAWA) DISPLAY LIKE 'E'.
    LEAVE TO LIST-PROCESSING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM MDL_CALL_DEQU
*----------------------------------------------------------------------*
* テーブルロック解除用汎用モジュール呼び出し登録内容出力
*----------------------------------------------------------------------*
FORM MDL_CALL_DEQU.

* テーブルロック解除汎用モジュール
  CALL FUNCTION 'DEQUEUE_EZKAWA_TEST4'.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_WRITE_DATA
*----------------------------------------------------------------------*
* 登録内容出力
*----------------------------------------------------------------------*
FORM F_WRITE_DATA.

  IF SY-SUBRC = 0.
*   成功時、登録した内容を出力
    WRITE:
      /   GW_ZKAWA1-MANDT,                        "クライアント
      20  GW_ZKAWA1-MATNR,                        "品目コード
      40  GW_ZKAWA1-TEXT,                         "品目テキスト
      65  GW_ZKAWA1-SUU,                          "数量
      90  GW_ZKAWA1-TANI,                         "単位
      100 GW_ZKAWA1-AMT,                          "金額
      120 GW_ZKAWA1-MONT,                         "月
      140 GW_ZKAWA1-DATE,                         "登録日
      160 GW_ZKAWA1-BNAME,                        "ユーザー
      180 GW_ZKAWA1-SPLD.                         "デバイス

    MESSAGE I105(ZKAWA).

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_WRITE_HEAD
*----------------------------------------------------------------------*
* ヘッダー出力
*----------------------------------------------------------------------*
FORM F_WRITE_HEAD.

  WRITE:
    /    TEXT-001,                     "クライアント
    20   TEXT-002,                     "品目コード
    40   TEXT-003,                     "品目テキスト
    65   TEXT-004,                     "数量
    90   TEXT-005,                     "単位
    100  TEXT-006,                     "金額
    120  TEXT-007,                     "月
    140  TEXT-008,                     "登録日
    160  TEXT-009,                     "ユーザー
    180  TEXT-010.                     "デバイス

  ULINE.

ENDFORM.
