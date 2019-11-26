*&---------------------------------------------------------------------*
*& Include          ZKAWA_TESTF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& FORM F_CALL_ENQU
*----------------------------------------------------------------------*
* テーブルロック用汎用モジュール呼び出し
*----------------------------------------------------------------------*

FORM F_CALL_ENQU.

* テーブルロック汎用モジュール
  CALL FUNCTION 'ENQUEUE_EZKAWA_TEST4'
    EXCEPTIONS
      FOREIGN_LOCK   = 1
      SYSTEM_FAILURE = 2
      OTHERS         = 3.

  IF SY-SUBRC <> 0.
*   失敗時、異常終了
    MESSAGE E106(ZKAWA).
  ENDIF.

* パラメータで入力した値を構造体に代入
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

* 代入した値をDBに登録
  INSERT ZKAWA_TEST1 FROM @GW_ZKAWA1.

  IF SY-SUBRC = 0.
*   成功時、コミットしメッセージ出力
    COMMIT WORK.
    MESSAGE S104(ZKAWA).

  ELSE.
*   失敗時、ロールバックしメッセージ出力
    ROLLBACK WORK.
    MESSAGE E106(ZKAWA).
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_CALL_DEQU
*----------------------------------------------------------------------*
* テーブルロック解除用汎用モジュール呼び出し登録内容出力
*----------------------------------------------------------------------*
FORM F_CALL_DEQU.

* テーブルロック解除汎用モジュール
  CALL FUNCTION 'DEQUEUE_EZKAWA_TEST4'.


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
