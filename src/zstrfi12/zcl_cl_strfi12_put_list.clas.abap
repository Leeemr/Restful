CLASS zcl_cl_strfi12_put_list DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .

    METHODS: constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_name_mapping TYPE /ui2/cl_json=>name_mappings.

ENDCLASS.



CLASS ZCL_CL_STRFI12_PUT_LIST IMPLEMENTATION.


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
    DATA lt_zstrfi12_arlist TYPE STANDARD TABLE OF zstrfi12_alist.

    """ 연동시작
    DATA(lv_json) = request->get_text( ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_json
                                         name_mappings = mt_name_mapping
*                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                               CHANGING data = ls_ar_list ).

    """ 연동끝

    DATA: lv_internal_amount_in TYPE zdec23_2.
    DATA: lv_internal_amount_out TYPE zdec23_2.
    DATA: lv_internal_amount_trans  TYPE zdec23_2.
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

      "금액 필드
      lv_internal_amount_in = <result>-in_bal.
      lv_internal_amount_out = <result>-out_bal.
      lv_internal_amount_trans = <result>-tran_bal.
      lv_waers = <result>-waers.

      <result>-in_bal = zcl_strcm_utils=>currency_conv_to_internal( currency = lv_waers
                                                                    amount_display = lv_internal_amount_in ).
      <result>-out_bal = zcl_strcm_utils=>currency_conv_to_internal( currency = lv_waers
                                                                    amount_display = lv_internal_amount_out ).
*      <result>-tran_bal = zcl_strcm_utils=>currency_conv_to_internal( currency = lv_waers
*                                                                    amount_display = lv_internal_amount_trans ).

*      <result>-in_bal = zcl_strcm_utils=>currency_conv_to_internal_krw( amount_display = lv_internal_amount_in ).
*      <result>-out_bal = zcl_strcm_utils=>currency_conv_to_internal_krw( amount_display = lv_internal_amount_out ).

    ENDLOOP.

    " 테이블에 입력
    lt_zstrfi12_arlist = CORRESPONDING #( ls_ar_list-list ).

    INSERT zstrfi12_alist FROM TABLE @lt_zstrfi12_arlist ACCEPTING DUPLICATE KEYS.


******************************************
*   POST 수행
******************************************

