CLASS lhc_HomeTax DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR HomeTax RESULT result.

    METHODS excel_validation FOR READ
      IMPORTING keys FOR FUNCTION HomeTax~excel_validation RESULT result.

ENDCLASS.

CLASS lhc_HomeTax IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD excel_validation.
    TYPES : BEGIN OF ty_s_rawdata,
              HTInputDate    TYPE string,
              HTApprvNo      TYPE string,
              Col03          TYPE string,
              Col04          TYPE string,
              HTSupplierNo   TYPE string,
              Col06          TYPE string,
              HTSupplier     TYPE string,
              Col08          TYPE string,
              Col09          TYPE string,
              Col10          TYPE string,
              Col11          TYPE string,
              Col12          TYPE string,
              Col13          TYPE string,
              Col14          TYPE string,
              HTTotalAmount  TYPE string,
              HTSupplyAmount TYPE string,
              HTTaxAmount    TYPE string,
              Currency       TYPE string,
              ErrMsg         TYPE string,
              updatekey      TYPE string,
            END OF ty_s_rawdata.
    DATA:
      lt_excel   TYPE TABLE OF ty_s_rawdata,
      lt_restemp TYPE TABLE OF zstrfi_a_exp_err_02,
      ls_restemp TYPE          zstrfi_a_exp_err_02,
      lt_rawdata TYPE TABLE OF zstrfi_i_hometax,
      ls_rawdata TYPE          zstrfi_i_hometax,
      lv_conuuid TYPE string.
*    FIELD-SYMBOLS: <fs_result> LIKE LINE OF result.

    LOOP AT keys INTO DATA(ls_key).
      DATA: lr_excel TYPE REF TO data.
*      DATA: lr_excel TYPE REF TO ty_rawdata.

      lr_excel = REF #( lt_excel[] ).

      zcl_strcm_excel_import=>base64_to_itab(
        EXPORTING
          iv_excel_file     = ls_key-%param-excel_file
          iv_fr_col         = ls_key-%param-fr_col
          iv_to_col         = ls_key-%param-to_col
          iv_fr_row         = ls_key-%param-fr_row
        CHANGING
          it_internal_table = lr_excel
      ).

      DATA : lv_msgcheck  TYPE c LENGTH 1.

      DATA : ls_typecheck TYPE zstrfi_i_hometax.
*
      LOOP AT lt_excel ASSIGNING FIELD-SYMBOL(<fs_excel>).
        IF <fs_excel> IS INITIAL.
          CONTINUE.
        ENDIF.
        "Null 값 Check
        IF    <fs_excel>-htapprvno        IS INITIAL
           OR <fs_excel>-htinputdate      IS INITIAL
           OR <fs_excel>-htsupplier       IS INITIAL
           OR <fs_excel>-htsupplierno     IS INITIAL
           OR <fs_excel>-htsupplyamount   IS INITIAL
           OR <fs_excel>-httotalamount    IS INITIAL.

          <fs_excel>-ErrMsg = 'N'.
          lv_msgcheck = 'X'.
        ENDIF.

        "Data Type Validation Check
        REPLACE ALL OCCURRENCES OF '-' IN <fs_excel>-htinputdate WITH ''.
        REPLACE ALL OCCURRENCES OF '-' IN <fs_excel>-HTSupplierNo WITH ''.

*       할당 및 기본적인 Type 체크
        TRY.
            ls_typecheck-htapprvno      = <fs_excel>-htapprvno.
            ls_typecheck-htinputdate    = <fs_excel>-htinputdate.
            ls_typecheck-htsupplier     = <fs_excel>-htsupplier.
            ls_typecheck-htsupplierno   = <fs_excel>-htsupplierno.
            ls_typecheck-htsupplyamount = <fs_excel>-htsupplyamount.
            ls_typecheck-httotalamount  = <fs_excel>-httotalamount.
          CATCH cx_root.
            <fs_excel>-ErrMsg = 'F'.
            lv_msgcheck = 'X'.
        ENDTRY.


        "HTInputDate 필드 Type Check
        IF not zcl_strcm_date_methods=>date_type_check( EXPORTING iv_str    = <fs_excel>-htinputdate ).
          <fs_excel>-ErrMsg = 'F'.
          lv_msgcheck = 'X'.
        ENDIF.

        "HTSupplierNo 필드 Type Check
        if strlen( <fs_excel>-htsupplierno ) > 12 or <fs_excel>-htsupplierno cn '0123456789'.
          <fs_excel>-ErrMsg = 'F'.
          lv_msgcheck = 'X'.
        endif.

        "중복 승인번호 Check - Excel 데이터 내부
        IF lv_msgcheck IS INITIAL.
          SELECT *
            FROM   @lt_rawdata AS rawdata
            WHERE  rawdata~HTApprvNo = @<fs_excel>-HTApprvNo
            INTO TABLE @DATA(lt_dupexcel).

          IF lt_dupexcel[] IS NOT INITIAL.
            <fs_excel>-ErrMsg = 'E'.
            lv_msgcheck = 'X'.
          ENDIF.
        ENDIF.

        "중복 승인번호 Check - DB Table
        IF lv_msgcheck IS INITIAL.
          SELECT SINGLE id, htapprvno
            FROM   zstrfi_c_journalhometax
            WHERE  HTApprvNo = @<fs_excel>-HTApprvNo
            INTO @DATA(ls_dupdb).

          IF ls_dupdb IS NOT INITIAL.
            <fs_excel>-ErrMsg = 'D'.
            lv_conuuid = ls_dupdb-id.
            lv_conuuid = to_lower( lv_conuuid ).
            CONCATENATE lv_conuuid+0(8) '-'
                        lv_conuuid+8(4) '-'
                        lv_conuuid+12(4) '-'
                        lv_conuuid+16(4) '-'
                        lv_conuuid+20(12)
                   INTO <fs_excel>-updatekey.
          ENDIF.
        ENDIF.

        CLEAR: ls_dupdb.

        <fs_excel>-currency = 'KRW'.

        "Excel 데이터 내부 중복 확인

        APPEND INITIAL LINE TO lt_rawdata ASSIGNING FIELD-SYMBOL(<fs_rawdata>).
        <fs_rawdata>-HTApprvNo = <fs_excel>-HTApprvNo.
      ENDLOOP.

      MOVE-CORRESPONDING lt_excel TO lt_restemp.

      LOOP AT lt_restemp ASSIGNING FIELD-SYMBOL(<fs_restemp>).
        IF <fs_restemp> IS NOT INITIAL.
          APPEND INITIAL LINE TO result[] ASSIGNING FIELD-SYMBOL(<fs_result>).
          <fs_result>-%param = <fs_restemp>.
        ENDIF.
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
