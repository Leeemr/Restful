CLASS zcl_strfi11_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_strfi11_api.

    CLASS-METHODS:
      check_holder IMPORTING is_check_holder               TYPE zif_strfi11_api=>ts_check_holder
                   RETURNING VALUE(rs_check_holder_result) TYPE zif_strfi11_api=>ts_check_holder_result
                   RAISING   zcx_strfi11_api,

      post_api IMPORTING is_post_api               TYPE zif_strfi11_api=>ts_post_api
               RETURNING VALUE(rs_post_api_result) TYPE zif_strfi11_api=>ts_post_api_result
               RAISING   zcx_strfi11_api,

      check_balance IMPORTING is_check_balance               TYPE zif_strfi11_api=>ts_check_balance
                    RETURNING VALUE(rs_check_balance_result) TYPE zif_strfi11_api=>ts_check_balance_result
                    RAISING   zcx_strfi11_api,

      get_payment_header RETURNING VALUE(rs_payment_header) TYPE zif_strfi11_api=>ts_payment_header_result
                         RAISING   zcx_strfi11_api,

      get_payment_item RETURNING VALUE(rs_payment_item) TYPE zif_strfi11_api=>ts_payment_item_result
                       RAISING   zcx_strfi11_api.


  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_STRFI11_API IMPLEMENTATION.


  METHOD check_balance.

    DATA(struc2json_xco)  = xco_cp_json=>data->from_abap( is_check_balance )->to_string( ).
*    DATA json2struc_xco TYPE zif_strfi11_api=>ts_check_holder_result.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI11_API_GETTER'
                                service_id = 'ZSTRFI11_API_CHECK_BALANCE_REST'
                                ).

*        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://dev-stradvision-vth85adp.it-cpi015-rt.cfapps.ap12.hana.ondemand.com/http/FB020' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-type'
                                      i_value = 'application/json' ).

*        lo_request->set_query( query = 'data=[out:json];area[name="Heidelberg"];node["amenity"="biergarten"](area);out;' ).
        lo_request->append_text( data = struc2json_xco ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).

        DATA(check_balance_result_json) = lo_response->get_text( ).

        " JSON -> ABAP (structure) using XCO
        xco_cp_json=>data->from_string( check_balance_result_json )->write_to( REF #( rs_check_balance_result ) ).


*      CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).
*      CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).
      CATCH cx_static_check INTO DATA(lx_exception).

        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_exception )->if_message~get_longtext( ).

        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lx_exception )->t100key.

        RAISE EXCEPTION TYPE zcx_strfi11_api
          EXPORTING
            textid   = VALUE scx_t100key(
            msgid = exception_t100_key-msgid
            msgno = exception_t100_key-msgno
            attr1 = exception_t100_key-attr1
            attr2 = exception_t100_key-attr2
            attr3 = exception_t100_key-attr3
            attr4 = exception_t100_key-attr4 )
            previous = lx_exception.

    ENDTRY.

  ENDMETHOD.


  METHOD check_holder.

    DATA(struc2json_xco)  = xco_cp_json=>data->from_abap( is_check_holder )->to_string( ).
*    DATA json2struc_xco TYPE zif_strfi11_api=>ts_check_holder_result.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI11_API_GETTER'
                                service_id = 'ZSTRFI11_API_CHECK_HOLDER_REST'
                                ).

*        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://dev-stradvision-vth85adp.it-cpi015-rt.cfapps.ap12.hana.ondemand.com/http/FB020' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-type'
                                      i_value = 'application/json' ).

*        lo_request->set_query( query = 'data=[out:json];area[name="Heidelberg"];node["amenity"="biergarten"](area);out;' ).
        lo_request->append_text( data = struc2json_xco ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).

        DATA(check_holder_result_json) = lo_response->get_text( ).

        " JSON -> ABAP (structure) using XCO
        xco_cp_json=>data->from_string( check_holder_result_json )->write_to( REF #( rs_check_holder_result ) ).

*      CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).
*      CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).
      CATCH cx_static_check INTO DATA(lx_exception).

        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_exception )->if_message~get_longtext( ).

        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lx_exception )->t100key.

        RAISE EXCEPTION TYPE zcx_strfi11_api
          EXPORTING
            textid   = VALUE scx_t100key(
            msgid = exception_t100_key-msgid
            msgno = exception_t100_key-msgno
            attr1 = exception_t100_key-attr1
            attr2 = exception_t100_key-attr2
            attr3 = exception_t100_key-attr3
            attr4 = exception_t100_key-attr4 )
            previous = lx_exception.

    ENDTRY.

  ENDMETHOD.


  METHOD get_payment_header.

    DATA lt_name_mapping TYPE /ui2/cl_json=>name_mappings.

    lt_name_mapping = VALUE #(
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

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI11_API_GETTER'
                                service_id = 'ZSTRFI11_API_GET_HEADERS_REST' " Proposal Header
                                ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).

