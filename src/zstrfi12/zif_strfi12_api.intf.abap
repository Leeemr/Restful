INTERFACE zif_strfi12_api
  PUBLIC .

*  CONSTANTS co_channel TYPE string VALUE `KACCOUNT`.
*  CONSTANTS co_corp_biz_no TYPE string VALUE `5068190203`.

  " 입금 전표 생성 요청 : post_api
  " posting - post_api
  TYPES: BEGIN OF ts_item,
           referencedocumentitem       TYPE string,   "ReferenceDocumentItem
           debitcreditcode             TYPE string,   "DebitCreditCode
           companycode                 TYPE string,   "CompanyCode
           amountintransactioncurrency TYPE string,   "AmountInTransactionCurrency
           glaccount                   TYPE string,   "GLAccount
           documentitemtext            TYPE string,   "DocumentItemText
           assignmentreference         TYPE string,   "AssignmentReference
           housebank                   TYPE string,   "HouseBank
           housebankaccount            TYPE string,   "HouseBankAccount
         END OF ts_item.

  TYPES: BEGIN OF ts_journalentry,
           originalreferencedocumenttype TYPE string,   "OriginalReferenceDocument
           accountingdocumenttype        TYPE string,   "AccountingDocumentType
           businesstransactiontype       TYPE string,   "BusinessTransactionType
           companycode                   TYPE string,   "CompanyCode
           documentdate                  TYPE string,   "DocumentDate
           postingdate                   TYPE string,   "PostingDate
           documentheadertext            TYPE string,   "DocumentHeaderText
           createdbyuser                 TYPE string,   "CreatedByUser
           documentreferenceid           TYPE string,   "DocumentReferenceID
           item                          TYPE TABLE OF ts_item WITH EMPTY KEY,
         END OF ts_journalentry.

  TYPES: BEGIN OF ts_messageheader,
           creationdatetime TYPE string,
           id               TYPE string,
         END OF ts_messageheader.

  TYPES: BEGIN OF ts_journalentrycreate,
           journalentry  TYPE ts_journalentry,
           messageheader TYPE ts_messageheader,  "Messageheader 1
         END OF ts_journalentrycreate.

  TYPES: BEGIN OF ts_journalentrycreaterequest,
           JournalEntryCreateRequest TYPE ts_journalentrycreate,
           messageheader             TYPE ts_messageheader,  "Messageheader 2
         END OF ts_journalentrycreaterequest.

  TYPES: BEGIN OF ts_BulkCreateRequest,
           JournalEntryBulkCreateRequest TYPE ts_journalentrycreaterequest,
         END OF ts_BulkCreateRequest.

  " result data - post_api
  TYPES: BEGIN OF ts_post_api_data,
           AccountingDocument  TYPE string,
           CompanyCode  TYPE string,
           FiscalYear TYPE string,
         END OF ts_post_api_data.

  " result - post_api
  TYPES: BEGIN OF ts_post_api_result,
           JournalEntryCreateRequest TYPE ts_post_api_data,
         END OF ts_post_api_result.


  " 입금 전표 생성  : post AR
  " posting - post AR
  TYPES: BEGIN OF ts_post_ar,
           channel     TYPE string,
           corp_biz_no TYPE string,
           bankcd      TYPE string,
           acctno      TYPE string,
         END OF ts_post_ar.

  " result data - post AR
  TYPES: BEGIN OF ts_post_ar_result,
           rtn              TYPE string,
           err_code         TYPE string,
           err_msg          TYPE string,

           trxrespdesc      TYPE string,
           trxrespcode      TYPE string,
           bankrespcode     TYPE string,
           bankrespdesc     TYPE string,

           balance          TYPE string,
           balanceavailable TYPE string,
         END OF ts_post_ar_result.

  " Inbound WebService 관련
  " ar list
  TYPES: BEGIN OF ts_ar_list,
           bukrs      TYPE string,
           gjahr      TYPE string,
           caccnt     TYPE string,
           caccntt_dt TYPE string,
           akont      TYPE string,
           akont_dt   TYPE string,
           seq_no     TYPE string,
           ubnkl      TYPE string,
           ubknt      TYPE string,
           jukyo      TYPE string,
           in_bal     TYPE string,
           out_bal    TYPE string,
           tran_bal   TYPE string,
           waers      TYPE string,
           tran_gb    TYPE string,
           tran_gb_nm TYPE string,
           status     TYPE string,
           trans_time TYPE string,
           trans_date TYPE string,
           tran_key   TYPE string,
         END OF ts_ar_list.

  TYPES: BEGIN OF ts_ar_list_result,
           list TYPE TABLE OF ts_ar_list WITH EMPTY KEY,
         END OF ts_ar_list_result.

ENDINTERFACE.
