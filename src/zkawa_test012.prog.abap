*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST011
*&---------------------------------------------------------------------*
*&演習問題14:DBレコード変更
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST012.

*----------------------------------------------------------------------*
* Type定義
*----------------------------------------------------------------------*
TYPES:

* テスト用テーブルのデータ型
  BEGIN OF TYP_W_ZKAWA1,
    MATNR TYPE ZKAWA_TEST1-MATNR,              "品目コード
    TEXT  TYPE ZKAWA_TEST1-Z1KAWA_TEXT,        "品目テキスト
    SUU   TYPE ZKAWA_TEST1-Z1KAWA_SUU,         "数量
    TANI  TYPE ZKAWA_TEST1-Z1KAWA_TANI,        "単位
  END   OF TYP_W_ZKAWA1.

*----------------------------------------------------------------------*
* Data定義
*----------------------------------------------------------------------*
DATA:
  GW_ZKAWA1 TYPE TYP_W_ZKAWA1.                 "構造定義

*----------------------------------------------------------------------*
* 選択画面定義
*----------------------------------------------------------------------*
PARAMETERS:
  P_MATNR TYPE ZKAWA_TEST1-MATNR       OBLIGATORY, "品目コード
  P_TEXT  TYPE ZKAWA_TEST1-Z1KAWA_TEXT OBLIGATORY, "品目テキスト
  P_SUU   TYPE ZKAWA_TEST1-Z1KAWA_SUU  OBLIGATORY, "数量
  P_TANI  TYPE ZKAWA_TEST1-Z1KAWA_TANI OBLIGATORY. "単位

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM F_CALL_ENQUEUE.                      "テーブルロック汎用モジュール
  PERFORM F_SET_DATA.                          "入力したデータを代入
  PERFORM DB_UPD_ZKAWA_TEST1.                  "テーブルデータ更新
  PERFORM F_CALL_DEQUEUE.                      "テーブルロック解除汎用モジュール
  PERFORM F_PROC_WRITE.                        "更新したデータとメッセージ出力表示

*----------------------------------------------------------------------*
* TOP-OF-PAGE
*----------------------------------------------------------------------*
TOP-OF-PAGE.

  PERFORM F_PROC_WRITE_HEAD.                   "ヘッダー出力

*&---------------------------------------------------------------------*
*& FORM F_CALL_ENQUEU
*&---------------------------------------------------------------------*
* テーブルロック汎用モジュール
*----------------------------------------------------------------------*
  FORM F_CALL_ENQUEUE.

    CALL FUNCTION 'ENQUEUE_EZKAWA_TEST4'
      EXCEPTIONS
        FOREIGN_LOCK   = 1
        SYSTEM_FAILURE = 2
        OTHERS         = 3.

*   テーブルロックの判定
    IF SY-SUBRC <> 0.

*     失敗時、エラーメッセージ出力
      MESSAGE W106(ZKAWA) DISPLAY LIKE 'E'.
      LEAVE TO LIST-PROCESSING.

    ENDIF.

  ENDFORM.                                     "F_CALL_ENQUEUE

*&---------------------------------------------------------------------*
*& FORM F_SET_DATA
*&---------------------------------------------------------------------*
* 入力したデータを代入
*----------------------------------------------------------------------*
  FORM F_SET_DATA.

    MOVE:
      P_MATNR  TO GW_ZKAWA1-MATNR,             "品目コード
      P_TEXT   TO GW_ZKAWA1-TEXT,              "品目テキスト
      P_SUU    TO GW_ZKAWA1-SUU,               "数量
      P_TANI   TO GW_ZKAWA1-TANI.              "単位

  ENDFORM.                                     "F_SET_DATA

*&---------------------------------------------------------------------*
*& FORM DB_UPD_ZKAWA_TEST1
*&---------------------------------------------------------------------*
* テーブルデータ更新
*----------------------------------------------------------------------*
  FORM DB_UPD_ZKAWA_TEST1.

    UPDATE ZKAWA_TEST1
      SET:
        Z1KAWA_TEXT = GW_ZKAWA1-TEXT           "品目テキスト
        Z1KAWA_SUU  = GW_ZKAWA1-SUU            "数量
        Z1KAWA_TANI = GW_ZKAWA1-TANI           "単位
      WHERE MATNR   = GW_ZKAWA1-MATNR.         "(条件)品目コード

*   データ更新の判定
    IF SY-SUBRC = 0.

*     成功時、コミットしメッセージ出力
      COMMIT WORK.
      MESSAGE I107(ZKAWA).                     "データが正常に登録されました

    ELSE.

*     失敗時、ロールバックしメッセージ出力
      ROLLBACK WORK.
      MESSAGE W106(ZKAWA) DISPLAY LIKE 'E'.    "異常終了します
      LEAVE TO LIST-PROCESSING.

    ENDIF.

  ENDFORM.                                     "DB_UPD_ZKAWA_TEST1

*&---------------------------------------------------------------------*
*& FORM F_CALL_DEQUEUE
*&---------------------------------------------------------------------*
* テーブルロック解除汎用モジュール
*----------------------------------------------------------------------*
  FORM F_CALL_DEQUEUE.

    CALL FUNCTION 'DEQUEUE_EZKAWA_TEST4'.

  ENDFORM.                                     "FORM F_CALL_DEQUEUE

*&---------------------------------------------------------------------*
*& FORM F_PROC_WRITE
*&---------------------------------------------------------------------*
* 更新したデータとメッセージ出力表示
*----------------------------------------------------------------------*
  FORM F_PROC_WRITE.

*   テーブルロック解除の判定
    IF SY-SUBRC = 0.

*     成功時、更新したデータとメッセージ出力表示
      WRITE:
        /  GW_ZKAWA1-TEXT,                     "品目テキスト
        30 GW_ZKAWA1-SUU,                      "数量
        60 GW_ZKAWA1-TANI.                     "単位

      MESSAGE S105(ZKAWA).                     "テーブルロックを解除しました

    ENDIF.

  ENDFORM.                                     "F_PROC_WRITE

*&---------------------------------------------------------------------*
*& FORM F_PROC_WRITE_HEAD
*&---------------------------------------------------------------------*
* ヘッダー出力
*----------------------------------------------------------------------*
  FORM F_PROC_WRITE_HEAD.

    WRITE:
      /  TEXT-001,                             "【変更内容】
      /  TEXT-002,                             "品目テキスト
      30 TEXT-003,                             "数量
      60 TEXT-004.                             "単位

    ULINE.

  ENDFORM.                                     "F_PROC_WRITE_HEAD
