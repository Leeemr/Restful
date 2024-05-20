CLASS zcl_strfi11_put_header DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .

    METHODS: constructor.


  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mt_name_mapping TYPE /ui2/cl_json=>name_mappings.

ENDCLASS.



CLASS ZCL_STRFI11_PUT_HEADER IMPLEMENTATION.


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
                      ( abap = 'koart' json = 'FinancialAccountType' )
                      ( abap = 'absbu' json = 'SendingCompanyCode' )
                      ( abap = 'ausfd' json = 'PaymentDueDate' )
                      ( abap = 'land1' json = 'CompanyCodeCountry' )
                      ( abap = 'rzawe' json = 'PaymentMethod' )
                      ( abap = 'zaldt' json = 'PostingDate' )
                      ( abap = 'valut' json = 'ValueDate' )
                      "( abap = 'gjahr' json = 'FiscalYear' ) " FiscalYear 는 전송되지 않지만 포맷통일을 위해 넣어둠
                      ( abap = 'ubnky' json = 'Bank' )
                      ( abap = 'stras' json = 'StreetAddressName' )
                      ( abap = 'name1' json = 'OrganizationBPName1' )
                      ( abap = 'name2' json = 'OrganizationBPName2' )
                      ( abap = 'ubnkl' json = 'BankInternalID' )
                      ( abap = 'ubknt' json = 'BankAccount' )
                      ( abap = 'ubnks' json = 'BankCountry' )
                      ( abap = 'ubknt_long' json = 'BankAccountLongID' )
                      ( abap = 'hbkid' json = 'HouseBank' )
                      ( abap = 'hktid' json = 'HouseBankAccount' )
                      ( abap = 'znme1' json = 'PayeeName' )
                      ( abap = 'znme2' json = 'PayeeAdditionalName' )
                      ( abap = 'zbnks' json = 'PayeeBankCountry' )
                      ( abap = 'zbnkl' json = 'PayeeBank' )
                      ( abap = 'zbnky' json = 'PayeeBankKey' )
                      ( abap = 'zbnkn' json = 'PayeeBankAccount' )
                      ( abap = 'zbnkn_long' json = 'PayeeBankAccountLongID' )
                      ( abap = 'koinh' json = 'PayeeBankAccountHolderName' )
                      ( abap = 'rbetr' json = 'PaymentAmountInFunctionalCrcy' )
                      ( abap = 'waers' json = 'PaymentCurrency' )
                      ).

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

*    DELETE FROM zstrfi11_aheader. " TODO: 개발용 - 테이블 전체 삭제시 활용
*    RETURN. " TODO: 개발용 - 테이블 전체 삭제 때 활용


    DATA ls_payment_header TYPE zif_strfi11_api=>ts_payment_header_result.

    " ZSTRFI11_AHEADER 입력용
    DATA lt_zstrfi11_aheader TYPE STANDARD TABLE OF zstrfi11_aheader.

    """ 연동시작
    DATA(lv_json) = request->get_text( ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_json
                                         name_mappings = mt_name_mapping
*                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                               CHANGING data = ls_payment_header ).
    """ 연동끝

    DATA: lv_internal_amount TYPE zdec23_2.

    " 테이블에 입력전 전처리
    " 웹서비스로 전달받는 시간데이터는 UTC timestamp 값들이다.
    " 이것들 YYYYMMDD 로 변환한다.

    LOOP AT ls_payment_header-results ASSIGNING FIELD-SYMBOL(<result>).

      " vblnr 이 'F' 로 시작되면 이후 프로세스에서 삭제하기 때문에 전처리 생략 (CONTINUE)
      IF <result>-vblnr CP `F*`. CONTINUE. ENDIF.

      " xvorl 이 T(t) 이면 이후 프로세스에서 삭제하기 때문에 전처리 생략(CONTINUE)
      IF <result>-xvorl EQ 'True' OR <result>-xvorl EQ 'true'. CONTINUE. ENDIF.

      " PaymentRunID 길기가 5보다 크면 <result>-xvorl 을 강제로 'True'로 만든다.
      " 이 Row 는 이후 프로세스에서 삭제되기 때문에 전처리 생략(CONTINUE)
      IF strlen( <result>-laufi ) > 5.
        <result>-xvorl = 'True'.
        CONTINUE.
      ENDIF.

      IF <result>-rzawe EQ 't'. " 만약 소문자 t 로 전송되어 온다면 강제로 대문자 'T' 로 치환한다.
        <result>-rzawe = 'T'.
      ENDIF.

      " PaymentMethod(지급방법) 가 'T' 가 아닐 경우 전처리 생략(CONTINUE)
      IF <result>-rzawe NE 'T' .
        CONTINUE.
      ENDIF.

      <result>-laufd = zcl_strcm_utils=>parse_json_date( <result>-laufd ).
      zcl_strcm_utils=>unix_time_to_timestamp(  EXPORTING iv_tstmp = <result>-laufd
                                                IMPORTING ev_date = <result>-laufd ).

      <result>-ausfd = zcl_strcm_utils=>parse_json_date( <result>-ausfd ).
      zcl_strcm_utils=>unix_time_to_timestamp(  EXPORTING iv_tstmp = <result>-ausfd
                                                IMPORTING ev_date = <result>-ausfd ).

      <result>-zaldt = zcl_strcm_utils=>parse_json_date( <result>-zaldt ).
      zcl_strcm_utils=>unix_time_to_timestamp(  EXPORTING iv_tstmp = <result>-zaldt
                                                IMPORTING ev_date = <result>-zaldt ).

      <result>-valut = zcl_strcm_utils=>parse_json_date( <result>-valut ).
      zcl_strcm_utils=>unix_time_to_timestamp(  EXPORTING iv_tstmp = <result>-valut
                                                IMPORTING ev_date = <result>-valut ).

      <result>-gjahr = zcl_strcm_utils=>get_fiscal_year_from( <result>-zaldt ).

      lv_internal_amount = <result>-rbetr.
      <result>-rbetr = zcl_strcm_utils=>currency_conv_to_internal_krw( amount_display = lv_internal_amount ).

    ENDLOOP.

    " 테이블에 입력
    lt_zstrfi11_aheader = CORRESPONDING #( ls_payment_header-results ).

    " Z 테이블에 입력하기 전 아래 조건의 레코드를 삭제한다.
    " vblnr(PaymentDocument)이 'F' 로 시작될 경우 (외부전표)
    " xvorl(PaymentRunIsProposal, 자동지급제안) 값이 'T(t)' 일 경우 (20240411)
    " rzawe(PaymentMethod) 값이 'T' 가 아닐 경우 (20240418)
    DELETE lt_zstrfi11_aheader WHERE vblnr CP `F*` OR xvorl = 'T' OR xvorl = 't' OR rzawe NE 'T'.


    "MODIFY zstrfi11_aheader FROM TABLE @lt_zstrfi11_aheader.
    INSERT zstrfi11_aheader FROM TABLE @lt_zstrfi11_aheader ACCEPTING DUPLICATE KEYS.

  ENDMETHOD.
ENDCLASS.
