CLASS lhc_paymentproposalpayment DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF payee_match_status,
        success TYPE c LENGTH 1 VALUE 'S', " SUCCESS
        error   TYPE c LENGTH 1 VALUE 'E', " ERROR
      END OF payee_match_status.

    CONSTANTS:
      BEGIN OF api_trans_status,
        success TYPE c LENGTH 1 VALUE 'S', " SUCCESS
        error   TYPE c LENGTH 1 VALUE 'E', " ERROR
      END OF api_trans_status.


    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR paymentproposalpayment RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR paymentproposalpayment RESULT result.


    METHODS check_holder FOR MODIFY
      IMPORTING keys FOR ACTION paymentproposalpayment~check_holder RESULT result.

    METHODS post_api FOR MODIFY
      IMPORTING keys FOR ACTION paymentproposalpayment~post_api RESULT result.

    METHODS check_balance FOR MODIFY
      IMPORTING keys FOR ACTION paymentproposalpayment~check_balance RESULT result.

    " result 파라미터가 없을 때
*    METHODS refresh FOR MODIFY
*      IMPORTING keys FOR ACTION paymentproposalpayment~refresh.

*    " result 파라미터가 있을 때
*    METHODS refresh FOR MODIFY
*      IMPORTING keys FOR ACTION paymentproposalpayment~refresh RESULT result.


    " Helper methods
    METHODS get_payment_headers.

    METHODS get_payment_items.

ENDCLASS.


CLASS lhc_paymentproposalpayment IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_instance_features.

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
        FIELDS ( reversedocument payeematch payeematchstatus apitransstatus paymentcurrency )
        WITH CORRESPONDING #( keys )
      RESULT DATA(proposals)
      FAILED failed.

    " evaluate the conditions, set the operation state, and set result parameter
    result = VALUE #( FOR proposal IN proposals
                        ( %tky = proposal-%tky
                          %features-%action-check_holder = COND #( WHEN ( proposal-payeematchstatus IS NOT INITIAL AND proposal-payeematchstatus = payee_match_status-success )
                                                                    OR proposal-apitransstatus = api_trans_status-success
                                                                    OR proposal-reversedocument IS NOT INITIAL
                                                                    OR proposal-paymentcurrency <> 'KRW'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                          %features-%action-post_api = COND #( WHEN proposal-payeematchstatus IS INITIAL
                                                                OR proposal-payeematchstatus <> payee_match_status-success
                                                                OR proposal-apitransstatus = api_trans_status-success
                                                                OR proposal-reversedocument IS NOT INITIAL
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled )
                         ) ).

  ENDMETHOD.


  METHOD check_holder.

    DATA: ls_check_holder        TYPE zif_strfi11_api=>ts_check_holder,
          ls_check_holder_result TYPE zif_strfi11_api=>ts_check_holder_result.

    DATA: lv_check_holder_json TYPE string.

    DATA: lv_severity TYPE if_abap_behv_message=>t_severity.

    DATA: lv_msg TYPE string.

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
        FIELDS ( payeebank payeebankaccount bank ) WITH CORRESPONDING #( keys )
      RESULT DATA(paymentproposalpayments)
      FAILED DATA(read_failed).

    CHECK paymentproposalpayments IS NOT INITIAL.

    LOOP AT paymentproposalpayments ASSIGNING FIELD-SYMBOL(<fs_paymentproposalpayment>).

      CLEAR: ls_check_holder, ls_check_holder_result.

      ls_check_holder-channel = zif_strfi11_api=>co_channel.
      ls_check_holder-corp_biz_no = zif_strfi11_api=>co_corp_biz_no.
      ls_check_holder-bankcd = <fs_paymentproposalpayment>-payeebank.

      ls_check_holder-acctno = <fs_paymentproposalpayment>-payeebankaccount.
      ls_check_holder-acctno = zcl_strcm_utils=>exit_special_character( ls_check_holder-acctno ).

      ls_check_holder-outbankcd = <fs_paymentproposalpayment>-bank.
      ls_check_holder-trxamt = `0`.

      TRY.

          ls_check_holder_result = zcl_strfi11_api=>check_holder( is_check_holder = ls_check_holder ).

          IF ls_check_holder_result-errcode NE '0000'.

            <fs_paymentproposalpayment>-payeematch = `ERROR: ` && ls_check_holder_result-data-err_msg.
            <fs_paymentproposalpayment>-payeematchstatus = payee_match_status-error.

            APPEND VALUE #( %msg = new_message_with_text(   severity  = if_abap_behv_message=>severity-error
                                                            text = <fs_paymentproposalpayment>-payeematch )
                        ) TO reported-paymentproposalpayment.

          ELSEIF ls_check_holder_result-data-bankrespcode NE '0000'.

            ls_check_holder_result-data-bankrespdesc = zcl_strcm_utils=>exit_special_character( ls_check_holder_result-data-bankrespdesc ).
            <fs_paymentproposalpayment>-payeematch = `ERROR: ` && ls_check_holder_result-data-bankrespdesc.
            <fs_paymentproposalpayment>-payeematchstatus = payee_match_status-error.

            APPEND VALUE #( %msg = new_message_with_text(   severity  = if_abap_behv_message=>severity-error
                                                            text = <fs_paymentproposalpayment>-payeematch )
                        ) TO reported-paymentproposalpayment.

          ELSE.

            <fs_paymentproposalpayment>-payeematch = ls_check_holder_result-data-depositor.
            <fs_paymentproposalpayment>-payeematchstatus = payee_match_status-success.

            APPEND VALUE #( %msg = new_message_with_text(   severity  = if_abap_behv_message=>severity-success
                                                            text = ls_check_holder_result-data-bankrespdesc )
                        ) TO reported-paymentproposalpayment.

          ENDIF.

        CATCH zcx_strfi11_api INTO DATA(lx_exception).

          <fs_paymentproposalpayment>-payeematch = lx_exception->get_text( ).

          APPEND VALUE #( %msg = new_message_with_text(   severity  = if_abap_behv_message=>severity-error
                                                          text = <fs_paymentproposalpayment>-payeematch )
                      ) TO reported-paymentproposalpayment.

      ENDTRY.

    ENDLOOP.

    MODIFY ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
        UPDATE FIELDS ( payeematch payeematchstatus )
        WITH VALUE #( FOR paymentproposalpayment IN paymentproposalpayments ( %tky = paymentproposalpayment-%tky
                                                                              payeematch = paymentproposalpayment-payeematch
                                                                              payeematchstatus = paymentproposalpayment-payeematchstatus
                                                                               ) )
      FAILED DATA(updated_failed)
      REPORTED DATA(updated_reported).

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
       ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(paymentproposalpayments_result).

    " set the action result parameter
    result = VALUE #( FOR paymentproposalpayment_result IN paymentproposalpayments_result ( %tky = paymentproposalpayment_result-%tky
                                                                                            %param = paymentproposalpayment_result ) ).

  ENDMETHOD.


  METHOD post_api.

    DATA: ls_post_api        TYPE zif_strfi11_api=>ts_post_api,
          ls_post_api_result TYPE zif_strfi11_api=>ts_post_api_result.

    DATA: lv_post_api_json TYPE string.

    DATA: lv_external_amount     TYPE zdec23_2,
          lv_external_amount_i   TYPE i,
          lv_external_amount_str TYPE string.

    DATA: lv_severity TYPE if_abap_behv_message=>t_severity.

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
     ENTITY paymentproposalpayment
