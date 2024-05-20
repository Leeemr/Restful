CLASS lhc_arlist DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

*    CONSTANTS:
*      is_draft  TYPE if_abap_behv=>t_xflag VALUE if_abap_behv=>mk-on,     "draft: '01'
*      is_active TYPE if_abap_behv=>t_xflag VALUE if_abap_behv=>mk-off.    "active: '00'
*
    CONSTANTS:
      BEGIN OF arlist_status,
        success TYPE c LENGTH 1 VALUE 'S', " Success
        deleted TYPE c LENGTH 1 VALUE 'X', " Deleted
        ready   TYPE c LENGTH 1 VALUE 'R', " Rejected
      END OF arlist_status.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR arlist RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR arlist RESULT result.

    METHODS deletear FOR MODIFY
      IMPORTING keys FOR ACTION arlist~deletear RESULT result.

    METHODS deleterb FOR MODIFY
      IMPORTING keys FOR ACTION arlist~deleteRB RESULT result.

    METHODS input FOR MODIFY
      IMPORTING keys FOR ACTION arlist~input RESULT result.

    METHODS postar FOR MODIFY
      IMPORTING keys FOR ACTION arlist~postar RESULT result.

    METHODS post_api FOR MODIFY
      IMPORTING keys FOR ACTION arlist~post_api RESULT result.

*    METHODS post FOR DETERMINE ON SAVE
*      IMPORTING keys FOR ARList~post.

    METHODS getarlists IMPORTING lv_json TYPE string.

ENDCLASS.

CLASS lhc_arlist IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    "Action Button
    " Read the status of the existing AR list
    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY ARList
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(ARLists)
      FAILED failed.

    result =
      VALUE #(
        FOR ARList IN ARLists
          LET is_input  =   COND #( WHEN ARList-Customer IS INITIAL
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )
              is_deleted =   COND #( WHEN ARList-status = arlist_status-deleted     "X"
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_ready   =   COND #( WHEN ARList-status = arlist_status-ready       "R
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )
              is_success =   COND #( WHEN ARList-status = arlist_status-success     "S
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )
              is_hidden  =   COND #( WHEN ARList-status = arlist_status-deleted     "R일때, 재처리
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )
              is_post  =   COND #( WHEN ARList-status = arlist_status-ready        "R 이고, 통화가 KRW일 경우
                                      AND ARList-Waers = 'KRW'
                                      THEN if_abap_behv=>fc-o-enabled
                                      ELSE if_abap_behv=>fc-o-disabled )

          IN
            ( %tky                 = ARList-%tky
              %action-input    = is_ready          "Customer가 없는 경우에만 활성화
              %action-deleteAR = is_ready          "Status가 'R'인 경우만 '처리제외' 활성화
              %action-post_api = is_post           "R 이고, 통화가 KRW일 경우
              %action-deleteRB = is_hidden

             ) ).



    "시간 기준으로 SORTING
    SORT ARLists BY TransactionDate TransactionTime DESCENDING .

  ENDMETHOD.

  METHOD getarlists.

    TYPES: BEGIN OF ts_arlist,
             bukrs      TYPE string,
             belnr      TYPE  string,
             gjahr      TYPE  string,
             kunnr      TYPE  string,
             knunrname  TYPE  string,
             blart      TYPE  string,
             caccnt     TYPE  string,
             caccntt_dt TYPE  string,
             akont      TYPE  string,
             akont_dt   TYPE  string,
             seq_no     TYPE  string,
             ubnkl      TYPE  string,
             ubknt      TYPE  string,
             jukyo      TYPE  string,
             in_bal     TYPE  string,
             out_bal    TYPE  string,
             waers      TYPE  string,
             tran_gb    TYPE  string,
             tran_gb_nm TYPE  string,
             status     TYPE  string,
             trans_time TYPE  string,
             trans_date TYPE  string,
             tran_key   TYPE  string,
           END OF ts_arlist.

    TYPES: BEGIN OF ts_arlist_result,
             list TYPE TABLE OF ts_arlist WITH EMPTY KEY,
           END OF ts_arlist_result.

    DATA json2struc TYPE ts_arlist_result.

    DATA lt_zstrfi12_alist TYPE STANDARD TABLE OF zstrfi12_alist.

    DATA lt_name_mapping TYPE /ui2/cl_json=>name_mappings.

    lt_name_mapping = VALUE #(
                     ( abap = 'bukrs'              json = 'CompanyCode          ' )
                     ( abap = 'belnr'              json = 'AccountingDocument   ' )
                     ( abap = 'gjahr'              json = 'FiscalYear           ' )
                     ( abap = 'kunnr'              json = 'Customer             ' )
                     ( abap = 'knunrname'          json = 'CustomerName         ' )
                     ( abap = 'blart'              json = 'JournalEntryType     ' )
                     ( abap = 'caccnt'             json = 'CreditAccount        ' )
                     ( abap = 'caccntt_dt'         json = 'CreditAccountDetail  ' )
                     ( abap = 'akont'              json = 'ReconciliationAccount' )
                     ( abap = 'akont_dt'           json = 'ReconciliationDetail ' )
                     ( abap = 'seq_no '            json = 'SequenceNo           ' )
                     ( abap = 'ubknt  '            json = 'BankAccount          ' )
                     ( abap = 'jukyo  '            json = 'TransactionDetail    ' )
                     ( abap = 'in_bal '            json = 'IncomingAmount       ' )
                     ( abap = 'out_bal'            json = 'OutgoingAmount       ' )
                     ( abap = 'waers'              json = 'Waers                ' )
                     ( abap = 'tran_gb '           json = 'TransactionGb        ' )
                     ( abap = 'tran_gb_nm'         json = 'TransactionGbNumber  ' )
                     ( abap = 'status    '         json = 'status               ' )
                     ( abap = 'trans_time'         json = 'TransactionTime      ' )
                     ( abap = 'trans_date'         json = 'TransactionDate      ' )
                     ( abap = 'tran_key'           json = 'TransactionKey      ' )

                  ).

    /ui2/cl_json=>deserialize(
    EXPORTING
    json = lv_json
    name_mappings = lt_name_mapping
*  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
    CHANGING
    data = json2struc ).

    "데이터 전처리
    " 웹서비스로 전달받는 시간데이터는 UTC timestamp 값들이다.
    " 이를 YYYYMMDD로 변환한다.
    LOOP AT json2struc-list ASSIGNING FIELD-SYMBOL(<result>).

      <result>-trans_date = zcl_strcm_utils=>parse_json_date( <result>-trans_date ).
      zcl_strcm_utils=>unix_time_to_timestamp( EXPORTING iv_tstmp = <result>-trans_date
                                  IMPORTING ev_date = <result>-trans_date ).
