*&---------------------------------------------------------------------*
*& Include          ZDINGTEST009F01
*&---------------------------------------------------------------------*

FORM MAIN_PROC.
  SELECT
    MATNR,                     "品目コード
    ERSDA,                     "登録日付
    ERNAM,                     "オブジェクト登録者名
    LAEDA,                     "最終変更日付
    AENAM                      "オブジェクトの変更者名
  INTO TABLE
    @GIT_MARA                  "品目の内部テーブルに格納
  FROM
    MARA
  .
* 該当するデータがあった場合は最後にその件数(SY-DBCNT)を出力してください。
  IF SY-SUBRC IS INITIAL.
    GV_COUNT = SY-DBCNT.

*  MOVE SY-DBCNT TO GV_COUNT.

* 該当するデータが存在しない時は、メッセージ：010(Z1)を出力し処理を終了する
  ELSE.
*  データが存在しません。
    MESSAGE E000(ZDTEST02).
  ENDIF.

  SORT GIT_MARA BY MATNR ASCENDING.

  LOOP AT GIT_MARA INTO GW_MARA.
    WRITE:
      /  GW_MARA-MATNR,           "品目コード
      20 GW_MARA-ERSDA,           "登録日付
      40 GW_MARA-ERNAM,           "オブジェクト登録者名
      60 GW_MARA-LAEDA,           "最終変更日付
      80 GW_MARA-AENAM.           "オブジェクトの変更者名
  ENDLOOP.

    ULINE.

    WRITE:
      /
      '件数 =  ',
      GV_COUNT,
      '件'.
ENDFORM.