*         ALL FIELDS WITH CORRESPONDING #( keys )
       FIELDS ( bank bankaccount paymentamountinfunctionalcrcy payeebank payeebankaccount ) WITH CORRESPONDING #( keys )
     RESULT DATA(paymentproposalpayments)
     FAILED DATA(read_failed).

    CHECK paymentproposalpayments IS NOT INITIAL.

    LOOP AT paymentproposalpayments ASSIGNING FIELD-SYMBOL(<fs_paymentproposalpayment>).

      CLEAR: ls_post_api, ls_post_api_result.

      ls_post_api-channel = zif_strfi11_api=>co_channel.
      ls_post_api-corp_biz_no = zif_strfi11_api=>co_corp_biz_no.

      ls_post_api-outbankcd = <fs_paymentproposalpayment>-bank.                         " 출금은행코드

      ls_post_api-outacctno = <fs_paymentproposalpayment>-bankaccount.                  " 출금계좌번호
      ls_post_api-outacctno = zcl_strcm_utils=>exit_special_character( ls_post_api-outacctno ).

      ls_post_api-outacctpw = ''.

      " 출금금액
      lv_external_amount = <fs_paymentproposalpayment>-paymentamountinfunctionalcrcy.
      lv_external_amount_i = zcl_strcm_utils=>currency_conv_to_external_krw( amount_internal = lv_external_amount ).
      IF lv_external_amount_i < 0.
        lv_external_amount_i =  lv_external_amount_i * -1.
      ENDIF.

      lv_external_amount_str = lv_external_amount_i. " integer -> string 형변환

      ls_post_api-outamt = zcl_strcm_utils=>exit_special_character( lv_external_amount_str ).

      ls_post_api-outdesc = ''.                                                         " 출금계좌적요

      ls_post_api-inbankcd = <fs_paymentproposalpayment>-payeebank.                     " 입금은행코드

      ls_post_api-inacctno = <fs_paymentproposalpayment>-payeebankaccount.              " 입금계좌번호
      ls_post_api-inacctno = zcl_strcm_utils=>exit_special_character( ls_post_api-inacctno ).

      ls_post_api-indesc = zif_strfi11_api=>co_indesc.                                  " 입금계좌적요

      ls_post_api-cmscd = ''.                                                           " CMSCD
      ls_post_api-salaryyn = ''.                                                        " 급여구분


      TRY.

          ls_post_api_result = zcl_strfi11_api=>post_api( is_post_api = ls_post_api ).

          IF ls_post_api_result-errcode NE '0000'.

            <fs_paymentproposalpayment>-apitrans = `ERROR: ` && ls_post_api_result-data-err_msg.
            <fs_paymentproposalpayment>-apitransstatus = api_trans_status-error.
            lv_severity = if_abap_behv_message=>severity-error.

          ELSEIF ls_post_api_result-data-bankrespcode NE '0000'.