*      <result>-gjahr = zcl_strcm_utils=>parse_json_date( <result>-trans_date ).   "Fiscal Year
    ENDLOOP.

    " 테이블에 입력
    INSERT zstrfi12_alist FROM TABLE @lt_zstrfi12_alist ACCEPTING DUPLICATE KEYS.
    lt_zstrfi12_alist = CORRESPONDING #( json2struc-list ).

    MODIFY zstrfi12_alist FROM TABLE @lt_zstrfi12_alist.

  ENDMETHOD.

  " 삭제 버튼 클릭 시, Status 값을 Deleted('X')로 변경
  METHOD deletear.

    " modify AR instance
    MODIFY ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                        status = arlist_status-deleted ) ) " 'X'
      FAILED failed
      REPORTED reported.

    " read changed data for action result
    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        ALL FIELDS WITH
          CORRESPONDING #( keys )
      RESULT DATA(arlists).

    " set the action result parameter
    result = VALUE #( FOR arlist IN arlists ( %tky = arlist-%tky
                                              %param = arlist ) ).

  ENDMETHOD.

  " 처리 제외일 경우만, Status 값을 Ready ('R')로 변경가능하도록 재처리
  METHOD deleterb.

    " modify AR instance
    MODIFY ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                        status = arlist_status-ready ) ) " 'R'
      FAILED failed
      REPORTED reported.

    " read changed data for action result
    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        ALL FIELDS WITH
          CORRESPONDING #( keys )
      RESULT DATA(arlists).

    " set the action result parameter
    result = VALUE #( FOR arlist IN arlists ( %tky = arlist-%tky
                                              %param = arlist ) ).

  ENDMETHOD.

  METHOD input.

    DATA : lt_update_doc  TYPE TABLE FOR UPDATE zstrfi12_r_list.
    DATA(lt_keys) = keys.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      APPEND VALUE #( %tky = <fs_key>-%tky ) TO failed-arlist.
      DATA(lv_customer)    = <fs_key>-%param-zkunnr.

    ENDLOOP.

    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
            ENTITY arlist
            FIELDS ( transactionkey )
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_doc_head).

    MODIFY ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        UPDATE FIELDS ( customer customername )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                        customer = lv_customer ) )
      FAILED failed
      REPORTED reported.

    " Modify header entity
    MODIFY ENTITIES OF zstrfi12_r_list IN LOCAL MODE
        ENTITY arlist
        UPDATE FIELDS ( customer customername )
        WITH VALUE #( FOR <fs_doc> IN lt_doc_head
                        ( %tky = <fs_doc>-%tky
                          customer = lv_customer ) )

       FAILED failed
      REPORTED reported.

    " Return result to UI
    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
        ENTITY arlist
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT lt_doc_head.

    result = VALUE #( FOR arlist IN lt_doc_head ( %tky = arlist-%tky
                                                 %param = arlist ) ).

  ENDMETHOD.

  METHOD post_api.

    DATA : ls_item                      TYPE  zif_strfi12_api=>ts_item,
           ls_journalentry              TYPE  zif_strfi12_api=>ts_journalentry,
           ls_journalentrycreate        TYPE  zif_strfi12_api=>ts_journalentrycreate,
           ls_journalentrycreaterequest TYPE  zif_strfi12_api=>ts_journalentrycreaterequest,
           ls_BulkCreateRequest         TYPE  zif_strfi12_api=>ts_BulkCreateRequest,
           ls_post_api_result           TYPE  zif_strfi12_api=>ts_post_api_result,
           lv_waers                     TYPE waers,
           lv_external_amount           TYPE zdec23_2,
           lv_external_amount_1         TYPE string,
           lv_external_amount_2         TYPE string,
           lv_tran_date                 TYPE string,
           lv_tran_date2                TYPE string,
           lv_date_time                 TYPE string.


    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
     ENTITY arlist
      ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(arlists)
     FAILED DATA(read_failed).

    CHECK arlists IS NOT INITIAL.

    LOOP AT arlists ASSIGNING FIELD-SYMBOL(<fs_arlist>).

      "데이터 변환
      "날짜 변환
      "TimeStamp yyyy-mm-ddThh:ss:ssZ
      GET TIME STAMP FIELD DATA(lv_time).
      FINAL(time_result) = CONV string( lv_time ).
      lv_date_time = |{ time_result(4) }-{ time_result+4(2) }-{ time_result+6(2) }T{ time_result+8(2) }:{ time_result+10(2) }:{ time_result+12(2) }Z|.
      lv_tran_date  = |{ lv_date_time(10) }|.

      lv_tran_date2 = |{ <fs_arlist>-TransactionDate(4) }-{ <fs_arlist>-TransactionDate+4(2) }-{ <fs_arlist>-TransactionDate+6(2) }|.


      ""통화 금액 변환
      lv_waers = <fs_arlist>-Waers.
      lv_external_amount = <fs_arlist>-IncomingAmount.
      lv_external_amount_1 = zcl_strcm_utils=>currency_conv_to_external_krw( amount_internal = lv_external_amount ).
      lv_external_amount_2 = |-{ lv_external_amount_1 }|.


      "전표 Item 정보 journal entry 구조 선언
      ls_journalentry-item = VALUE #(
                                           ( referencedocumentitem = '1'
                                             debitcreditcode = 'S'
                                             companycode = <fs_arlist>-CompanyCode
                                             amountintransactioncurrency = lv_external_amount_1
                                             glaccount = <fs_arlist>-GLAccount
                                             documentitemtext = |{ <fs_arlist>-TransactionDetail } 가수금| "적요 + 가수금
                                             housebank = <fs_arlist>-HouseBank
                                             housebankaccount = <fs_arlist>-HouseBankAccountKey
                                               )
                                           ( referencedocumentitem = '2'
                                             debitcreditcode = 'H'
                                             companycode = '1000'
                                             amountintransactioncurrency = lv_external_amount_2
                                             glaccount = '11009000'
                                             documentitemtext = |{ <fs_arlist>-TransactionDetail }|  "고객정보 + 날짜
                                             assignmentreference = ''"고객선택시(전표유형이FB인경우)
                                               )
                                         ).
      ls_journalentrycreate-journalentry = ls_journalentry.
      ls_BulkCreateRequest-JournalEntryBulkCreateRequest = ls_journalentrycreaterequest.

      "Message
      ls_journalentrycreate-messageheader-creationdatetime = lv_date_time.
      ls_journalentrycreate-messageheader-id = <fs_arlist>-TransactionKey.

      "전표 Header 정보
      ls_journalentrycreate-journalentry-originalreferencedocumenttype = 'BKPFF'.             " OriginalReferenceDocument
      ls_journalentrycreate-journalentry-businesstransactiontype = 'RFBU'.             " BusinessTransactionType

      "AccountingDocumentType
      "Customer 있는 경우 - 'FB' , Customer 없는 경우 - 'SA'
      IF <fs_arlist>-customer IS INITIAL.
        ls_journalentrycreate-journalentry-accountingdocumenttype = 'SA'.
      ELSE.
        ls_journalentrycreate-journalentry-accountingdocumenttype = 'FB'.
      ENDIF.

      " DocumentHeaderText - 고객정보&금액
