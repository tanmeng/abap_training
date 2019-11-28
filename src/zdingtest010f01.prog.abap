*&---------------------------------------------------------------------*
*& Include          ZDINGTEST010F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM
*&---------------------------------------------------------------------*

FORM MAIN_PROC.

  DATA:
    LIT_MARA TYPE TYP_T_MARA.    "内部テーブル

  SELECT
    MATNR,    "品目コード
    ERSDA,    "登録日付
    ERNAM,    "オブジェクト登録者名
    LAEDA,    "最終変更日付
    AENAM     "オブジェクトの変更者名
  FROM
    MARA
  INTO TABLE
    @LIT_MARA
  WHERE
    MATNR LIKE @P_MATNR
  AND
    ERSDA IN @S_ERSDA.


  IF SY-SUBRC IS INITIAL.
     GV_VALUE = SY-DBCNT.
  ELSE.
    MESSAGE S000(ZTEST) DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  LOOP AT LIT_MARA INTO GW_MARA.
    WRITE:
      /  GW_MARA-MATNR,   "品目コード
      20 GW_MARA-ERSDA,   "登録日付
      40 GW_MARA-ERNAM,   "オブジェクト登録者名
      60 GW_MARA-LAEDA,   "最終変更日付
      80 GW_MARA-AENAM.   "オブジェクトの変更者名
  ENDLOOP.
  ULINE.

    WRITE:
      / '件数 = ',
      GV_VALUE,
      '件'.
ENDFORM.
