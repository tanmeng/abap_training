*&---------------------------------------------------------------------*
*& Include          ZDINGTEST008F01
*&---------------------------------------------------------------------*


FORM MAIN_PROC.
   SELECT SINGLE
     MATNR,                   "品目コード
     ERSDA,                   "登録日付
     ERNAM,                   "オブジェクト登録者名
     LAEDA,                   "最終変更日付
     AENAM                    "オブジェクトの変更者名
   FROM
     MARA
   INTO
     @GW_MARA
   WHERE
     MATNR = @P_MATNR.       "品目コード

  IF SY-SUBRC IS INITIAL.
    WRITE:
      / '品目コード', 20 GW_MARA-MATNR,
      / '登録日',     20 GW_MARA-ERSDA,
      / '登録日',     20 GW_MARA-ERNAM,
      / '変更日',     20 GW_MARA-LAEDA,
      / '変更者',     20 GW_MARA-AENAM.
  ELSE.
*  データが存在しません。
    MESSAGE S000(ZDTEST02) DISPLAY LIKE 'E'.
    LEAVE  TO LIST-PROCESSING.
  ENDIF.
ENDFORM.
