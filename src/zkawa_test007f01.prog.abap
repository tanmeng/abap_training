*&---------------------------------------------------------------------*
*& Include          ZKAWA_TEST007F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM DB_SEL_MARA.
*&---------------------------------------------------------------------*
* MARAから必要な項目を取得し、内部テーブルGIT_MARAに溜め込む
*----------------------------------------------------------------------*
FORM DB_SEL_MARA.

  CLEAR:
    GIT_MARA.

  SELECT
    MATNR,                             "品目コード
    ERNAM,                             "登録者
    BRGEW,                             "総重量
    GEWEI                              "重量単位
  FROM
    MARA
  INTO TABLE
    @GIT_MARA.                         "内部テーブルに格納

  IF SY-SUBRC = 0.

*   内部テーブルMARAの品目コードで昇順にソートしておく
    SORT GIT_MARA ASCENDING BY MATNR.

  ELSE.

* 取得失敗の場合

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM DB_SEL_MBEW
*&---------------------------------------------------------------------*
* GIT_MARAをFOR ALL ENTRYSに指定、
* MBEWから必要な項目を取得し、内部テーブルGIT_MBEWに溜め込む
*----------------------------------------------------------------------*
FORM DB_SEL_MBEW.

  IF GIT_MARA IS NOT INITIAL.

*   内部テーブルMARAにデータが抽出できた場合、データ取得
    CLEAR:
      GIT_MBEW,
      GV_WAERS.

    SELECT
      MATNR,                           "品目コード
      BWKEY,                           "評価レベル
      STPRS                            "標準原価
    FROM
      MBEW
    FOR ALL ENTRIES IN
      @GIT_MARA
    WHERE
      MATNR = @GIT_MARA-MATNR
    INTO TABLE
      @GIT_MBEW.

    IF SY-SUBRC = 0.

*     MBEWからデータ取得成功の場合、T001から通貨コードを取得
      SORT GIT_MBEW ASCENDING BY MATNR.  "昇順にソート

      SELECT SINGLE
        WAERS                            "通貨コード
      FROM
        T001
      INTO
        GV_WAERS
      WHERE
        BUKRS = '1010'.

      IF SY-SUBRC = 0.

*     T001-WAERS取得成功の場合

      ELSE.

*     T001-WAERS取得失敗の場合

      ENDIF.

    ELSE.

*   MBEWからデータ取得失敗の場合

    ENDIF.

  ELSE.

* GIT_MARAにデータがない場合

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_PRC_WRITE.
*&---------------------------------------------------------------------*
*内部テーブルGIT_MBEWを帳票出力する
*MARAの情報はGIT_MARAをバイナリサーチして取得する
*----------------------------------------------------------------------*
FORM F_PRC_WRITE.

  LOOP AT GIT_MBEW INTO LW_MBEW.
    CLEAR LW_MARA.
    READ TABLE GIT_MARA WITH KEY MATNR = LW_MBEW-MATNR BINARY SEARCH INTO LW_MARA.
      WRITE:
        /   LW_MARA-MATNR,                   "品目コード
        25  LW_MARA-ERNAM,                   "登録者
        40  LW_MARA-BRGEW UNIT LW_MARA-GEWEI,"総重量
        75  LW_MARA-GEWEI,                   "重量単位
        100 LW_MBEW-BWKEY,                   "評価レベル
        125 LW_MBEW-STPRS CURRENCY GV_WAERS. "標準原価
  ENDLOOP.

*  IF SY-SUBCS = 0.
*
** 帳票出力失敗の場合
*
*  ELSE.
*
** 帳票出力失敗の場合
*
*  ENDIF.

ENDFORM.
