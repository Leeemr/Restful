CLASS zcl_strfi11_put_item DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .

    METHODS: constructor.


  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mt_name_mapping TYPE /ui2/cl_json=>name_mappings.

ENDCLASS.



CLASS ZCL_STRFI11_PUT_ITEM IMPLEMENTATION.


  METHOD constructor.

    mt_name_mapping = VALUE #(
                              ( abap = 'laufd' json = 'PaymentRunDate' )
                              ( abap = 'laufi' json = 'PaymentRunID' )
                              ( abap = 'xvorl' json = 'PaymentRunIsProposal' )
                              ( abap = 'zbukr' json = 'PayingCompanyCode' )
                              ( abap = 'lifnr' json = 'Supplier' )
                              ( abap = 'kunnr' json = 'Customer' )
                              ( abap = 'empfg' json = 'PaymentRecipient' )
                              ( abap = 'vblnr' json = 'PaymentDocument' )
                              ( abap = 'bukrs' json = 'CompanyCode' )
                              ( abap = 'belnr' json = 'AccountingDocument' )
                              ( abap = 'gjahr' json = 'FiscalYear' )
                              ( abap = 'buzei' json = 'AccountingDocumentItem' )
                              ( abap = 'blart' json = 'AccountingDocumentType' )
                              ( abap = 'bldat' json = 'DocumentDate' )
                              ( abap = 'zfbdt' json = 'DueCalculationBaseDate' )
                              ( abap = 'zlsch' json = 'PaymentMethod' )                   " JSON 없음
                              ( abap = 'budat' json = 'PostingDate' )                     " JSON 없음
                              ( abap = 'sgtxt' json = 'DocumentItemText' )                " JSON 없음
                              ( abap = 'hkont' json = 'GLAccount' )                       " JSON 없음
                              ( abap = 'mwskz' json = 'TaxCode' )                         " JSON 없음
                              ( abap = 'wrbtr' json = 'AmountInTransactionCurrency' )
                              ( abap = 'waers' json = 'PaymentCurrency' )
                              ( abap = 'shkzg' json = 'DebitCreditCode' )
                              ( abap = 'bupla' json = 'BusinessPlace' )
                              ( abap = 'hbkid' json = 'HouseBank' )
                              ( abap = 'saknr' json = 'BankReconciliationAccount' )
                              ( abap = 'zwels' json = 'ConsideredPaymentMethods' )
                          ).

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

*    DELETE FROM zstrfi11_aitem. " TODO: 개발용 - 테이블 전체 삭제시 활용
*    RETURN. " TODO: 개발용 - 테이블 전체 삭제 때 활용


    DATA ls_payment_item TYPE zif_strfi11_api=>ts_payment_item_result.

    " ZSTRFI11_AITEM 입력용
    DATA lt_zstrfi11_aitem TYPE STANDARD TABLE OF zstrfi11_aitem.

    """ 연동시작
    DATA(lv_json) = request->get_text( ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_json
                                         name_mappings = mt_name_mapping
*                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                               CHANGING data = ls_payment_item ).
    """ 연동끝

    DATA: lv_internal_amount TYPE zdec23_2.

    " 테이블에 입력전 전처리
    " 웹서비스로 전달받는 시간데이터는 UTC timestamp 값들이다.
    " 이것들 YYYYMMDD 로 변환한다.

    LOOP AT ls_payment_item-results ASSIGNING FIELD-SYMBOL(<result>).

      <result>-laufd = zcl_strcm_utils=>parse_json_date( <result>-laufd ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-laufd
                                  IMPORTING ev_date = <result>-laufd ).

      <result>-bldat = zcl_strcm_utils=>parse_json_date( <result>-bldat ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-bldat
                                  IMPORTING ev_date = <result>-bldat ).

      <result>-zfbdt = zcl_strcm_utils=>parse_json_date( <result>-zfbdt ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-zfbdt
                                  IMPORTING ev_date = <result>-zfbdt ).

      lv_internal_amount = <result>-wrbtr.
      <result>-wrbtr = zcl_strcm_utils=>currency_conv_to_internal_krw( amount_display = lv_internal_amount ).

    ENDLOOP.

    " 테이블에 입력
    lt_zstrfi11_aitem = CORRESPONDING #( ls_payment_item-results ).

    " vblnr(PaymentDocument)이 'F' 로 시작되면 외부전표이다.
    " 이것은 입력을 생략한다.
    " Z 테이블에 트렌젝션 하기 전 인터널 테이블의 vblnr 이 'F' 로 시작되는 레코드를 모두 삭제한다.
    DELETE lt_zstrfi11_aitem WHERE vblnr CP `F*`.

    "MODIFY zstrfi11_aitem FROM TABLE @lt_zstrfi11_aitem.
    INSERT zstrfi11_aitem FROM TABLE @lt_zstrfi11_aitem ACCEPTING DUPLICATE KEYS.

  ENDMETHOD.
ENDCLASS.
