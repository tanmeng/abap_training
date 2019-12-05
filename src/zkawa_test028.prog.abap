*&---------------------------------------------------------------------*
*& Report ZKAWA_TEST028
*&---------------------------------------------------------------------*
*& 演習問題３：レコーダによる登録
*&---------------------------------------------------------------------*
REPORT ZKAWA_TEST028
       NO STANDARD PAGE HEADING LINE-SIZE 255.

INCLUDE BDCRECX1.

PARAMETERS:
  DATASET(132) LOWER CASE.
***    DO NOT CHANGE - the generated data section - DO NOT CHANGE    ***
*
*   If it is nessesary to change the data section use the rules:
*   1.) Each definition of a field exists of two lines
*   2.) The first line shows exactly the comment
*       '* data element: ' followed with the data element
*       which describes the field.
*       If you don't have a data element use the
*       comment without a data element name
*   3.) The second line shows the fieldname of the
*       structure, the fieldname must consist of
*       a fieldname and optional the character '_' and
*       three numbers and the field length in brackets
*   4.) Each field must be type C.
*
*** Generated data section with specific formatting - DO NOT CHANGE  ***
DATA:
  BEGIN OF RECORD,
* data element: BU_LOCATOR_DIALOG_SEARCH_TYPE
        SEARCH_TYPE_001(014),
* data element: BU_LOCATOR_DIALOG_SEARCH_ID
        SEARCH_ID_002(002),
* data element: BU_PARTNER
        PARTNER_NUMBER_003(016),
* data element: BU_ROLE_SCREEN
        PARTNER_ROLE_004(007),
* data element: BU_TIMEDEP_SCREEN
        PARTNER_TIMEDEP_005(007),
  END OF RECORD.

*** End generated data section ***

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM OPEN_DATASET USING DATASET.
  PERFORM OPEN_GROUP.

  DO.

    READ DATASET DATASET INTO RECORD.

    IF SY-SUBRC <> 0.

      EXIT.

    ENDIF.

    PERFORM BDC_DYNPRO      USING 'SAPLBUS_LOCATOR' '3000'.
    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                  '=BUS_MAIN_BACK'.
    PERFORM BDC_FIELD       USING 'BUS_LOCA_SRCH01-SEARCH_TYPE'
                                  RECORD-SEARCH_TYPE_001.
    PERFORM BDC_FIELD       USING 'BUS_LOCA_SRCH01-SEARCH_ID'
                                  RECORD-SEARCH_ID_002.
    PERFORM BDC_FIELD       USING 'BUS_JOEL_SEARCH-PARTNER_NUMBER'
                                  RECORD-PARTNER_NUMBER_003.
    PERFORM BDC_FIELD       USING 'BUS_JOEL_MAIN-PARTNER_ROLE'
                                  RECORD-PARTNER_ROLE_004.
    PERFORM BDC_FIELD       USING 'BUS_JOEL_MAIN-PARTNER_TIMEDEP'
                                  RECORD-PARTNER_TIMEDEP_005.
    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                  'GS_LFA1-KUNNR'.
    PERFORM BDC_TRANSACTION USING 'BP'.

  ENDDO.

  PERFORM CLOSE_GROUP.
  PERFORM CLOSE_DATASET USING DATASET.