*            ls_post_api_result-data-bankrespdesc = zcl_strcm_utils=>exit_special_character( ls_post_api_result-data-bankrespdesc ).
            <fs_paymentproposalpayment>-apitrans = `ERROR: ` && ls_post_api_result-data-bankrespdesc.
            <fs_paymentproposalpayment>-apitransstatus = api_trans_status-error.
            lv_severity = if_abap_behv_message=>severity-error.

          ELSE.

            <fs_paymentproposalpayment>-apitrans = zcl_strcm_utils=>exit_special_character( ls_post_api_result-data-bankrespdesc ).
            <fs_paymentproposalpayment>-apitransstatus = api_trans_status-success.
            <fs_paymentproposalpayment>-issueno = zcl_strcm_utils=>exit_special_character( ls_post_api_result-data-issueno ).
            lv_severity = if_abap_behv_message=>severity-success.

          ENDIF.

          APPEND VALUE #( %msg = new_message_with_text(   severity  = lv_severity
                                                          text = <fs_paymentproposalpayment>-apitrans )
                      ) TO reported-paymentproposalpayment.

        CATCH zcx_strfi11_api INTO DATA(lx_exception).

          <fs_paymentproposalpayment>-apitransstatus = lx_exception->get_text( ).

          APPEND VALUE #( %msg = new_message_with_text(   severity  = if_abap_behv_message=>severity-error
                                                          text = <fs_paymentproposalpayment>-apitrans )
                      ) TO reported-paymentproposalpayment.

      ENDTRY.

    ENDLOOP.

    MODIFY ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
        UPDATE FIELDS ( apitrans apitransstatus issueno )
        WITH VALUE #( FOR paymentproposalpayment IN paymentproposalpayments ( %tky = paymentproposalpayment-%tky
                                                                              apitrans = paymentproposalpayment-apitrans
                                                                              apitransstatus = paymentproposalpayment-apitransstatus
                                                                              issueno = paymentproposalpayment-issueno ) )
      FAILED DATA(updated_failed)
      REPORTED DATA(updated_reported).

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
       ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(paymentproposalpayments_result).

    " set the action result parameter
    result = VALUE #( FOR paymentproposalpayment_result IN paymentproposalpayments_result ( %tky = paymentproposalpayment_result-%tky
                                                                                            %param = paymentproposalpayment_result ) ).

  ENDMETHOD.


  METHOD check_balance.

    DATA: ls_check_balance        TYPE zif_strfi11_api=>ts_check_balance,
          ls_check_balance_result TYPE zif_strfi11_api=>ts_check_balance_result.

    DATA: lv_check_holder_json TYPE string.

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
*         ALL FIELDS WITH CORRESPONDING #( keys )
        FIELDS ( bank bankaccount ) WITH CORRESPONDING #( keys )
      RESULT DATA(paymentproposalpayments)
      FAILED DATA(read_failed).

    CHECK paymentproposalpayments IS NOT INITIAL.

    LOOP AT paymentproposalpayments ASSIGNING FIELD-SYMBOL(<fs_paymentproposalpayment>).

      CLEAR: ls_check_balance, ls_check_balance_result.

      ls_check_balance-channel = zif_strfi11_api=>co_channel.
      ls_check_balance-corp_biz_no = zif_strfi11_api=>co_corp_biz_no.
      ls_check_balance-bankcd = <fs_paymentproposalpayment>-bank.
      ls_check_balance-acctno = <fs_paymentproposalpayment>-bankaccount.

      TRY.
          ls_check_balance_result = zcl_strfi11_api=>check_balance( is_check_balance = ls_check_balance ).
          <fs_paymentproposalpayment>-checkbalance = ls_check_balance_result-data-balance.

        CATCH zcx_strfi11_api INTO DATA(lx_exception).

          " 잔액조회를 사용하게 된다면 여기서 예외처리를 하여야 한다.

      ENDTRY.

    ENDLOOP.

    MODIFY ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
        UPDATE FIELDS ( checkbalance )
        WITH VALUE #( FOR paymentproposalpayment IN paymentproposalpayments ( %tky = paymentproposalpayment-%tky
                                                                              checkbalance = paymentproposalpayment-checkbalance ) )
      FAILED DATA(updated_failed)
      REPORTED DATA(updated_reported).

    READ ENTITIES OF zstrfi11_r_header IN LOCAL MODE
      ENTITY paymentproposalpayment
       ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(paymentproposalpayments_result).

    " set the action result parameter
    result = VALUE #( FOR paymentproposalpayment_result IN paymentproposalpayments_result ( %tky = paymentproposalpayment_result-%tky
                                                                                            %param = paymentproposalpayment_result ) ).

  ENDMETHOD.


