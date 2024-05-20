INTERFACE zif_strfi11_api
  PUBLIC .

  CONSTANTS co_channel TYPE string VALUE `STRAD`.
  CONSTANTS co_corp_biz_no TYPE string VALUE `5068190203`.
  CONSTANTS co_indesc TYPE string VALUE `스트라드비전`.

  " 원화잔액조회 : check_balance
  " posting - check_balance
  TYPES: BEGIN OF ts_check_balance,
           channel     TYPE string,
           corp_biz_no TYPE string,
           bankcd      TYPE string,
           acctno      TYPE string,
         END OF ts_check_balance.

  " result data - check_balance
  TYPES: BEGIN OF ts_check_balance_data,
           rtn              TYPE string,
           err_code         TYPE string,
           err_msg          TYPE string,

           trxrespdesc      TYPE string,
           trxrespcode      TYPE string,
           bankrespcode     TYPE string,
           bankrespdesc     TYPE string,

           balance          TYPE string,
           balanceavailable TYPE string,
         END OF ts_check_balance_data.

  " result - check_balnace
  TYPES: BEGIN OF ts_check_balance_result,
           errcode TYPE string,
           errmsg  TYPE string,
           result  TYPE string,
           data    TYPE ts_check_balance_data,
         END OF ts_check_balance_result.


  " 원화예금주조회 : check_holder
  " posting - check_holder
  TYPES: BEGIN OF ts_check_holder,
           channel     TYPE string,
           corp_biz_no TYPE string,
           bankcd      TYPE string,
           acctno      TYPE string,
           outbankcd   TYPE string,
           trxamt      TYPE string,
         END OF ts_check_holder.

  " result data - check_holder
  TYPES: BEGIN OF ts_check_holder_data,
           rtn          TYPE string,
           err_code     TYPE string,
           err_msg      TYPE string,

           trxrespdesc  TYPE string,
           trxrespcode  TYPE string,
           bankrespcode TYPE string,
           bankrespdesc TYPE string,

           depositor    TYPE string,
         END OF ts_check_holder_data.

  " result - check_holder
  TYPES: BEGIN OF ts_check_holder_result,
           errcode TYPE string,
           errmsg  TYPE string,
           result  TYPE string,
           data    TYPE ts_check_holder_data,
         END OF ts_check_holder_result.


  " 원화지급이체요청 : post_api
  " posting - post_api
  TYPES: BEGIN OF ts_post_api,
           channel     TYPE string,
           corp_biz_no TYPE string,
           outbankcd   TYPE string,
           outacctno   TYPE string,
           outacctpw   TYPE string,
           outamt      TYPE string,
           outdesc     TYPE string,
           inbankcd    TYPE string,
           inacctno    TYPE string,
           indesc      TYPE string,
           cmscd       TYPE string,
           salaryyn    TYPE string,
         END OF ts_post_api.

  " result data - post_api
  TYPES: BEGIN OF ts_post_api_data,
           rtn          TYPE string,
           err_code     TYPE string,
           err_msg      TYPE string,

           trxrespdesc  TYPE string,
           trxrespcode  TYPE string,
           bankrespcode TYPE string,
           bankrespdesc TYPE string,

           balance      TYPE string,
           fee          TYPE string,
           issueno      TYPE string,
         END OF ts_post_api_data.

  " result - post_api
  TYPES: BEGIN OF ts_post_api_result,
           errcode TYPE string,
           errmsg  TYPE string,
           result  TYPE string,
           data    TYPE ts_post_api_data,
         END OF ts_post_api_result.



  " Inbound WebService 관련

  " payment header
  TYPES: BEGIN OF ts_payment_header,
           laufd      TYPE string,
           laufi      TYPE string,
           xvorl      TYPE string,
           zbukr      TYPE string,
           lifnr      TYPE string,
           kunnr      TYPE string,
           empfg      TYPE string,
           vblnr      TYPE string,
           koart      TYPE string,
           ababu      TYPE string,
           ausfd      TYPE string,
           land1      TYPE string,
           rzawe      TYPE string,
           gjahr      TYPE string,
           zaldt      TYPE string,
           valut      TYPE string,
           ubnky      TYPE string,
           stras      TYPE string,
           name1      TYPE string,
           name2      TYPE string,
           ubnkl      TYPE string,
           ubknt      TYPE string,
           ubnks      TYPE string,
           ubknt_long TYPE string,
           hbkid      TYPE string,
           hktid      TYPE string,
           znme1      TYPE string,
           znme2      TYPE string,
           zbnks      TYPE string,
           zbnkl      TYPE string,
           zbnky      TYPE string,
           zbnkn      TYPE string,
           zbnkn_long TYPE string,
           koinh      TYPE string,
           rbetr      TYPE string,
           waers      TYPE string,
         END OF ts_payment_header.

  TYPES: BEGIN OF ts_payment_header_result,
           results TYPE TABLE OF ts_payment_header WITH EMPTY KEY,
         END OF ts_payment_header_result.

  " payment item
  TYPES: BEGIN OF ts_payment_item,
           laufd TYPE string, "
           laufi TYPE string,
           xvorl TYPE string,
           zbukr TYPE string,
           lifnr TYPE string,
           kunnr TYPE string,
           empfg TYPE string,
           vblnr TYPE string,
           bukrs TYPE string,
           belnr TYPE string,
           gjahr TYPE string,
           buzei TYPE string,
           blart TYPE string,
           bldat TYPE string, "
           zfbdt TYPE string, "
           zlsch TYPE string, " JSON 없음
           budat TYPE string, " JSON 없음
           sgtxt TYPE string, " JSON 없음
           hkont TYPE string, " JSON 없음
           mwskz TYPE string, " JSON 없음
           wrbtr TYPE string,
           waers TYPE string,
           shkzg TYPE string,
           bupla TYPE string,
           hbkid TYPE string,
           saknr TYPE string,
           zwels TYPE string,
         END OF ts_payment_item.

  TYPES: BEGIN OF ts_payment_item_result,
           results TYPE TABLE OF ts_payment_item WITH EMPTY KEY,
         END OF ts_payment_item_result.


ENDINTERFACE.