*      ls_journalentrycreate-journalentry-documentheadertext = <fs_arlist>-customer.
      ls_journalentrycreate-journalentry-documentheadertext = |{ lv_external_amount_1 } { <fs_arlist>-TransactionDetail }|.
      ls_journalentrycreate-journalentry-createdbyuser = 'CC0000000002'.           " CreatedByUser
      ls_journalentrycreate-journalentry-companycode = <fs_arlist>-companycode.           " CompanyCode
      ls_journalentrycreate-journalentry-documentdate = lv_tran_date.      " DocumentDate
      ls_journalentrycreate-journalentry-postingdate = lv_tran_date2.       " PostingDate
*      ls_journalentrycreate-journalentry-postingdate = lv_tran_date.       " PostingDate
      ls_journalentrycreate-journalentry-documentreferenceid = ''.                        " DocumentReferenceID


      ls_journalentrycreaterequest-journalentrycreaterequest = ls_journalentrycreate.
      ls_BulkCreateRequest-journalentrybulkcreaterequest = ls_journalentrycreaterequest.

      ls_BulkCreateRequest-JournalEntryBulkCreateRequest-messageheader-creationdatetime = lv_date_time.
      ls_BulkCreateRequest-JournalEntryBulkCreateRequest-messageheader-id = <fs_arlist>-TransactionKey.


      TRY.

          ls_post_api_result = zcl_strfi12_api=>post_api( is_post_api = ls_BulkCreateRequest ).

          "전표번호 return
          <fs_arlist>-AccountingDocument = zcl_strcm_utils=>exit_special_character( ls_post_api_result-journalentrycreaterequest-accountingdocument ).
          <fs_arlist>-FiscalYear = zcl_strcm_utils=>exit_special_character( ls_post_api_result-journalentrycreaterequest-fiscalyear ).