*  METHOD refresh.
*    me->get_payment_headers( ).
*    me->get_payment_items( ).
*  ENDMETHOD.


  " HELPER METHODS
  METHOD get_payment_headers.

    DATA ls_payment_header TYPE zif_strfi11_api=>ts_payment_header_result.

    " ZSTRFI11_AHEADER 입력용
    DATA lt_zstrfi11_aheader TYPE STANDARD TABLE OF zstrfi11_aheader.

    """ 연동시작
    TRY.

        ls_payment_header = zcl_strfi11_api=>get_payment_header( ).

      CATCH cx_root INTO DATA(lx_exception).

    ENDTRY.
    """ 연동끝

    DATA: lv_internal_amount TYPE zdec23_2.

    " 테이블에 입력전 전처리
    " 웹서비스로 전달받는 시간데이터는 UTC timestamp 값들이다.
    " 이것들 YYYYMMDD 로 변환한다.
    LOOP AT ls_payment_header-results ASSIGNING FIELD-SYMBOL(<result>).

      <result>-laufd = zcl_strcm_utils=>parse_json_date( <result>-laufd ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-laufd
                                  IMPORTING ev_date = <result>-laufd ).

      <result>-ausfd = zcl_strcm_utils=>parse_json_date( <result>-ausfd ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-ausfd
                                  IMPORTING ev_date = <result>-ausfd ).

      <result>-zaldt = zcl_strcm_utils=>parse_json_date( <result>-zaldt ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-zaldt
                                  IMPORTING ev_date = <result>-zaldt ).

      <result>-valut = zcl_strcm_utils=>parse_json_date( <result>-valut ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-valut
                                  IMPORTING ev_date = <result>-valut ).

      <result>-gjahr = zcl_strcm_utils=>get_fiscal_year_from( <result>-zaldt ).

      lv_internal_amount = <result>-rbetr.
      <result>-rbetr = zcl_strcm_utils=>currency_conv_to_internal_krw( amount_display = lv_internal_amount ).

    ENDLOOP.

    " 테이블에 입력
    lt_zstrfi11_aheader = CORRESPONDING #( ls_payment_header-results ).

    " vblnr(PaymentDocument)이 'F' 로 시작되면 외부전표이다.
    " 이것은 입력을 생략한다.
    " Z 테이블에 트렌젝션 하기 전 인터널 테이블의 vblnr 이 'F' 로 시작되는 레코드를 모두 삭제한다.
    DELETE lt_zstrfi11_aheader WHERE vblnr CP `F*`.

    "MODIFY zstrfi11_aheader FROM TABLE @lt_zstrfi11_aheader.
    INSERT zstrfi11_aheader FROM TABLE @lt_zstrfi11_aheader ACCEPTING DUPLICATE KEYS.

  ENDMETHOD.


  METHOD get_payment_items.

    DATA ls_payment_item TYPE zif_strfi11_api=>ts_payment_item_result.

    " ZSTRFI11_AITEM 입력용
    DATA lt_zstrfi11_aitem TYPE STANDARD TABLE OF zstrfi11_aitem.


    """ 연동시작
    TRY.

        ls_payment_item = zcl_strfi11_api=>get_payment_item( ).

      CATCH cx_root INTO DATA(lx_exception).

    ENDTRY.
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
