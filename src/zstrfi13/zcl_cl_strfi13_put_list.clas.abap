CLASS zcl_cl_strfi13_put_list DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .

    METHODS: constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_name_mapping TYPE /ui2/cl_json=>name_mappings.

ENDCLASS.



CLASS ZCL_CL_STRFI13_PUT_LIST IMPLEMENTATION.


  METHOD constructor.

"거래 내역 api
    mt_name_mapping = VALUE #(
          ( abap = 'seq_no'     json = 'SEQ' )
          ( abap = 'ubnkl'      json = 'BANKCD' )
          ( abap = 'ubknt'      json = 'ACCT_NO' )
          ( abap = 'jukyo'      json = 'JUKYO' )
          ( abap = 'in_bal'     json = 'IN_BAL' )
          ( abap = 'out_bal'    json = 'OUT_BAL' )
          ( abap = 'tran_bal'   json = 'TRAN_BAL' )
          ( abap = 'waers'      json = 'CURRCD' )
          ( abap = 'tran_gb'    json = 'TRAN_GB' )
          ( abap = 'tran_gb_nm' json = 'TRAN_GB_NM' )
          ( abap = 'status'     json = 'STATUS' )
          ( abap = 'trans_time' json = 'TRAN_TIME' )
          ( abap = 'trans_date' json = 'TRAN_DATE' )
          ( abap = 'tran_key '  json = 'TRAN_KEY' )
          ).

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.


    DATA ls_ar_list TYPE zif_strfi12_api=>ts_ar_list_result.
*    DATA ls_ar_list TYPE TABLE OF zstrfi12_alist.

    " ZSTRFI12_AR 리스트 입력용
    DATA lt_zstrfi13_arlist TYPE STANDARD TABLE OF zstrfi13_alist.

    """ 연동시작
    DATA(lv_json) = request->get_text( ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_json
                                         name_mappings = mt_name_mapping
*                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                               CHANGING data = ls_ar_list ).

    """ 연동끝

    DATA: lv_internal_amount_in TYPE zdec23_2.
    DATA: lv_internal_amount_out TYPE zdec23_2.
    DATA: lv_waers TYPE waers.

    " 테이블에 입력전 전처리
    " 웹서비스로 전달받는 시간데이터는 UTC timestamp 값들이다.
    " 이것들 YYYYMMDD 로 변환한다.

    LOOP AT ls_ar_list-list ASSIGNING FIELD-SYMBOL(<result>).

*      <result>-trans_date = zcl_strcm_utils=>parse_json_date( <result>-trans_date ).
*      zcl_strcm_utils=>unix_time_to_timestamp(  EXPORTING iv_tstmp = <result>-trans_date
*                                                IMPORTING ev_date = <result>-trans_date ).
*
*      <result>-trans_time = zcl_strcm_utils=>parse_json_date( <result>-trans_time ).
*      zcl_strcm_utils=>unix_time_to_timestamp(  EXPORTING iv_tstmp = <result>-trans_time
*                                                IMPORTING ev_time = <result>-trans_time ).
*      <result>-gjahr = zcl_strcm_utils=>get_fiscal_year_from( <result>-gjahr ). "Fiscar Year
      <result>-bukrs = '1000'.                    "회사코드
      <result>-caccnt = '11009000'.               "차변계정
      <result>-caccntt_dt = '가수금'.             "차변내역
      <result>-status = 'R'.                      "상태값

      "금액 필드(로직 수정 24.05.17)
      lv_internal_amount_in = <result>-in_bal.
      lv_internal_amount_out = <result>-out_bal.
      lv_waers = <result>-waers.

      <result>-in_bal = zcl_strcm_utils=>currency_conv_to_internal( currency = lv_waers
                                                                    amount_display = lv_internal_amount_in ).
      <result>-out_bal = zcl_strcm_utils=>currency_conv_to_internal( currency = lv_waers
                                                                    amount_display = lv_internal_amount_out ).

    ENDLOOP.

    " 테이블에 입력
    lt_zstrfi13_arlist = CORRESPONDING #( ls_ar_list-list ).

    INSERT zstrfi13_alist FROM TABLE @lt_zstrfi13_arlist ACCEPTING DUPLICATE KEYS.

  ENDMETHOD.
ENDCLASS.