*          <fs_arlist>-issueno = zcl_strcm_utils=>exit_special_character( ls_post_api_result-data-issueno ).
**
          IF <fs_arlist>-AccountingDocument = '0000000000'.
            <fs_arlist>-status = 'E'.
          ELSE.
            <fs_arlist>-status = 'S'.
          ENDIF.
*
*          APPEND VALUE #( %msg = new_message_with_text(   severity  = lv_severity
*                                                          text = <fs_arlist>-status )
*                      ) TO reported-arlist.

*        CATCH zcx_strfi12_api INTO DATA(lx_exception).
*
*          <fs_paymentproposalpayment>-apitransstatus = lx_exception->get_text( ).
*
*          APPEND VALUE #( %msg = new_message_with_text(   severity  = if_abap_behv_message=>severity-error
*                                                          text = <fs_paymentproposalpayment>-apitransstatus )
*                      ) TO reported-paymentproposalpayment.


      ENDTRY.

    ENDLOOP.

    MODIFY ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        UPDATE FIELDS ( accountingdocument status FiscalYear )
        WITH VALUE #( FOR arlist IN arlists ( %tky = arlist-%tky
                                              AccountingDocument = arlist-AccountingDocument
                                              FiscalYear         = arlist-FiscalYear
                                              status             = arlist-status
                                             ) )


      FAILED DATA(updated_failed)
      REPORTED DATA(updated_reported).

    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
      ENTITY arlist
        ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(arlists_result).

    " set the action result parameter
    result = VALUE #( FOR arlist_result IN arlists_result ( %tky = arlist_result-%tky
                                                           %param = arlist_result ) ).

  ENDMETHOD.

  METHOD postar.