*        lo_request->set_query( query = 'data=[out:json];area[name="Heidelberg"];node["amenity"="biergarten"](area);out;' ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

        DATA(payment_header_json) = lo_response->get_text( ).

        " JSON -> ABAP (structure) using XCO
        /ui2/cl_json=>deserialize( EXPORTING json = payment_header_json
                                             name_mappings = lt_name_mapping
*                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = rs_payment_header ).

*      CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).
*      CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).
      CATCH cx_static_check INTO DATA(lx_exception).

        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_exception )->if_message~get_longtext( ).

        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lx_exception )->t100key.

        RAISE EXCEPTION TYPE zcx_strfi11_api
          EXPORTING
            textid   = VALUE scx_t100key(
            msgid = exception_t100_key-msgid
            msgno = exception_t100_key-msgno
            attr1 = exception_t100_key-attr1
            attr2 = exception_t100_key-attr2
            attr3 = exception_t100_key-attr3
            attr4 = exception_t100_key-attr4 )
            previous = lx_exception.

    ENDTRY.

  ENDMETHOD.


  METHOD get_payment_item.

    DATA lt_name_mapping TYPE /ui2/cl_json=>name_mappings.

    lt_name_mapping = VALUE #(
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

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI11_API_GETTER'
                                service_id = 'ZSTRFI11_API_GET_ITEMS_REST' " Proposal Item
                                ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).

*        lo_request->set_query( query = 'data=[out:json];area[name="Heidelberg"];node["amenity"="biergarten"](area);out;' ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

        DATA(payment_item_json)  = lo_response->get_text( ).

        /ui2/cl_json=>deserialize( EXPORTING json = payment_item_json
                                             name_mappings = lt_name_mapping
*                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = rs_payment_item ).

*      CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).
*      CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).
      CATCH cx_static_check INTO DATA(lx_exception).

        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_exception )->if_message~get_longtext( ).

        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lx_exception )->t100key.

        RAISE EXCEPTION TYPE zcx_strfi11_api
          EXPORTING
            textid   = VALUE scx_t100key(
            msgid = exception_t100_key-msgid
            msgno = exception_t100_key-msgno
            attr1 = exception_t100_key-attr1
            attr2 = exception_t100_key-attr2
            attr3 = exception_t100_key-attr3
            attr4 = exception_t100_key-attr4 )
            previous = lx_exception.

    ENDTRY.

  ENDMETHOD.


  METHOD post_api.

    DATA(struc2json_xco)  = xco_cp_json=>data->from_abap( is_post_api )->to_string( ).
*    DATA json2struc_xco TYPE zif_strfi11_api=>ts_check_holder_result.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI11_API_GETTER'
                                service_id = 'ZSTRFI11_API_POST_API_REST'
                                ).

*        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://dev-stradvision-vth85adp.it-cpi015-rt.cfapps.ap12.hana.ondemand.com/http/FB020' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_field( i_name = 'Content-type'
                                      i_value = 'application/json' ).

*        lo_request->set_query( query = 'data=[out:json];area[name="Heidelberg"];node["amenity"="biergarten"](area);out;' ).
        lo_request->append_text( data = struc2json_xco ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).

        DATA(api_post_result_json) = lo_response->get_text( ).

        " JSON -> ABAP (structure) using XCO
        xco_cp_json=>data->from_string( api_post_result_json )->write_to( REF #( rs_post_api_result ) ).

*      CATCH cx_http_dest_provider_error INTO DATA(lx_destexcept).
*      CATCH cx_web_http_client_error INTO DATA(lx_clientexcept).
      CATCH cx_static_check INTO DATA(lx_exception).

        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( lx_exception )->if_message~get_longtext( ).

        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( lx_exception )->t100key.

        RAISE EXCEPTION TYPE zcx_strfi11_api
          EXPORTING
            textid   = VALUE scx_t100key(
            msgid = exception_t100_key-msgid
            msgno = exception_t100_key-msgno
            attr1 = exception_t100_key-attr1
            attr2 = exception_t100_key-attr2
            attr3 = exception_t100_key-attr3
            attr4 = exception_t100_key-attr4 )
            previous = lx_exception.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
