*&---------------------------------------------------------------------*
*& Include          ZDINGTEST020F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& FORM
*&---------------------------------------------------------------------*

FORM MAIN_PROC.
  CLEAR:
    GV_COUNT,
    GIT_MARA.

  CALL FUNCTION 'Z_DING_MARA'
    EXPORTING
      IM_CREATE    = P_ERNAM
    IMPORTING
      EX_COUNT     = GV_COUNT
    TABLES
      HINMOKU      = GIT_MARA
    EXCEPTIONS
      NOTFND        = 1
      OTHERS        = 2
            .
    IF SY-SUBRC IS INITIAL.

      LOOP AT GIT_MARA INTO GW_MARA.
        WRITE:
          /  GW_MARA-MATNR,    "品目コード
          20 GW_MARA-ERSDA.    "登録者

      ENDLOOP.
      ULINE.

    ELSE.
* 対象データが取得できません
      MESSAGE S101(ZDTEST01) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.



ENDFORM.