*    DATA : ls_post_ar        TYPE zif_strfi12_api=>ts_post_ar,
*           ls_post_ar_result TYPE zif_strfi12_api=>ts_post_ar_result.
*
*
*    DATA: lv_post_ar_json TYPE string.
*
*    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
*      ENTITY ARList
*        FIELDS ( TransactionKey ) WITH CORRESPONDING #( keys )
*      RESULT DATA(arlists)
*      FAILED DATA(read_failed).
*
*    CHECK arlists IS NOT INITIAL.
*
*    LOOP AT arlists ASSIGNING FIELD-SYMBOL(<fs_arlist>).
*
*      CLEAR: ls_post_ar, ls_post_ar_result.
*
*      ls_post_ar-channel = zif_strfi11_api=>co_channel.
*      ls_post_ar-corp_biz_no = zif_strfi11_api=>co_corp_biz_no.
*      ls_post_ar-bankcd = <fs_arlist>-payeebank.
*      ls_post_ar-acctno = <fs_arlist>-payeebankaccount.
*      ls_post_ar-outbankcd = <fs_arlist>-bank.
*      ls_post_ar-trxamt = `0`.
*
*      TRY.
*
*          ls_post_ar_result = zcl_strfi12_api=>check_holder( is_check_holder = ls_check_holder ).
*          <fs_paymentproposalpayment>-payeematch = ls_check_holder_result-data-depositor.
*
*        CATCH zcx_strfi11_api INTO DATA(lx_exception).
*
*          <fs_paymentproposalpayment>-payeematch = lx_exception->get_text( ).
*
*      ENDTRY.
*
*    ENDLOOP.
*
*
*    MODIFY ENTITIES OF zstrfi12_r_list IN LOCAL MODE
*         ENTITY arlist
*           UPDATE FIELDS ( payeematch )
*           WITH VALUE #( FOR paymentproposalpayment IN paymentproposalpayments ( %tky = paymentproposalpayment-%tky
*                                                                                 payeematch = paymentproposalpayment-payeematch ) )
*         FAILED DATA(updated_failed)
*         REPORTED DATA(updated_reported).
*
*    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
*      ENTITY arlist
*       ALL FIELDS WITH CORRESPONDING #( keys )
*     RESULT DATA(paymentproposalpayments_result).
*
*    " set the action result parameter
*    result = VALUE #( FOR paymentproposalpayment_result IN paymentproposalpayments_result ( %tky = paymentproposalpayment_result-%tky
*                                                                                            %param = paymentproposalpayment_result ) ).


  ENDMETHOD.

