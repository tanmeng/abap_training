*&---------------------------------------------------------------------*
*& Include          ZDINGTEST011F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM
*&---------------------------------------------------------------------*

FORM MAIN_PROC.
*   MARA を読み、必要な項目のみを内部テーブルMARAに一括で溜め込む
  SELECT
        MATNR,
        ERNAM,
        BRGEW,
        GEWEI
   FROM MARA
   INTO TABLE
        @GIT_MARA.

  IF SY-SUBRC IS INITIAL.
*    内部テーブルMARAの品目コードで昇順にソートしておく
    SORT GIT_MARA ASCENDING BY MATNR.
*    内部テーブルMARA内重複レコード削除
    DELETE ADJACENT DUPLICATES FROM GIT_MARA
      COMPARING
        MATNR.
  ENDIF.


*  CHECK GIT_MARA.

*  内部テーブルMARAより（FOR ALL ENTRIES に指定）、MBEW を読み必要な項目を内部テーブル２に溜め込む。
*  MBEW と内部テーブルMARAは、品目コードで結びつける（WHERE 条件）
  IF GIT_MARA IS NOT INITIAL.
    SELECT
          MATNR,
          BWKEY,
          STPRS
     FROM MBEW
    FOR ALL ENTRIES IN
          @GIT_MARA
     WHERE
          MATNR = @GIT_MARA-MATNR
    INTO TABLE
          @GIT_MBEW.

    IF SY-SUBRC IS INITIAL.
*  内部テーブルMBEWの品目コードで昇順にソートしておく
      SORT GIT_MBEW ASCENDING BY MATNR.
*  内部テーブルMBEWをLOOP させて、帳票を出力する。
*  金額については、テーブルT001 が参照項目になっているので、はじめに１度だけT001を会社コード’0001’でよんでおく。
      SELECT SINGLE
             WAERS           "通貨コード
        FROM T001
        INTO GV_WAERS        "通貨
       WHERE
             BUKRS = '1010'. "会社コード
      IF SY-SUBRC IS INITIAL.
      ELSE.
        CLEAR GV_WAERS. "通貨
      ENDIF.

    ENDIF.

    LOOP AT GIT_MBEW INTO GW_MBEW.

      CLEAR GW_MARA.
*    MARA の情報は、内部テーブルMARAをバイナリサーチして取得する。
      READ TABLE GIT_MARA WITH KEY MATNR = GW_MBEW-MATNR BINARY SEARCH INTO GW_MARA.

      WRITE:
        /   GW_MARA-MATNR,                       "品目コード
        20  GW_MARA-ERNAM,                       "登録者
*   総重量と標準原価についてはディクショナリ(SE11)で参照項目を確認しておき,WRITE 時にそれぞれOPTION で設定する。
        30  GW_MARA-BRGEW UNIT GW_MARA-GEWEI,    "総重量
        60  GW_MARA-GEWEI,                       "重量単位
        80  GW_MBEW-BWKEY,                       "評価レベル
        90  GW_MBEW-STPRS CURRENCY GV_WAERS.     "標準原価'

    ENDLOOP.


  ENDIF.
ENDFORM.
