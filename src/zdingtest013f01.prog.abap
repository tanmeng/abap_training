*&---------------------------------------------------------------------*
*& Include          ZDINGTEST013F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM
*&---------------------------------------------------------------------*

FORM MAIN_PROC.
  SELECT
    MARA~MATNR,  "品目コード
    MARA~ERNAM,  "登録者名
    MARA~BRGEW,  "総重量
    MARA~GEWEI,  "単位
    MBEW~BWKEY,  "評価エリア
    MBEW~STPRS   "標準原価
  INTO TABLE
    @GIT_MABW
  FROM
    MARA
  INNER JOIN
    MBEW
  ON
    MARA~MATNR = MBEW~MATNR.

  IF SY-SUBRC IS INITIAL.
    SORT GIT_MABW ASCENDING BY MATNR.

    SELECT SINGLE
      WAERS     "通貨コード
    FROM
      T001
    WHERE
      BUKRS = '1010'  "会社コード
    INTO
      @GV_VALUE. "通貨
    IF SY-SUBRC IS  INITIAL.
    ELSE.
      CLEAR
        GV_VALUE.
    ENDIF.

  ENDIF.

  LOOP AT GIT_MABW INTO GW_MABW .
    WRITE:
      /   GW_MABW-MATNR,                       "品目コード
      20  GW_MABW-ERNAM,                       "登録者名
      40  GW_MABW-BRGEW UNIT GW_MABW-GEWEI,    "総重量
      60  GW_MABW-GEWEI,                       "単位
      80  GW_MABW-BWKEY,                       "評価エリア
      100 GW_MABW-STPRS CURRENCY GV_VALUE.     "標準原価
  ENDLOOP.

  ULINE.

ENDFORM.
