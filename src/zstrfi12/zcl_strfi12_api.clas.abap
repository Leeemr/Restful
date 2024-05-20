CLASS zcl_strfi12_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_strfi12_api.

    CLASS-METHODS:

      get_ar_list RETURNING VALUE(rs_ar_list) TYPE zif_strfi12_api=>ts_ar_list_result
                  RAISING   cx_web_http_client_error,

      post_api IMPORTING is_post_api               TYPE zif_strfi12_api=>ts_bulkcreaterequest
               RETURNING VALUE(rs_post_api_result) TYPE zif_strfi12_api=>ts_post_api_result.
*               RAISING   zcx_strfi11_api.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_STRFI12_API IMPLEMENTATION.


  METHOD get_ar_list.

    DATA lt_name_mapping TYPE /ui2/cl_json=>name_mappings.

    lt_name_mapping = VALUE #(
                      ( abap = 'seq_no'         json = 'SEQ' )
                      ( abap = 'ubknt'          json = 'ACCT_NO' )
                      ( abap = 'waers'          json = 'CURRCD' )
                      ( abap = 'trans_date'     json = 'TRAN_DATE' )
                      ( abap = 'trans_time'     json = 'TRAN_TIME' )
                      ( abap = 'in_bal'         json = 'IN_BAL' )
                      ( abap = 'out_bal'        json = 'OUT_BAL' )
                      ( abap = 'tran_bal'       json = 'TRAN_BAL' )
                      ( abap = 'JUKYO'          json = 'JUKYO' )
                      ( abap = 'tran_gb'        json = 'TRAN_GB' )
                      ( abap = 'tran_gb_nm'     json = 'TRAN_GB_NM' )
                      ( abap = 'ubnkl'          json = 'BANKCD' )
                      ( abap = 'tran_key'       json = 'TRAN_KEY' )
                        ).

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI12_API_GETTER'
                                service_id = 'ZSTRFI12_API_GET_HEADERS_REST' " Proposal Header
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
                                   CHANGING data = rs_ar_list ).

      CATCH cx_root INTO DATA(lx_exception).

*        RAISE EXCEPTION TYPE cx_web_http_client_error MESSAGE ID 'ZSTRFI11_MSG' TYPE 'E' NUMBER '001'.
*        RAISE EXCEPTION TYPE cx_web_http_client_error MESSAGE ID 'ZSTRFI11_MSG' NUMBER '001' WITH 'ERROR MESSAGE'.

    ENDTRY.

  ENDMETHOD.


  METHOD post_api.

    DATA(struc2json_xco)  = xco_cp_json=>data->from_abap( is_post_api )->to_string( ).
    DATA : ls_post_api_data TYPE  zif_strfi12_api=>ts_post_api_data.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZSTRFI12_API_GETTER'
                                service_id = 'ZSTRFI12_API_GETTER_REST'
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

*        RAISE EXCEPTION TYPE zcx_strfi11_api
*          EXPORTING
*            textid   = VALUE scx_t100key(
*            msgid = exception_t100_key-msgid
*            msgno = exception_t100_key-msgno
*            attr1 = exception_t100_key-attr1
*            attr2 = exception_t100_key-attr2
*            attr3 = exception_t100_key-attr3
*            attr4 = exception_t100_key-attr4 )
*            previous = lx_exception.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