*  METHOD postAR.
*
*    DATA: lt_entry    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*          ls_entry    LIKE LINE OF lt_entry,
*          ls_aritem   LIKE LINE OF ls_entry-%param-_aritems,
*          ls_amount   LIKE LINE OF ls_aritem-_currencyamount,
*          lt_temp_key TYPE zstrfi12_transaction_handler=>tt_temp_key,
*          ls_temp_key LIKE LINE OF lt_temp_key.
*
*    READ ENTITIES OF zstrfi12_r_list IN LOCAL MODE
*        ENTITY ARLIST ALL FIELDS WITH CORRESPONDING #( keys ) RESULT FINAL(header).
*        ENTITY zstrfi12_r_list BY \_item ALL FIELDS WITH CORRESPONDING #( keys ) RESULT FINAL(item).
*
*    "start to call I_JournalEntryTP~Post
*    LOOP AT header REFERENCE INTO DATA(ls_header).
*      CLEAR ls_entry.
*      ls_entry-%cid = ls_header->uuid. "use UUID as CID
*      ls_entry-%param-companycode = ls_header->CompanyCode.
*      ls_entry-%param-businesstransactiontype = 'RFPO'.
*      ls_entry-%param-accountingdocumenttype = 'SA'.
*      ls_entry-%param-accountingdocumentheadertext = ls_header->CreditAccountDetail.
*      ls_entry-%param-documentdate = ls_header->TransactionDate.
*      ls_entry-%param-postingdate = ls_header->TransactionDate.
*      ls_entry-%param-createdbyuser = ls_header->LastChangedBy.
*
*      LOOP AT item REFERENCE INTO DATA(ls_item) USING KEY entity WHERE uuid = ls_header->uuid.
*      CLEAR ls_aritem.
*      ls_aritem-glaccountlineitem = ls_header->%data-CreditAccount.
*      ls_aritem-glaccount = '11009000'.
*
*
*      ls_aritem-documentitemtext = '외상매출금'.
*      ls_aritem-assignmentreference = ''.
*
*      CLEAR ls_amount.
*      ls_amount-currencyrole = '00'.
*      ls_amount-currency = ls_header->waers.
*      ls_amount-journalentryitemamount = ls_header->%data-OutgoingAmount.
*      APPEND ls_amount TO ls_aritem-_currencyamount.
*      APPEND ls_aritem TO ls_entry-%param-_aritems.
*    ENDLOOP.
*    APPEND ls_entry TO lt_entry.
*    ENDLOOP.
*
*    IF lt_entry IS NOT INITIAL.
*      MODIFY ENTITIES OF i_journalentrytp
*      ENTITY journalentry
*      EXECUTE post FROM lt_entry
*        MAPPED FINAL(ls_post_mapped)
*        FAILED FINAL(ls_post_failed)
*        REPORTED FINAL(ls_post_reported).
*
*      IF ls_post_failed IS NOT INITIAL.
*        LOOP AT ls_post_reported-journalentry INTO DATA(ls_report).
*          APPEND VALUE #( uuid = ls_report-%cid
*                          %create = if_abap_behv=>mk-on
*                          %is_draft = if_abap_behv=>mk-on
*                          %msg = ls_report-%msg ) TO reported-arlist.
*        ENDLOOP.
*      ENDIF.
*
*      LOOP AT ls_post_mapped-journalentry INTO DATA(ls_je_mapped).
*        ls_temp_key-cid = ls_je_mapped-%cid.
*        ls_temp_key-pid = ls_je_mapped-%pid.
*        APPEND ls_temp_key TO lt_temp_key.
*      ENDLOOP.
*
*    ENDIF.
*
*    zstrfi12_transaction_handler=>get_instance( )->set_temp_key( lt_temp_key ).
*
*  ENDMETHOD.
*
*ENDCLASS.


*CLASS lsc_zr_generaljournalentry DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.
*
*    METHODS save_modified REDEFINITION.
*
*    METHODS cleanup_finalize REDEFINITION.
*
*ENDCLASS.
*
*CLASS lsc_zr_generaljournalentry IMPLEMENTATION.
*
*  METHOD save_modified.
*
**  DATA : lt_inspectionplan TYPE STANDARD TABLE OF .
*
*    "unmanaged save for table ZGJE_HEADER
*    DATA: Lt_create TYPE TABLE OF zstrfi12_alist,
*          lt_delete TYPE TABLE OF zstrfi12_alist.
*
*    lt_create = CORRESPONDING #( create-ARLIST MAPPING FROM ENTITY ).
*    lt_delete = CORRESPONDING #( delete-ARLIST MAPPING FROM ENTITY ).
*
*    zstrfi12_transaction_handler=>get_instance( )->additional_save( it_create = lt_create
*                                                                it_delete = lt_delete ).
*
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*    zstrfi12_transaction_handler=>get_instance( )->clean_up( ).
*  ENDMETHOD.
*
ENDCLASS.