*
*    "데이터 구성
*    TYPES: BEGIN OF ts_detail,
*               AccountingDocument        TYPE zstrfi12_r_list-AccountingDocument,
*               BankAccount               TYPE zstrfi12_r_list-BankAccount,
*               BankInternalID            TYPE zstrfi12_r_list-BankInternalID,
*               CompanyCode               TYPE zstrfi12_r_list-CompanyCode,
*               CreditAccount             TYPE zstrfi12_r_list-CreditAccount,
*               CreditAccountDetail       TYPE zstrfi12_r_list-CreditAccountDetail,
*               Customer                  TYPE zstrfi12_r_list-Customer,
*               CustomerName              TYPE zstrfi12_r_list-CustomerName,
*               FiscalYear                TYPE zstrfi12_r_list-FiscalYear,
*               IncomingAmount            TYPE zstrfi12_r_list-IncomingAmount,
*               JournalEntryType          TYPE zstrfi12_r_list-JournalEntryType,
*               OutgoingAmount            TYPE zstrfi12_r_list-OutgoingAmount,
*               ReconciliationAccount     TYPE zstrfi12_r_list-ReconciliationAccount,
*               ReconciliationDetail      TYPE zstrfi12_r_list-ReconciliationDetail,
*               TransactionDate           TYPE zstrfi12_r_list-TransactionDate,
*               TransactionDetail         TYPE zstrfi12_r_list-TransactionDetail,
*               TransactionGb             TYPE zstrfi12_r_list-TransactionGb,
*               TransactionGbNumber             TYPE zstrfi12_r_list-TransactionGbNumber,
*             cid                         TYPE sysuuid_x16,
*           END OF ts_detail.
*
*    DATA: lt_detail TYPE TABLE OF ts_detail,
*          BEGIN OF ls_rslt,
*            response TYPE string,
*            detail   TYPE TABLE OF ts_detail,
*          END OF ls_rslt.
*    DATA lv_response TYPE string.
*
*        TYPES: BEGIN OF ts_detail_base,
*             postingdate TYPE zstrfi12_r_list-TransactionDate,
**             headerid    TYPE zstrfi12_r_list-headerid,
*             sepcid      TYPE sysuuid_x16,
*           END OF ts_detail_base.
*
*    DATA : lt_je_deep    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*           lv_cid        TYPE sysuuid_x16,
*           lt_detailbase TYPE TABLE OF ts_detail_base.
*
*
*   DATA lr_docseqno TYPE RANGE OF zstrfi12_r_list-AccountingDocument.
*
*    SELECT CompanyCode, AccountingDocument, status, TransactionKey, uuid, SequenceNo, FiscalYear,
*    FROM zstrfi12_r_list
*            WHERE AccountingDocument IN @lr_docseqno
*             INTO TABLE @DATA(lt_base).
*
*
*    LOOP AT lt_base INTO DATA(ls_base).
*
*      SELECT SINGLE @abap_true FROM @lt_base AS base
*           WHERE status = 'S'
*              OR status = 'X'
*              OR status = 'R'
*           INTO @DATA(lv_check_post).
*
*      IF lv_check_post IS NOT INITIAL.
*        ls_rslt-response = 'SKIP'.
*        /ui2/cl_json=>serialize(
*           EXPORTING
*               data = ls_rslt
*           RECEIVING
*               r_json = lv_response ).
*        response->set_text(
*          EXPORTING
*            i_text   = lv_response
*        ).
*        ELSE.
*           CHECK lv_check_post NE abap_true.
*            MODIFY ENTITIES OF i_journalentrytp
*            ENTITY journalentry
*            EXECUTE post FROM lt_je_deep
*            FAILED DATA(fail)
*            REPORTED DATA(report)
*            MAPPED DATA(map).
*        IF fail IS NOT INITIAL.
**          out->write( fail-journalentry[ 1 ]-%fail-cause ).
*          LOOP AT report-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
*            DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
*          ENDLOOP.
*        ELSE.
*          COMMIT ENTITIES BEGIN
*          RESPONSE OF i_journalentrytp
*            FAILED DATA(commit_fail)
*            REPORTED DATA(commit_report).
*          COMMIT ENTITIES END.
*        ENDIF.
*
*        IF commit_fail IS NOT INITIAL.
*          ls_rslt-response = 'error'.
*
*          /ui2/cl_json=>serialize(
*             EXPORTING
*                 data = ls_rslt
*             RECEIVING
*                 r_json = lv_response ).
*          response->set_text(
*            EXPORTING
*              i_text   = lv_response
*          ).
*        ELSEIF fail IS NOT INITIAL.
*          ls_rslt-response = 'error'.
*
*          /ui2/cl_json=>serialize(
*             EXPORTING
*                 data = ls_rslt
*             RECEIVING
*                 r_json = lv_response ).
*          response->set_text(
*            EXPORTING
*              i_text   = lv_response
*          ).
*        ELSE.
*          ls_rslt-response = 'success'.
*          LOOP AT ls_rslt-detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
*            READ TABLE map-journalentry INTO DATA(ls_map_sa) WITH KEY %cid = <fs_detail>-cid.
*
*            SELECT SINGLE accountingdocument FROM @commit_report-journalentry AS commit
*            WHERE commit~%pid = @ls_map_sa-%pid
*             INTO @<fs_detail>-accountingdocument.
*          ENDLOOP.
*
*          /ui2/cl_json=>serialize(
*             EXPORTING
*                 data = ls_rslt
*             RECEIVING
*                 r_json = lv_response ).
*          response->set_text(
*            EXPORTING
*              i_text   = lv_response
*          ).
*        ENDIF.
*
*
*        ENDIF.
*
*      ENDLOOP.

    ENDMETHOD.
ENDCLASS.
