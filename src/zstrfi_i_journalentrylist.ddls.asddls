@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 신용카드 레포트'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZSTRFI_I_JOURNALENTRYLIST
  as select from ZSTRFI_I_JOURNALHEADER
  association [0..1] to ZSTRFI_I_ITEMAP     as _AP          on  $projection.CompanyCode        = _AP.CompanyCode
                                                            and $projection.FiscalYear         = _AP.FiscalYear
                                                            and $projection.AccountingDocument = _AP.AccountingDocument
  association [0..1] to ZSTRFI_I_ITEMTAX    as _Tax         on  $projection.CompanyCode        = _Tax.CompanyCode
                                                            and $projection.FiscalYear         = _Tax.FiscalYear
                                                            and $projection.AccountingDocument = _Tax.AccountingDocument
  association [0..1] to ZSTRFI_I_ITEMSUPPLY as _SupplyPrice on  $projection.CompanyCode        = _SupplyPrice.CompanyCode
                                                            and $projection.FiscalYear         = _SupplyPrice.FiscalYear
                                                            and $projection.AccountingDocument = _SupplyPrice.AccountingDocument
{
  key CompanyCode,

  key FiscalYear,

  key AccountingDocument,

      AccountingDocumentType,

      abap.int1'1' as CountLine,
      
      abap.int1'0' as ErrorCheck,

      FiscalPeriod,

      PostingDate,
      
      IsReversal,
      
      _AP.PostingKey  as PostingKey,

      DocumentDate,

      TransactionCurrency,

      _CompanyCode.CompanyCodeName,

      _AccountingDocumentType._Text[ 1:Language=$session.system_language ].AccountingDocumentTypeName,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      - _AP.AmountInTransactionCurrency as APAmount,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _Tax.AmountInTransactionCurrency as TaxAmount,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case  
        when _Tax.AmountInTransactionCurrency is null
          then
            - _AP.AmountInTransactionCurrency
        else
          - _AP.AmountInTransactionCurrency - _Tax.AmountInTransactionCurrency
      end as SuppAmount,
      
      _Tax.TaxCode,

      _AP,

      _Tax,

      _SupplyPrice
}
where
     AccountingDocumentType = 'KR'
  or AccountingDocumentType = 'RE'
  or AccountingDocumentType = 'ER'
